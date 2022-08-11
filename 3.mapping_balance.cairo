# contract deployed at : https://goerli.voyager.online/contract/0x2e27c8c83a626e0670b4db65af2889bdb5eb6b3312691bf17ca6c91c67aed29
# https://www.cairo-lang.org/docs/hello_starknet/user_auth.html


%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_nn
from starkware.starknet.common.syscalls import get_caller_address


@storage_var
func balance(user : felt) -> (res : felt):
end

@external
func increase_balance{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr,
}(amount : felt):
   # Verify that the amount is positive.
    with_attr error_message(
            "Amount must be positive. Got: {amount}."):
        assert_nn(amount)
    end

    # Obtain the address of the account contract.
    let (user) = get_caller_address()

    # Read and update its balance.
    let (res) = balance.read(user=user)
    balance.write(user, res + amount)
    return ()
end

@view
func get_balance{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr,
}(user : felt) -> (res : felt):
    let (res) = balance.read(user=user)
    return (res)
end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    