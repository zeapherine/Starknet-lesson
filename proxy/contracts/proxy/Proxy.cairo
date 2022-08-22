# Deploy transaction was sent.
# Contract address: 0x0012e4618a9947c908f7aad0eff3a618407fc769cdf6bc416854f299fab72f38
# Transaction hash: 0x57c0c8dc10642579dbe520d3c78641c96e21c9b8c5e461b4cfebb011b37523e

# Contract address: 0x0463b036ce41857365d6c7d9e26e6ad8988d8b0ec7fec26fdee45aeffbd2652a
# Transaction hash: 0x15ab232ad0dd1f38e1cf66cbf4059c01e2ade7de52773d16d8f075a5ede3cfb



# SPDX-License-Identifier: MIT
# OpenZeppelin Contracts for Cairo v0.2.1 (upgrades/presets/Proxy.cairo)

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import (
    library_call,
    library_call_l1_handler
)

from contracts.proxy.library import Proxy


#
# Constructor
#

@constructor
func constructor{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(implementation_hash: felt):
    Proxy._set_implementation_hash(implementation_hash)
    return ()
end

#
# Fallback functions
#

@external
@raw_input
@raw_output
func __default__{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(
        selector: felt,
        calldata_size: felt,
        calldata: felt*
    ) -> (
        retdata_size: felt,
        retdata: felt*
    ):
    let (class_hash) = Proxy.get_implementation_hash()

    let (retdata_size: felt, retdata: felt*) = library_call(
        class_hash=class_hash,
        function_selector=selector,
        calldata_size=calldata_size,
        calldata=calldata,
    )
    return (retdata_size=retdata_size, retdata=retdata)
end


@l1_handler
@raw_input
func __l1_default__{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(
        selector: felt,
        calldata_size: felt,
        calldata: felt*
    ):
    let (class_hash) = Proxy.get_implementation_hash()

    library_call_l1_handler(
        class_hash=class_hash,
        function_selector=selector,
        calldata_size=calldata_size,
        calldata=calldata,
    )
    return ()
end