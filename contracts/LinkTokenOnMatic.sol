pragma solidity ^0.6.0;

import {LinkToken} from "link_token/contracts/LinkToken.sol";
import {AccessControlMixin} from "pos-portal/contracts/common/AccessControlMixin.sol";
import {IChildToken} from "pos-portal/contracts/child/ChildToken/IChildToken.sol";
import {NativeMetaTransaction} from "pos-portal/contracts/common/NativeMetaTransaction.sol";
import {ContextMixin} from "pos-portal/contracts/common/ContextMixin.sol";


contract LinkTokenOnMatic is
    LinkToken,
    IChildToken,
    AccessControlMixin,
    NativeMetaTransaction,
    ContextMixin
{

    string public constant ERC712_VERSION = "1";
    bytes32 public constant DEPOSITOR_ROLE = keccak256("DEPOSITOR_ROLE");

    constructor(
        address childChainManager
    ) public LinkToken() {
        // Burn all msg.sender tokens that are minted on LinkToken construction
        _burn(msg.sender, balanceOf(msg.sender));
        _setupContractId("LinkTokenOnMatic");
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(DEPOSITOR_ROLE, childChainManager);
        _initializeEIP712(name(), ERC712_VERSION);
    }

    function _msgSender()
        internal
        override
        view
        returns (address payable sender)
    {
        return ContextMixin.msgSender();
    }

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
        override
        only(DEPOSITOR_ROLE)
    {
        uint256 amount = abi.decode(depositData, (uint256));
        _mint(user, amount);
    }

    /**
     * @notice called when user wants to withdraw tokens back to root chain
     * @dev Should burn user's tokens. This transaction will be verified when exiting on root chain
     * @param amount amount of tokens to withdraw
     */
    function withdraw(uint256 amount) external {
        _burn(_msgSender(), amount);
    }
}
