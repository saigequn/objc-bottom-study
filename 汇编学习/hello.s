	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_hello_word             ; -- Begin function hello_word
	.p2align	2
_hello_word:                    ; @hello_word
	.cfi_startproc
; %bb.0:
	// 方法头
	sub	sp, sp, #16             ; =16
	.cfi_def_cfa_offset 16

	str	x0, [sp, #8]			; x0写入sp+8
	ldr	x8, [sp, #8]			; sp+8写入x8
	mov	w9, #10       			; 10写入w9
	str	w9, [x8]				; w9写入内存x8中

	// 方法尾
	add	sp, sp, #16             ; =16  释放栈内存
	ret							; 返回
	.cfi_endproc
                                    ; -- End function
	.globl	_main                   ; -- Begin function main
	.p2align	2
_main:                               ; @main
	.cfi_startproc
; %bb.0:
	// 方法头
	sub	sp, sp, #64             ; =64
	stp	x29, x30, [sp, #48]     ; 16-byte Folded Spill
	add	x29, sp, #48            ; =48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16

	mov	w8, #0    				; w8存入0
	stur	wzr, [x29, #-4]		; wzr写入内存FP-4
	ldur	x0, [x29, #-16]		; x0写入内存FP-16
	stur	w8, [x29, #-20]     ; 4-byte Folded Spill  w8写入内存FP-20
	bl	_hello_word				; 调用_hello_word函数
	ldur	x9, [x29, #-16]		; FP-16写入x9
	ldr	w8, [x9]				; x9写入w8
                                ; implicit-def: $x0
	mov	x0, x8  				; x0存入x8
	adrp	x9, l_.str@PAGE
	add	x9, x9, l_.str@PAGEOFF
	str	x0, [sp, #16]           ; 8-byte Folded Spill x0写入sp+16
	mov	x0, x9   				; x0存入x9
	mov	x9, sp 					; x9存入sp
	ldr	x10, [sp, #16]          ; 8-byte Folded Reload sp+16写入x10
	str	x10, [x9]				; x10的内容写入x9寄存器所在的地址
	bl	_printf					; 打印
	ldur	w8, [x29, #-20]     ; 4-byte Folded Reload
	mov	x0, x8
	ldp	x29, x30, [sp, #48]     ; 16-byte Folded Reload
	add	sp, sp, #64             ; =64
	ret
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"%d"

.subsections_via_symbols
