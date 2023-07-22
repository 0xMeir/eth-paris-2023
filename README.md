# Cairo Vesting Wallet

Built with Cairo V1 Compiler V2 (AKA Cairo 2)

---

Deployed on Starknet Goerli testnet: https://testnet.starkscan.co/class/0x07767650406027e05538b0fff0c086689bf85ef196a7771c551676124d5ef2d8#overview
https://testnet.starkscan.co/contract/0x03904901cb1221310c25a54e79a5c55a7472928e23b857a5b38e04602e2c6872

  ---

This contract handles the vesting of ERC20 tokens on Starknet for a given beneficiary. Custody of multiple tokens can be given to this contract, which will release the token to the beneficiary following a given vesting schedule. The vesting schedule is customizable through the vested_amount function. 

Any token transferred to this contract will follow the vesting schedule as if they were locked from the beginning. Consequently, if the vesting has already started, any amount of tokens sent to this contract will (at least partly) be immediately releasable. By setting the duration to 0, one can configure this contract to behave like an asset timelock that hold tokens for a beneficiary until a specified time.

This standard aims to be imported into the OpenZeppelin Cairo-contracts repository of standard Cairo language contracts.

  ---

test: `scarb test`

  

build: `scarb build`
