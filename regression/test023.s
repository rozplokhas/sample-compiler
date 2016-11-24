	.data
	.comm	var_n,	4,	4
	.comm	var_s,	4,	4
	.text
	.globl	main
main:
	pushl	%ebp
	movl	%esp,	%ebp
	movl	$0,	%eax
	movl	%eax,	var_s
start0:
	call	read
	movl	%eax,	var_n
	movl	var_s,	%eax
	movl	var_n,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	var_s
	movl	var_n,	%eax
	movl	$0,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	sete	%al
	cmp	$0,	%eax
	jz	start0
	movl	var_s,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	%ebp,	%esp
	popl	%ebp
	xorl	%eax,	%eax
	ret
