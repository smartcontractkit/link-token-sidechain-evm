pragma solidity ^0.6.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ChildERC20Recoverable} from "./ChildERC20Recoverable.sol";

abstract contract ChildERC20Capped is ChildERC20Recoverable {
  // TODO: role to update _cap
  uint256 private _cap;

  /**
   * @dev Sets the value of the `cap`. This value is immutable, it can only be
   * set once during construction.
   */
  constructor (uint256 cap) public {
      require(cap > 0, "ChildERC20Capped: cap is 0");
      _cap = cap;
  }

  /**
   * @dev Returns the cap on the token's total supply.
   */
  function cap() public view returns (uint256) {
      return _cap;
  }

  /**
   * @dev Does not allow if called with amout that would make the child token undercollateralized.
   *
   * @param depositData abi encoded amount
   */
  function _isDepositAllowed(address /* user */, bytes memory depositData)
    internal
    override
    virtual
    returns (bool, string memory)
  {
    uint256 amount = abi.decode(depositData, (uint256));
    bool allowed = totalSupply().add(amount) <= _cap;
    string memory message = allowed ? "" : "ChildERC20Capped: cap exceeded";
    return (allowed, message);
  }
}
