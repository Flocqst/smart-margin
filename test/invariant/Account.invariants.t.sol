// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.18;

import {Account} from "../../src/Account.sol";
import {ERC20} from "@solmate/tokens/ERC20.sol";
import {Events} from "../../src/Events.sol";
import {Factory} from "../../src/Factory.sol";
import {IAccount} from "../../src/interfaces/IAccount.sol";
import {IAddressResolver} from "@synthetix/IAddressResolver.sol";
import {IFuturesMarketManager} from "../../src/interfaces/IAccount.sol";
import {IOps} from "../../src/utils/OpsReady.sol";
import {IPerpsV2MarketConsolidated} from "../../src/interfaces/IAccount.sol";
import {IPerpsV2MarketSettings} from "@synthetix/IPerpsV2MarketSettings.sol";
import {ISynth} from "@synthetix/ISynth.sol";
import {OpsReady, IOps} from "../../src/utils/OpsReady.sol";
import {Settings} from "../../src/Settings.sol";
import {Setup} from "../../script/Deploy.s.sol";
import {Test} from "forge-std/Test.sol";
import "../utils/Constants.sol";

contract AccountInvariants is Test {
    receive() external payable {}

    Settings private settings;
    Events private events;
    Factory private factory;
    ERC20 private sUSD;
    Account private account;

    function setUp() public {
        vm.rollFork(BLOCK_NUMBER);

        sUSD = ERC20(
            (IAddressResolver(ADDRESS_RESOLVER)).getAddress("ProxyERC20sUSD")
        );

        Setup setup = new Setup();
        factory = setup.deploySmartMarginFactory({
            owner: address(this),
            treasury: KWENTA_TREASURY,
            tradeFee: TRADE_FEE,
            limitOrderFee: LIMIT_ORDER_FEE,
            stopOrderFee: STOP_ORDER_FEE,
            addressResolver: ADDRESS_RESOLVER,
            marginAsset: MARGIN_ASSET,
            gelato: GELATO,
            ops: OPS
        });
        settings = Settings(factory.settings());
        events = Events(factory.events());
        account = Account(payable(factory.newAccount()));

        address issuer = IAddressResolver(ADDRESS_RESOLVER).getAddress("Issuer");
        ISynth synthsUSD =
            ISynth(IAddressResolver(ADDRESS_RESOLVER).getAddress("SynthsUSD"));

        // mint sUSD to the account and the owner
        vm.startPrank(issuer);
        synthsUSD.issue(address(this), AMOUNT);
        synthsUSD.issue(address(account), AMOUNT);
        vm.stopPrank();

        // mint ETH to the account
        vm.deal(address(account), AMOUNT);
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
