	.data
	.comm	var_x0,	4,	4
	.comm	var_x1,	4,	4
	.comm	var_y,	4,	4
	.text
	.globl	main
main:
	pushl	%ebp
	movl	%esp,	%ebp
	call	read
	movl	%eax,	var_x0
	call	read
	movl	%eax,	var_x1
	movl	$12,	%eax
	movl	%eax,	var_y
	movl	var_y,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	%ebp,	%esp
	popl	%ebp
	xorl	%eax,	%eax
	ret
