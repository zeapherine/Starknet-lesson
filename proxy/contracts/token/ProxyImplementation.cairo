# SPDX-License-Identifier: MIT

# Declare transaction 
# Contract class hash: 0x4157a1843e1c3b7b8085e693613f7afaa3f55b56f19b220e07f022e6e1996f
# Transaction hash: 0x6861cdb76b6270ed03b18407f04087e3162cd6404531f0445372eb672c8bcb0

# Declare transaction was sent.
# Contract class hash: 0x4157a1843e1c3b7b8085e693613f7afaa3f55b56f19b220e07f022e6e1996f
# Transaction hash: 0x6861cdb76b6270ed03b18407f04087e3162cd6404531f0445372eb672c8bcb0

# Deploy transaction was sent.
# Contract address: 0x01ed41b50dff709d4817a44ba2ba9035487f10d74c7b72911093f4e87e35d469
# Transaction hash: 0x45697030888aef82f6fd8af54658ac0589a41a1edcbfbe988953ab4eaf31a5c



%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

from contracts.proxy.library import Proxy
#
# Storage
#

@storage_var
func value_1() -> (res: felt):
end

#
# Initializer
#

@external
func initializer{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(proxy_admin: felt):
    Proxy.proxy_initializer(proxy_admin)
    return ()
end

#
# Upgrades
#

@external
func upgrade{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(new_implementation: felt):
    Proxy.assert_only_admin()
    Proxy._set_implementation_hash(new_implementation)
    return ()
end

#
# Getters
#

@view
func getValue1{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (val: felt):
    let (val) = value_1.read()
    return (val)
end

#
# Setters
#

@external
func setValue1{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(val: felt):
    value_1.write(val)
    return ()
end