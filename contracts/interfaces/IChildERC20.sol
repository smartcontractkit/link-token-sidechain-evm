pragma solidity ^0.6.0;

interface IChildERC20 {
  function deposit(address user, bytes calldata depositData) external;
  function withdraw(uint256 amount) external;
}
