pragma solidity ^0.6.0;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import {ChildERC20Recoverable} from "./ChildERC20Recoverable.sol";

abstract contract ChildERC20CollateralLimited is ChildERC20Recoverable {

  AggregatorV3Interface public proofOfReservesFeed;

  constructor(
    address childChainManager,
    address proofOfReservesFeedAddr
  ) public ChildERC20Recoverable(childChainManager) {
    _setupContractId("ChildERC20CollateralLimited");
    // Set the Proof of Reserves feed contract
    proofOfReservesFeed = AggregatorV3Interface(proofOfReservesFeedAddr);
  }

  /**
   * @dev Does not allow if called with amout that would make the child token undercollateralized.
   *
   * @param depositData abi encoded amount
   */
  function _isDepositAllowed(address /* user */, bytes memory depositData) internal override virtual returns (bool, string memory) {
    (
      /* uint80 roundId */,
      int256 answer,
      /* uint256 startedAt */,
      /* uint256 updatedAt */,
      /* uint80 answeredInRound */
    ) = proofOfReservesFeed.latestRoundData();

    uint256 amount = abi.decode(depositData, (uint256));
    bool allowed = totalSupply().add(amount) <= uint256(answer);
    string memory message = allowed ? "" : "ChildERC20CollateralLimited: insufficient reserves";
    return (allowed, message);
  }
}
