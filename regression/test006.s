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
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setl	%al
	movl	%eax,	var_z
	movl	var_z,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	var_x,	%eax
	movl	var_y,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setle	%al
	movl	%eax,	var_z
	movl	var_z,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	var_x,	%eax
	movl	var_y,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	sete	%al
	movl	%eax,	var_z
	movl	var_z,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	var_x,	%eax
	movl	var_y,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setne	%al
	movl	%eax,	var_z
	movl	var_z,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	var_x,	%eax
	movl	var_y,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setge	%al
	movl	%eax,	var_z
	movl	var_z,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	var_x,	%eax
	movl	var_y,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setg	%al
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
