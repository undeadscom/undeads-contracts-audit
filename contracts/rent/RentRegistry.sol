// SPDX-License-Identifier: PROPRIERTARY
// For development, we used some code from open source with an MIT license
// https://github.com/re-nft/legacy-contracts

pragma solidity =0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "./interfaces/IRentResolver.sol";
import "./interfaces/IRentRegistry.sol";
import "../utils/GuardExtension.sol";

contract RentRegistry is IRentRegistry, ERC721Holder, ERC1155Holder, GuardExtension {
    using SafeERC20 for ERC20;

    IRentResolver private _resolver;
    address private _beneficiary;
    uint256 private _lendingID = 1;
    uint256 private _rentingID = 1;
    bool public _paused = false;
    mapping(address => uint256) private _rentFee;
    mapping(bytes32 => Lending) private _lendings;
    mapping(bytes32 => Renting) private _rentings;

    modifier notPaused() {
        require(!_paused, "ReNFT::paused");
        _;
    }

    constructor(
        address resolver_,
        address beneficiary_, 
        address rights_,
        address[] memory feeTokens_,
        uint256[] memory feePercents_
    ) GuardExtension(rights_) {
        require(feeTokens_.length == feePercents_.length, "ReNFT: Invalid input");
        ensureIsNotZeroAddr(resolver_);
        ensureIsNotZeroAddr(beneficiary_);
        ensureIsNotZeroAddr(rights_);
        _resolver = IRentResolver(resolver_);
        _beneficiary = beneficiary_;
        for (uint i = 0; i < feeTokens_.length; ++i) {
            ensureIsNotZeroAddr(feeTokens_[i]);
            _setRentFee(feeTokens_[i], feePercents_[i]);
        }
    }

    function lend(
        NFTStandard[] memory nftStandard_,
        address[] memory nftAddress_,
        uint256[] memory tokenId_,
        uint256[] memory lendAmount_,
        uint8[] memory maxRentDuration_,
        bytes4[] memory dailyRentPrice_,
        uint8[] memory paymentToken_,
        bool[] memory willAutoRenew_
    ) external override notPaused {
        bundleCall(
            handleLend,
            createLendCallData(
                nftStandard_,
                nftAddress_,
                tokenId_,
                lendAmount_,
                maxRentDuration_,
                dailyRentPrice_,
                paymentToken_,
                willAutoRenew_
            )
        );
    }

    function stopLend(
        NFTStandard[] memory nftStandard_,
        address[] memory nftAddress_,
        uint256[] memory tokenId_,
        uint256[] memory lendingId_
    ) external override notPaused {
        bundleCall(
            handleStopLend, 
            createActionCallData(nftStandard_, nftAddress_, tokenId_, lendingId_, new uint256[](0))
        );
    }

    /**
     * @param nftStandard_ NFT standart (0 - ERC721, 1 - ERC1155)
     * @param nftAddress_ NFT contract address
     * @param tokenId_ NFT token Id
     * @param lendingId_ The landing Id
     * @param rentDuration_ Rent duration in days
     * @param rentAmount_ Token amount (for ERC721 always 1)
     */
    function rent(
        NFTStandard[] memory nftStandard_,
        address[] memory nftAddress_,
        uint256[] memory tokenId_,
        uint256[] memory lendingId_,
        uint8[] memory rentDuration_,
        uint256[] memory rentAmount_
    ) external override notPaused {
        bundleCall(
            handleRent, createRentCallData(nftStandard_, nftAddress_, tokenId_, lendingId_, rentDuration_, rentAmount_)
        );
    }

    function stopRent(
        NFTStandard[] memory nftStandard_,
        address[] memory nftAddress_,
        uint256[] memory tokenId_,
        uint256[] memory lendingId_,
        uint256[] memory rentingId_
    ) external override notPaused {
        bundleCall(handleStopRent, createActionCallData(nftStandard_, nftAddress_, tokenId_, lendingId_, rentingId_));
    }

    function claimRent(
        NFTStandard[] memory nftStandard_,
        address[] memory nftAddress_,
        uint256[] memory tokenId_,
        uint256[] memory lendingId_,
        uint256[] memory rentingId_
    ) external override notPaused {
        bundleCall(handleClaimRent, createActionCallData(nftStandard_, nftAddress_, tokenId_, lendingId_, rentingId_));
    }

    function handleLend(CallData memory cd_) private {
        for (uint256 i = cd_.left; i < cd_.right; i++) {
            ensureIsLendable(cd_, i);
            bytes32 identifier = keccak256(abi.encodePacked(cd_.nftAddress[cd_.left], cd_.tokenID[i], _lendingID));
            Lending storage lending = _lendings[identifier];
            ensureIsNull(lending);
            ensureTokenNotSentinel(uint8(cd_.paymentToken[i]));
            bool is721 = cd_.nftStandard[i] == NFTStandard.E721;
            uint16 _lendAmount = uint16(cd_.lendAmount[i]);
            require(
                !is721 || _lendAmount == 1, 
                "ReNFT::lendAmount should be equal to 1"
            );
            _lendings[identifier] = Lending({
                nftStandard: cd_.nftStandard[i],
                lenderAddress: msg.sender,
                maxRentDuration: cd_.maxRentDuration[i],
                dailyRentPrice: cd_.dailyRentPrice[i],
                lendAmount: _lendAmount,
                availableAmount: _lendAmount,
                paymentToken: cd_.paymentToken[i],
                willAutoRenew: cd_.willAutoRenew[i]
            });
            emit Lend(
                is721,
                msg.sender,
                cd_.nftAddress[cd_.left],
                cd_.tokenID[i],
                _lendingID,
                cd_.maxRentDuration[i],
                cd_.dailyRentPrice[i],
                _lendAmount,
                cd_.paymentToken[i],
                cd_.willAutoRenew[i]
                );
            _lendingID++;
        }
        safeTransfer(
            cd_,
            msg.sender,
            address(this),
            sliceArr(cd_.tokenID, cd_.left, cd_.right, 0),
            sliceArr(cd_.lendAmount, cd_.left, cd_.right, 0)
        );
    }

    function handleStopLend(CallData memory cd_) private {
        uint256[] memory lentAmounts = new uint256[](cd_.right - cd_.left);
        for (uint256 i = cd_.left; i < cd_.right; i++) {
            bytes32 lendingIdentifier =
                keccak256(abi.encodePacked(cd_.nftAddress[cd_.left], cd_.tokenID[i], cd_.lendingID[i]));
            Lending storage lending = _lendings[lendingIdentifier];
            ensureIsNotNull(lending);
            ensureIsStoppable(lending, msg.sender);
            require(cd_.nftStandard[i] == lending.nftStandard, "ReNFT::invalid nft standard");
            require(lending.lendAmount == lending.availableAmount, "ReNFT::actively rented");
            lentAmounts[i - cd_.left] = lending.lendAmount;
            emit StopLend(cd_.lendingID[i], uint32(block.timestamp), lending.lendAmount);
            delete _lendings[lendingIdentifier];
        }
        safeTransfer(
            cd_,
            address(this),
            msg.sender,
            sliceArr(cd_.tokenID, cd_.left, cd_.right, 0),
            sliceArr(lentAmounts, cd_.left, cd_.right, cd_.left)
        );
    }

    function handleRent(CallData memory cd_) private {
        for (uint256 i = cd_.left; i < cd_.right; i++) {
            bytes32 lendingIdentifier =
                keccak256(abi.encodePacked(cd_.nftAddress[cd_.left], cd_.tokenID[i], cd_.lendingID[i]));
            bytes32 rentingIdentifier = keccak256(
                abi.encodePacked(cd_.nftAddress[cd_.left], cd_.tokenID[i], _rentingID)
            );
            Lending storage lending = _lendings[lendingIdentifier];
            Renting storage renting = _rentings[rentingIdentifier];
            ensureIsNotNull(lending);
            ensureIsNull(renting);
            ensureIsRentable(lending, cd_, i, msg.sender);
            require(cd_.nftStandard[i] == lending.nftStandard, "ReNFT::invalid nft standard");
            require(cd_.rentAmount[i] <= lending.availableAmount, "ReNFT::invalid rent amount");
            uint8 paymentTokenIx = uint8(lending.paymentToken);
            ERC20 paymentToken = ERC20(_resolver.getPaymentToken(paymentTokenIx));
            uint256 decimals = paymentToken.decimals();
            {
                uint256 scale = 10 ** decimals;
                uint256 rentPrice = 
                    cd_.rentAmount[i] * 
                    cd_.rentDuration[i] * 
                    unpackPrice(lending.dailyRentPrice, scale);
                require(rentPrice > 0, "ReNFT::rent price is zero");
                paymentToken.safeTransferFrom(msg.sender, address(this), rentPrice);
            }
            _rentings[rentingIdentifier] = Renting({
                renterAddress: msg.sender,
                rentAmount: uint16(cd_.rentAmount[i]),
                rentDuration: cd_.rentDuration[i],
                rentedAt: uint32(block.timestamp)
            });
            _lendings[lendingIdentifier].availableAmount -= uint16(cd_.rentAmount[i]);
            emit Rent(
                msg.sender, 
                cd_.lendingID[i], 
                _rentingID, 
                uint16(cd_.rentAmount[i]), 
                cd_.rentDuration[i],
                renting.rentedAt
            );
            _rentingID++;
        }
    }

    function handleStopRent(CallData memory cd_) private {
        for (uint256 i = cd_.left; i < cd_.right; i++) {
            bytes32 lendingIdentifier =
                keccak256(abi.encodePacked(cd_.nftAddress[cd_.left], cd_.tokenID[i], cd_.lendingID[i]));
            bytes32 rentingIdentifier =
                keccak256(abi.encodePacked(cd_.nftAddress[cd_.left], cd_.tokenID[i], cd_.rentingID[i]));
            Lending storage lending = _lendings[lendingIdentifier];
            Renting storage renting = _rentings[rentingIdentifier];
            ensureIsNotNull(lending);
            ensureIsNotNull(renting);
            ensureIsReturnable(renting, msg.sender, block.timestamp);
            require(cd_.nftStandard[i] == lending.nftStandard, "ReNFT::invalid nft standard");
            require(renting.rentAmount <= lending.lendAmount, "ReNFT::critical error");
            uint256 secondsSinceRentStart = block.timestamp - renting.rentedAt;
            (uint256 sendRenterAmt, uint256 sendLenderAmt,  uint256 fee) = 
                distributePayments(lending, renting, secondsSinceRentStart);
            manageWillAutoRenew(
                lending, renting, cd_.nftAddress[cd_.left], cd_.nftStandard[cd_.left], cd_.tokenID[i], cd_.lendingID[i]
            );
            emit StopRent(cd_.rentingID[i], sendRenterAmt, sendLenderAmt, fee, uint32(block.timestamp));
            delete _rentings[rentingIdentifier];
        }
    }

    function handleClaimRent(CallData memory cd_) private {
        for (uint256 i = cd_.left; i < cd_.right; i++) {
            bytes32 lendingIdentifier =
                keccak256(abi.encodePacked(cd_.nftAddress[cd_.left], cd_.tokenID[i], cd_.lendingID[i]));
            bytes32 rentingIdentifier =
                keccak256(abi.encodePacked(cd_.nftAddress[cd_.left], cd_.tokenID[i], cd_.rentingID[i]));
            Lending storage lending = _lendings[lendingIdentifier];
            Renting storage renting = _rentings[rentingIdentifier];
            ensureIsNotNull(lending);
            ensureIsNotNull(renting);
            ensureIsClaimable(renting, block.timestamp);
            (uint256 amount, uint256 fee) = distributeClaimPayment(lending, renting);
            manageWillAutoRenew(
                lending, renting, cd_.nftAddress[cd_.left], cd_.nftStandard[cd_.left], cd_.tokenID[i], cd_.lendingID[i]
            );
            emit RentClaimed(cd_.rentingID[i], amount, fee, uint32(block.timestamp));
            delete _rentings[rentingIdentifier];
        }
    }

    function manageWillAutoRenew(
        Lending storage lending_,
        Renting storage renting_,
        address nftAddress_,
        NFTStandard nftStandard_,
        uint256 tokenId_,
        uint256 lendingId_
    ) private {
        if (lending_.willAutoRenew == false) {
            // No automatic renewal, stop the lending (or a portion of it) completely!

            // We must be careful here, because the lending might be for an ERC1155 token, which means
            // that the renting.rentAmount might not be the same as the lending.lendAmount. In this case, we
            // must NOT delete the lending, but only decrement the lending.lendAmount by the renting.rentAmount.
            // Notice: this is only possible for an ERC1155 tokens!
            if (lending_.lendAmount > renting_.rentAmount) {
                // update lending lendAmount to reflect NOT renewing the lending
                // Do not update lending.availableAmount, because the assets will not be lent out again
                lending_.lendAmount -= renting_.rentAmount;
                // return the assets to the lender
                IERC1155(nftAddress_).safeTransferFrom(
                    address(this), lending_.lenderAddress, tokenId_, uint256(renting_.rentAmount), ""
                );
            }
            // If the lending is for an ERC721 token, then the renting.rentAmount is always the same as the
            // lending.lendAmount, and we can delete the lending. If the lending is for an ERC1155 token and
            // the renting.rentAmount is the same as the lending.lendAmount, then we can also delete the
            // lending.
            else if (lending_.lendAmount == renting_.rentAmount) {
                // return the assets to the lender
                if (nftStandard_ == NFTStandard.E721) {
                    IERC721(nftAddress_).transferFrom(address(this), lending_.lenderAddress, tokenId_);
                } else {
                    IERC1155(nftAddress_).safeTransferFrom(
                        address(this), lending_.lenderAddress, tokenId_, uint256(renting_.rentAmount), ""
                    );
                }
                delete _lendings[keccak256(abi.encodePacked(nftAddress_, tokenId_, lendingId_))];
            }
            // StopLend event but only the amount that was not renewed (or all of it)
            emit StopLend(lendingId_, uint32(block.timestamp), renting_.rentAmount);
        } else {
            // automatic renewal, make the assets available to be lent out again
            lending_.availableAmount += renting_.rentAmount;
        }
    }

    function bundleCall(
        function(CallData memory) handler_, 
        CallData memory cd_
    ) private {
        require(cd_.nftAddress.length > 0, "ReNFT::no nfts");
        while (cd_.right != cd_.nftAddress.length) {
            if (
                (cd_.nftAddress[cd_.left] == cd_.nftAddress[cd_.right])
                    && (cd_.nftStandard[cd_.right] == NFTStandard.E1155)
            ) {
                cd_.right++;
            } else {
                handler_(cd_);
                cd_.left = cd_.right;
                cd_.right++;
            }
        }
        handler_(cd_);
    }

    function takeFee(uint256 rentAmount_, ERC20 token_) private returns (uint256 fee) {
        uint256 feePercent = _rentFee[address(token_)];
        if (feePercent > 0) {
            fee = rentAmount_ * feePercent;
            fee /= 10000;
            token_.safeTransfer(_beneficiary, fee);
        } else {
            fee = 0;
        }
    }

    function distributePayments(
        Lending memory lending_,
        Renting memory renting_,
        uint256 secondsSinceRentStart
    ) private returns (uint256 sendRenterAmt, uint256 sendLenderAmt,  uint256 takenFee) {
        uint8 paymentTokenIx = uint8(lending_.paymentToken);
        ERC20 paymentToken = ERC20(_resolver.getPaymentToken(paymentTokenIx));
        uint256 decimals = paymentToken.decimals();
        uint256 scale = 10 ** decimals;
        uint256 rentPrice = renting_.rentAmount * unpackPrice(lending_.dailyRentPrice, scale);
        uint256 totalRenterPmt = rentPrice * renting_.rentDuration;
        sendLenderAmt = (secondsSinceRentStart * rentPrice) / 1 days;
        require(totalRenterPmt > 0, "ReNFT::total renter payment is zero");
        require(sendLenderAmt > 0, "ReNFT::lender payment is zero");
        sendRenterAmt = totalRenterPmt - sendLenderAmt;
        takenFee = takeFee(sendLenderAmt, paymentToken);
        sendLenderAmt -= takenFee;
        paymentToken.safeTransfer(lending_.lenderAddress, sendLenderAmt);
        if (sendRenterAmt > 0) {
            paymentToken.safeTransfer(renting_.renterAddress, sendRenterAmt);
        }
    }

    function distributeClaimPayment(
        Lending memory lending_,
        Renting memory renting_
    ) private returns (uint256 amount, uint256 fee) {
        uint8 paymentTokenIx = uint8(lending_.paymentToken);
        ERC20 paymentToken = ERC20(_resolver.getPaymentToken(paymentTokenIx));
        uint256 decimals = paymentToken.decimals();
        uint256 scale = 10 ** decimals;
        uint256 rentPrice = renting_.rentAmount * unpackPrice(lending_.dailyRentPrice, scale);
        uint256 fullAmount = rentPrice * renting_.rentDuration;
        fee = takeFee(fullAmount, paymentToken);
        amount = fullAmount - fee;
        paymentToken.safeTransfer(lending_.lenderAddress, amount);
    }

    function safeTransfer(
        CallData memory cd_,
        address from_,
        address to_,
        uint256[] memory tokenId_,
        uint256[] memory lendAmount_
    ) private {
        if (cd_.nftStandard[cd_.left] == NFTStandard.E721) {
            IERC721(cd_.nftAddress[cd_.left]).transferFrom(from_, to_, cd_.tokenID[cd_.left]);
        } else {
            IERC1155(cd_.nftAddress[cd_.left]).safeBatchTransferFrom(from_, to_, tokenId_, lendAmount_, "");
        }
    }

    function getLending(
        address nftAddress_, 
        uint256 tokenId_, 
        uint256 lendingId_
    ) external view returns (Lending memory)
    {
        bytes32 identifier = keccak256(abi.encodePacked(nftAddress_, tokenId_, lendingId_));
        return _lendings[identifier];
    }

    function getRenting(
        address nftAddress_, 
        uint256 tokenId_, 
        uint256 rentingId_
    ) external view returns (Renting memory)
    {
        bytes32 identifier = keccak256(abi.encodePacked(nftAddress_, tokenId_, rentingId_));
        return _rentings[identifier];
    }

    function createLendCallData(
        NFTStandard[] memory nftStandard_,
        address[] memory nftAddress_,
        uint256[] memory tokenId_,
        uint256[] memory lendAmount_,
        uint8[] memory maxRentDuration_,
        bytes4[] memory dailyRentPrice_,
        uint8[] memory paymentToken_,
        bool[] memory willAutoRenew_
    ) private pure returns (CallData memory cd) {
        cd = CallData({
            left: 0,
            right: 1,
            nftStandard: nftStandard_,
            nftAddress: nftAddress_,
            tokenID: tokenId_,
            lendAmount: lendAmount_,
            lendingID: new uint256[](0),
            rentingID: new uint256[](0),
            rentDuration: new uint8[](0),
            rentAmount: new uint256[](0),
            maxRentDuration: maxRentDuration_,
            dailyRentPrice: dailyRentPrice_,
            paymentToken: paymentToken_,
            willAutoRenew: willAutoRenew_
        });
    }

    function createRentCallData(
        NFTStandard[] memory nftStandard_,
        address[] memory nftAddress_,
        uint256[] memory tokenId_,
        uint256[] memory lendingId_,
        uint8[] memory rentDuration_,
        uint256[] memory rentAmount_
    ) private pure returns (CallData memory cd) {
        cd = CallData({
            left: 0,
            right: 1,
            nftStandard: nftStandard_,
            nftAddress: nftAddress_,
            tokenID: tokenId_,
            lendAmount: new uint256[](0),
            lendingID: lendingId_,
            rentingID: new uint256[](0),
            rentDuration: rentDuration_,
            rentAmount: rentAmount_,
            maxRentDuration: new uint8[](0),
            dailyRentPrice: new bytes4[](0),
            paymentToken: new uint8[](0),
            willAutoRenew: new bool[](0)
        });
    }

    function createActionCallData(
        NFTStandard[] memory nftStandard_,
        address[] memory nftAddress_,
        uint256[] memory tokenId_,
        uint256[] memory lendingId_,
        uint256[] memory rentingId_
    ) private pure returns (CallData memory cd) {
        cd = CallData({
            left: 0,
            right: 1,
            nftStandard: nftStandard_,
            nftAddress: nftAddress_,
            tokenID: tokenId_,
            lendAmount: new uint256[](0),
            lendingID: lendingId_,
            rentingID: rentingId_,
            rentDuration: new uint8[](0),
            rentAmount: new uint256[](0),
            maxRentDuration: new uint8[](0),
            dailyRentPrice: new bytes4[](0),
            paymentToken: new uint8[](0),
            willAutoRenew: new bool[](0)
        });
    }

    function unpackPrice(bytes4 price_, uint256 scale_) private pure returns (uint256) {
        ensureIsUnpackablePrice(price_, scale_);
        uint16 whole = uint16(bytes2(price_));
        uint16 decimal = uint16(bytes2(price_ << 16));
        uint256 decimalScale = scale_ / 10000;
        if (whole > 9999) {
            whole = 9999;
        }
        if (decimal > 9999) {
            decimal = 9999;
        }
        uint256 w = whole * scale_;
        uint256 d = decimal * decimalScale;
        uint256 fullPrice = w + d;
        return fullPrice;
    }

    function sliceArr(
        uint256[] memory arr_, 
        uint256 fromIx_, 
        uint256 toIx_, 
        uint256 arrOffset_
    ) private pure returns (uint256[] memory r)
    {
        r = new uint256[](toIx_ - fromIx_);
        for (uint256 i = fromIx_; i < toIx_; i++) {
            r[i - fromIx_] = arr_[i - arrOffset_];
        }
    }

    function ensureIsNotZeroAddr(address addr_) private pure {
        require(addr_ != address(0), "ReNFT::zero address");
    }

    function ensureIsZeroAddr(address addr_) private pure {
        require(addr_ == address(0), "ReNFT::not a zero address");
    }

    function ensureIsNull(Lending memory lending_) private pure {
        ensureIsZeroAddr(lending_.lenderAddress);
        require(lending_.maxRentDuration == 0, "ReNFT::duration not zero");
        require(lending_.dailyRentPrice == 0, "ReNFT::rent price not zero");
    }

    function ensureIsNotNull(Lending memory lending_) private pure {
        ensureIsNotZeroAddr(lending_.lenderAddress);
        require(lending_.maxRentDuration != 0, "ReNFT::duration zero");
        require(lending_.dailyRentPrice != 0, "ReNFT::rent price is zero");
    }

    function ensureIsNull(Renting memory renting_) private pure {
        ensureIsZeroAddr(renting_.renterAddress);
        require(renting_.rentDuration == 0, "ReNFT::duration not zero");
        require(renting_.rentedAt == 0, "ReNFT::rented at not zero");
    }

    function ensureIsNotNull(Renting memory renting_) private pure {
        ensureIsNotZeroAddr(renting_.renterAddress);
        require(renting_.rentDuration != 0, "ReNFT::duration is zero");
        require(renting_.rentedAt != 0, "ReNFT::rented at is zero");
    }

    function ensureIsLendable(CallData memory cd_, uint256 index_) private pure {
        require(cd_.lendAmount[index_] > 0, "ReNFT::lend amount is zero");
        require(cd_.lendAmount[index_] <= type(uint16).max, "ReNFT::not uint16");
        require(cd_.maxRentDuration[index_] > 0, "ReNFT::duration is zero");
        require(cd_.maxRentDuration[index_] <= type(uint8).max, "ReNFT::not uint8");
        require(uint32(cd_.dailyRentPrice[index_]) > 0, "ReNFT::rent price is zero");
    }

    function ensureIsRentable(
        Lending memory lending_, 
        CallData memory cd_,
        uint256 index_,
        address msgSender
    ) private pure {
        require(msgSender != lending_.lenderAddress, "ReNFT::cant rent own nft");
        require(cd_.rentDuration[index_] <= type(uint8).max, "ReNFT::not uint8");
        require(cd_.rentDuration[index_] > 0, "ReNFT::duration is zero");
        require(cd_.rentAmount[index_] <= type(uint16).max, "ReNFT::not uint16");
        require(cd_.rentAmount[index_] > 0, "ReNFT::rentAmount is zero");
        require(cd_.rentDuration[index_] <= lending_.maxRentDuration, "ReNFT::rent duration exceeds allowed max");
    }

    function ensureIsReturnable(
        Renting memory renting_, 
        address msgSender_, 
        uint256 blockTimestamp_
    ) private pure {
        require(renting_.renterAddress == msgSender_, "ReNFT::not renter");
        require(!isPastReturnDate(renting_, blockTimestamp_), "ReNFT::past return date");
    }

    function ensureIsStoppable(Lending memory lending_, address msgSender_) private pure {
        require(lending_.lenderAddress == msgSender_, "ReNFT::not lender");
    }

    function ensureIsUnpackablePrice(bytes4 price_, uint256 scale_) private pure {
        require(uint32(price_) > 0, "ReNFT::invalid price");
        require(scale_ >= 10000, "ReNFT::invalid scale");
    }

    function ensureTokenNotSentinel(uint8 paymentIx_) private pure {
        require(paymentIx_ > 0, "ReNFT::token is sentinel");
    }

    function ensureIsClaimable(Renting memory renting_, uint256 blockTimestamp_) private pure {
        require(isPastReturnDate(renting_, blockTimestamp_), "ReNFT::return date not passed");
    }

    function isPastReturnDate(Renting memory renting_, uint256 nowTime_) private pure returns (bool) {
        require(nowTime_ > renting_.rentedAt, "ReNFT::now before rented");
        return nowTime_ - renting_.rentedAt > renting_.rentDuration * 1 days;
    }

    function getRentFee(address token_) external view returns (uint256) {
        return _rentFee[token_];
    }

    function getBeneficiary() external view returns (address) {
        return _beneficiary;
    }

    function setRentFee(address token_, uint256 newRentFee_) external haveRights {
        _setRentFee(token_, newRentFee_);
        require(newRentFee_ < 10000, "ReNFT::fee exceeds 100pct");
        _rentFee[token_] = newRentFee_;
        emit RentFeeUpdated(token_, newRentFee_);
    }

    function setBeneficiary(address newBeneficiary_) external haveRights {
        _beneficiary = newBeneficiary_;
    }

    function setPaused(bool newPaused_) external haveRights {
        _paused = newPaused_;
    }

    function _setRentFee(address token_, uint256 newRentFee_) private {
        require(newRentFee_ < 10000, "ReNFT::fee exceeds 100pct");
        _rentFee[token_] = newRentFee_;
        emit RentFeeUpdated(token_, newRentFee_);
    }
}
