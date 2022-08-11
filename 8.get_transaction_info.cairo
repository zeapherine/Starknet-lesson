

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_tx_info
from starkware.starknet.common.syscalls import ( get_block_number, get_block_timestamp,)


# Get transaction info: eg the signature and transaction fee.

@external
func get_tx_max_fee{
    syscall_ptr: felt*,
}() -> (max_fee : felt):
    let (tx_info) = get_tx_info()
    return (max_fee=tx_info.max_fee)
end

# The return value is a pointer TxInfo struct. which is as follows. 
#   
#
#   struct TxInfo:
#       # The version of the transaction. It is fixed (currently, 0) in the OS, and should be
#       # signed by the account contract.
#       # This field allows invalidating old transactions, whenever the meaning of the other
#       # transaction fields is changed (in the OS).
#       member version : felt
#   
#       # The account contract from which this transaction originates.
#       member account_contract_address : felt
#   
#       # The max_fee field of the transaction.
#       member max_fee : felt
#   
#       # The signature of the transaction.
#       member signature_len : felt
#       member signature : felt*
#   
#       # The hash of the transaction.
#       member transaction_hash : felt
#   
#       # The identifier of the chain.
#       # This field can be used to prevent replay of testnet transactions on mainnet.
#       member chain_id : felt
#   end
#   



# ...

@external
func get_block_info{
    syscall_ptr: felt*,
}() -> (info : felt):
    let (block_number) = get_block_number()
    let (block_timestamp) = get_block_timestamp()
    return (info=block_number)
    # return (info=block_timestamp)
end