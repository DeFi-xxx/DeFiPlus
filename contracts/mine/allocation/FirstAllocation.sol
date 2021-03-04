// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "../../interface/IERC20.sol";
import "../../libraries/Math.sol";
import "../../libraries/SafeMath.sol";
import "../../libraries/Address.sol";
import "../../libraries/SafeERC20.sol";
import "../interface/IMasterChef.sol";


contract FirstAllocation {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    IMasterChef masterChef;

    struct PoolInfo {
        // lp地址
        IERC20 lpToken;

        // 奖励token
        IERC20 rewardToken;

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
    mapping(bytes32 => uint) public poolIndex;

    constructor(IMasterChef _masterChef) public {
        masterChef = _masterChef;
    }

    function add(
        IERC20 _lpToken,
        IERC20 _rewardToken,
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
            rewardAmount: _rewardAmount,
            startTime: _startTime,
            duration: _duration,
            periodFinish: _startTime.add(_duration),
            rewardRate: _rewardRate,
            lastUpdateTime: _startTime,
            rewardPerTokenStored: 0,
            totalAmount: 0
        }));
        poolIndex[keccak256(abi.encode(_lpToken, _rewardToken))] = poolInfo.length - 1;
    }

    function stake(uint _amount, bytes32 _hash) external updateReward( msg.sender, _hash) {
        require(_amount > 0, "Cannot stake 0");
        uint index = poolIndex[_hash];
        poolInfo[index].deposits[ msg.sender] = poolInfo[index].deposits[ msg.sender].add(_amount);
        poolInfo[index].totalAmount = poolInfo[index].totalAmount.add(_amount);
    }


    function exit(bytes32 _hash) external {
        uint index = poolIndex[_hash];
        withdraw(_hash, poolInfo[index].deposits[ msg.sender]);
        getReward( _hash);
    }

    // 结算HTC奖励
    function getReward(bytes32 _hash) public updateReward( msg.sender, _hash) {
        uint256 reward = earned( msg.sender, _hash);
        uint index = poolIndex[_hash];
        if (reward > 0) {
            poolInfo[index].rewards[ msg.sender] = 0;
            poolInfo[index].rewardToken.safeTransfer( msg.sender, reward);
        }
    }

    function withdraw(bytes32 _hash, uint _amount) public updateReward( msg.sender, _hash) {
        require(_amount > 0, "Cannot stake 0");
        uint index = poolIndex[_hash];
        poolInfo[index].deposits[ msg.sender] = poolInfo[index].deposits[ msg.sender].sub(_amount);
        poolInfo[index].lpToken.safeTransfer( msg.sender, _amount);
    }

    function poolLength() public view returns(uint) {
        return poolInfo.length;
    }

    modifier updateReward(address account, bytes32 _hash) {
        uint index = poolIndex[_hash];
        poolInfo[index].rewardPerTokenStored = rewardPerToken(_hash);
        poolInfo[index].lastUpdateTime = lastTimeRewardApplicable(_hash);
        if (account != address(0)) {
            poolInfo[index].rewards[account] = earned(account, _hash);
            poolInfo[index].userRewardPerTokenPaid[account] = poolInfo[index].rewardPerTokenStored;
        }
        _;
    }

    function lastTimeRewardApplicable(bytes32 _hash) public view returns (uint256) {
        uint index = poolIndex[_hash];
        return Math.min(block.timestamp, poolInfo[index].periodFinish);
    }

    function rewardPerToken(bytes32 _hash) public view returns (uint256) {
        uint index = poolIndex[_hash];
        if (poolInfo[index].totalAmount == 0) {
            return poolInfo[index].rewardPerTokenStored;
        }
        // 每个HT能获得的奖励 = 每个HT能获得的奖励 + ((当前区块时间 - 上次更新时间) * 每秒能获得的奖励 / 质押HT总量)
        return
            poolInfo[index].rewardPerTokenStored.add(
                lastTimeRewardApplicable(_hash)
                    .sub(poolInfo[index].lastUpdateTime)
                    .mul(poolInfo[index].rewardRate)
                    .mul(1e18)
                    .div(poolInfo[index].totalAmount)
            );
    }

    function earned(address account, bytes32 _hash) public view returns (uint256) {
        uint index = poolIndex[_hash];
        // 用户奖励 = 用户质押HT数量 * (每个HT能获得的奖励 - 每个令牌支付给用户的奖励) + 用户奖励
        return
            poolInfo[index].deposits[account]
                .mul(rewardPerToken(_hash).sub(poolInfo[index].userRewardPerTokenPaid[account]))
                .div(1e18)
                .add(poolInfo[index].rewards[account]);
    }

}