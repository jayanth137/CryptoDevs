// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Whitelist {
    uint8 public maxWhitelistedAddresses;

    mapping(address => bool) public whitelistedAddress;

    uint8 public numAddressesWhitelisted;

    constructor(uint8 _maxWhitelistedAddresses) {
        maxWhitelistedAddresses = _maxWhitelistedAddresses;
    }

    function addAddressToWhitelist() public {
        require(
            !whitelistedAddress[msg.sender],
            "Sender has Already Waitlisted"
        );

        require(
            numAddressesWhitelisted < maxWhitelistedAddresses,
            "More Addresses cant be added, Limit Reached!"
        );

        whitelistedAddress[msg.sender] = true;
        numAddressesWhitelisted += 1;
    }
}
