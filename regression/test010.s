	.data
	.comm	var_k,	4,	4
	.comm	var_n,	4,	4
	.comm	var_res,	4,	4
	.text
	.globl	main
main:
	pushl	%ebp
	movl	%esp,	%ebp
	movl	$2,	%eax
	movl	%eax,	var_n
	movl	$10,	%eax
	movl	%eax,	var_k
	movl	$1,	%eax
	movl	%eax,	var_res
start0:
	movl	var_k,	%eax
	movl	$0,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setg	%al
	cmp	$0,	%eax
	jz	fin0
	movl	var_res,	%eax
	movl	var_n,	%ebx
	imull	%ebx,	%eax
	movl	%eax,	var_res
	movl	var_k,	%eax
	movl	$1,	%ebx
	subl	%ebx,	%eax
	movl	%eax,	var_k
	jmp	start0
fin0:
	movl	var_res,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	%ebp,	%esp
	popl	%ebp
	xorl	%eax,	%eax
	ret
