// SPDX-License-Identifier: PROPRIERTARY

// Author: Ilya A. Shlyakhovoy
// Email: is@unicsoft.com

pragma solidity 0.8.17;
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "../../utils/interfaces/IRights.sol";
import "../../utils/Guard.sol";

abstract contract GuardExtensionUpgradeable is Guard, Initializable {
    IRights private _rightsContract;

    string private constant SAME_VALUE = "Guard: same value";
    string private constant ZERO_ADDRESS = "Guard: zero address";

    function __GuardExtensionUpgradeable_init(address rights_)
        internal
        onlyInitializing
    {
        require(rights_ != address(0), ZERO_ADDRESS);
        _rightsContract = IRights(rights_);
    }

    function _rights() internal view virtual override returns (IRights) {
        return _rightsContract;
    }

    function setRights(address rights_) external virtual override haveRights {
        require(address(_rightsContract) != rights_, SAME_VALUE);
        require(rights_ != address(0), ZERO_ADDRESS);
        _rightsContract = IRights(rights_);
    }
}
