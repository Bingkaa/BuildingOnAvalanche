# DegenToken

## Description

`DegenToken` is an Ethereum ERC20 token with added functionalities including minting, burning, and a gacha game. It also tracks the inventory of users based on gacha results.

## Features

- Minting new tokens.
- Burning existing tokens.
- Gacha game with different item probabilities.
- Tracking user inventory.

### Usage

1. Deploy the contract to your chosen Ethereum network using a development framework like Truffle.

2. Interact with the contract using a web3-enabled application or a Truffle console.

## Contract Details

- Name: DegenToken
- Symbol: DGN
- Initial Supply: 10,000
- Decimals: 18

## Functions

- `mint(address account, uint256 amount)`: Mint new tokens.
- `burn(uint256 amount)`: Burn existing tokens.
- `gacha()`: Play the gacha game and receive an item.
- `getInventory()`: Get the user's inventory of items.
- `transfer(address recipient, uint256 amount)`: Transfer tokens to another address.

## Gacha Game

The gacha game allows users to spend 100 tokens for a chance to get different items:
- Glasses (60% chance)
- Tshirt (33% chance)
- PC (2% chance)

## Inventory

The contract keeps track of the user's inventory based on gacha results. The inventory can be queried using the `getInventory` function.
