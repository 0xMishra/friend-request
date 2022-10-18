// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/Friends.sol";

contract FriendsTest is Test {
  Friends friends;
  address public bob = 0x06e41f3efF3107f728Bf015E573E56389bf9181b;
  address public alice = 0x661F64De262622868824b3f61836D34e9644A07b;

  function setUp() public {
    friends = new Friends();
  }

  function testSendFriendRequest() public {
    friends.createProfile("bob", "@bob");
    vm.startPrank(alice);
    friends.sendFriendRequest(bob);
    address[] memory friendRequestsAfter = friends
      .getProfile(bob)
      .requestPending;
    emit log_address(friendRequestsAfter[0]);
    assertEq(friendRequestsAfter[0], alice);
  }

  function testAcceptFriendRequest() public {
    friends.createProfile("bob", "@bob");
    vm.startPrank(alice);
    friends.sendFriendRequest(bob);
    address[] memory friendRequests = friends.getProfile(bob).requestPending;
    vm.stopPrank();
    vm.startPrank(bob);
    address[] memory friendListBefore = friends.getProfile(bob).friendList;
    friends.acceptFriendRequest(alice, true);
    address[] memory friendListAfter = friends.getProfile(bob).friendList;
    address[] memory friendRequestsAfter = friends
      .getProfile(bob)
      .requestPending;
    emit log_array(friendListAfter);
    assertEq(friendListAfter[0], alice);
    assertEq(friendRequestsAfter[0], address(0));
  }

  function testRejectFriendRequest() public {
    friends.createProfile("bob", "@bob");
    vm.startPrank(alice);
    friends.sendFriendRequest(bob);
    address[] memory friendRequests = friends.getProfile(bob).requestPending;
    vm.stopPrank();
    vm.startPrank(bob);
    address[] memory friendListBefore = friends.getProfile(bob).friendList;
    friends.acceptFriendRequest(alice, false);
    address[] memory friendListAfter = friends.getProfile(bob).friendList;
    address[] memory friendRequestsAfter = friends
      .getProfile(bob)
      .requestPending;
    emit log_array(friendListAfter);
    assertEq(friendRequestsAfter[0], address(0));
  }
}
