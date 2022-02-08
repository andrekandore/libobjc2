.macro MSGSEND receiver, sel
    .cfi_startproc

0:  # check nil or small object

    # when nil receiver, then immediately return via `4`
    beqz    \receiver, 4f

    # when small object (NSNumber) then jump to `6`
    andi    t0, \receiver, SMALLOBJ_MASK
    bnez    t0, 6f

    # load selector and receiver pointers
    ld      t0, (\receiver)
    ld      t1, (\sel)

1:  # load dispatch table and its size
    ld      t2, DTABLE_OFFSET(t0)
    lw      t3, SHIFT_OFFSET(t2)

    # check if small size = 8
    li      t4, 8
    beq     t3, t4, 2f

    # check if small size = 0
    beqz    t3, 3f

2:  # small (8) dispatch table


3:  # zero-size dispatch table
4:  # nil receiver
5:
6:  # small object
7:
8:
9:
.cfi_endproc
.endm

.globl CDECL(objc_msgSend)
TYPE_DIRECTIVE(CDECL(objc_msgSend), @function)

.globl CDECL(objc_msgSend_fpret)
TYPE_DIRECTIVE(CDECL(objc_msgSend_fpret), @function)

CDECL(objc_msgSend_fpret):
CDECL(objc_msgSend):
    MSGSEND a0 a1

.globl CDECL(objc_msgSend_stret)
TYPE_DIRECTIVE(CDECL(objc_msgSend_stret), @function)
CDECL(objc_msgSend_stret):
    MSGSEND a1 a2
