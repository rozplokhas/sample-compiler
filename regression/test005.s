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
	movl	var_x,	%eax
	movl	var_y,	%ebx
	addl	%ebx,	%eax
	movl	var_x,	%ebx
	movl	var_y,	%ecx
	subl	%ecx,	%ebx
	addl	%ebx,	%eax
	movl	var_x,	%ebx
	movl	var_y,	%ecx
	subl	%ecx,	%ebx
	movl	var_x,	%ecx
	movl	var_y,	%esi
	xchg	%eax,	%ecx
	cdq
	idiv	%esi
	xchg	%eax,	%ecx
	subl	%ecx,	%ebx
	addl	%ebx,	%eax
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
