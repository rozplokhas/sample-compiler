	.data
	.comm	var_f,	4,	4
	.comm	var_n,	4,	4
	.text
	.globl	main
main:
	pushl	%ebp
	movl	%esp,	%ebp
	call	read
	movl	%eax,	var_n
	movl	$1,	%eax
	movl	%eax,	var_f
start0:
	movl	var_n,	%eax
	movl	$1,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setge	%al
	cmp	$0,	%eax
	jz	fin0
	movl	var_f,	%eax
	movl	var_n,	%ebx
	imull	%ebx,	%eax
	movl	%eax,	var_f
	movl	var_n,	%eax
	movl	$1,	%ebx
	subl	%ebx,	%eax
	movl	%eax,	var_n
	jmp	start0
fin0:
	movl	var_f,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	%ebp,	%esp
	popl	%ebp
	xorl	%eax,	%eax
	ret
