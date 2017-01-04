	.data
	.comm	var_i,	4,	4
	.comm	var_j,	4,	4
	.comm	var_s,	4,	4
	.text
	.globl	main
main:
	pushl	%ebp
	movl	%esp,	%ebp
	movl	$0,	%eax
	movl	%eax,	var_i
	movl	$0,	%eax
	movl	%eax,	var_s
start0:
	movl	var_i,	%eax
	movl	$100,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setl	%al
	cmp	$0,	%eax
	jz	fin0
	movl	$0,	%eax
	movl	%eax,	var_j
start1:
	movl	var_j,	%eax
	movl	$100,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setl	%al
	cmp	$0,	%eax
	jz	fin1
	movl	var_s,	%eax
	movl	var_j,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	var_s
	movl	var_j,	%eax
	movl	$1,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	var_j
	jmp	start1
fin1:
	movl	var_s,	%eax
	movl	var_i,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	var_s
	movl	var_i,	%eax
	movl	$1,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	var_i
	jmp	start0
fin0:
	movl	var_s,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	%ebp,	%esp
	popl	%ebp
	xorl	%eax,	%eax
	ret
