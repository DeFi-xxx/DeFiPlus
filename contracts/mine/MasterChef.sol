pragma solidity ^0.6.0;

import "../interface/IERC20.sol";
import "../libraries/Math.sol";
import "../libraries/SafeMath.sol";
import "../libraries/Address.sol";
import "../libraries/SafeERC20.sol";

contract MasterChef {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    struct PoolInfo {
        // lp地址
        IERC20 lpToken;

        // 奖励token
        IERC20 rewardToken;

        // 分配方式地址
        address allocation;

        // 奖励数量
        uint rewardAmount;

        // 开始时间
        uint startTime;

        // 挖矿天数
        uint duration;

        // 结束时间
        uint periodFinish;

        // 每秒获得的奖励
        uint rewardRate;

        // 上次更新时间
        uint lastUpdateTime;

        // 每个质押的token能获得的奖励
        uint rewardPerTokenStored;

        // 质押总量
        uint totalAmount;

        // 每个质押token给用户的奖励
        mapping(address => uint256) userRewardPerTokenPaid;

        // 用户奖励
        mapping(address => uint256) rewards;

        // 入金映射
        mapping(address => uint256) deposits;
    }

    PoolInfo[] public poolInfo;

    // 池子索引
    mapping(address => uint) public poolIndex;

    function add(
        IERC20 _lpToken,
        IERC20 _rewardToken,
        address _allocation,
        uint _rewardAmount,
        uint _startTime,
        uint _duration
    ) external {
        require(block.timestamp <= _startTime, "invalid start time");
        _rewardToken.safeTransferFrom(msg.sender, address(this), _rewardAmount);
        uint _rewardRate = _rewardAmount.div(_duration);
        poolInfo.push(PoolInfo({
            lpToken: _lpToken,
            rewardToken: _rewardToken,
            allocation: _allocation,
            rewardAmount: _rewardAmount,
            startTime: _startTime,
            duration: _duration,
            periodFinish: _startTime.add(_duration),
            rewardRate: _rewardRate,
            lastUpdateTime: _startTime,
            rewardPerTokenStored: 0,
            totalAmount: 0
        }));
        poolIndex[address(_lpToken)] = poolInfo.length - 1;
    }

    function stake(IERC20 _lpToken, uint _amount) external updateReward(msg.sender, _lpToken) {
        require(_amount > 0, "Cannot stake 0");
        _lpToken.safeTransferFrom(msg.sender, address(this), _amount);
        uint index = poolIndex[address(_lpToken)];
        poolInfo[index].deposits[msg.sender] = poolInfo[index].deposits[msg.sender].add(_amount);
        poolInfo[index].totalAmount = poolInfo[index].totalAmount.add(_amount);
    }

    function withdraw(IERC20 _lpToken, uint _amount) external updateReward(msg.sender, _lpToken) {
        require(_amount > 0, "Cannot stake 0");
        uint index = poolIndex[address(_lpToken)];
        poolInfo[index].deposits[msg.sender] = poolInfo[index].deposits[msg.sender].sub(_amount);
        _lpToken.safeTransfer(msg.sender, _amount);
    }

    function poolLength() external view returns(uint) {
        return poolInfo.length;
    }

    modifier updateReward(address account, IERC20 _lpToken) {
        uint index = poolIndex[address(_lpToken)];
        poolInfo[index].rewardPerTokenStored = rewardPerToken(address(_lpToken));
        poolInfo[index].lastUpdateTime = lastTimeRewardApplicable(address(_lpToken));
        if (account != address(0)) {
            poolInfo[index].rewards[account] = earned(account, address(_lpToken));
            poolInfo[index].userRewardPerTokenPaid[account] = poolInfo[index].rewardPerTokenStored;
        }
        _;
    }

    function lastTimeRewardApplicable(address _lpToken) public view returns (uint256) {
        uint index = poolIndex[_lpToken];
        return Math.min(block.timestamp, poolInfo[index].periodFinish);
    }

    function rewardPerToken(address _lpToken) public view returns (uint256) {
        uint index = poolIndex[_lpToken];
        if (poolInfo[index].totalAmount == 0) {
            return poolInfo[index].rewardPerTokenStored;
        }
        // 每个HT能获得的奖励 = 每个HT能获得的奖励 + ((当前区块时间 - 上次更新时间) * 每秒能获得的奖励 / 质押HT总量)
        return
            poolInfo[index].rewardPerTokenStored.add(
                lastTimeRewardApplicable(_lpToken)
                    .sub(poolInfo[index].lastUpdateTime)
                    .mul(poolInfo[index].rewardRate)
                    .mul(1e18)
                    .div(poolInfo[index].totalAmount)
            );
    }

    function earned(address account, address _lpToken) public view returns (uint256) {
        uint index = poolIndex[_lpToken];
        // 用户奖励 = 用户质押HT数量 * (每个HT能获得的奖励 - 每个令牌支付给用户的奖励) + 用户奖励
        return
            poolInfo[index].deposits[account]
                .mul(rewardPerToken(_lpToken).sub(poolInfo[index].userRewardPerTokenPaid[account]))
                .div(1e18)
                .add(poolInfo[index].rewards[account]);
    }
}
