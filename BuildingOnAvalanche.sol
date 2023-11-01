// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts@4.9.0/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.9.0/access/Ownable.sol";

// Added the SafeMath library
import "@openzeppelin/contracts@4.9.0/utils/math/SafeMath.sol";

contract DegenToken is ERC20, Ownable {
    // Prevents overflow and underflow for arithmetic operations
    using SafeMath for uint256;

    // Gacha Item Objects
    enum GachaItem {None, Glasses, Tshirt, PC}

    // Mapping each address to the burned tokens (required to burn before obtaining gacha) and inventory item objects
    mapping(address => uint256) public burnedTokens;
    mapping(address => GachaItem[]) public inventory;

    // Events triggered whenever the user uses the gacha function
    event GachaResult(address indexed user, GachaItem item);
    event InventoryUpdated(address indexed user, GachaItem[] items); // Updates inventory with the gacha result

    // Initializes 10000000000000000000000 Degen coins
    constructor() ERC20("Degen", "DGN") {
        _mint(msg.sender, 10000 * (10 ** uint256(decimals())));
    }

    // Mints coins, can only be used by the owner
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Burns coins
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
        burnedTokens[msg.sender] = burnedTokens[msg.sender].add(amount);
    }

    // Main gacha function
    function gacha() public {
        // You will need to have at least 100 coins to use a gacha
        require(balanceOf(msg.sender) >= 100, "Insufficient balance to play gacha");
        // You should at least burn once
        require(burnedTokens[msg.sender] >= 1, "You must have burned tokens to play gacha");

        // Initializes a random number for the gacha
        uint256 randomNumber = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, msg.sender))) % 100;

        // Creates empty object
        GachaItem item;

        // Initializes the item object, depending on what number the system generates
        // If 2%, will provide the user a PC
        if (randomNumber < 2) {
            item = GachaItem.PC;
        } else if (randomNumber < 35) { // If 35%, will provide the user a t-shirt
            item = GachaItem.Tshirt;
        } else {
            item = GachaItem.Glasses; // If anything else, provide the user a pair of glasses
        }

        // Adds the item into the inventory mapped to the address
        inventory[msg.sender].push(item);
        // Deduct 100 tokens for each gacha attempt
        _burn(msg.sender, 100); 

        // Emit the events
        emit GachaResult(msg.sender, item); 
        emit InventoryUpdated(msg.sender, inventory[msg.sender]);
    }

    // Displays the inventory of the user
    function getInventory() public view returns (string memory) {
        // Grabs the inventory mapped to the user from memory
        GachaItem[] memory items = inventory[msg.sender];
        uint256 glassesCount;
        uint256 tshirtCount;
        uint256 pcCount;

        // Counts the item objects that the user has (segregated with the different prizes)
        for (uint256 i = 0; i < items.length; i++) {
            if (items[i] == GachaItem.Glasses) {
                glassesCount++;
            } else if (items[i] == GachaItem.Tshirt) {
                tshirtCount++;
            } else if (items[i] == GachaItem.PC) {
                pcCount++;
            }
        }

        // Returns the string version of the count of each item in inventory
        return string(abi.encodePacked(
            "Glasses: ", uint2str(glassesCount),
            ", Tshirt: ", uint2str(tshirtCount),
            ", PC: ", uint2str(pcCount)
        ));
    }

    // Converts uint into string for the inventory count using the SafeMath library
    function uint2str(uint _i) internal pure returns (string memory str) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint k = length;
        j = _i;
        while (j != 0) {
            bstr[--k] = bytes1(uint8(48 + j % 10));
            j /= 10;
        }
        str = string(bstr);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
}
