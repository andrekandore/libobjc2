.macro MSGSEND receiver, sel
    .cfi_startproc
0: #check nil or small object

    beqz \receiver, 4f
    # extract bitfiled from \receiver at position zero to lenght of SMALLOBJ_BITS
    xori t0, \receiver, SMALLOBJ_MASK #SMALLOBJ_BITS?
    bnez t0, 6f
1:
2:
3:
4:
5:
6:
7:
8:
9:
.endm
