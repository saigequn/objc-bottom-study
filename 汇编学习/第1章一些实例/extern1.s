	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_main                   ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!   ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16

	adrp	x8, _line@GOTPAGE
	ldr	x8, [x8, _line@GOTPAGEOFF]
	mov	w9, #97				; w9=97('a')
	strb	w9, [x8]
	bl	_copy
	mov	w9, #0
	mov	x0, x9

	ldp	x29, x30, [sp], #16     ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.comm	_line,1000,0            ; @line
	
.subsections_via_symbols
