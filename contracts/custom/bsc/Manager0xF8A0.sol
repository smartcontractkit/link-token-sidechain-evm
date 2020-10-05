pragma solidity ^0.6.0;

import {MigrationManager} from "./MigrationManager.sol";

contract Manager0xF8A0 is MigrationManager {
  address public constant PREV_TOKEN = 0xF8A0BF9cF54Bb92F17374d9e9A321E6a111a51bD;

  constructor(address childTokenAddr) public MigrationManager(PREV_TOKEN, childTokenAddr) {}

  /**
   * @dev Legacy LinkToken BEP20 deployed at 0xF8A0 does not have the `burnFrom` method,
   * so token burning is a two step process for the migration contract.
   */
  function _burn(address account, uint256 amount) internal override virtual {
    prevToken.transferFrom(account, address(this), amount);
    prevToken.burn(amount);
  }
}
