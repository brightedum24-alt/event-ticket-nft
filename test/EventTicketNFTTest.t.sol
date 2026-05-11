// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/EventTicketNFT.sol";
import "../src/MockERC20.sol";

contract EventTicketNFTTest is Test {
    EventTicketNFT nft;
    MockERC20 token;

    address user = address(1);

    function setUp() public {
        token = new MockERC20();

        nft = new EventTicketNFT(
            0.01 ether,
            address(token),
            100 ether,
            2,
            100
        );

        vm.deal(user, 10 ether);
        token.transfer(user, 1000 ether);
    }

    function testMintWithETH() public {
        vm.prank(user);
        nft.mintWithETH{value: 0.01 ether}();
        assertEq(nft.balanceOf(user), 1);
    }

    function testMintWithToken() public {
        vm.startPrank(user);
        token.approve(address(nft), 100 ether);
        nft.mintWithToken();
        vm.stopPrank();
        assertEq(nft.balanceOf(user), 1);
    }
}
