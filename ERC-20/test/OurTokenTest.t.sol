// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";
import {Test, console} from "forge-std/Test.sol";

contract OurTokenTest is Test {

    OurToken public ourToken;
    DeployOurToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testAllowances() public {
        uint256 initialAllowance = 1000;

        // Bob approves Alice to spend tokens on his behalf by using ourToken.approve

        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);
        uint256 transferAmount = 500;

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);
        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }
    function testTransfer() public {

        vm.prank(bob);
        ourToken.transfer(alice, 10 ether);

        assertEq(ourToken.balanceOf(alice), 10 ether);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - 10 ether);
    }
    function testTransferFrom() public {
        uint256 transferAmount = 20 ether;

        vm.prank(bob);
        ourToken.approve(alice, transferAmount);

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);

        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }
    function testBalanceAfterTransfer() public {
    uint256 transferAmount = 10 ether;

    vm.prank(bob);
    ourToken.transfer(alice, transferAmount);

    uint256 aliceBalance = ourToken.balanceOf(alice);
    uint256 bobBalance = ourToken.balanceOf(bob);

    assertEq(aliceBalance, transferAmount);
    assertEq(bobBalance, STARTING_BALANCE - transferAmount);
}
//self transfer
function testTransferToSelf() public {
    uint256 amount = 10 ether;

    vm.prank(bob);
    ourToken.transfer(bob, amount);

    assertEq(ourToken.balanceOf(bob), STARTING_BALANCE);
}

//zero transfer
function testTransferZeroTokens() public {
    vm.prank(bob);
    ourToken.transfer(alice, 0);

    assertEq(ourToken.balanceOf(alice), 0);
}

}
