// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.18;

import {Test} from "forge-std/Test.sol";
import {Account} from "../../src/Account.sol";
import {IAccount} from "../../src/interfaces/IAccount.sol";

contract AccountInvariants is Test {
    Account private account;

    function setUp() public {
        account = new Account(address(0), address(0), address(0), address(0));
    }

    function invariant_WithdrawEth() public {
        // only the owner should be able to withdraw ETH
        revert("not implemented");
    }

    function invariant__ModifyAccountMargin() public {
        // only the owner should be able to modify the account margin
        revert("not implemented");
    }

    function invariant__FreeMargin() public {
        // free margin should be less than or equal to the total account margin
        revert("not implemented");
    }
}
