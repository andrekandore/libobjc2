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

1:  # load dispatch table (t2) and its size (t3)...
    # depending on the result we can skip some steps

    ld      t2, DTABLE_OFFSET(t0)
    lw      t3, SHIFT_OFFSET(t2)

    # check if small selector size (2 bytes)
    li      t4, 8
    beq     t3, t4, 2f

    # check if small selector size (1 byte)
    beqz    t3, 3f

    ################################################
    # now we calculate pointer address of selector #
    ################################################

    # load byte 3 of dispatch table, shift left
    # by 3 add to dtable pointer, reload dtable
    srl    t4, t3, 16
    lbu    t4, t4
    slli   t4, t4, 3
    add    t4, t2, t4
    ld     t2, DATA_OFFSET(t4)

2:  # load byte 2 of dispatch table, shift left
    # by 3 add to dtable pointer, reload dtable
    srl    t4, t3, 8
    lbu    t4, t4
    slli   t4, t4, 3
    add    t4, t2, t4
    ld     t2, DATA_OFFSET(t4)

3:  # small byte 1 of dispatch table, shift left
    # by 3 add to dtable pointer, reload dtable
    lbu    t4, t3
    slli   t4, t4, 3
    add    t4, t2, t4
    ld     t2, DATA_OFFSET(t4)

    # slot was nil, jump to nil handler
    beqz   t2, 5f

    # load method from slot
    ld     t2, SLOT_OFFSET(t2)

    # jump to imp
    jr     t2

4:  # nil receiver, return all nil/zero
    ld          a0, zero
    ld          a1, zero
    fmv.s.x     fa0, zero
    fmv.s.x     fa1, zero
    jr          ra

5:  # search for imp (slow c path)

    # save all (8 int + 8 fp + ra)
    # registers to stack (17 * 8)
    addi    sp, sp, -136

    # save integer registers on stack
    sd      a0, 0(sp)
    sd      a1, 8(sp)
    sd      a2, 16(sp)
    sd      a3, 24(sp)
    sd      a4, 32(sp)
    sd      a5, 40(sp)
    sd      a6, 48(sp)
    sd      a7, 56(sp)

    # save fp registers on stack
    fsd      fa0, 64(sp)
    fsd      fa1, 72(sp)
    fsd      fa2, 80(sp)
    fsd      fa3, 88(sp)
    fsd      fa4, 96(sp)
    fsd      fa5, 104(sp)
    fsd      fa6, 112(sp)
    fsd      fa7, 120(sp)

    # save return address on stack
    sd      ra, 128(sp)

    # todo: prepare args on stack

    call    slowMsgLookup

6:  # small object
7:
8:
9:
.cfi_endproc
.endm

#.globl CDECL(objc_msgSend)
#TYPE_DIRECTIVE(CDECL(objc_msgSend), @function)

#.globl CDECL(objc_msgSend_fpret)
#TYPE_DIRECTIVE(CDECL(objc_msgSend_fpret), @function)

#CDECL(objc_msgSend_fpret):
#CDECL(objc_msgSend):
    #MSGSEND a0 a1

#.globl CDECL(objc_msgSend_stret)
#TYPE_DIRECTIVE(CDECL(objc_msgSend_stret), @function)
#CDECL(objc_msgSend_stret):
    #MSGSEND a1 a2

.globl main

.text
main:
    MSGSEND a0, a1
