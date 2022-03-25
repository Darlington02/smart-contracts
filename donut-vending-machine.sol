// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract VendingMachine{

    address public owner;
    uint public vendingMachineBalance;
    mapping(address => uint) public donutBalances;

    constructor() {
        owner = msg.sender;
        vendingMachineBalance = 100;
    }

    // A modifier that ensures only the owner of the contract can call a function
    modifier onlyOwner{
        require(msg.sender == owner, "This can only be called by the contract's owner");
        _;
    }

    // A payble function that sells donuts to the user after he makes payment
    function purchase(uint amount) public payable{
        uint price = 2 * amount; 
        require(msg.value >= price, "Insufficient payment");
        vendingMachineBalance -= amount;
        donutBalances[msg.sender] += amount;
    }

    // A function that helps the owner restock donuts
    function restock(uint _restockAmount) public onlyOwner{
        vendingMachineBalance += _restockAmount;
    }
}
