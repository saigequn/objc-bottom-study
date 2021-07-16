	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_add                    ; -- Begin function add
	.p2align	2
_add:                                   ; @add
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #80             ; =80
	.cfi_def_cfa_offset 80
	ldr	x8, [sp, #80]
	ldr	x9, [sp, #88]
	str	d0, [sp, #72]
	str	d1, [sp, #64]
	str	d2, [sp, #56]
	str	d3, [sp, #48]
	str	d4, [sp, #40]
	str	d5, [sp, #32]
	str	d6, [sp, #24]
	str	d7, [sp, #16]
	str	x8, [sp, #8]
	str	x9, [sp]
	ldr	d0, [sp, #72]
	ldr	d1, [sp, #64]
	fadd	d0, d0, d1
	ldr	d1, [sp, #56]
	fadd	d0, d0, d1
	ldr	d1, [sp, #48]
	fadd	d0, d0, d1
	ldr	d1, [sp, #40]
	fadd	d0, d0, d1
	ldr	d1, [sp, #32]
	fadd	d0, d0, d1
	ldr	d1, [sp, #24]
	fadd	d0, d0, d1
	ldr	d1, [sp, #16]
	fadd	d0, d0, d1
	ldr	d1, [sp, #8]
	fadd	d0, d0, d1
	ldr	d1, [sp]
	fadd	d0, d0, d1
	add	sp, sp, #80             ; =80
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_main                   ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48             ; =48
	stp	x29, x30, [sp, #32]     ; 16-byte Folded Spill
	add	x29, sp, #32            ; =32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	wzr, [x29, #-4]
	stur	w0, [x29, #-8]
	str	x1, [sp, #16]
								; 从寄存器d0 - d7(浮点寄存器的64位)分别存放了第1至8个参数, 第9~10个参数放到了[sp]和[sp, #8]也就是栈里, 而返回值则存在寄存器d0中。
	fmov	d0, #1.00000000
	fmov	d1, #2.00000000
	fmov	d2, #3.00000000
	fmov	d3, #4.00000000
	fmov	d4, #5.00000000
	fmov	d5, #6.00000000
	fmov	d6, #7.00000000
	fmov	d7, #8.00000000
	mov	x8, sp
	fmov	d16, #9.00000000
	str	d16, [x8]
	fmov	d16, #10.00000000
	str	d16, [x8, #8]
	bl	_add
	fcvtzs	w0, d0
	ldp	x29, x30, [sp, #32]     ; 16-byte Folded Reload
	add	sp, sp, #48             ; =48
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
