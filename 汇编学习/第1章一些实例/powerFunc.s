	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_main                   ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
// 空间开辟：栈上开辟了32个byte的空间，16byte给局部变量
	sub	sp, sp, #32             ; =32
	stp	x29, x30, [sp, #16]     ; 16-byte Folded Spill
	add	x29, sp, #16            ; =16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16

	stur	wzr, [x29, #-4]		; x29-4置0
	mov	w0, #2 					; w0=2
	mov	w1, #1  				; w1=1
	bl	_power	 				; 调用 _power
	ldp	x29, x30, [sp, #16]     ; 16-byte Folded Reload
	add	sp, sp, #32             ; =32
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_power                  ; -- Begin function power
	.p2align	2

// power方法的两个参数2和1分别放入了w0和w1中(x0和x1)
_power:                                 ; @power
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16             ; =16 空间开辟：栈上开辟了16个byte的空间
	.cfi_def_cfa_offset 16
	str	w0, [sp, #12]			; w0写入内存sp+12Byte  
	str	w1, [sp, #8]			; w1写入内存sp+8Byte
	ldr	w0, [sp, #12]			; sp+12Byte写入w0,直接返回
	add	sp, sp, #16             ; =16 释放空间
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
