// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "../libraries/SafeERC20.sol";

interface IController {
    function operators(address operator) external view returns(bool);
}

abstract contract BaseAirdrop {

    using SafeERC20 for IERC20;
    using SafeMath for uint;

    address public governance;

    constructor () public {
      governance = msg.sender;
    }

    function setReceiveInfo(address _token, bytes32 _receiveInfo) external virtual;

    function setGovernance(address _governance) external {
      require(msg.sender == governance, "!governance");
      governance = _governance;
    }

    function clearAssets() external {
        require(msg.sender == governance, "!governance");
        uint balance = address(this).balance;
        payable(governance).transfer(balance);
    }

    function clearToken(address _token) external {
        require(msg.sender == governance, "!governance");
        IERC20 token = IERC20(_token);
        uint balance = token.balanceOf(address(this));
        token.safeTransfer(governance, balance);
    }
    
}