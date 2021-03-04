pragma solidity ^0.6.12;

import "../../interface/IERC20.sol";
import "../../libraries/Math.sol";
import "../../libraries/SafeMath.sol";
import "../../libraries/Address.sol";
import "../../libraries/SafeERC20.sol";

interface MasterChef {
    function getAllocation(address _lpToken, address _rewardToken) external view returns(address);
}


contract SecondAllocation {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    MasterChef masterChef;

    struct PoolInfo {
        // lp地址
        IERC20 lpToken;

        // 奖励token
        IERC20 rewardToken;

        // 奖励数量
        uint rewardAmount;

        // 开始时间
        uint startTime;

        // 每秒获得的奖励
        uint rewardRate;

        // 质押总量
        uint totalAmount;

        // 每个质押token给用户的奖励
        mapping(address => uint256) lastUpdateTime;

        // 用户奖励
        mapping(address => uint256) rewards;

        // 入金映射
        mapping(address => uint256) deposits;
    }

    PoolInfo[] public poolInfo;

    // 池子索引
    mapping(bytes32 => uint) public poolIndex;

    constructor(MasterChef _masterChef) public {
        masterChef = _masterChef;
    }

    function add(
        IERC20 _lpToken,
        IERC20 _rewardToken,
        uint _rewardAmount,
        uint _startTime,
        uint _rewardRate
    ) external {
        require(block.timestamp <= _startTime, "invalid start time");
        _rewardToken.safeTransferFrom(msg.sender, address(this), _rewardAmount);
        poolInfo.push(PoolInfo({
            lpToken: _lpToken,
            rewardToken: _rewardToken,
            rewardAmount: _rewardAmount,
            startTime: _startTime,
            rewardRate: _rewardRate,
            totalAmount: 0
        }));
        poolIndex[keccak256(abi.encode(_lpToken, _rewardToken))] = poolInfo.length - 1;
    }

    function stake(uint _amount, bytes32 _hash) external updateReward(msg.sender, _hash) {
        require(_amount > 0, "Cannot stake 0");
        uint index = poolIndex[_hash];
        poolInfo[index].deposits[msg.sender] = poolInfo[index].deposits[msg.sender].add(_amount);
        poolInfo[index].totalAmount = poolInfo[index].totalAmount.add(_amount);
    }


    function exit(bytes32 _hash) external {
        uint index = poolIndex[_hash];
        withdraw(_hash, poolInfo[index].deposits[msg.sender]);
        getReward(_hash);
    }

    // 结算HTC奖励 
    function getReward(bytes32 _hash) public updateReward(msg.sender, _hash) {
        uint256 reward = earned(msg.sender, _hash);
        uint index = poolIndex[_hash];
        if (reward > 0) {
            poolInfo[index].rewards[msg.sender] = 0;
            poolInfo[index].rewardToken.safeTransfer(msg.sender, reward);
        }
    }

    function withdraw(bytes32 _hash, uint _amount) public updateReward(msg.sender, _hash) {
        require(_amount > 0, "Cannot stake 0");
        uint index = poolIndex[_hash];
        poolInfo[index].deposits[msg.sender] = poolInfo[index].deposits[msg.sender].sub(_amount);
        poolInfo[index].lpToken.safeTransfer(msg.sender, _amount);
    }

    function poolLength() public view returns(uint) {
        return poolInfo.length;
    }

    modifier updateReward(address account, bytes32 _hash) {
        uint index = poolIndex[_hash];
        if (account != address(0)) {
            poolInfo[index].rewards[account] = earned(account, _hash);
            poolInfo[index].lastUpdateTime[account] = block.timestamp;
        }
        _;
    }

    function earned(address account, bytes32 _hash) public view returns (uint256) {
        uint index = poolIndex[_hash];
        return poolInfo[index].deposits[account]
            .mul(block.timestamp.sub(poolInfo[index].lastUpdateTime[account]))
            .mul(poolInfo[index].rewardRate)
            .div(1e18)
            .add(poolInfo[index].rewards[account]);
    }

}