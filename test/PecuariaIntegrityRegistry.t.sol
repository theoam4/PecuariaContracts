// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {PecuariaIntegrityRegistry} from "../src/PecuariaIntegrityRegistry.sol";

contract PecuariaIntegrityRegistryTest is Test {
    PecuariaIntegrityRegistry internal registry;
    address internal registrar = makeAddr("registrar");
    address internal unauthorized = makeAddr("unauthorized");

    bytes32 internal constant RECORD_ID = keccak256("tenant:event:1");
    bytes32 internal constant PAYLOAD_HASH = keccak256("canonical-payload");

    function setUp() public {
        registry = new PecuariaIntegrityRegistry(registrar);
    }

    function test_RegisterPersistsMinimalIntegrityRecord() public {
        vm.warp(1_700_000_000);
        vm.prank(registrar);
        registry.register(RECORD_ID, PAYLOAD_HASH);

        PecuariaIntegrityRegistry.IntegrityRecord memory record = registry.getRecord(RECORD_ID);
        assertEq(record.payloadHash, PAYLOAD_HASH);
        assertEq(record.registeredAt, 1_700_000_000);
        assertEq(record.registeredBy, registrar);
        assertTrue(registry.isRegistered(RECORD_ID));
    }

    function test_RevertsForDuplicateRecord() public {
        vm.startPrank(registrar);
        registry.register(RECORD_ID, PAYLOAD_HASH);
        vm.expectRevert(abi.encodeWithSelector(PecuariaIntegrityRegistry.RecordAlreadyRegistered.selector, RECORD_ID));
        registry.register(RECORD_ID, PAYLOAD_HASH);
        vm.stopPrank();
    }

    function test_RevertsForUnauthorizedSender() public {
        vm.expectRevert(abi.encodeWithSelector(PecuariaIntegrityRegistry.Unauthorized.selector, unauthorized));
        vm.prank(unauthorized);
        registry.register(RECORD_ID, PAYLOAD_HASH);
    }

    function test_OwnerCanAuthorizeAnotherRegistrar() public {
        registry.setRegistrar(unauthorized, true);
        assertTrue(registry.authorizedRegistrars(unauthorized));
    }
}
