	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_f1                     ; -- Begin function f1
	.p2align	2
_f1:                                    ; @f1
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48             ; =48
	stp	x29, x30, [sp, #32]     ; 16-byte Folded Spill
	add	x29, sp, #32            ; =32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16

	adrp	x8, ___stack_chk_guard@GOTPAGE
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
	ldr	x8, [x8]
	stur	x8, [x29, #-8]   
	ldr	w9, [sp, #20]
	str	w9, [sp, #12]
	adrp	x8, ___stack_chk_guard@GOTPAGE
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
	ldr	x8, [x8]
	ldur	x10, [x29, #-8]
	cmp	x8, x10
	b.ne	LBB0_2
; %bb.1:
	ldp	x29, x30, [sp, #32]     ; 16-byte Folded Reload
	add	sp, sp, #48             ; =48
	ret
LBB0_2:
	bl	___stack_chk_fail
	.cfi_endproc
                                        ; -- End function

                                        
	.globl	_f2                     ; -- Begin function f2
	.p2align	2
_f2:                                    ; @f2
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48             ; =48
	stp	x29, x30, [sp, #32]     ; 16-byte Folded Spill
	add	x29, sp, #32            ; =32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16

	adrp	x8, ___stack_chk_guard@GOTPAGE
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
	ldr	x8, [x8]
	stur	x8, [x29, #-8]
	ldr	w9, [sp, #20]
	str	w9, [sp, #12]
	adrp	x8, ___stack_chk_guard@GOTPAGE
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
	ldr	x8, [x8]
	ldur	x10, [x29, #-8]
	cmp	x8, x10
	b.ne	LBB1_2
; %bb.1:
	ldp	x29, x30, [sp, #32]     ; 16-byte Folded Reload
	add	sp, sp, #48             ; =48
	ret
LBB1_2:
	bl	___stack_chk_fail
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
