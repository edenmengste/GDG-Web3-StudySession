// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/SavingsBank.sol";

contract SavingsBankTest is Test {
    SavingsBank public bank;
    address user1 = address(0x1);
    address user2 = address(0x2);

    function setUp() public {
        bank = new SavingsBank();
        vm.deal(user1, 10 ether);
        vm.deal(user2, 10 ether);
    }

    function testDeposit() public {
        vm.prank(user1);
        bank.deposit{value: 1 ether}();
        assertEq(bank.getUserBalance(user1), 1 ether);
        assertEq(bank.getTotalBankBalance(), 1 ether);
    }

    function testWithdrawSuccess() public {
        vm.startPrank(user1);
        bank.deposit{value: 2 ether}();
        bank.withdraw(1 ether);
        vm.stopPrank();

        assertEq(bank.getUserBalance(user1), 1 ether);
        assertEq(user1.balance, 9 ether); // 10 - 2 + 1
    }

    function test_RevertIfWithdrawMoreThanBalance() public {
        vm.prank(user1);
        bank.deposit{value: 1 ether}();
        
        vm.prank(user1);
        vm.expectRevert(SavingsBank.InsufficientBalance.selector);
        bank.withdraw(2 ether);
    }

    function testMultipleUsers() public {
        vm.prank(user1);
        bank.deposit{value: 1 ether}();
        
        vm.prank(user2);
        bank.deposit{value: 2 ether}();

        assertEq(bank.getTotalBankBalance(), 3 ether);
        assertEq(bank.getUserBalance(user1), 1 ether);
        assertEq(bank.getUserBalance(user2), 2 ether);
    }
}