# Contract address: 0x06da792b463878d4eb1ee6223e0a2820e844952d94de6a0c7906748172c9d310
# Transaction hash: 0x209780b9c36421b05a7826567455c4871b3a739842252e5bd294a191b7d9db4


%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

@contract_interface
namespace IBalanceContract:
    func increase_balance(amount : felt):
    end

    func get_balance() -> (res :felt):
    end
end


# calling a function of another contract requires passing one additional argument before the functions
# original arguments.

@external
func call_increase_balance{
    syscall_ptr : felt*,
    range_check_ptr
}(contract_address : felt, amount : felt):
    IBalanceContract.increase_balance(contract_address = contract_address, amount = amount)
    return()
end

@view
func get_balance{
    syscall_ptr : felt*,
    range_check_ptr
}(contract_address : felt) -> (res : felt) :
   let (res) = IBalanceContract.get_balance(contract_address = contract_address)
   return(res= res)
end