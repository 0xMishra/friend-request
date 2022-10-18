// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import { Friends } from "src/Friends.sol";

contract FriendsScript is Script {
  function setUp() public {}

  function run() public {
    vm.startBroadcast();
    new Friends();
    vm.stopBroadcast();
  }
}
