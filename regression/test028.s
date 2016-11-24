	.data
	.comm	var_S,	4,	4
	.comm	var_flag,	4,	4
	.comm	var_i,	4,	4
	.text
	.globl	main
main:
	pushl	%ebp
	movl	%esp,	%ebp
	movl	$100,	%eax
	movl	$97,	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	str_make
	addl	$8,	%esp
	movl	%eax,	var_S
	movl	$1,	%eax
	movl	%eax,	var_flag
	movl	$0,	%eax
	movl	%eax,	var_i
start0:
	movl	var_i,	%eax
	movl	var_S,	%ebx
	movl	%eax,	-4(%esp)
	movl	%ebx,	-8(%esp)
	subl	$8,	%esp
	call	str_len
	movl	%eax,	%ebx
	addl	$4,	%esp
	popl	%eax
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setl	%al
	movl	var_flag,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	$0,	%ebx
	setne	%al
	movl	%eax,	%ebx
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	andl	%ebx,	%eax
	cmp	$0,	%eax
	jz	fin0
	movl	var_S,	%eax
	movl	var_i,	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	str_get
	addl	$8,	%esp
	movl	$97,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	sete	%al
	movl	%eax,	var_flag
	movl	var_i,	%eax
	movl	$1,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	var_i
	jmp	start0
fin0:
	movl	var_flag,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	var_S,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	str_dup
	addl	$4,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	str_len
	addl	$4,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	%ebp,	%esp
	popl	%ebp
	xorl	%eax,	%eax
	ret
