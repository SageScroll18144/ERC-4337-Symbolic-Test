# ERC-4337-Symbolic-Test
Symbolic Tests for ERC4337

The goal of this project was to develop a symbolic test suite for the ERC-4337 protocol, as described in EIP-4337. To do this, we used an implementation of the protocol based on the OpenZeppelin library. Through symbolic tests, the intention was to verify the behavior of the protocol in different scenarios and validate its consistency.

In addition, the test campaign was executed using the Halmos and hevm tools, with the aim of verifying the performance, the reliability of the responses and identifying possible flaws in the tools. During the execution, the focus was on finding flaws in the tests and documenting the findings.

This repository was developed by Felipe Santos and Giovanny Lira.

## Functions from contract Test

```js
function testValidatePackedDataWithNonZeroValidUntil();
```
- Tests the packing and unpacking of validation data with a non-zero `validUntil` value, ensuring the aggregator, `validAfter`, and `validUntil` values match the expected results.

```js
function testValidatePackedDataWithZeroValidUntil();
```

- Tests the packing and unpacking of validation data with a zero `validUntil` value, verifying that `validUntil` is correctly set to `type(uint48).max` and other values match expectations.

```js
function testValidateCombinationWithDifferentAggregators(address aggregator1, address aggregator2, uint48 validAfter1, uint48 validUntil1, uint48 validAfter2, uint48 validUntil2);
```
- Tests the combination of two validation data sets with different aggregators, ensuring the combined aggregator, `validAfter`, and `validUntil` values are correctly calculated based on the input data.

```js
function testValidateCombinationWithSameAggregator(address aggregator, uint48 validAfter1, uint48 validUntil1, uint48 validAfter2, uint48 validUntil2);
```
- Tests the combination of two validation data sets with the same aggregator, verifying that the combined aggregator, `validAfter`, and `validUntil` values are correctly derived from the input data.