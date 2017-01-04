	.data
	.comm	var_z,	4,	4
	.text
	.globl	main
main:
	pushl	%ebp
	movl	%esp,	%ebp
	movl	$0,	%eax
	movl	$1,	%ebx
	subl	%ebx,	%eax
	movl	$2,	%ebx
	subl	%ebx,	%eax
	movl	$3,	%ebx
	subl	%ebx,	%eax
	movl	$4,	%ebx
	subl	%ebx,	%eax
	movl	$5,	%ebx
	subl	%ebx,	%eax
	movl	$6,	%ebx
	subl	%ebx,	%eax
	movl	$7,	%ebx
	subl	%ebx,	%eax
	movl	$8,	%ebx
	subl	%ebx,	%eax
	movl	$9,	%ebx
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
