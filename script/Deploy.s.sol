// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.18;

import "forge-std/Script.sol";
import {Account} from "src/Account.sol";
import {Events} from "src/Events.sol";
import {Factory} from "src/Factory.sol";
import {Settings} from "src/Settings.sol";

/// @title Script to deploy Kwenta's Smart Margin Account Factory
/// @author JaredBorders (jaredborders@pm.me)
contract Setup {
    function deploySmartMarginFactory(
        bool useDeployer,
        address owner,
        address treasury,
        uint256 tradeFee,
        uint256 limitOrderFee,
        uint256 stopOrderFee,
        address addressResolver,
        address marginAsset,
        address gelato,
        address ops
    ) public returns (Factory factory) {
        address mainnetDeployer = 0xc625F59d51ecDff57FEFE535C80d318CA42A0Ec4;

        Settings settings = new Settings({
            _owner: owner,
            _treasury: treasury,
            _tradeFee: tradeFee,
            _limitOrderFee: limitOrderFee,
            _stopOrderFee: stopOrderFee
        });

        Account implementation = new Account({
            addressResolver: addressResolver, 
            marginAsset: marginAsset,
            gelato: gelato,
            ops: ops
        });

        // deploy Factory
        factory = new Factory({
            _owner: useDeployer ? mainnetDeployer : address(this),
            _settings: address(settings),
            _events: address(0),
            _implementation: address(implementation)
        });

        // set events
        Events events = new Events({_factory: address(factory)});
        factory.upgradeEvents(address(events));

        // set proper owner of factory
        factory.transferOwnership(owner);
    }
}

/// @dev steps to deploy and verify on Optimism:
/// (1) load the variables in the .env file via `source .env`
/// (2) run `forge script script/Deploy.s.sol:DeployOptimism --rpc-url $ARCHIVE_NODE_URL_L2 --broadcast --verify -vvvv`
contract DeployOptimism is Script, Setup {
    address private constant KWENTA_ADMIN_DAO_MULTI_SIG =
        0xF510a2Ff7e9DD7e18629137adA4eb56B9c13E885;
    address private constant KWENTA_TREASURY_MULTI_SIG =
        0x82d2242257115351899894eF384f779b5ba8c695;

    uint256 private constant SETTINGS_TRADE_FEE = 0;
    uint256 private constant SETTINGS_LIMIT_ORDER_FEE = 2;
    uint256 private constant SETTINGS_STOP_ORDER_FEE = 2;

    address private constant ADDRESS_RESOLVER =
        0x1Cb059b7e74fD21665968C908806143E744D5F30;
    address private constant MARGIN_ASSET =
        0x8c6f28f2F1A3C87F0f938b96d27520d9751ec8d9;

    address private constant GELATO = 0x01051113D81D7d6DA508462F2ad6d7fD96cF42Ef;
    address private constant OPS = 0x340759c8346A1E6Ed92035FB8B6ec57cE1D82c2c;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        Setup.deploySmartMarginFactory({
            useDeployer: true,
            owner: KWENTA_ADMIN_DAO_MULTI_SIG,
            treasury: KWENTA_TREASURY_MULTI_SIG,
            tradeFee: SETTINGS_TRADE_FEE,
            limitOrderFee: SETTINGS_LIMIT_ORDER_FEE,
            stopOrderFee: SETTINGS_STOP_ORDER_FEE,
            addressResolver: ADDRESS_RESOLVER,
            marginAsset: MARGIN_ASSET,
            gelato: GELATO,
            ops: OPS
        });

        vm.stopBroadcast();
    }
}

/// @dev steps to deploy and verify on Optimism Goerli:
/// (1) load the variables in the .env file via `source .env`
/// (2) run `forge script script/Deploy.s.sol:DeployOptimismGoerli --rpc-url $ARCHIVE_NODE_URL_GOERLI_L2 --broadcast --verify -vvvv`
contract DeployOptimismGoerli is Script, Setup {
    address private constant KWENTA_ADMIN_DAO_MULTI_SIG =
        0xc625F59d51ecDff57FEFE535C80d318CA42A0Ec4; // deployer address
    address private constant KWENTA_TREASURY_MULTI_SIG =
        0xc625F59d51ecDff57FEFE535C80d318CA42A0Ec4; // deployer address

    uint256 private constant SETTINGS_TRADE_FEE = 0;
    uint256 private constant SETTINGS_LIMIT_ORDER_FEE = 2;
    uint256 private constant SETTINGS_STOP_ORDER_FEE = 2;

    address private constant ADDRESS_RESOLVER =
        0x9Fc84992dF5496797784374B810E04238728743d;
    address private constant MARGIN_ASSET =
        0xeBaEAAD9236615542844adC5c149F86C36aD1136;

    address private constant GELATO = 0xF82D64357D9120a760e1E4C75f646C0618eFc2F3;
    address private constant OPS = 0x255F82563b5973264e89526345EcEa766DB3baB2;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        Setup.deploySmartMarginFactory({
            useDeployer: true,
            owner: KWENTA_ADMIN_DAO_MULTI_SIG,
            treasury: KWENTA_TREASURY_MULTI_SIG,
            tradeFee: SETTINGS_TRADE_FEE,
            limitOrderFee: SETTINGS_LIMIT_ORDER_FEE,
            stopOrderFee: SETTINGS_STOP_ORDER_FEE,
            addressResolver: ADDRESS_RESOLVER,
            marginAsset: MARGIN_ASSET,
            gelato: GELATO,
            ops: OPS
        });

        vm.stopBroadcast();
    }
}
