// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Whitelist.sol";

contract CryptoDevs is ERC721Enumerable, Ownable {
    uint256 public constant _price = 0.01 ether;

    uint256 public constant maxTokenIds = 20;

    Whitelist whitelisted;

    uint256 public reservedTokens;
    uint256 public reservedTokensClaimed = 0;

    constructor(address whitelistContract) ERC721("Crypto Devs", "CD") {
        whitelisted = Whitelist(whitelistContract);
        reservedTokens = whitelisted.maxWhitelistedAddresses();
    }

    function mint() public payable {
        // Make sure we always leave enough room for whitelist reservations
        require(
            totalSupply() + reservedTokens - reservedTokensClaimed <
                maxTokenIds,
            "EXCEEDED_MAX_SUPPLY"
        );

        // If user is part of the whitelist, make sure there is still reserved tokens left
        if (whitelisted.whitelistedAddress(msg.sender) && msg.value < _price) {
            // Make sure user doesn't already own an NFT
            require(balanceOf(msg.sender) == 0, "ALREADY_OWNED");
            reservedTokensClaimed += 1;
        } else {
            require(msg.value >= _price, "NOT_ENOUGH_ETHER");
        }
        uint256 tokenId = totalSupply();
        _safeMint(msg.sender, tokenId);
    }

    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }
}
