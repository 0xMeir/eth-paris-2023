# Cairo Vesting Wallet
Cairo v1 compiler v2 (AKA cairo 2)
based on https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/finance/VestingWallet.sol

deployed on Starknet Goerli testnet: https://testnet.starkscan.co/class/0x07767650406027e05538b0fff0c086689bf85ef196a7771c551676124d5ef2d8#overview
https://testnet.starkscan.co/contract/0x03904901cb1221310c25a54e79a5c55a7472928e23b857a5b38e04602e2c6872

This contract handles the vesting of ERC20 tokens for a given beneficiary. Custody of multiple tokens can be given to this contract, which will release the token to the beneficiary following a given vesting schedule. The vesting schedule is customizable through the vested_amount function.

test: scarb test
build: scarb build
