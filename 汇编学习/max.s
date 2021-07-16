	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_max                    ; -- Begin function max
	.p2align	2
_max:                                   ; @max
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16             ; =16
	.cfi_def_cfa_offset 16
	str	w0, [sp, #8]	// w0(变量a)写入内存sp+8Byte
	str	w1, [sp, #4]	// w1(变量b)写入sp+4Byte
	ldr	w8, [sp, #8]	// sp+8写入w8 
	ldr	w9, [sp, #4]	// sp+4写入w9
	cmp	w8, w9 			// 比较w8、w9
	b.lt	LBB0_2
; %bb.1:
	ldr	w8, [sp, #8]	// sp+8(变量a)写入w8 
	str	w8, [sp, #12]	// w8写入sp+12Byte
	b	LBB0_3			// 跳转到LBB0_3
LBB0_2:
	ldr	w8, [sp, #4]	// sp+4(变量a)写入w8 
	str	w8, [sp, #12]	// w8写入sp+12Byte
LBB0_3:
	ldr	w0, [sp, #12]	// sp+12写入w0，作为返回值
	add	sp, sp, #16             ; =16  释放栈内存
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_main                   ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	// 方法头
	sub	sp, sp, #48             ; =48
	stp	x29, x30, [sp, #32]     ; 16-byte Folded Spill
	add	x29, sp, #32            ; =32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	
	mov	w8, #0    				// w8存入0
	stur	wzr, [x29, #-4]		// FP-4处的内存值置为0
	mov	w9, #10  				// 10(变量a)写入w9
	stur	w9, [x29, #-8]		// w9(变量a)写入内存FP-8
	mov	w9, #20     			// 20(变量b)写入w9
	stur	w9, [x29, #-12]		// w9(变量b)写入内存FP-12
	ldur	w0, [x29, #-8]		// FP-8写入w0
	ldur	w1, [x29, #-12]		// FP-12写入w1
	str	w8, [sp, #12]           ; 4-byte Folded Spill
	bl	_max					// 调用max
	str	w0, [sp, #16]
	ldr	w0, [sp, #12]           ; 4-byte Folded Reload
	
	// 方法尾
	ldp	x29, x30, [sp, #32]     ; 16-byte Folded Reload
	add	sp, sp, #48             ; =48
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
