pragma solidity ^0.6.0;

import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";
import {IChildERC20} from "../../interfaces/IChildERC20.sol";

contract MigrationManager {
  ERC20Burnable public immutable prevToken;
  IChildERC20 public immutable childToken;

  constructor(address prevTokenAddr, address childTokenAddr) public {
    prevToken = ERC20Burnable(prevTokenAddr);
    childToken = IChildERC20(childTokenAddr);
  }

  function migrate(uint256 prevTokenAmount) external {
    _burn(msg.sender, prevTokenAmount);
    _deposit(msg.sender, prevTokenAmount);
  }

  function _burn(address account, uint256 amount) internal virtual {
    prevToken.burnFrom(account, amount);
  }

  function _deposit(address user, uint256 amount) internal virtual {
    bytes memory depositData = abi.encode(amount);
    childToken.deposit(user, depositData);
  }
}
