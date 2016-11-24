	.data
	.comm	var_x,	4,	4
	.text
	.globl	main
main:
	pushl	%ebp
	movl	%esp,	%ebp
	movl	$0,	%eax
	movl	%eax,	var_x
	movl	var_x,	%eax
	cmp	$0,	%eax
	jz	else0
	movl	$1,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	jmp	fin0
else0:
	movl	$2,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
fin0:
	movl	%ebp,	%esp
	popl	%ebp
	xorl	%eax,	%eax
	ret
