// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title StudentSavingsWallet
 * @dev A decentralized wallet for students to save ETH securely.
 */
contract StudentSavingsWallet {
    
    // --- State Variables ---
    address public owner;
    
    struct Transaction {
        string txType;    // "Deposit" or "Withdraw"
        uint256 amount;   // Amount in wei
        uint256 timestamp;
    }

    // Mapping of user addresses to their current balance
    mapping(address => uint256) public balances;
    
    // Mapping of user addresses to their history of transactions
    mapping(address => Transaction[]) public transactionHistory;

    // --- Events (Bonus) ---
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    constructor() {
        owner = msg.sender; // The person who deploys the contract
    }

    // --- Core Functions ---

    /**
     * @dev Allows users to deposit ETH into the contract.
     * The 'payable' modifier allows the function to receive ETH.
     */
    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");

        // Update state
        balances[msg.sender] += msg.value;
        
        // Record transaction history
        transactionHistory[msg.sender].push(Transaction({
            txType: "Deposit",
            amount: msg.value,
            timestamp: block.timestamp
        }));

        emit Deposit(msg.sender, msg.value);
    }

    /**
     * @dev Allows users to withdraw their saved ETH.
     * @param _amount The amount of ETH (in wei) to withdraw.
     */
    function withdraw(uint256 _amount) public {
        require(_amount > 0, "Withdrawal amount must be greater than 0");
        require(balances[msg.sender] >= _amount, "Insufficient balance in your savings");

        // Update balance before sending to prevent Reentrancy attacks
        balances[msg.sender] -= _amount;

        // Record transaction history
        transactionHistory[msg.sender].push(Transaction({
            txType: "Withdraw",
            amount: _amount,
            timestamp: block.timestamp
        }));

        // Perform the transfer
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Transfer failed");

        emit Withdraw(msg.sender, _amount);
    }

    // --- View Functions ---

    /**
     * @dev Returns the balance of the caller.
     */
    function getMyBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    /**
     * @dev Returns the full transaction history of the caller.
     */
    function getMyHistory() public view returns (Transaction[] memory) {
        return transactionHistory[msg.sender];
    }

    /**
     * @dev Returns the total balance held by the contract (Owner only hint).
     */
    function getContractTotalBalance() public view returns (uint256) {
        return address(this).balance;
    }
}