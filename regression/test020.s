	.data
	.comm	var_c,	4,	4
	.comm	var_f,	4,	4
	.comm	var_n,	4,	4
	.comm	var_p,	4,	4
	.comm	var_s,	4,	4
	.text
	.globl	main
main:
	pushl	%ebp
	movl	%esp,	%ebp
	movl	$0,	%eax
	movl	%eax,	var_s
	call	read
	movl	%eax,	var_n
	movl	$2,	%eax
	movl	%eax,	var_p
start0:
	movl	var_n,	%eax
	movl	$0,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setg	%al
	cmp	$0,	%eax
	jz	fin0
	movl	$2,	%eax
	movl	%eax,	var_c
	movl	$1,	%eax
	movl	%eax,	var_f
	movl	$2,	%eax
	movl	%eax,	var_c
start3:
	movl	var_c,	%eax
	movl	var_c,	%ebx
	imull	%ebx,	%eax
	movl	var_p,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setle	%al
	movl	var_f,	%ebx
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
	jz	fin3
	movl	var_p,	%eax
	movl	var_c,	%ebx
	cdq
	idiv	%ebx
	movl	%edx,	%eax
	movl	$0,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setne	%al
	movl	%eax,	var_f
	movl	var_c,	%eax
	movl	$1,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	var_c
	jmp	start3
fin3:
	movl	var_f,	%eax
	movl	$0,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setne	%al
	cmp	$0,	%eax
	jz	else1
	movl	var_n,	%eax
	movl	$1,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	sete	%al
	cmp	$0,	%eax
	jz	else2
	movl	var_p,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	jmp	fin2
else2:
fin2:
	movl	var_n,	%eax
	movl	$1,	%ebx
	subl	%ebx,	%eax
	movl	%eax,	var_n
	jmp	fin1
else1:
fin1:
	movl	var_p,	%eax
	movl	$1,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	var_p
	jmp	start0
fin0:
	movl	%ebp,	%esp
	popl	%ebp
	xorl	%eax,	%eax
	ret
