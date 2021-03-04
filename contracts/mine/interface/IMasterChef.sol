// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

interface IMasterChef {
    function getAllocation(address _lpToken, address _rewardToken) external view returns(address);
}