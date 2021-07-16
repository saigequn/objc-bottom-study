	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_copy                   ; -- Begin function copy
	.p2align	2
_copy:                                  ; @copy
	.cfi_startproc
; %bb.0:
	adrp	x8, _line@GOTPAGE
	ldr	x8, [x8, _line@GOTPAGEOFF]
	ldrb	w9, [x8]
	strb	w9, [x8, #1]
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
