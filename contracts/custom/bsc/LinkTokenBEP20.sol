pragma solidity ^0.6.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";
import {LinkToken} from "link_token/contracts/v0.6/LinkToken.sol";
import {LinkTokenChild} from "../../LinkTokenChild.sol";
import {BEP20} from "./BEP20.sol";

/**
 * @dev {ERC20Burnable} feature is requested by the Binance team to support
 * integrations with projects that support portfolio assets and may ask users
 * to burn LINK as to mint some new token.
 */
contract LinkTokenBEP20 is BEP20, ERC20Burnable, Pausable, LinkTokenChild {
  bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

  constructor(
    address childChainManager,
    uint256 cap,
    address proofOfReservesFeedAddr
  )
    public
    LinkTokenChild(childChainManager, cap, proofOfReservesFeedAddr)
  {
    _setupContractId("LinkTokenBEP20");
    _setupRole(PAUSER_ROLE, _msgSender());

    /**
     * @notice The contract starts in a paused state which disables withdrawals. As Binance
     * controls the bridge, the tokens are not moved to Ethereum by withdrawing (burning) but
     * by transferring to a specific address in Binance control. This tx should be set up using
     * the Binance bridge UI, and on success, withdrawn tokens will be deposited by Binance
     * on Ethereum Mainnet.
     *
     * If this is to change in the future, there is a possibility left open for the contract
     * to be unpaused (once) which will enable the withdraw function from then on.
     */
    _pause();
  }

  /**
   * @dev Returns the bep token owner.
   */
  function getOwner() override external view returns (address) {
    return getRoleMember(DEFAULT_ADMIN_ROLE, 0);
  }

  /**
   * @dev Should burn user's tokens.
   *
   * See {ChildERC20-withdraw}.
   */
  function withdraw(uint256 amount)
    external
    override
    whenNotPaused
  {
    _burn(_msgSender(), amount);
  }

  /**
   * @dev Unpauses all token withdraws.
   *
   * See {ERC20Pausable} and {Pausable-_unpause}.
   *
   * Requirements:
   *
   * - the caller must have the `PAUSER_ROLE`.
   */
  function unpause() public only(PAUSER_ROLE) {
    _unpause();
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
    override(ERC20, LinkTokenChild)
    virtual
  {
    LinkTokenChild._transfer(sender, recipient, amount);
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
    override(ERC20, LinkTokenChild)
    virtual
  {
    LinkTokenChild._approve(owner, spender, amount);
  }
}
