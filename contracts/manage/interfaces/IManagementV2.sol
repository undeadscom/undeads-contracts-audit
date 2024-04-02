// SPDX-License-Identifier: PROPRIERTARY

pragma solidity 0.8.17;

interface IManagementV2 {
    event Confirmed(address indexed sender, uint256 indexed transactionId);
    event Revoked(address indexed sender, uint256 indexed transactionId);
    event Submitted(uint256 indexed transactionId);
    event Executed(uint256 indexed transactionId);
    event ExecutionFailed(uint256 indexed transactionId, bytes reason);
    event AdminAdded(address indexed admin);
    event AdminRemoved(address indexed admin);
    event RequirementChanged(uint256 required);

    struct Transaction {
        address destination;
        uint256 createdAt;
        bool executed;
        bytes data;
    }

    /**
     * @dev Returns the confirmation status of a transaction.
     * @param transactionId_ Transaction ID.
     * @return Confirmation status.
     */
    function isConfirmed(uint256 transactionId_) external view returns (bool);

    /**
     * @dev Returns the admin status of a address.
     * @param admin_ Admin address.
     * @return Admin status.
     */
    function isAdmin(address admin_) external view returns (bool);

    /**
     * @dev Returns number of confirmations of a transaction.
     * @param transactionId_ Transaction ID.
     * @return count Number of confirmations.
     */
    function getConfirmationCount(
        uint256 transactionId_
    ) external view returns (uint256 count);

    /**
     * @dev Returns total number of transactions after filers are applied.
     * @param pending_ Include pending transactions.
     * @param executed_ Include executed transactions.
     * @param executed_ Include expired transactions.
     * @return count Total number of transactions after filters are applied.
     */
    function getTransactionCount(
        bool pending_,
        bool executed_,
        bool expired_
    ) external view returns (uint256 count);

    /**
     * @dev Returns list of admins.
     * @return List of admin addresses.
     */
    function getAdmins() external view returns (address[] memory);

    /**
     * @dev Returns array with admin addresses, which confirmed transaction.
     * @param transactionId_ Transaction ID.
     * @return confirms Returns array of admin addresses.
     */
    function getConfirmations(
        uint256 transactionId_
    ) external view returns (address[] memory confirms);

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
    ) external view returns (uint256[] memory _transactionIds);

    /**
     * @dev Returns transaction details by id.
     * @param transactionId_ The transaction id.
     * @return Returns transaction details.
     */
    function getTransaction(
        uint256 transactionId_
    ) external view returns (Transaction memory);

    /**
     * @dev Allows to add a new admin. Transaction has to be sent by this contract.
     * @param admin_ Address of new admin.
     */
    function addAdmin(address admin_) external;

    /**
     * @dev Allows to remove an admin. Transaction has to be sent by this contract.
     * @param admin_ Address of admin.
     */
    function removeAdmin(address admin_) external;

    /**
     * @dev Allows to replace an admin with a new admin. Transaction has to be sent by this contract.
     * @param admin_ Address of admin to be replaced.
     * @param newAdmin_ Address of new admin.
     */
    function replaceAdmin(address admin_, address newAdmin_) external;

    /**
     * @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
     * @param required_ Number of required confirmations.
     */
    function changeRequirement(uint256 required_) external;

    /**
     * @dev Allows an admin to submit and confirm a transaction.
     * @param destination_ Transaction target address.
     * @param data_ Transaction data payload.
     * @return transactionId Returns transaction ID.
     */
    function submitTransaction(
        address destination_,
        bytes calldata data_
    ) external returns (uint256 transactionId);

    /**
     * @dev Allows an admin to confirm a transaction.
     * @param transactionId_ Transaction ID.
     */
    function confirmTransaction(uint256 transactionId_) external;

    /**
     * @dev Allows an admin to revoke a confirmation for a transaction.
     * @param transactionId_ Transaction ID.
     */
    function revokeConfirmation(uint256 transactionId_) external;

    /**
     * @dev Allows anyone to execute a confirmed transaction.
     * @param transactionId_ Transaction ID.
     */
    function executeTransaction(uint256 transactionId_) external;
}
