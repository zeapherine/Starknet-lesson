

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

# A mapping from user to a pair (min, max) ||  # (min, max)
@storage_var
func range(user : felt) -> (res : (felt,felt)):
end

@external
func extend_range{
    syscall_ptr : felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}(user: felt) :
    let (min_max) = range.read(user)  # range.read(user) returns one item, i.e a pair ---> min_max
    range.write(user, (min_max[0] - 1, min_max[1] + 1))
    return()
end

