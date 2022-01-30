.macro MSGSEND receiver, sel
    .cfi_startproc
0: #check nil or small object

    beqz \receiver, 4f
    # extract bitfield from \receiver at position zero to lenght of SMALLOBJ_BITS
    xori t0, \receiver, SMALLOBJ_MASK #instead of using SMALLOBJ_BITS
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
