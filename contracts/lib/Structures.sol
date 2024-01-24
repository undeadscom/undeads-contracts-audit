// SPDX-License-Identifier: PROPRIERTARY

// Author: Ilya A. Shlyakhovoy
// Email: is@unicsoft.com
pragma solidity 0.8.17;

/**
 * @dev Collection of structures
 */
library Structures {
    struct ActorData {
        uint256 adultTime;
        uint256 bornTime;
        string kidTokenUriHash;
        string adultTokenUriHash;
        uint16[10] props;
        uint8 childs;
        uint8 childsPossible;
        bool sex;
        bool born;
        bool immaculate;
        uint16 rank;
        address initialOwner;
    }

    struct Item {
        string itemKey;
        uint256 location;
        uint8 slots;
        string uri;
    }

    struct LootBox {
        uint256 price;
        uint16 total;
        uint16 available;
        bool paused;
        bool deleted;
        string uri;
        LootBoxItem[] items;
    }

    struct LootBoxItem {
        uint256 class;
        uint256 model;
        uint8 slots;
        uint16 promilles;
    }

    struct Estate {
        address lender;
        uint256 location;
        uint8 estateType;
        uint256 parent;
        uint256 coordinates;
    }

    struct Villa {
        uint256 location;
        uint256 fraction;
    }

    struct ManageAction {
        address target;
        address author;
        uint256 expiration;
        bytes4 signature;
        bytes data;
        bool executed;
    }

    struct InvestorData {
        address investor;
        uint256 promille;
    }

    struct Benefit {
        uint256 price;
        uint256 from;
        uint256 until;
        uint16 id;
        uint16 amount;
        uint8 level;
        uint8 issued;
    }

    struct BreedingParams {
        uint256 motherId;
        uint256 fatherId;
        uint256 breedingId;
        uint256 sessionId;
        uint256 breedingFee;
        uint256 deadline;
        address asset;
        bool isKidForMother;
    }
}
