	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_makePoint              ; -- Begin function makePoint
	.p2align	2
_makePoint:                     ; @makePoint
	.cfi_startproc
; %bb.0:
// 方法头
	sub	sp, sp, #16             ; =16 分配16Byte内存
	.cfi_def_cfa_offset 16
	str	s0, [sp, #4]			; s0(变量x)写入内存sp+4Byte
	str	s1, [sp]				; s1(变量y)写入内存sp
	ldr	w8, [sp, #4]			; sp+4写入w8 
	str	w8, [sp, #8]			; w8写入sp+8
	ldr	w8, [sp]				; sp写入w8 
	str	w8, [sp, #12]			; w8写入sp+12
	ldr	s0, [sp, #8]			; sp+8写入s0
	ldr	s1, [sp, #12]			; sp+12写入s1
// 方法尾
	add	sp, sp, #16             ; =16 释放内存
	ret
	.cfi_endproc
                                ; -- End function

	.globl	_logPoint           ; -- Begin function logPoint
	.p2align	2
_logPoint:                      ; @logPoint
	.cfi_startproc
; %bb.0:
// 方法头
	sub	sp, sp, #48             ; =48
	stp	x29, x30, [sp, #32]     ; 16-byte Folded Spill
	add	x29, sp, #32            ; =32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16

	stur	s0, [x29, #-8]		; s0(变量point.x)写入内存FP-8
	stur	s1, [x29, #-4]		; s1(变量point.y)写入内存FP-4
	ldur	s0, [x29, #-8]		; FP-8写入s0
	fcvt	d2, s0   			; s0(point.x)写入d2(同时进行浮点数精确度转换)
	ldur	s0, [x29, #-4]		; FP-4写入s0
	fcvt	d3, s0				; s0(point.x)写入d3
	adrp	x0, l_.str@PAGE  	; 这两行作用是找到字符串所在内存地址
	add	x0, x0, l_.str@PAGEOFF
	mov	x8, sp   				; sp写入x8
	str	d2, [x8]				; (point.x) 写入sp+8Byte
	str	d3, [x8, #8]			; (point.y) 写入sp
	bl	_printf					; 打印
// 方法尾
	ldp	x29, x30, [sp, #32]     ; 16-byte Folded Reload
	add	sp, sp, #48             ; =48
	ret
	.cfi_endproc
                                ; -- End function

	.globl	_main               ; -- Begin function main
	.p2align	2
_main:                          ; @main
	.cfi_startproc
; %bb.0:
// 方法头
	sub	sp, sp, #32             ; =32
	stp	x29, x30, [sp, #16]     ; 16-byte Folded Spill
	add	x29, sp, #16            ; =16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	
	mov	w8, #0     				; // w8存入0
	stur	wzr, [x29, #-4] 	; // FP-4处的内存值置为0
	fmov	s0, #1.50000000		; s0处写入1.5
	mov	w9, #13107				; 
	movk	w9, #16403, lsl #16 ; 浮点数2.3存入w9
	fmov	s1, w9    			; w9存入s1
	str	w8, [sp]                ; 4-byte Folded Spill w8写入内存sp
	bl	_makePoint				; 调转到 _makePoint
	str	s0, [sp, #4]			; s0写入内存sp+4Byte
	str	s1, [sp, #8]			; s1写入内存sp+8Byte
	ldr	s0, [sp, #4]			; sp+4写入s0 
	ldr	s1, [sp, #8]			; sp+8写入s1 
	bl	_logPoint				; 调转到 _logPoint
	ldr	w0, [sp]                ; 4-byte Folded Reload  sp写入s0
// 方法尾
	ldp	x29, x30, [sp, #16]     ; 16-byte Folded Reload
	add	sp, sp, #32             ; =32
	ret
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"(%.2f, %.2f)"

.subsections_via_symbols
