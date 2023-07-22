use starknet::ContractAddress;

#[starknet::contract]
mod VestingWallet {
    use starknet::{get_block_timestamp, ContractAddress};
    use vesting_wallet::interface;
    use traits::Into;

    #[storage]
    struct Storage {
        _beneficiary: ContractAddress,
        _start: u64,
        _duration: u64,
        _released: LegacyMap<ContractAddress, u256>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        ERC20Released: ERC20Released
    }

    #[derive(Drop, starknet::Event)]
    struct ERC20Released {
        token: ContractAddress,
        amount: u256
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        beneficiary_address: ContractAddress,
        start_timestamp: u64,
        duration_seconds: u64
    ) {
        self.initializer(beneficiary_address, start_timestamp, duration_seconds);
    }


    #[external(v0)]
    impl VestingWalletImpl of interface::IVestingWallet<ContractState> {
        fn beneficiary(self: @ContractState) -> ContractAddress {
            self._beneficiary.read()
        }

        fn start(self: @ContractState) -> u64 {
            self._start.read()
        }

        fn duration(self: @ContractState) -> u64 {
            self._duration.read()
        }

        fn end(self: @ContractState) -> u64 {
            self._start.read() + self._duration.read()
        }

        fn released(self: @ContractState, token: ContractAddress) -> u256 {
            self._released.read(token)
        }

        fn releasable(self: @ContractState, token: ContractAddress) -> u256 {
            self._releasable(token)
        }

        fn release(ref self: ContractState, token: ContractAddress) {
            let amount: u256 = self._releasable(token);
            let released_amount = self._released.read(token) + amount;
            self._released.write(token, released_amount);
            self.emit(ERC20Released { token, amount: released_amount });
            let ERC20 = IERC20Dispatcher { contract_address: token };
            if (amount > 0) {
                ERC20.transfer(self.beneficiary(), amount);
            }
        }
        fn vested_amount(self: @ContractState, token: ContractAddress, timestamp: u64) -> u256 {
            self
                ._vestingSchedule(
                    IERC20(token).balanceOf(address(this)) + self._released.read(token), timestamp
                )
        }
    }

    //
    // Internal
    //

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn initializer(
            ref self: ContractState,
            beneficiary_address: ContractAddress,
            start_timestamp: u64,
            duration_seconds: u64
        ) {
            self._beneficiary.write(beneficiary_address);
            self._start.write(start_timestamp);
            self._duration.write(duration_seconds);
        }

        fn _vested_amount(self: @ContractState, token: ContractAddress, timestamp: u64) -> u256 {
            self
                ._vestingSchedule(
                    IERC20(token).balanceOf(address(this)) + self._released.read(token), timestamp
                )
        }

        fn _releasable(self: @ContractState, token: ContractAddress) -> u256 {
            self._vested_amount(token, get_block_timestamp()) - self._released.read(token)
        }

        fn _vestingSchedule(self: @ContractState, total_allocation: u256, timestamp: u64) -> u256 {
            let start = self._start.read();
            let duration = self._duration.read();
            let end = start + duration;

            if timestamp < start {
                0
            } else if timestamp > end {
                total_allocation
            } else {
                (total_allocation * (timestamp.into() - start.into())) / duration.into()
            }
        }
    }
}
