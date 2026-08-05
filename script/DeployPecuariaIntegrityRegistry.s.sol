// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {PecuariaIntegrityRegistry} from "../src/PecuariaIntegrityRegistry.sol";

contract DeployPecuariaIntegrityRegistry is Script {
    function run() external returns (PecuariaIntegrityRegistry registry) {
        address registrar = vm.envAddress("INTEGRITY_REGISTRAR_ADDRESS");

        vm.startBroadcast();
        registry = new PecuariaIntegrityRegistry(registrar);
        vm.stopBroadcast();
    }
}
