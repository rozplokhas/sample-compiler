	.data
	.comm	var_x,	4,	4
	.comm	var_y,	4,	4
	.comm	var_z,	4,	4
	.text
	.globl	main
main:
	pushl	%ebp
	movl	%esp,	%ebp
	call	read
	movl	%eax,	var_x
	call	read
	movl	%eax,	var_y
	movl	var_y,	%eax
	movl	var_y,	%ebx
	imull	%ebx,	%eax
	movl	%eax,	var_z
	movl	var_x,	%eax
	movl	var_z,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	%ebp,	%esp
	popl	%ebp
	xorl	%eax,	%eax
	ret
