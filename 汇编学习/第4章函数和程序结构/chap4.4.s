	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_main                   ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16             ; =16
	.cfi_def_cfa_offset 16
								; 在链接的过程中, 会将其他源代码中的a符号放入GOT表, 让a符号可以被全局访问到。
	str	wzr, [sp, #12]
	adrp	x8, _a@GOTPAGE      ; 通过GOT的方式来查找a
	ldr	x8, [x8, _a@GOTPAGEOFF]
	ldr	w9, [x8]
	add	w10, w9, #1             ; =1
	str	w10, [x8]
	mov	x0, x9

	add	sp, sp, #16             ; =16
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
