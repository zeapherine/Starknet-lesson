# contract address : 0x0486e422d2789f04a7e1727069c04212ee55e8adf58810216a66ff11611a58e7

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

@external
func compare_arrays(
    a_len : felt, a : felt*, b_len : felt, b : felt*
):
    assert a_len = b_len
    if a_len == 0:
        return ()
    end
    assert a[0] = b[0]
    return compare_arrays(
        a_len=a_len - 1, a=&a[1], b_len=b_len - 1, b=&b[1]
    )
end

# to invoke in cli use 
# starknet invoke --address 0x0486e422d2789f04a7e1727069c04212ee55e8adf58810216a66ff11611a58e7 --abi contract_abi.json --function compare_arrays --inputs 4 10 20 30 40 2 50 60