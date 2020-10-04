pragma solidity ^0.6.0;

import {IChildERC20} from "./IChildERC20.sol";

interface IChildERC20Recoverable is IChildERC20 {
  function redeposit(address user) external;
  function withdrawFailedDeposit(uint256 amount) external;

  /**
   * @dev Emitted when token deposit is not allowed.
   */
  event FailedDeposit(address indexed user, bytes depositData, string indexed message);
}
