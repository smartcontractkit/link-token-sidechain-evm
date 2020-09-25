pragma solidity ^0.6.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import {IChildToken} from "../../interfaces/IChildToken.sol";

contract MigrationManager {
  using SafeERC20 for IERC20;

  address public constant BURN_ADDRESS = address(0x0);

  IERC20 public immutable prevToken;
  IChildToken public immutable childToken;

  constructor(address prevTokenAddr, address childTokenAddr) public {
    prevToken = IERC20(prevTokenAddr);
    childToken = IChildToken(childTokenAddr);
  }

  function migrate(uint256 prevTokenAmount) external {
    prevToken.safeTransferFrom(msg.sender, BURN_ADDRESS, prevTokenAmount);
    bytes memory depositData = abi.encode(prevTokenAmount);
    childToken.deposit(msg.sender, depositData);
  }
}
