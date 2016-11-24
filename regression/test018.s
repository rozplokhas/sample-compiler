	.data
	.comm	var_c,	4,	4
	.comm	var_cc,	4,	4
	.comm	var_d,	4,	4
	.comm	var_i,	4,	4
	.comm	var_m,	4,	4
	.comm	var_n,	4,	4
	.comm	var_p,	4,	4
	.comm	var_q,	4,	4
	.text
	.globl	main
main:
	pushl	%ebp
	movl	%esp,	%ebp
	call	read
	movl	%eax,	var_n
	movl	$1,	%eax
	movl	%eax,	var_c
	movl	$2,	%eax
	movl	%eax,	var_p
start0:
	movl	var_c,	%eax
	cmp	$0,	%eax
	jz	fin0
	movl	$1,	%eax
	movl	%eax,	var_cc
start3:
	movl	var_cc,	%eax
	cmp	$0,	%eax
	jz	fin3
	movl	$2,	%eax
	movl	%eax,	var_q
start5:
	movl	var_q,	%eax
	movl	var_q,	%ebx
	imull	%ebx,	%eax
	movl	var_p,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setle	%al
	movl	var_cc,	%ebx
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
	jz	fin5
	movl	var_p,	%eax
	movl	var_q,	%ebx
	cdq
	idiv	%ebx
	movl	%edx,	%eax
	movl	$0,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setne	%al
	movl	%eax,	var_cc
	movl	var_q,	%eax
	movl	$1,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	var_q
	jmp	start5
fin5:
	movl	var_cc,	%eax
	cmp	$0,	%eax
	jz	else4
	movl	$0,	%eax
	movl	%eax,	var_cc
	jmp	fin4
else4:
	movl	var_p,	%eax
	movl	$1,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	var_p
	movl	$1,	%eax
	movl	%eax,	var_cc
fin4:
	jmp	start3
fin3:
	movl	var_p,	%eax
	movl	%eax,	var_d
	movl	$0,	%eax
	movl	%eax,	var_i
	movl	var_n,	%eax
	movl	var_d,	%ebx
	cdq
	idiv	%ebx
	movl	%eax,	var_q
	movl	var_n,	%eax
	movl	var_d,	%ebx
	cdq
	idiv	%ebx
	movl	%edx,	%eax
	movl	%eax,	var_m
start1:
	movl	var_q,	%eax
	movl	$0,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setg	%al
	movl	var_m,	%ebx
	movl	$0,	%ecx
	movl	%ebx,	%edx
	movl	%eax,	%ebx
	xorl	%eax,	%eax
	cmp	%ecx,	%edx
	sete	%al
	xchg	%eax,	%ebx
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
	jz	fin1
	movl	var_i,	%eax
	movl	$1,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	var_i
	movl	var_d,	%eax
	movl	var_p,	%ebx
	imull	%ebx,	%eax
	movl	%eax,	var_d
	movl	var_n,	%eax
	movl	var_d,	%ebx
	cdq
	idiv	%ebx
	movl	%edx,	%eax
	movl	%eax,	var_m
	movl	var_m,	%eax
	movl	$0,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	sete	%al
	cmp	$0,	%eax
	jz	else2
	movl	var_n,	%eax
	movl	var_d,	%ebx
	cdq
	idiv	%ebx
	movl	%eax,	var_q
	jmp	fin2
else2:
fin2:
	jmp	start1
fin1:
	movl	var_p,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	var_i,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	var_n,	%eax
	movl	var_d,	%ebx
	movl	var_p,	%ecx
	xchg	%eax,	%ebx
	cdq
	idiv	%ecx
	xchg	%eax,	%ebx
	cdq
	idiv	%ebx
	movl	%eax,	var_n
	movl	var_p,	%eax
	movl	$1,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	var_p
	movl	var_n,	%eax
	movl	$1,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setne	%al
	movl	%eax,	var_c
	jmp	start0
fin0:
	movl	%ebp,	%esp
	popl	%ebp
	xorl	%eax,	%eax
	ret
