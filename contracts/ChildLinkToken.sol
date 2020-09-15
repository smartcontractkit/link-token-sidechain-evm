pragma solidity ^0.6.0;

import {LinkToken} from "link_token/contracts/v0.6/LinkToken.sol";
import {IChildToken} from "./child/IChildToken.sol";
import {AccessControlMixin} from "./access/AccessControlMixin.sol";

contract ChildLinkToken is
  LinkToken,
  IChildToken,
  AccessControlMixin
{
  bytes32 public constant DEPOSITOR_ROLE = keccak256("DEPOSITOR_ROLE");

  constructor(
    address childChainManager
  ) public LinkToken() {
    _setupContractId("ChildLinkToken");
    _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    _setupRole(DEPOSITOR_ROLE, childChainManager);
  }

  function _onCreate()
    internal
    override
  {
    // Do not mint any tokens on deployment, start with total supply of 0
  }

  /**
   * @notice called when token is deposited on root chain
   * @dev Should be callable only by ChildChainManager
   * Should handle deposit by minting the required amount for user
   * Make sure minting is done only by this function
   * @param user user address for whom deposit is being done
   * @param depositData abi encoded amount
   */
  function deposit(address user, bytes calldata depositData)
    external
    override
    only(DEPOSITOR_ROLE)
  {
    uint256 amount = abi.decode(depositData, (uint256));
    _mint(user, amount);
  }

  /**
   * @notice called when user wants to withdraw tokens back to root chain
   * @dev Should burn user's tokens. This transaction will be verified when exiting on root chain
   * @param amount amount of tokens to withdraw
   */
  function withdraw(uint256 amount)
    external
  {
    _burn(_msgSender(), amount);
  }
}
