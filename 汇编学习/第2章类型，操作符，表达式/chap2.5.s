	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_main                   ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16             ; =16
	.cfi_def_cfa_offset 16

	mov	w8, #1  				; w8=1
	str	w8, [sp, #12]			; w8存入sp+12
	ldr	w8, [sp, #12] 			; 取出内存地址sp+12 存入w8
	add	w8, w8, #2              ; =2 	w8=w8+2
	str	w8, [sp, #12]			; w8存入sp+12

	add	sp, sp, #16             ; =16
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
