// SPDX-License-Identifier: PROPRIERTARY

pragma solidity 0.8.17;

import "./interfaces/IManagementV2.sol";

contract ManagementV2 is IManagementV2 {
    error ManagementRequired();
    error AdminNotExist(address admin);
    error AdminAlreadyExists(address admin);
    error TransactionNotExist(uint256 transactionId);
    error ConfirmRequired(uint256 transactionId, address admin);
    error AlreadyConfirmed(uint256 transactionId, address admin);
    error AlreadyExecuted(uint256 transactionId);
    error AddressRequired();
    error InvalidRequirements(uint256 adminCount, uint256 required);
    error TransactionExpired(uint256 transactionId, uint256 expiredAt);

    uint256 public constant MAX_ADMIN_COUNT = 10;
    uint256 public constant TRANSACTION_TTL = 7 days;

    mapping(uint256 => Transaction) private _transactions;
    mapping(uint256 => mapping(address => bool)) private _confirmations;
    mapping(address => bool) private _isAdmin;
    address[] private _admins;
    uint256 private _required;
    uint256 private _transactionCount;

    modifier onlyManagement() {
        if (msg.sender != address(this)) {
            revert ManagementRequired();
        }
        _;
    }

    modifier adminDoesNotExist(address admin_) {
        if (_isAdmin[admin_]) {
            revert AdminAlreadyExists(admin_);
        }
        _;
    }

    modifier adminExists(address admin_) {
        if (!_isAdmin[admin_]) {
            revert AdminNotExist(admin_);
        }
        _;
    }

    modifier transactionExists(uint256 transactionId_) {
        if (_transactions[transactionId_].destination == address(0)) {
            revert TransactionNotExist(transactionId_);
        }
        _;
    }

    modifier confirmed(uint256 transactionId_, address admin_) {
        if (!_confirmations[transactionId_][admin_]) {
            revert ConfirmRequired(transactionId_, admin_);
        }
        _;
    }

    modifier notConfirmed(uint256 transactionId_, address admin_) {
        if (_confirmations[transactionId_][admin_]) {
            revert AlreadyConfirmed(transactionId_, admin_);
        }
        _;
    }

    modifier notExecuted(uint256 transactionId_) {
        if (_transactions[transactionId_].executed) {
            revert AlreadyExecuted(transactionId_);
        }
        _;
    }

    modifier notExpired(uint256 transactionId_) {
        uint256 expiredAt = _transactions[transactionId_].createdAt +
            TRANSACTION_TTL;
        if (block.timestamp >= expiredAt) {
            revert TransactionExpired(transactionId_, expiredAt);
        }
        _;
    }

    modifier notNull(address address_) {
        if (address_ == address(0)) {
            revert AddressRequired();
        }
        _;
    }

    modifier validRequirement(uint256 adminCount_, uint256 required_) {
        if (
            adminCount_ > MAX_ADMIN_COUNT ||
            required_ > adminCount_ ||
            adminCount_ < 2 ||
            required_ < adminCount_ / 2 + 1
        ) {
            revert InvalidRequirements(adminCount_, required_);
        }
        _;
    }

    /**
     * @dev Contract constructor sets initial admins and required number of confirmations.
     * @param admins_ List of initial admins.
     * @param required_ Number of required confirmations.
     */
    constructor(
        address[] memory admins_,
        uint256 required_
    ) validRequirement(admins_.length, required_) {
        for (uint256 i; i < admins_.length; ++i) {
            if (admins_[i] == address(0)) {
                revert AddressRequired();
            }
            if (_isAdmin[admins_[i]]) {
                revert AdminAlreadyExists(admins_[i]);
            }
            _isAdmin[admins_[i]] = true;
        }
        _admins = admins_;
        _required = required_;
    }

    /**
     * @dev Returns the confirmation status of a transaction.
     * @param transactionId_ Transaction ID.
     * @return Confirmation status.
     */
    function isConfirmed(
        uint256 transactionId_
    ) external view override returns (bool) {
        return _isConfirmed(transactionId_);
    }

    /**
     * @dev Returns the admin status of a address.
     * @param admin_ Admin address.
     * @return Admin status.
     */
    function isAdmin(address admin_) external view override returns (bool) {
        return _isAdmin[admin_];
    }

    /**
     * @dev Returns number of confirmations of a transaction.
     * @param transactionId_ Transaction ID.
     * @return count Number of confirmations.
     */
    function getConfirmationCount(
        uint256 transactionId_
    ) external view override returns (uint256 count) {
        for (uint256 i; i < _admins.length; ++i) {
            if (_confirmations[transactionId_][_admins[i]]) {
                ++count;
            }
        }
    }

    /**
     * @dev Returns total number of transactions after filers are applied.
     * @param pending_ Include pending transactions.
     * @param executed_ Include executed transactions.
     * @param expired_ Include expired transactions.
     * @return count Total number of transactions after filters are applied.
     */
    function getTransactionCount(
        bool pending_,
        bool executed_,
        bool expired_
    ) external view override returns (uint256 count) {
        for (uint256 i; i < _transactionCount; ++i) {
            bool isExpired = _transactions[i].createdAt + TRANSACTION_TTL <
                block.timestamp;
            bool isExecuted = _transactions[i].executed;
            if (
                (expired_ && isExpired && !isExecuted) ||
                (pending_ && !isExpired && !isExecuted) ||
                (executed_ && isExecuted)
            ) {
                ++count;
            }
        }
    }

    /**
     * @dev Returns list of admins.
     * @return List of admin addresses.
     */
    function getAdmins() external view override returns (address[] memory) {
        return _admins;
    }

    /**
     * @dev Returns array with admin addresses, which confirmed transaction.
     * @param transactionId_ Transaction ID.
     * @return confirms Returns array of admin addresses.
     */
    function getConfirmations(
        uint256 transactionId_
    ) external view override returns (address[] memory confirms) {
        address[] memory confirmationsTemp = new address[](_admins.length);
        uint256 count;
        for (uint256 i; i < _admins.length; ++i) {
            if (_confirmations[transactionId_][_admins[i]]) {
                confirmationsTemp[count] = _admins[i];
                ++count;
            }
        }
        confirms = new address[](count);
        for (uint256 i; i < count; ++i) {
            confirms[i] = confirmationsTemp[i];
        }
    }

    /**
     * @dev Returns list of transaction IDs in defined range.
     * @param from_ Index start position of transaction array.
     * @param to_ Index end position of transaction array.
     * @param pending_ Include pending transactions.
     * @param executed_ Include executed transactions.
     * @param expired_ Include expired transactions.
     * @return _transactionIds Returns array of transaction IDs.
     */
    function getTransactionIds(
        uint256 from_,
        uint256 to_,
        bool pending_,
        bool executed_,
        bool expired_
    ) external view override returns (uint256[] memory _transactionIds) {
        uint256[] memory transactionIdsTemp = new uint256[](_transactionCount);
        uint256 count;
        uint256 i;
        for (i; i < _transactionCount; ++i) {
            bool isExpired = _transactions[i].createdAt + TRANSACTION_TTL <
                block.timestamp;
            bool isExecuted = _transactions[i].executed;
            if (
                (expired_ && isExpired && !isExecuted) ||
                (pending_ && !isExecuted) ||
                (executed_ && isExecuted)
            ) {
                transactionIdsTemp[count] = i;
                ++count;
            }
        }
        _transactionIds = new uint256[](to_ - from_);
        for (i = from_; i < to_; ++i) {
            _transactionIds[i - from_] = transactionIdsTemp[i];
        }
    }

    /**
     * @dev Returns transaction details by id.
     * @param transactionId_ The transaction id.
     * @return Returns transaction details.
     */
    function getTransaction(
        uint256 transactionId_
    ) external view override returns (Transaction memory) {
        return _transactions[transactionId_];
    }

    /**
     * @dev Allows to add a new admin. Transaction has to be sent by this contract.
     * @param admin_ Address of new admin.
     */
    function addAdmin(
        address admin_
    )
        external
        override
        onlyManagement
        adminDoesNotExist(admin_)
        notNull(admin_)
        validRequirement(_admins.length + 1, _required + 1)
    {
        _required = _required + 1;
        _isAdmin[admin_] = true;
        _admins.push(admin_);
        emit AdminAdded(admin_);
    }

    /**
     * @dev Allows to remove an admin. Transaction has to be sent by this contract.
     * @param admin_ Address of admin.
     */
    function removeAdmin(
        address admin_
    )
        external
        override
        onlyManagement
        adminExists(admin_)
        validRequirement(_admins.length - 1, _required)
    {
        _isAdmin[admin_] = false;
        uint256 adminLength = _admins.length;
        for (uint256 i; i < adminLength - 1; ++i) {
            if (_admins[i] == admin_) {
                _admins[i] = _admins[adminLength - 1];
                _admins.pop();
                break;
            }
        }

        // To avoid the use of the veto
        if (_required == _admins.length) {
            _changeRequirement(_admins.length - 1);
        }
        emit AdminRemoved(admin_);
    }

    /**
     * @dev Allows to replace an admin with a new admin. Transaction has to be sent by this contract.
     * @param admin_ Address of admin to be replaced.
     * @param newAdmin_ Address of new admin.
     */
    function replaceAdmin(
        address admin_,
        address newAdmin_
    )
        external
        override
        onlyManagement
        notNull(newAdmin_)
        adminExists(admin_)
        adminDoesNotExist(newAdmin_)
    {
        for (uint256 i; i < _admins.length; i++) {
            if (_admins[i] == admin_) {
                _admins[i] = newAdmin_;
                break;
            }
        }
        _isAdmin[admin_] = false;
        _isAdmin[newAdmin_] = true;
        emit AdminRemoved(admin_);
        emit AdminAdded(newAdmin_);
    }

    /**
     * @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
     * @param required_ Number of required confirmations.
     */
    function changeRequirement(
        uint256 required_
    ) external override onlyManagement {
        _changeRequirement(required_);
    }

    /**
     * @dev Allows an admin to submit and confirm a transaction.
     * @param destination_ Transaction target address.
     * @param data_ Transaction data payload.
     * @return transactionId Returns transaction ID.
     */
    function submitTransaction(
        address destination_,
        bytes calldata data_
    )
        external
        override
        adminExists(msg.sender)
        returns (uint256 transactionId)
    {
        transactionId = _addTransaction(destination_, data_);
        _confirmTransaction(transactionId);
        _executeTransaction(transactionId);
    }

    /**
     * @dev Allows an admin to confirm a transaction.
     * @param transactionId_ Transaction ID.
     */
    function confirmTransaction(
        uint256 transactionId_
    )
        external
        adminExists(msg.sender)
        transactionExists(transactionId_)
        notConfirmed(transactionId_, msg.sender)
        notExpired(transactionId_)
    {
        _confirmTransaction(transactionId_);
        _executeTransaction(transactionId_);
    }

    /**
     * @dev Allows an admin to revoke a confirmation for a transaction.
     * @param transactionId_ Transaction ID.
     */
    function revokeConfirmation(
        uint256 transactionId_
    )
        external
        override
        adminExists(msg.sender)
        confirmed(transactionId_, msg.sender)
        notExecuted(transactionId_)
    {
        _confirmations[transactionId_][msg.sender] = false;
        emit Revoked(msg.sender, transactionId_);
    }

    /**
     * @dev Allows anyone to execute a confirmed transaction.
     * @param transactionId_ Transaction ID.
     */
    function executeTransaction(
        uint256 transactionId_
    )
        external
        override
        adminExists(msg.sender)
        confirmed(transactionId_, msg.sender)
        notExecuted(transactionId_)
        notExpired(transactionId_)
    {
        _executeTransaction(transactionId_);
    }

    function _addTransaction(
        address destination_,
        bytes calldata data_
    ) internal notNull(destination_) returns (uint256 transactionId) {
        transactionId = _transactionCount;
        _transactions[transactionId] = Transaction({
            destination: destination_,
            createdAt: block.timestamp,
            data: data_,
            executed: false
        });
        ++_transactionCount;
        emit Submitted(transactionId);
    }

    function _isConfirmed(uint256 transactionId_) internal view returns (bool) {
        uint256 count;
        for (uint256 i; i < _admins.length; ++i) {
            if (_confirmations[transactionId_][_admins[i]]) {
                ++count;
            }

            if (count == _required) {
                return true;
            }
        }
        return false;
    }

    function _confirmTransaction(uint256 transactionId_) internal {
        _confirmations[transactionId_][msg.sender] = true;
        emit Confirmed(msg.sender, transactionId_);
    }

    function _executeTransaction(uint256 transactionId_) internal {
        if (_isConfirmed(transactionId_)) {
            Transaction storage txn = _transactions[transactionId_];
            txn.executed = true;
            (bool success, bytes memory data) = txn.destination.call(txn.data);
            if (success) {
                emit Executed(transactionId_);
            } else {
                emit ExecutionFailed(transactionId_, data);
                txn.executed = false;
            }
        }
    }

    function _changeRequirement(
        uint256 required_
    ) internal validRequirement(_admins.length, required_) {
        _required = required_;
        emit RequirementChanged(required_);
    }
}
