// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/SavingsBank.sol";

contract DeploySavingsBank is Script {
    function run() external {
        vm.startBroadcast();
        new SavingsBank();
        vm.stopBroadcast();
    }
}