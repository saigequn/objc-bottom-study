	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_main                   ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16             ; =16
	.cfi_def_cfa_offset 16

	ldr	w8, [sp, #12]	; 取出sp+12的值，存入w8 	取出a
	ldr	w9, [sp, #8]	; 取出sp+8的值，存入w9 	取出b
	ldr	w10, [sp, #4]	; 取出sp+4的值，存入w10 	取出c
	and	w9, w9, w10  	; w9 = w9 and w10    b=b&c
	orr	w8, w8, w9 		; w8 = s8 or w9  	 a=a|b
	str	w8, [sp, #12]

	add	sp, sp, #16             ; =16
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
