// SPDX-License-Identifier: MIT
/// @author 0xArbiter

pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "../src/Soulbound.sol";

contract SoulboundTest is Test,IERC721Receiver {

    Soulbound soulbound;

    function setUp() public {
        soulbound = new Soulbound();
    }

    // Token ID for tests has to be monitored
    uint256 tokenId;

    // Allow the contract to receive ERC721 for testing
    function onERC721Received(
        address operator, 
        address from, 
        uint256 tokenId, 
        bytes calldata data
    ) public pure override returns (bytes4){
        return IERC721Receiver.onERC721Received.selector;
    }

    function fuzzingRestrictions(address someAddress) internal{
        vm.assume(someAddress != address(0));
        vm.assume(someAddress != address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
        vm.assume(someAddress != address(0xCe71065D4017F316EC606Fe4422e11eB2c47c246));
    }

    // Test that tokens can be minted
    function test_mint_tokens(address tokenOwner_ ) public{
        
        fuzzingRestrictions(tokenOwner_);

        // Check old balance
        uint256 existingBalance = soulbound.balanceOf(address(tokenOwner_));
        // Mint a token
        soulbound.safeMint{value:0} (address(tokenOwner_));
        // Check new balance
        uint256 newBalance = soulbound.balanceOf(address(tokenOwner_));

        // Check that our token balance increased by 1
        if(newBalance - existingBalance != 1){
            revert("No tokens were sent to the test contract.");
        }

        

    }

    // Test that tokens can be burnt
    function test_burn_tokens(address tokenOwner_ ) public{
        
        // Mint tokens using the above test
        this.test_mint_tokens(tokenOwner_);
        
        // Check old balance
        uint256 existingBalance = soulbound.balanceOf(address(tokenOwner_));

        vm.startPrank(tokenOwner_);
        // Burn the token
        soulbound.burn(soulbound.tokenId() - 1);

        // Check new balance
        uint256 newBalance = soulbound.balanceOf(address(tokenOwner_));

        // Check that our token balance decreased by 1
        if(existingBalance - newBalance != 1){
            revert("No tokens were sent to the test contract.");
        }
    }

    // Test that tokens cannot be sent and thus are soulbound
    function test_cannot_send_soulbound_tokens(address tokenOwner_ , address tokenRecipient_) public{
        
        fuzzingRestrictions(tokenRecipient_);

        vm.assume(tokenOwner_ != tokenRecipient_);

        // Mint tokens using the above test
        this.test_mint_tokens(tokenOwner_);
        
        vm.startPrank(tokenOwner_);
        // Try to send a token
        soulbound.approve(address(tokenRecipient_), soulbound.tokenId() - 1);

        // Expect revert with `TokenIsSoulbound()` error type

        vm.expectRevert(Soulbound.TokenIsSoulbound.selector);

        soulbound.safeTransferFrom(address(tokenOwner_),address(tokenRecipient_), soulbound.tokenId() - 1);


    }

}
