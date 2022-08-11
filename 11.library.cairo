%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

# --> A library call is a way to invoke a function declared in a given contract class within the context of the calling contract.
# --> Storage changing function operation calls will afect the state of the calling function.
# --> It is similar to delegate call in solidity. the only deference is that 
#                                        --> delegate call requires a deployed contract.
#                                        --> while library works with the contract class.

@contract_interface
namespace IBalanceContract:
    func increase_balance(amount : felt):
    end

    func get_balance() -> (res :felt):
    end
end

# Define local balance variable in our proxy contract.
@storage_var
func balance() -> (res : felt):
end


## pass class_hash as a parameter, unlike in lesson 10, where we pass contract address to call the function of another contract.
@external
func increase_my_balance{syscall_ptr : felt*, range_check_ptr}(
    class_hash : felt, amount : felt
):
    # Increase the local balance variable using a function from a
    # different contract class using a library call.
    IBalanceContract.library_call_increase_balance(
        class_hash=class_hash, amount=amount
    )
    return ()
end