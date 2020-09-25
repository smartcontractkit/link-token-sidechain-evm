pragma solidity ^0.6.0;

import {MigrationManager} from "./MigrationManager.sol";

contract Manager0xF8A0 is MigrationManager {

  address public constant PREV_TOKEN = 0xF8A0BF9cF54Bb92F17374d9e9A321E6a111a51bD;

  constructor(address childTokenAddr)
    public 
    MigrationManager(PREV_TOKEN, childTokenAddr) 
  {
    // noop
  }
}
