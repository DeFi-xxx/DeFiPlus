// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "../interface/IERC20.sol";
import "../libraries/Math.sol";
import "../libraries/SafeMath.sol";
import "../libraries/Address.sol";
import "../libraries/SafeERC20.sol";

interface IAllocation {
    function add(IERC20 _lpToken, IERC20 _rewardToken, uint _rewardAmount, uint _startTime, uint _duration) external;

    function stake(address _account, uint _amount, bytes32 _hash) external;

    function getReward(address _account, bytes32 _hash) external;

    function withdraw(address _account, bytes32 _hash, uint _amount) external;

    function exit(address _account, bytes32 _hash) external;
}

contract MasterChef {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    // 治理地址
    address public governance;

    mapping(bytes32 => address) public allocations;

    constructor() public {
        governance = msg.sender;
    }

    function getAllocation(address _lpToken, address _rewardToken) public view returns(address) {
        bytes32 _hash = keccak256(abi.encodePacked(_lpToken, _rewardToken));
        return allocations[_hash];
    }

    function setAllocation(address _lpToken, address _rewardToken, address _allocation) internal {
        bytes32 _hash = keccak256(abi.encodePacked(_lpToken, _rewardToken));
        allocations[_hash] = _allocation;
    }
}
