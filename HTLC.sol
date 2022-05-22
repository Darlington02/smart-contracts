//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns(bool);
}

contract HTLC {

    uint public startTime;
    uint public lockTime = 10000 seconds;
    string public secret;
    bytes32 public hash = "65462b0520ef7d3df61b9992ed3bea0c56ead753be7c8b3614e0ce01e4cac41b";
    address public recipient;
    address public owner;
    uint public amount;
    
    IERC20 public token;

    constructor(address _recipient, address _token, uint _amount) {
        recipient = _recipient;
        owner = msg.sender;
        amount = _amount;
        token = IERC(_token);
    }

    function fund() external {
        startTime = block.timeStamp;
        token.transferFrom(msg.sender, address(this), amount);
    }

    function withdraw(string memory _secret) external {
        require(keccak256(abi.encodePacked(_secret)) == hash, "Wrong secret!");
        secret = _secret;
        token.transfer(recipient, amount);
    }

    function refund() external {
        require(block.timeStamp > startTime + lockTime, "Too early for a refund!");
        token.transfer(owner, amount);
    }
}
