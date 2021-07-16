	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_swap                   ; -- Begin function swap
	.p2align	2
_swap:                                  ; @swap
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32             ; =32
	.cfi_def_cfa_offset 32
	str	x0, [sp, #24]	; x0写入内存sp+24Byte 	变量`a`
	str	x1, [sp, #16]	; x1写入内存sp+16Byte 	变量`b`
	ldr	x8, [sp, #24]	; sp+24写入w8 
	ldr	w9, [x8]		; x8写入w9 
	str	w9, [sp, #12]	; w9写入内存sp+12Byte
	ldr	x8, [sp, #16]	; sp+16写入x8 
	ldr	w9, [x8]		; x8写入w9 
	ldr	x8, [sp, #24]	; sp+24写入x8 
	str	w9, [x8]		; x8写入w9 
	ldr	w9, [sp, #12]	; sp+12写入w9
	ldr	x8, [sp, #16]	; sp+16写入x8
	str	w9, [x8]		; x8写入w9 
	add	sp, sp, #32             ; =32
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

	mov	w8, #0
	stur	wzr, [x29, #-4]
	add	x0, sp, #8              ; =8
	mov	w9, #1 			; w9=1 变量a
	str	w9, [sp, #8]
	add	x1, sp, #4              ; =4
	mov	w9, #2 			; w9=2 变量b
	str	w9, [sp, #4]
	str	w8, [sp]                ; 4-byte Folded Spill
	bl	_swap
	ldr	w0, [sp]                ; 4-byte Folded Reload
	
	ldp	x29, x30, [sp, #16]     ; 16-byte Folded Reload
	add	sp, sp, #32             ; =32
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
