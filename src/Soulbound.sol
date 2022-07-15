// SPDX-License-Identifier: MIT
/// @author 0xArbiter

pragma solidity ^0.8.15;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Burnable.sol";

/**
 * @title ERC721 Soulbound Token
 * @dev ERC721 Token that can be burned and minted but not transferred.
 */
contract Soulbound is ERC721, ERC721Burnable {

    // Custom SBT error for if users try to transfer
    error TokenIsSoulbound();

    /// @dev Put your NFT's name and symbol here
    constructor() ERC721("Soulbound Token", "SBT"){}

    /// TokenId counter for minting
    uint256 public tokenId = 0;

    /// @dev Mint function for testing
    function safeMint(address to) public payable {
        _safeMint(to, tokenId);
        ++tokenId;
    } 

    /**
     * @dev Enforces that tokens cannot be sent in a manner consistent with the 'Soulbound' spec.
     *
     * Requirements:
     *
     * - The `from` address must be the 0 address
     * OR
     * - The `to` address must be the 0 address
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId 
    ) internal pure override {

        // Revert if transfers are not from the 0 address and not to the 0 address
        if(from != address(0) && to != address(0)){
            revert TokenIsSoulbound();
        }

        return;
    }

}