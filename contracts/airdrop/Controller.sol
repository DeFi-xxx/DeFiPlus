// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "../libraries/SafeERC20.sol";

interface BaseAirdrop {
    function setReceiveInfo(address _token, bytes32 _receiveInfo) external;
}

contract Controller {

    using SafeERC20 for IERC20;
    using SafeMath for uint;

    // 治理地址
    address public governance;

    // 收费开关
    bool private open = false;

    // HT费用
    uint private fee;

    // token费用占比 分母为10000
    uint private tokenPct;

    // 空投方式计数
    uint public numAirdrop;

    uint public numProject;

    // 空投项目信息
    ProjectInfo[] public projectInfos;

    // 操作者映射
    mapping (address => bool) public operators;

    // 空投方式
    mapping(uint => AirdropType) public airdrops;

    event Airdrop(address indexed _src, address indexed _token, uint _value);

    struct AirdropType {
        // 激活否
        bool active;

        // 空投方式地址
        address airdrop;

        // 空投方式介绍
        bytes introduction;
    }

    struct ProjectInfo {
        // 发起者
        address initiator;

        // 项目hash
        bytes project;

        // 空投总量
        uint totalNum;

        // 空投开始时间
        uint starTime;

        // 空投方式
        uint option;
    }

    constructor () public {
      governance = msg.sender;
    }

    function airdrop(address _token, uint _totalNum, uint _value, uint _option, bytes memory _project) external payable {
        if(open) {
            require(msg.value >= fee, "insufficient fee");
            payable(governance).transfer(msg.value);
            IERC20 token = IERC20(_token);
            token.safeTransferFrom(msg.sender, governance, _totalNum.mul(tokenPct).div(10000));
        }
        require(airdrops[_option].active, "!active");
        bytes32 receiveInfo = keccak256(abi.encode(_token, _value));
        BaseAirdrop(airdrops[_option].airdrop).setReceiveInfo(_token, receiveInfo);
        projectInfos.push(ProjectInfo(msg.sender, _project, _totalNum, block.timestamp, _option));
        numProject++;
        emit Airdrop(msg.sender, _token, _value);
    }

    function addAirdrop(address _airdrop, bytes memory _introduction) external {
      require(msg.sender == governance, "!governance");
      airdrops[numAirdrop] = AirdropType(true, _airdrop, _introduction);
      numAirdrop++;
    }

    function setAirdrop(uint _index, bool _active, address _airdrop, bytes memory _introduction) external {
      require(msg.sender == governance, "!governance");
      airdrops[_index] = AirdropType(_active, _airdrop, _introduction);
    }

    function setGovernance(address _governance) external {
      require(msg.sender == governance, "!governance"); 
      governance = _governance;
    }

    function addOperator(address _operator) external {
      require(msg.sender == governance, "!governance");
      operators[_operator] = true;
    }
  
    function removeOperator(address _operator) external {
        require(msg.sender == governance, "!governance");
        operators[_operator] = false;
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

    function setFeeInfo(bool _open, uint _fee) external {
        require(msg.sender == governance, "!governance");
        open = _open;
        fee = _fee;
    }

    // 收费信息
    function feeInfo() external view returns(bool, uint, uint) {
        return(open, fee, tokenPct);
    }
}