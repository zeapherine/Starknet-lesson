# contract address : 0x01dc16bde26b92151069b3464791ce38d99b38d57c9fc36a34f19c8ad0c4c83a

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

# arguments of storage variable can be a struct --> as long as they
# don't contain pointers
# these types are called FELTS-ONLY TYPES
struct User:
    member first_name : felt
    member last_name : felt
end

# Mapping to a user to 1 if they voted and 0 if not
@storage_var
func user_voted(user: User) -> (res : felt):
end

@external
func vote{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}(user: User):
    user_voted.write(user,1)
    return()
end

