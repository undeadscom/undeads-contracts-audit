// SPDX-License-Identifier: PROPRIERTARY

pragma solidity =0.8.17;

interface IRentRegistry {
    event Lend(
        bool is721,
        address indexed lenderAddress,
        address indexed nftAddress,
        uint256 indexed tokenID,
        uint256 lendingID,
        uint8 maxRentDuration,
        bytes4 dailyRentPrice,
        uint16 lendAmount,
        uint8 paymentToken,
        bool willAutoRenew
    );

    event Rent(
        address indexed renterAddress,
        uint256 indexed lendingID,
        uint256 indexed rentingID,
        uint16 rentAmount,
        uint8 rentDuration,
        uint32 rentedAt
    );

    event StopLend(uint256 indexed lendingID, uint32 stoppedAt, uint16 amount);

    event StopRent(
        uint256 indexed rentingID,
        uint256 renterAmount,
        uint256 lenderAmount,
        uint256 fee,
        uint32 stoppedAt
    );

    event RentClaimed(
        uint256 indexed rentingID,
        uint256 amount,
        uint256 fee,
        uint32 collectedAt
    );

    event RentFeeUpdated(address indexed token, uint256 feePercent);

    enum NFTStandard {
        E721,
        E1155
    }

    struct CallData {
        uint256 left;
        uint256 right;
        NFTStandard[] nftStandard;
        address[] nftAddress;
        uint256[] tokenID;
        uint256[] lendAmount;
        uint8[] maxRentDuration;
        bytes4[] dailyRentPrice;
        uint256[] lendingID;
        uint256[] rentingID;
        uint8[] rentDuration;
        uint256[] rentAmount;
        uint8[] paymentToken;
        bool[] willAutoRenew;
    }

    // fits into a single storage slot
    // nftStandard       2
    // lenderAddress   162
    // maxRentDuration 170
    // dailyRentPrice  202
    // lendAmount      218
    // availableAmount 234
    // paymentToken    242
    // willAutoRenew   250
    // leaves a spare byte
    struct Lending {
        NFTStandard nftStandard;
        address lenderAddress;
        uint8 maxRentDuration;
        bytes4 dailyRentPrice;
        uint16 lendAmount;
        uint16 availableAmount;
        uint8 paymentToken;
        bool willAutoRenew;
    }

    // fits into a single storage slot
    // renterAddress 160
    // rentDuration  168
    // rentedAt      216
    // rentAmount    232
    // leaves 3 spare bytes
    struct Renting {
        address renterAddress;
        uint8 rentDuration;
        uint32 rentedAt;
        uint16 rentAmount;
    }

    // creates the lending structs and adds them to the enumerable set
    function lend(
        NFTStandard[] memory nftStandard_,
        address[] memory nftAddress_,
        uint256[] memory tokenId_,
        uint256[] memory lendAmount_,
        uint8[] memory maxRentDuration_,
        bytes4[] memory dailyRentPrice_,
        uint8[] memory paymentToken_,
        bool[] memory willAutoRenew_
    ) external;

    function stopLend(
        NFTStandard[] memory nftStandard_,
        address[] memory nftAddress_,
        uint256[] memory tokenId_,
        uint256[] memory lendingId_
    ) external;

    // creates the renting structs and adds them to the enumerable set
    function rent(
        NFTStandard[] memory nftStandard_,
        address[] memory nftAddress_,
        uint256[] memory tokenID_,
        uint256[] memory lendingId_,
        uint8[] memory rentDuration_,
        uint256[] memory rentAmount
    ) external;

    function stopRent(
        NFTStandard[] memory nftStandard_,
        address[] memory nftAddress_,
        uint256[] memory tokenId_,
        uint256[] memory lendingId_,
        uint256[] memory rentingId
    ) external;

    function claimRent(
        NFTStandard[] memory nftStandard_,
        address[] memory nftAddress_,
        uint256[] memory tokenId_,
        uint256[] memory lendingId_,
        uint256[] memory rentingId
    ) external;
}
