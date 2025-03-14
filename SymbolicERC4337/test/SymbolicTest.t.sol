// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../lib/forge-std/src/Test.sol";
import "../lib/openzeppelin-contracts/contracts/account/utils/draft-ERC4337Utils.sol";

contract SymbolicTest is Test {

    function testValidatePackedDataWithNonZeroValidUntil() public pure {
        address expectedAggregator = address(0x123);
        uint48 expectedValidAfter = 10;
        uint48 expectedValidUntil = 20;

        uint256 packedData = ERC4337Utils.packValidationData(expectedAggregator, expectedValidAfter, expectedValidUntil);
        (address actualAggregator, uint48 actualValidAfter, uint48 actualValidUntil) = ERC4337Utils.parseValidationData(packedData);

        assertEq(actualAggregator, expectedAggregator, "Erro: Aggregator does not match for validUntil not null");
        assertEq(actualValidAfter, expectedValidAfter, "Erro: validAfter does not match for validUntil not null");
        assertEq(actualValidUntil, expectedValidUntil, "Erro: validUntil does not match for validUntil not null");
    }


    function testValidatePackedDataWithZeroValidUntil() public pure {
        address expectedAggregator = address(0x123);
        uint48 expectedValidAfter = 400;
        uint48 expectedValidUntil = 0;

        uint256 packedData = ERC4337Utils.packValidationData(expectedAggregator, expectedValidAfter, expectedValidUntil);
        (address actualAggregator, uint48 actualValidAfter, uint48 actualValidUntil) = ERC4337Utils.parseValidationData(packedData);

        assertEq(actualAggregator, expectedAggregator, "Erro: Aggregator does not match for validUntil eq. zero");
        assertEq(actualValidAfter, expectedValidAfter, "Erro: validAfter does not match for validUntil eq. zero");
        assertEq(actualValidUntil, type(uint48).max, "Erro: validUntil does not match for validUntil eq. zero");
    }

    function testValidateCombinationWithDifferentAggregators(address aggregator1, address aggregator2, uint48 validAfter1, uint48 validUntil1, uint48 validAfter2, uint48 validUntil2) public pure {
        if (validUntil1 != 0) vm.assume(validAfter1 <= validUntil1);
        if (validUntil2 != 0) vm.assume(validAfter2 <= validUntil2);
        vm.assume(aggregator1 != aggregator2);

        uint256 packedData1 = ERC4337Utils.packValidationData(aggregator1, validAfter1, validUntil1);
        uint256 packedData2 = ERC4337Utils.packValidationData(aggregator2, validAfter2, validUntil2);
        uint256 combinedData = ERC4337Utils.combineValidationData(packedData1, packedData2);

        (address combinedAggregator, uint48 combinedValidAfter, uint48 combinedValidUntil) = ERC4337Utils.parseValidationData(combinedData);

        address expectedAggregator = address(1);
        uint48 expectedValidAfter = validAfter1 >= validAfter2 ? validAfter1 : validAfter2;
        uint48 normalizedValidUntil1 = validUntil1 == 0 ? type(uint48).max : validUntil1;
        uint48 normalizedValidUntil2 = validUntil2 == 0 ? type(uint48).max : validUntil2;
        uint48 expectedValidUntil = normalizedValidUntil1 <= normalizedValidUntil2 ? normalizedValidUntil1 : normalizedValidUntil2;

        assertEq(combinedAggregator, expectedAggregator, "Erro: Aggregator invalid for differents aggregators");
        assertEq(combinedValidAfter, expectedValidAfter, "Erro: validAfter incorrect combination for different aggregators");
        assertEq(combinedValidUntil, expectedValidUntil, "Erro: validUntil incorrect combination for different aggregators");
    }

    function testValidateCombinationWithSameAggregator(address aggregator, uint48 validAfter1, uint48 validUntil1, uint48 validAfter2, uint48 validUntil2) public pure {
        if (validUntil1 != 0) vm.assume(validAfter1 <= validUntil1);
        if (validUntil2 != 0) vm.assume(validAfter2 <= validUntil2);

        uint256 packedData1 = ERC4337Utils.packValidationData(aggregator, validAfter1, validUntil1);
        uint256 packedData2 = ERC4337Utils.packValidationData(aggregator, validAfter2, validUntil2);
        uint256 combinedData = ERC4337Utils.combineValidationData(packedData1, packedData2);

        (address combinedAggregator, uint48 combinedValidAfter, uint48 combinedValidUntil) = ERC4337Utils.parseValidationData(combinedData);

        address expectedAggregator = (aggregator == address(0)) ? address(0) : address(1);
        uint48 expectedValidAfter = validAfter1 >= validAfter2 ? validAfter1 : validAfter2;
        uint48 normalizedValidUntil1 = validUntil1 == 0 ? type(uint48).max : validUntil1;
        uint48 normalizedValidUntil2 = validUntil2 == 0 ? type(uint48).max : validUntil2;
        uint48 expectedValidUntil = normalizedValidUntil1 <= normalizedValidUntil2 ? normalizedValidUntil1 : normalizedValidUntil2;

        assertEq(combinedAggregator, expectedAggregator, "Erro: Aggregator invalid for same aggregator");
        assertEq(combinedValidAfter, expectedValidAfter, "Erro: validAfter incorrect combination for the same aggregator");
        assertEq(combinedValidUntil, expectedValidUntil, "Erro: validUntil incorrect combination for the same aggregator");
    }



}