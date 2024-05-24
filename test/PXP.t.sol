// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {PXP404} from "../src/PXP404.sol";
import {ERC721Holder} from "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";

import {Test} from "forge-std/Test.sol";

contract PXP404Test is Test {
    //--------------------------------------------------------------------------------
    // State
    //--------------------------------------------------------------------------------

    PXP404 pxp;
    address owner = makeAddr("owner");
    address white = makeAddr("white");
    address white2 = makeAddr("white2");
    address normie = makeAddr("normie");
    address normie2 = makeAddr("normie2");
    address normie3 = makeAddr("normie3");
    address normie4 = makeAddr("normie4");

    function setUp() public {
        pxp = new PXP404(owner);

        vm.startPrank(owner);
        pxp.setWhitelistedStatus(white, true);
        pxp.setWhitelistedStatus(white2, true);
        vm.stopPrank();
    }

    function test_tokenSetup() public view {
        assertEq(pxp.owner(), owner);
        assertEq(pxp.totalSupply(), 30_000 ether);
        assertEq(pxp.balanceOf(owner), 30_000 ether);
        uint[] memory ids = pxp.userOwnedIds(owner);
        assertEq(ids.length, 0);
    }

    function test_ownerToWhitelisted() public {
        // escribir el test para enviar 10_000 tokens al usuario whitelisted
        vm.prank(owner);
        pxp.transfer(white, 10_000 ether);

        assertEq(pxp.balanceOf(white), 10_000 ether);
        assertEq(pxp.userOwnedIds(white).length, 0);

        // escribir el test para enviar 2_500 tokens al usuario whitelisted
        vm.prank(owner);
        pxp.transfer(white2, 2_500 ether);

        assertEq(pxp.balanceOf(white2), 2_500 ether);
        assertEq(pxp.userOwnedIds(white2).length, 0);
    }

    function test_ownerToNormie() public {
        // Owner cannot transfer ids
        vm.expectRevert();
        vm.prank(owner);
        pxp.transfer(normie, 15);

        vm.prank(owner);
        pxp.transfer(normie, 15 ether);

        assertEq(pxp.balanceOf(normie), 15 ether);
        uint[] memory ids = pxp.userOwnedIds(normie);
        assertEq(ids.length, 15);
        for (uint i = 0; i < 15; i++) {
            assertEq(ids[i], i + 1);
        }

        vm.prank(owner);
        pxp.transfer(normie2, 9.3 ether);
        assertEq(pxp.balanceOf(normie2), 9.3 ether);
        uint[] memory ids2 = pxp.userOwnedIds(normie2);
        assertEq(ids2.length, 9);
        for (uint i = 0; i < 9; i++) {
            assertEq(ids2[i], i + 16);
        }

        assertEq(pxp.balanceOf(owner), 30_000 ether - 15 ether - 9.3 ether);
        assertEq(pxp.userOwnedIds(owner).length, 0);
    }

    function test_whitelistToNormie() public {
        vm.prank(owner);
        pxp.transfer(white, 10 ether);

        vm.prank(white);
        pxp.transfer(normie, 4.01 ether);

        assertEq(pxp.balanceOf(white), 5.99 ether);
        assertEq(pxp.balanceOf(normie), 4.01 ether);

        assertEq(pxp.userOwnedIds(white).length, 0);
        assertEq(pxp.userOwnedIds(normie).length, 4);

        uint[] memory ids = pxp.userOwnedIds(normie);

        for (uint i = 0; i < 4; i++) {
            assertEq(ids[i], i + 1);
        }
    }

    function test_whitelistToWhitelist() public {
        vm.prank(owner);
        pxp.transfer(white, 10 ether);

        vm.prank(white);
        pxp.transfer(white2, 5 ether);

        assertEq(pxp.balanceOf(white), 5 ether);
        assertEq(pxp.balanceOf(white2), 5 ether);

        assertEq(pxp.userOwnedIds(white).length, 0);
        assertEq(pxp.userOwnedIds(white2).length, 0);
    }

    function test_normieToNormie() public {
        vm.prank(owner);
        pxp.transfer(normie, 15 ether); // IDS 0 - 14

        vm.prank(normie);
        pxp.transfer(normie2, 9.3 ether); // ids held = 9 => [14,13,12,11,10,9,8,7,6].. id in queue [5].

        assertEq(pxp.balanceOf(normie), 5.7 ether);
        assertEq(pxp.balanceOf(normie2), 9.3 ether);

        assertEq(pxp.userOwnedIds(normie).length, 5);
        assertEq(pxp.userOwnedIds(normie2).length, 9);

        uint[] memory ids = pxp.userOwnedIds(normie);
        for (uint i = 0; i < 5; i++) {
            assertEq(ids[i], i + 1);
        }
        ids = pxp.userOwnedIds(normie2);
        for (uint i = 0; i > 9; i++) {
            assertEq(ids[i], 15 - i);
        }

        vm.prank(owner);
        pxp.transfer(normie3, 1 ether);

        assertEq(pxp.balanceOf(normie3), 1 ether);
        assertEq(pxp.userOwnedIds(normie3).length, 1);
        assertEq(pxp.userOwnedIds(normie3)[0], 6);
    }

    function test_normieToWhitelist() public {
        vm.prank(owner);
        pxp.transfer(normie, 10 ether);

        vm.prank(normie);
        pxp.transfer(white, 5.8 ether);

        assertEq(pxp.balanceOf(normie), 4.2 ether);
        assertEq(pxp.balanceOf(white), 5.8 ether);

        assertEq(pxp.userOwnedIds(normie).length, 4);
        assertEq(pxp.userOwnedIds(white).length, 0);

        assertEq(pxp.ownerOf(5), address(0));
        assertEq(pxp.ownerOf(6), address(0));
        assertEq(pxp.ownerOf(7), address(0));
        assertEq(pxp.ownerOf(8), address(0));
        assertEq(pxp.ownerOf(9), address(0));
        assertEq(pxp.ownerOf(10), address(0));
    }

    function test_transferFromWithID() public {
        vm.prank(owner);
        pxp.transfer(normie, 10 ether);
        /// Normie approve normie3 to use ID 3
        vm.prank(normie);
        pxp.approve(normie3, 3);
        assertEq(pxp.getApproved(3), normie3);

        // Normie 3 attempts to transfer ID 1 from normie to normie4
        vm.expectRevert(PXP404.PXP404__InvalidApproval.selector);
        vm.prank(normie3);
        pxp.transferFrom(normie, normie4, 1);

        vm.prank(normie3);
        pxp.transferFrom(normie, normie4, 3);

        assertEq(pxp.getApproved(3), address(0));

        assertEq(pxp.balanceOf(normie), 9 ether);
        assertEq(pxp.balanceOf(normie4), 1 ether);
        assertEq(pxp.userOwnedIds(normie).length, 9);
        assertEq(pxp.userOwnedIds(normie4).length, 1);
        assertEq(pxp.userOwnedIds(normie4)[0], 3);
    }

    function test_transferFromWithBalance() public {
        vm.prank(owner);
        pxp.transfer(normie, 10 ether);

        /// Normie approves normie2 to use 2 ether of balance
        vm.prank(normie);
        pxp.approve(normie2, 2 ether);

        vm.expectRevert();
        vm.prank(normie2);
        pxp.transferFrom(normie, white, 1);

        vm.prank(normie2);
        pxp.transferFrom(normie, white, 1 ether);
        vm.prank(normie2);
        pxp.transferFrom(normie, normie4, 1 ether);

        assertEq(pxp.allowance(normie, normie2), 0);

        assertEq(pxp.balanceOf(normie), 8 ether);
        assertEq(pxp.balanceOf(white), 1 ether);
        assertEq(pxp.balanceOf(normie4), 1 ether);
        assertEq(pxp.userOwnedIds(normie4)[0], 9);
    }
}
