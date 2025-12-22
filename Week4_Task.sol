// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract ATM {
    address public owner;
    bool public isPaused;

    mapping(address => uint) public balance;
    
    modifier onlyOwner(){
        require(msg.sender == owner, "Not the owner");
        _;
    }

    modifier whenNotPaused() {
        require(!isPaused, "The ATM is currently out of order");
        _;
    }

    constructor() {
        owner = msg.sender; 
        isPaused = false;
    } 

    function deposit() public payable whenNotPaused {
        require(msg.value > 0, "You must send something");
        balance[msg.sender] += msg.value;
    }

    function withdraw(uint _amount) public whenNotPaused {
        require(balance[msg.sender] >= _amount, "Insufficient balance!");
        
        balance[msg.sender] -= _amount;
        
        payable(msg.sender).transfer(_amount);
    }

    function getBalance() public view returns (uint) {
        return balance[msg.sender];
    }

    function togglePause() public onlyOwner {
        isPaused = !isPaused;
    }
}