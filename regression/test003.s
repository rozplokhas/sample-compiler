	.data
	.comm	var_x,	4,	4
	.comm	var_y,	4,	4
	.text
	.globl	main
main:
	pushl	%ebp
	movl	%esp,	%ebp
	call	read
	movl	%eax,	var_x
	call	read
	movl	%eax,	var_y
	movl	var_x,	%eax
	movl	var_y,	%ebx
	subl	%ebx,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	var_x,	%eax
	movl	var_y,	%ebx
	cdq
	idiv	%ebx
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	var_x,	%eax
	movl	var_y,	%ebx
	cdq
	idiv	%ebx
	movl	%edx,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	%ebp,	%esp
	popl	%ebp
	xorl	%eax,	%eax
	ret
