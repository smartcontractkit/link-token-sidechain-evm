pragma solidity ^0.6.0;

import {IChildERC20} from "../interfaces/IChildERC20.sol";
import {IChildERC20Recoverable} from "../interfaces/IChildERC20Recoverable.sol";
import {ChildERC20} from "./ChildERC20.sol";

abstract contract ChildERC20Recoverable is ChildERC20, IChildERC20Recoverable {

  mapping (address => bytes) private _failedDeposits;

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
    override(IChildERC20, ChildERC20)
  {
    uint256 amount = abi.decode(depositData, (uint256));

    (bool allowed, string memory message) = _isDepositAllowed(user, depositData);
    if (!allowed) {
      uint256 failedDepositsAmount = abi.decode(_failedDeposits[user], (uint256));
      _failedDeposits[user] = abi.encode(failedDepositsAmount.add(amount));

      // Emit an event and exit
      emit FailedDeposit(user, depositData, message);
      return;
    }

    // If deposit is allowed mint the tokens
    _mint(user, amount);
  }

  /**
   * @dev Redeposit failed deposits for user.
   *
   * @param user user address for whom deposit is being done
   */
  function redeposit(address user)
    external
    override
  {
    bytes memory depositData = _failedDeposits[user];
    (bool allowed, string memory message) = _isDepositAllowed(user, depositData);
    require(allowed, message);
    delete _failedDeposits[user];

    // Allowed to deposit
    uint256 amount = abi.decode(depositData, (uint256));
    _mint(user, amount);
  }

  /**
   * @dev Withdraw failed deposits for user.
   *
   * @param amount amount of failed deposits to withdraw
   */
  function withdrawFailedDeposit(uint256 amount)
    external
    override
  {
    uint256 failedDepositsAmount = abi.decode(_failedDeposits[_msgSender()], (uint256));
    uint256 newFailedDepositsAmount = failedDepositsAmount.sub(amount, "ChildERC20Recoverable: withdraw amount exceeds failed deposits");
    _failedDeposits[_msgSender()] = abi.encode(newFailedDepositsAmount);

    // Mint and immediately burn tokens so they can be unlocked on the origin chain
    _mint(_msgSender(), amount);
    _burn(_msgSender(), amount);
  }

  /**
   * @dev Condition that is checked before any deposits of tokens.
   *
   * Returns a boolean value indicating whether the deposit is allowed.
   * If not allowed, a reason string will also be returned.
   *
   * @param user user address for whom deposit is being done
   * @param depositData abi encoded amount
   */
  function _isDepositAllowed(address user, bytes memory depositData)
    internal
    virtual
    returns
    (bool, string memory)
  {
    // Extend for custom conditions
  }
}
