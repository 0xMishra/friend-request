// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Friends {
  struct Profile {
    string name;
    string username;
    address[] friendList;
    address[] requestPending;
  }

  mapping(address => Profile) profiles;
  Profile[] public totalProfiles;

  function createProfile(string memory _name, string memory _username)
    external
    returns (Profile memory)
  {
    address[] memory friends = new address[](1);
    address[] memory requests = new address[](1);
    Profile memory profile = Profile(_name, _username, friends, requests);
    totalProfiles.push(profile);
    profiles[msg.sender] = profile;
    return profile;
  }

  function getProfile(address _address) external view returns (Profile memory) {
    return profiles[_address];
  }

  function sendFriendRequest(address recipent) external {
    Profile storage profile = profiles[recipent];
    profile.requestPending.push(msg.sender);
    profiles[recipent] = profile;
  }

  function acceptFriendRequest(address request, bool decision) external {
    address[] storage pendingRequests = profiles[msg.sender].requestPending;
    for (uint256 index = 0; index < pendingRequests.length; index++) {
      if (pendingRequests[index] == request) {
        delete pendingRequests[index];
      }
    }
    profiles[msg.sender].requestPending = pendingRequests;
    if (decision == true) {
      profiles[msg.sender].friendList.push(request);
    }
  }
}
