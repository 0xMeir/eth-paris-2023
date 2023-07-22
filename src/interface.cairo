use starknet::ContractAddress;

#[starknet::interface]
trait IVestingWallet<TState> {
    fn beneficiary(self: @TState) -> ContractAddress;
    fn start(self: @TState) -> u64;
    fn duration(self: @TState) -> u64;
    fn end(self: @TState) -> u64;
    fn released(self: @TState, token: ContractAddress) -> u256;
    fn releasable(self: @TState, token: ContractAddress) -> u256;
    fn release(ref self: TState, token: ContractAddress);
    fn vested_amount(self: @TState, token: ContractAddress, timestamp: u64) -> u256;
}
