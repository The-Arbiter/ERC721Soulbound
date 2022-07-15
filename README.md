# ERC721Soulbound

*Thanks to Andreas Bigger for fixing the error issues and porting it across to Solmate.*

### *Why does SBT need a new token standard?*

Watch me negate the need for a new Soulbound token spec using 2 functions.

### How does this work?

I use _beforeTokenTransfer() to check that:

1) The *from* address is the zero address (permits minting, does not permit transfers)
OR
2) The *to* address is the zero address (permits burning, does not permit transfers)

*Can someone mint to the zero address?*

OZ already handles this:

`require(to != address(0), "ERC721: mint to the zero address");`

### Okay, so you added 2 lines. So what?

The *so what* is that **this is all that a Soulbound token minimum spec would do**.

### Yeah but we don't want people to be able to list a SBT on OS and the sale fails, so we need a new spec!

First of all, if the sales always fail or contract behaviour breaks due to SBT limitations (i.e. no transfers) then this isn't really out problem.

Do you really want to retool everything to support these tokens? Not necessarily contract infra, since like has been pointed out, this will likely just not be applicable to SBT and break, but things like:

1) Blockchain scanners
2) Event watchers
3) Portfolio trackers
4) Literally anything offchain that interacts with ERC721s currently

to **all** need retooling?

### Okay but {some future valid reason why SBTs deserve their own spec}

Okay, fine, let's make a new spec.

In the meantime this repo serves as a basis for implementing SBTs which doesn't break interactions.

*If you're a SBT project that has been waiting for the token spec to be finalised so you can go to market, you don't have to wait anymore.*

### Footnotes

- beforeTokenTransfer is the best place to do our checks as _burn in the OZ contract uses this
- You could map tokenIds to bool to have semi-soulbound tokens where tokens are soulbound until they are 'unlocked' on a per-token basis
