	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_main                   ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16             ; =16
	.cfi_def_cfa_offset 16
	str	wzr, [sp, #12]
	str	wzr, [sp, #8]		; a=0
LBB0_1:                                 ; =>This Inner Loop Header: Depth=1
	ldr	w8, [sp, #8]
	add	w8, w8, #1              ; =1
	str	w8, [sp, #8]
	ldr	w8, [sp, #8]
	cmp	w8, #10                 ; =10
	b.ne	LBB0_3
; %bb.2:
	b	LBB0_4
LBB0_3:                                 ;   in Loop: Header=BB0_1 Depth=1
	b	LBB0_1
LBB0_4:
	ldr	w8, [sp, #8]
	add	w8, w8, #3              ; =3
	str	w8, [sp, #8]
	ldr	w0, [sp, #12]
	add	sp, sp, #16             ; =16
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
