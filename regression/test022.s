	.data
	.comm	var_fib,	4,	4
	.comm	var_fib_1,	4,	4
	.comm	var_fib_2,	4,	4
	.comm	var_i,	4,	4
	.comm	var_n,	4,	4
	.text
	.globl	main
main:
	pushl	%ebp
	movl	%esp,	%ebp
	call	read
	movl	%eax,	var_n
	movl	$1,	%eax
	movl	%eax,	var_fib_1
	movl	$1,	%eax
	movl	%eax,	var_fib_2
	movl	$1,	%eax
	movl	%eax,	var_fib
	movl	$2,	%eax
	movl	%eax,	var_i
start0:
	movl	var_i,	%eax
	movl	var_n,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setl	%al
	cmp	$0,	%eax
	jz	fin0
	movl	var_fib_1,	%eax
	movl	var_fib_2,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	var_fib
	movl	var_fib_1,	%eax
	movl	%eax,	var_fib_2
	movl	var_fib,	%eax
	movl	%eax,	var_fib_1
	movl	var_i,	%eax
	movl	$1,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	var_i
	jmp	start0
fin0:
	movl	var_fib,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	%ebp,	%esp
	popl	%ebp
	xorl	%eax,	%eax
	ret
