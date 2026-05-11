// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/EventTicketNFT.sol";
import "../src/MockERC20.sol";

contract DeployEventTicketNFT is Script {
    function run() external {
        vm.startBroadcast();

        MockERC20 token = new MockERC20();

        new EventTicketNFT(
            0.01 ether,
            address(token),
            100 ether,
            2,
            100
        );

        vm.stopBroadcast();
    }
}
