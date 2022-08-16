
# Contract address: 0x05808c76d9fa24baae378ff2e1996d6d59120a60487778a85772b816f9bcf263
# Transaction hash: 0x2f8c8197f8874413e939b36a1733a6a8208c14fd267645cada9c49924e51056


%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.math import assert_not_zero
from starkware.starknet.common.syscalls import get_caller_address



@storage_var
func balance() -> (value : felt):
end

@storage_var
func super_admin(super_admin_public_key : felt) -> (super_admin_public_key : felt):
end

@storage_var
func admin(admin_public_key : felt) -> (admin_public_key : felt):
end

@constructor
func constructor{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}(admin_address : felt):
    super_admin.write(admin_address, value=admin_address)
    return()
end

@external
func add_admin{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}(admin_address : felt):
    let (caller) = get_caller_address()
    let (is_super_admin) = super_admin.read(caller)
   

     with_attr error_message(
            "Only super admin can add admin"):
        assert is_super_admin = caller
    end
    admin.write(admin_address, value=admin_address)
    return()
end

@external
func remove_admin{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}(admin_address : felt):
    let (caller) = get_caller_address()
    let (is_super_admin) = super_admin.read(caller)
   

     with_attr error_message(
            "Only super admin can remove admin"):
        assert is_super_admin = caller
    end
    admin.write(admin_address, value=0)
    return()
end

@external
func transfer_admin_role{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}(new_admin_address : felt):
    let (caller) = get_caller_address()
    let (current_admin) = admin.read(caller)
   

     with_attr error_message(
            "Only existing admin can transfer admin role"):
        assert current_admin = caller
    end
    admin.write(caller, value=new_admin_address)
    return()
end

@external
func renounce_admin_role{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}():
    let (caller) = get_caller_address()
    let (current_admin) = admin.read(caller)
   

     with_attr error_message(
            "Only existing admin can transfer admin role"):
        assert current_admin = caller
    end
    admin.write(caller, value=0)
    return()
end

@external
func add_balance{syscall_ptr : felt*, range_check_ptr, pedersen_ptr: HashBuiltin*}(amount : felt):
    let (caller) = get_caller_address()
    let (current_admin) = admin.read(caller)
   
     with_attr error_message(
            "Only admin can add balance"):
        assert current_admin = caller
    end
    let (res) = balance.read()
    balance.write(res + amount)
    return()
end

@view
func view_balance{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}() -> (balance : felt):
    let (res) = balance.read()
    return (balance = res)
end