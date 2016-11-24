	.data
	.comm	var_x,	4,	4
	.comm	var_y,	4,	4
	.comm	var_z,	4,	4
	.text
	.globl	main
main:
	pushl	%ebp
	movl	%esp,	%ebp
	movl	$1,	%eax
	movl	%eax,	var_x
	movl	$2,	%eax
	movl	%eax,	var_y
	movl	var_x,	%eax
	movl	var_y,	%ebx
	subl	%ebx,	%eax
	movl	$3,	%ebx
	subl	%ebx,	%eax
	movl	%eax,	var_z
	movl	var_z,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	%ebp,	%esp
	popl	%ebp
	xorl	%eax,	%eax
	ret
