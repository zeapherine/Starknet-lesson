%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import (
    get_contract_address,
)


# You can get the contract adddress by using get_contract_address() library function.

# .......

func get_address_this{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}() -> (address: felt): 
    let (contract_address) = get_contract_address()
    return (address = contract_address)
end
