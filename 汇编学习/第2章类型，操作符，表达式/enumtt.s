	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_main                   ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	// 开辟空间16byte
	sub	sp, sp, #16             ; =16
	.cfi_def_cfa_offset 16
	mov	w8, #40					; w8=40
	str	w8, [sp, #12]			; 取出w8存入sp+12
	add	sp, sp, #16             ; =16
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
