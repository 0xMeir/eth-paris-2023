use integer::BoundedInt;
use integer::u256;
use integer::u256_from_felt252;
use starknet::ContractAddress;
use starknet::contract_address_const;
use starknet::testing::set_caller_address;
use traits::Into;
use zeroable::Zeroable;

use vesting_wallet::vesting_wallet::VestingWallet;
use vesting_wallet::vesting_wallet::VestingWallet::{VestingWalletImpl, InternalImpl};

use vesting_wallet::tests::mocks::erc20_mock::{ERC20, IERC20Dispatcher, IERC20DispatcherTrait};

fn STATE() -> VestingWallet::ContractState {
    VestingWallet::contract_state_for_testing()
}

fn BENEFICIARY() -> ContractAddress {
    contract_address_const::<1>()
}

const START: u64 = 1690063034;
const DURATION: u64 = 12960000;

fn setup() -> VestingWallet::ContractState {
    let mut state = STATE();
    VestingWallet::constructor(ref state, BENEFICIARY(), START, DURATION);
    state
}

//
// initializer & constructor
//

#[test]
#[available_gas(2000000)]
fn test_initializer() {
    let mut state = STATE();
    InternalImpl::initializer(ref state, BENEFICIARY(), START, DURATION);

    assert(VestingWalletImpl::start(@state) == START, 'Start should be START');
    assert(VestingWalletImpl::duration(@state) == DURATION, 'Duration should be DURATION');
}

#[test]
#[available_gas(2000000)]
fn test_constructor() {
    let mut state = STATE();
    VestingWallet::constructor(ref state, BENEFICIARY(), START, DURATION);

    assert(VestingWalletImpl::start(@state) == START, 'Start should be START');
    assert(VestingWalletImpl::duration(@state) == DURATION, 'Duration should be DURATION');
}

#[test]
#[available_gas(2000000)]
fn test_end_timestamp() {
    let mut state = STATE();
    VestingWallet::constructor(ref state, BENEFICIARY(), START, DURATION);
    let end: u64 = START + DURATION;
    assert(VestingWalletImpl::end(@state) == end, 'End should be START + DURATION');
}

