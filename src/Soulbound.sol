// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {ERC721} from "solmate/tokens/ERC721.sol";

/// @title ERC721 Soulbound Token
/// @author 0xArbiter
/// @author Andreas Bigger <https://github.com/abigger87>
/// @dev ERC721 Token that can be burned and minted but not transferred.
abstract contract Soulbound is ERC721 {

    // Custom SBT error for if users try to transfer
    error TokenIsSoulbound();

    /// @dev Put your NFT's name and symbol here
    constructor(string memory name, string memory symbol) ERC721(name, symbol){}

    /// @notice Prevent Non-soulbound transfers
    function onlySoulbound(address from, address to) internal pure {
        // Revert if transfers are not from the 0 address and not to the 0 address
        if (from != address(0) && to != address(0)) {
            revert TokenIsSoulbound();
        }
    }

    /// @notice Override token transfers to prevent sending tokens
    function transferFrom(address from, address to, uint256 id) public override {
        onlySoulbound(from, to);
        super.transferFrom(from, to, id);
    }
}