// SPDX-License-Identifier: MIT
/// @author 0xArbiter

pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {SBT} from "./mocks/SBT.sol";
import {ERC721TokenReceiver} from "solmate/tokens/ERC721.sol";

contract SoulboundTest is Test, ERC721TokenReceiver {
    SBT soulbound;

    function setUp() public {
        soulbound = new SBT();
    }

    // Allow the contract to receive ERC721 for testing
    function onERC721Received(address, address, uint256, bytes calldata) public pure override returns (bytes4){
        return ERC721TokenReceiver.onERC721Received.selector;
    }

    function fuzzingRestrictions(address someAddress) internal{
        vm.assume(someAddress != address(0));
        vm.assume(someAddress != address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
        vm.assume(someAddress != address(0xCe71065D4017F316EC606Fe4422e11eB2c47c246));
    }

    // Test that tokens can be minted
    function testMintTokens(address tokenOwner_ ) public{
        fuzzingRestrictions(tokenOwner_);

        // Check old balance
        uint256 existingBalance = soulbound.balanceOf(tokenOwner_);
        soulbound.safeMint{value:0}(tokenOwner_);
        uint256 newBalance = soulbound.balanceOf(tokenOwner_);

        // Check that our token balance increased by 1
        if(newBalance - existingBalance != 1){
            revert("No tokens were sent to the test contract.");
        }
    }

    // Test that tokens can be burnt
    function testBurnTokens(address tokenOwner_ ) public{
        // Mint tokens using the above test
        this.testMintTokens(tokenOwner_);

        // Check old balance
        uint256 existingBalance = soulbound.balanceOf(tokenOwner_);

        // Burn the tokens
        uint256 token_id = soulbound.totalSupply() - 1;
        vm.prank(tokenOwner_);
        soulbound.burn(token_id);
        uint256 newBalance = soulbound.balanceOf(tokenOwner_);

        // Check that our token balance decreased by 1
        if(existingBalance - newBalance != 1){
            revert("No tokens were sent to the test contract.");
        }
    }

    // Test that tokens cannot be sent and thus are soulbound
    function testCannotSendSoulboundTokens(address tokenOwner_ , address tokenRecipient_) public{
        fuzzingRestrictions(tokenRecipient_);
        vm.assume(tokenOwner_ != tokenRecipient_);

        // Mint tokens using the above test
        this.testMintTokens(tokenOwner_);

        // Try to send a token
        vm.startPrank(tokenOwner_);
        uint256 new_id = soulbound.totalSupply() - 1;
        soulbound.approve(address(tokenRecipient_), new_id);

        // Expect revert with `TokenIsSoulbound()` error type
        vm.expectRevert(abi.encodeWithSignature("TokenIsSoulbound()"));
        soulbound.safeTransferFrom(tokenOwner_, tokenRecipient_, new_id);

        vm.stopPrank();
    }

}
