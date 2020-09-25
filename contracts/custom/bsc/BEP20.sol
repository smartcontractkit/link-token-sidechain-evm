pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

abstract contract BEP20 is ERC20 {

  /**
   * @dev Returns the bep token owner.
   */
  function getOwner() virtual external view returns (address);
}
