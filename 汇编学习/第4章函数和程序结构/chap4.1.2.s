	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_add                    ; -- Begin function add
	.p2align	2
_add:                                   ; @add
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16             ; =16
	.cfi_def_cfa_offset 16
	str	w0, [sp, #12]	; w0 写入 sp+12
	str	w1, [sp, #8]	; w1 写入 sp+8
	ldr	w8, [sp, #12]	; 取出sp+12 写入w8
	ldr	w9, [sp, #8]	; 取出sp+8 写入w9
	add	w0, w8, w9 		; w0=w8+w9
	add	sp, sp, #16     ; =16 释放空间
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_main                   ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32             ; =32
	stp	x29, x30, [sp, #16]     ; 16-byte Folded Spill
	add	x29, sp, #16            ; =16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	wzr, [x29, #-4]		; x29-4置0
	str	w0, [sp, #8]			; w0 写入 sp+8 
	str	x1, [sp]				; w1 写入 sp
	mov	w0, #1 					; 寄存器w0 = 1
	mov	w1, #2 					; 寄存器w1 = 2
	bl	_add	
	add	w0, w0, #1              ; =1  w0=w0+1
	ldp	x29, x30, [sp, #16]     ; 16-byte Folded Reload
	add	sp, sp, #32             ; =32
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
