pragma solidity ^0.6.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import {IChildERC20} from "../../interfaces/IChildERC20.sol";

contract MigrationManager {
  using SafeERC20 for IERC20;

  address public constant BURN_ADDRESS = address(0x0);

  IERC20 public immutable prevToken;
  IChildERC20 public immutable childToken;

  constructor(address prevTokenAddr, address childTokenAddr) public {
    prevToken = IERC20(prevTokenAddr);
    childToken = IChildERC20(childTokenAddr);
  }

  // TODO: check if transfer to BURN_ADDRESS (0x0) is allowed for prevToken
  function migrate(uint256 prevTokenAmount) external {
    prevToken.safeTransferFrom(msg.sender, BURN_ADDRESS, prevTokenAmount);
    bytes memory depositData = abi.encode(prevTokenAmount);
    childToken.deposit(msg.sender, depositData);
  }
}
