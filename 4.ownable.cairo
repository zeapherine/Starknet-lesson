# https://goerli.voyager.online/contract/0x05faf6eaa393a9f07063e7440aa69f49d0cded00528a5afc324d2a744f11d776

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

# Define a storage variable for the owner address.
@storage_var
func owner() -> (owner_address: felt):
end

@constructor
func constructor{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}(owner_address : felt):
    owner.write(value=owner_address)
    return()
end

@view
func get_owner{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}() -> (address : felt):
    let (address) = owner.read()
    return(address)
end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    















