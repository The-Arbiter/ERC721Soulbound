// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Soulbound} from "src/Soulbound.sol";

/// @title Soulbound Token
/// @author Andreas Bigger <https://github.com/abigger87>
/// @dev ERC721 Token that can be burned and minted but not transferred.
contract SBT is Soulbound {

  /// @notice The total supply of tokens
  uint256 public totalSupply = 0;

  /// @notice Instantiate Metadata
  constructor() Soulbound("Soulbound Token", "SBT"){}

  /// @notice Mint a token to the given address
  function safeMint(address to) public payable {
    _safeMint(to, totalSupply);
    ++totalSupply;
  }

  /// @notice Burn the given token
  function burn(uint256 id) public payable {
    _burn(id);
    --totalSupply;
  }

  /// @notice Implement an empty uri func
  function tokenURI(uint256 id) public view override returns (string memory) {}

}