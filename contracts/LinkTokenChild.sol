pragma solidity ^0.6.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {LinkToken} from "link_token/contracts/v0.6/LinkToken.sol";
import {ChildERC20} from "./child/ChildERC20.sol";
import {ChildERC20Capped} from "./child/ChildERC20Capped.sol";
import {ChildERC20Collateralized} from "./child/ChildERC20Collateralized.sol";

contract LinkTokenChild is
  LinkToken,
  ChildERC20Capped,
  ChildERC20Collateralized
{

  constructor(
    address childChainManager,
    uint256 cap,
    address proofOfReservesFeedAddr
  )
    public
    ChildERC20(childChainManager)
    ChildERC20Capped(cap)
    ChildERC20Collateralized(proofOfReservesFeedAddr)
  {
    _setupContractId("LinkTokenChild");
  }

  function _onCreate()
    internal
    override
  {
    // Do not mint any tokens on deployment, start with total supply of 0
  }

  /**
   * @dev Does not allow if called with amount that would make the child token undercollateralized.
   *
   * @param user user address for whom deposit is being done
   * @param depositData abi encoded amount
   */
  function _isDepositAllowed(address user, bytes memory depositData)
    internal
    override(ChildERC20Capped, ChildERC20Collateralized)
    virtual
    returns (bool, string memory)
  {
    (bool allowed, string memory message) = ChildERC20Capped._isDepositAllowed(user, depositData);
    if (!allowed) {
      return (allowed, message);
    }

    return ChildERC20Collateralized._isDepositAllowed(user, depositData);
  }

  /**
   * @dev Moves tokens `amount` from `sender` to `recipient`.
   *
   * This is internal function is equivalent to {transfer}, and can be used to
   * e.g. implement automatic token fees, slashing mechanisms, etc.
   *
   * Emits a {Transfer} event.
   *
   * Requirements:
   *
   * - `sender` cannot be the zero address.
   * - `recipient` cannot be the zero address.
   * - `sender` must have a balance of at least `amount`.
   */
  function _transfer(address sender, address recipient, uint256 amount)
    internal
    override(ERC20, LinkToken)
    virtual
  {
    LinkToken._transfer(sender, recipient, amount);
  }

  /**
   * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
   *
   * This is internal function is equivalent to `approve`, and can be used to
   * e.g. set automatic allowances for certain subsystems, etc.
   *
   * Emits an {Approval} event.
   *
   * Requirements:
   *
   * - `owner` cannot be the zero address.
   * - `spender` cannot be the zero address.
   */
  function _approve(address owner, address spender, uint256 amount)
    internal
    override(ERC20, LinkToken)
    virtual
  {
    LinkToken._approve(owner, spender, amount);
  }
}
