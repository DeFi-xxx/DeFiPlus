// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "../BaseAirdrop.sol";

contract ManualAirdrop is BaseAirdrop {

    address public provider;

    address public controller;

    address WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;

    mapping(address => bytes32) receiveInfoMap;

    mapping(address => mapping(bytes32 => bool)) claimedMap;

    // struct account

    constructor(address _controller) public {
        controller = _controller;
    }

    function setReceiveInfo(address _token, bytes32 _receiveInfo) external override {
        require(msg.sender == controller, "!controller");
        receiveInfoMap[_token] = _receiveInfo;
    }

    function claim(address _token, uint _value) external {
        bytes32 receiveInfo = keccak256(abi.encode(_token, _value));
        require(receiveInfoMap[_token] == receiveInfo && !claimedMap[msg.sender][receiveInfo], "claims");
        claimedMap[msg.sender][receiveInfo] = true;
        if(_token != WBNB) {
            IERC20 token = IERC20(_token);
            token.safeTransferFrom( msg.sender, msg.sender, _value);
        } else {
            payable(msg.sender).transfer(_value);
        }
        
    }

    function setController(address _controller) external {
        require(msg.sender == governance, "!governance");
        controller = _controller;
    }

}