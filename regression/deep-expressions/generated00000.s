	.data
	.comm	var_x0,	4,	4
	.comm	var_x1,	4,	4
	.comm	var_x2,	4,	4
	.comm	var_x3,	4,	4
	.comm	var_y,	4,	4
	.text
	.globl	main
main:
	pushl	%ebp
	movl	%esp,	%ebp
	subl	$16,	%esp
	call	read
	movl	%eax,	var_x0
	call	read
	movl	%eax,	var_x1
	call	read
	movl	%eax,	var_x2
	call	read
	movl	%eax,	var_x3
	movl	var_x0,	%eax
	movl	var_x0,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setle	%al
	movl	var_x2,	%ebx
	movl	$362,	%ecx
	subl	%ecx,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setle	%al
	movl	$454,	%ebx
	movl	var_x2,	%ecx
	movl	%ebx,	%edx
	movl	%eax,	%ebx
	xorl	%eax,	%eax
	cmp	%ecx,	%edx
	setne	%al
	xchg	%eax,	%ebx
	movl	var_x2,	%ecx
	movl	$4,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	setg	%al
	xchg	%eax,	%ecx
	movl	%ebx,	%edx
	movl	%eax,	%ebx
	xorl	%eax,	%eax
	cmp	%ecx,	%edx
	setne	%al
	xchg	%eax,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setge	%al
	movl	$444,	%ebx
	movl	$724,	%ecx
	addl	%ecx,	%ebx
	movl	var_x3,	%ecx
	movl	var_x0,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	setne	%al
	xchg	%eax,	%ecx
	movl	%ebx,	%edx
	movl	%eax,	%ebx
	xorl	%eax,	%eax
	cmp	%ecx,	%edx
	setne	%al
	xchg	%eax,	%ebx
	movl	$83,	%ecx
	movl	var_x2,	%esi
	subl	%esi,	%ecx
	movl	$784,	%esi
	movl	$635,	%edi
	addl	%edi,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	setle	%al
	xchg	%eax,	%ecx
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
	movl	var_x1,	%ebx
	movl	var_x2,	%ecx
	movl	%ebx,	%edx
	movl	%eax,	%ebx
	xorl	%eax,	%eax
	cmp	%ecx,	%edx
	setge	%al
	xchg	%eax,	%ebx
	movl	$370,	%ecx
	movl	$720,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	setg	%al
	xchg	%eax,	%ecx
	movl	%ebx,	%edx
	movl	%eax,	%ebx
	xorl	%eax,	%eax
	cmp	%ecx,	%edx
	sete	%al
	xchg	%eax,	%ebx
	movl	var_x3,	%ecx
	movl	var_x2,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	setg	%al
	xchg	%eax,	%ecx
	movl	var_x1,	%esi
	movl	$869,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	setle	%al
	xchg	%eax,	%esi
	subl	%esi,	%ecx
	imull	%ecx,	%ebx
	movl	var_x2,	%ecx
	movl	var_x3,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	sete	%al
	xchg	%eax,	%ecx
	movl	$346,	%esi
	movl	$243,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	$0,	%edi
	setne	%al
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	andl	%edi,	%eax
	xchg	%eax,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	setne	%al
	xchg	%eax,	%ecx
	movl	var_x0,	%esi
	movl	var_x0,	%edi
	subl	%edi,	%esi
	movl	$154,	%edi
	movl	$430,	0(%esp)
	imull	0(%esp),	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	setle	%al
	xchg	%eax,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	orl	%esi,	%edx
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	xchg	%eax,	%ecx
	movl	%ebx,	%edx
	movl	%eax,	%ebx
	xorl	%eax,	%eax
	cmp	%ecx,	%edx
	setne	%al
	xchg	%eax,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setg	%al
	movl	$499,	%ebx
	movl	$143,	%ecx
	movl	%ebx,	%edx
	movl	%eax,	%ebx
	xorl	%eax,	%eax
	cmp	$0,	%ecx
	setne	%al
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	andl	%ecx,	%eax
	xchg	%eax,	%ebx
	movl	var_x0,	%ecx
	movl	$489,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	setg	%al
	xchg	%eax,	%ecx
	subl	%ecx,	%ebx
	movl	$162,	%ecx
	movl	$252,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	setne	%al
	xchg	%eax,	%ecx
	movl	var_x3,	%esi
	movl	$129,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	setl	%al
	xchg	%eax,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	sete	%al
	xchg	%eax,	%ecx
	subl	%ecx,	%ebx
	movl	$405,	%ecx
	movl	var_x2,	%esi
	addl	%esi,	%ecx
	movl	var_x0,	%esi
	movl	$568,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	setle	%al
	xchg	%eax,	%esi
	imull	%esi,	%ecx
	movl	$414,	%esi
	movl	var_x1,	%edi
	imull	%edi,	%esi
	movl	var_x1,	%edi
	movl	$613,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	setg	%al
	xchg	%eax,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	setne	%al
	xchg	%eax,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	setne	%al
	xchg	%eax,	%ecx
	movl	%ebx,	%edx
	movl	%eax,	%ebx
	xorl	%eax,	%eax
	cmp	%ecx,	%edx
	setge	%al
	xchg	%eax,	%ebx
	movl	var_x1,	%ecx
	movl	$129,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	setg	%al
	xchg	%eax,	%ecx
	movl	$561,	%esi
	movl	var_x1,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	setl	%al
	xchg	%eax,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	setle	%al
	xchg	%eax,	%ecx
	movl	$34,	%esi
	movl	$275,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	setg	%al
	xchg	%eax,	%esi
	movl	$813,	%edi
	movl	$557,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	sete	%al
	xchg	%eax,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	sete	%al
	xchg	%eax,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	orl	%esi,	%edx
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	xchg	%eax,	%ecx
	movl	$604,	%esi
	movl	var_x1,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	orl	%edi,	%edx
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	xchg	%eax,	%esi
	movl	var_x1,	%edi
	movl	$475,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	setl	%al
	xchg	%eax,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	sete	%al
	xchg	%eax,	%esi
	movl	var_x1,	%edi
	movl	var_x0,	%edx
	movl	%edx,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	sete	%al
	xchg	%eax,	%edi
	movl	$554,	0(%esp)
	movl	var_x1,	%edx
	movl	%edx,	4(%esp)
	movl	0(%esp),	%edx
	movl	%eax,	0(%esp)
	xorl	%eax,	%eax
	cmp	4(%esp),	%edx
	setne	%al
	xchg	%eax,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	setl	%al
	xchg	%eax,	%edi
	addl	%edi,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	setle	%al
	xchg	%eax,	%ecx
	imull	%ecx,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setne	%al
	movl	$602,	%ebx
	movl	var_x2,	%ecx
	movl	%ebx,	%edx
	movl	%eax,	%ebx
	orl	%ecx,	%edx
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	xchg	%eax,	%ebx
	movl	$270,	%ecx
	movl	var_x3,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	setg	%al
	xchg	%eax,	%ecx
	movl	%ebx,	%edx
	movl	%eax,	%ebx
	xorl	%eax,	%eax
	cmp	%ecx,	%edx
	sete	%al
	xchg	%eax,	%ebx
	movl	var_x2,	%ecx
	movl	$608,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	setl	%al
	xchg	%eax,	%ecx
	movl	var_x2,	%esi
	movl	var_x1,	%edi
	imull	%edi,	%esi
	subl	%esi,	%ecx
	imull	%ecx,	%ebx
	movl	$223,	%ecx
	movl	$65,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	orl	%esi,	%edx
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	xchg	%eax,	%ecx
	movl	var_x2,	%esi
	movl	var_x1,	%edi
	addl	%edi,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	setl	%al
	xchg	%eax,	%ecx
	movl	$865,	%esi
	movl	var_x0,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	setle	%al
	xchg	%eax,	%esi
	movl	$708,	%edi
	movl	$762,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	setl	%al
	xchg	%eax,	%edi
	subl	%edi,	%esi
	addl	%esi,	%ecx
	movl	%ebx,	%edx
	movl	%eax,	%ebx
	xorl	%eax,	%eax
	cmp	%ecx,	%edx
	setne	%al
	xchg	%eax,	%ebx
	movl	$794,	%ecx
	movl	$856,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	setne	%al
	xchg	%eax,	%ecx
	movl	var_x2,	%esi
	movl	$856,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	setg	%al
	xchg	%eax,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	setge	%al
	xchg	%eax,	%ecx
	movl	$107,	%esi
	movl	var_x2,	%edi
	imull	%edi,	%esi
	movl	$458,	%edi
	movl	var_x2,	%edx
	movl	%edx,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	$0,	0(%esp)
	setne	%al
	movl	%eax,	0(%esp)
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	andl	0(%esp),	%eax
	xchg	%eax,	%edi
	subl	%edi,	%esi
	subl	%esi,	%ecx
	movl	var_x1,	%esi
	movl	var_x3,	%edi
	addl	%edi,	%esi
	movl	$531,	%edi
	movl	var_x0,	%edx
	movl	%edx,	0(%esp)
	subl	0(%esp),	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	setge	%al
	xchg	%eax,	%esi
	movl	$230,	%edi
	movl	var_x0,	%edx
	movl	%edx,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	setl	%al
	xchg	%eax,	%edi
	movl	var_x2,	%edx
	movl	%edx,	0(%esp)
	movl	$617,	4(%esp)
	movl	0(%esp),	%edx
	movl	%eax,	0(%esp)
	orl	4(%esp),	%edx
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	xchg	%eax,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	setg	%al
	xchg	%eax,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	setl	%al
	xchg	%eax,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	$0,	%esi
	setne	%al
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	andl	%esi,	%eax
	xchg	%eax,	%ecx
	subl	%ecx,	%ebx
	movl	$402,	%ecx
	movl	$72,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	setne	%al
	xchg	%eax,	%ecx
	movl	var_x0,	%esi
	movl	var_x3,	%edi
	subl	%edi,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	sete	%al
	xchg	%eax,	%ecx
	movl	$585,	%esi
	movl	$329,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	orl	%edi,	%edx
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	xchg	%eax,	%esi
	movl	var_x3,	%edi
	movl	var_x1,	%edx
	movl	%edx,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	$0,	0(%esp)
	setne	%al
	movl	%eax,	0(%esp)
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	andl	0(%esp),	%eax
	xchg	%eax,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	setl	%al
	xchg	%eax,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	orl	%esi,	%edx
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	xchg	%eax,	%ecx
	movl	$527,	%esi
	movl	$426,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	$0,	%edi
	setne	%al
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	andl	%edi,	%eax
	xchg	%eax,	%esi
	movl	var_x3,	%edi
	movl	var_x1,	%edx
	movl	%edx,	0(%esp)
	addl	0(%esp),	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	setg	%al
	xchg	%eax,	%esi
	movl	var_x1,	%edi
	movl	var_x2,	%edx
	movl	%edx,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	setle	%al
	xchg	%eax,	%edi
	movl	var_x0,	%edx
	movl	%edx,	0(%esp)
	movl	$105,	4(%esp)
	movl	0(%esp),	%edx
	movl	%eax,	0(%esp)
	xorl	%eax,	%eax
	cmp	4(%esp),	%edx
	sete	%al
	xchg	%eax,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	setle	%al
	xchg	%eax,	%edi
	subl	%edi,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	setle	%al
	xchg	%eax,	%ecx
	movl	$173,	%esi
	movl	$843,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	setne	%al
	xchg	%eax,	%esi
	movl	$117,	%edi
	movl	var_x0,	%edx
	movl	%edx,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	setle	%al
	xchg	%eax,	%edi
	imull	%edi,	%esi
	movl	$734,	%edi
	movl	var_x3,	%edx
	movl	%edx,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	setg	%al
	xchg	%eax,	%edi
	movl	$849,	0(%esp)
	movl	var_x2,	%edx
	movl	%edx,	4(%esp)
	movl	4(%esp),	%edx
	subl	%edx,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	setne	%al
	xchg	%eax,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	setl	%al
	xchg	%eax,	%esi
	movl	$596,	%edi
	movl	$870,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	setle	%al
	xchg	%eax,	%edi
	movl	var_x2,	%edx
	movl	%edx,	0(%esp)
	movl	var_x0,	%edx
	movl	%edx,	4(%esp)
	movl	0(%esp),	%edx
	movl	%eax,	0(%esp)
	xorl	%eax,	%eax
	cmp	4(%esp),	%edx
	setl	%al
	xchg	%eax,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	setl	%al
	xchg	%eax,	%edi
	movl	var_x0,	%edx
	movl	%edx,	0(%esp)
	movl	var_x2,	%edx
	movl	%edx,	4(%esp)
	movl	0(%esp),	%edx
	movl	%eax,	0(%esp)
	xorl	%eax,	%eax
	cmp	4(%esp),	%edx
	sete	%al
	xchg	%eax,	0(%esp)
	movl	$401,	4(%esp)
	movl	var_x1,	%edx
	movl	%edx,	8(%esp)
	movl	4(%esp),	%edx
	movl	%eax,	4(%esp)
	xorl	%eax,	%eax
	cmp	8(%esp),	%edx
	setl	%al
	xchg	%eax,	4(%esp)
	movl	0(%esp),	%edx
	movl	%eax,	0(%esp)
	xorl	%eax,	%eax
	cmp	4(%esp),	%edx
	setg	%al
	xchg	%eax,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	setle	%al
	xchg	%eax,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	sete	%al
	xchg	%eax,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	setge	%al
	xchg	%eax,	%ecx
	movl	%ebx,	%edx
	movl	%eax,	%ebx
	xorl	%eax,	%eax
	cmp	%ecx,	%edx
	setl	%al
	xchg	%eax,	%ebx
	movl	%eax,	%edx
	orl	%ebx,	%edx
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	movl	var_x3,	%ebx
	movl	var_x0,	%ecx
	movl	%ebx,	%edx
	movl	%eax,	%ebx
	xorl	%eax,	%eax
	cmp	%ecx,	%edx
	setg	%al
	xchg	%eax,	%ebx
	movl	$409,	%ecx
	movl	var_x2,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	$0,	%esi
	setne	%al
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	andl	%esi,	%eax
	xchg	%eax,	%ecx
	movl	%ebx,	%edx
	movl	%eax,	%ebx
	xorl	%eax,	%eax
	cmp	%ecx,	%edx
	setge	%al
	xchg	%eax,	%ebx
	movl	var_x1,	%ecx
	movl	$13,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	setle	%al
	xchg	%eax,	%ecx
	movl	$299,	%esi
	movl	var_x0,	%edi
	subl	%edi,	%esi
	addl	%esi,	%ecx
	movl	%ebx,	%edx
	movl	%eax,	%ebx
	xorl	%eax,	%eax
	cmp	%ecx,	%edx
	setg	%al
	xchg	%eax,	%ebx
	movl	$366,	%ecx
	movl	var_x3,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	setne	%al
	xchg	%eax,	%ecx
	movl	$633,	%esi
	movl	var_x1,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	orl	%edi,	%edx
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	xchg	%eax,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	setle	%al
	xchg	%eax,	%ecx
	movl	$367,	%esi
	movl	$135,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	sete	%al
	xchg	%eax,	%esi
	movl	var_x0,	%edi
	movl	$334,	0(%esp)
	addl	0(%esp),	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	setge	%al
	xchg	%eax,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	setl	%al
	xchg	%eax,	%ecx
	movl	%ebx,	%edx
	movl	%eax,	%ebx
	xorl	%eax,	%eax
	cmp	%ecx,	%edx
	sete	%al
	xchg	%eax,	%ebx
	movl	var_x2,	%ecx
	movl	var_x1,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	$0,	%esi
	setne	%al
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	andl	%esi,	%eax
	xchg	%eax,	%ecx
	movl	$154,	%esi
	movl	$721,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	setg	%al
	xchg	%eax,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	setge	%al
	xchg	%eax,	%ecx
	movl	$569,	%esi
	movl	var_x1,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	orl	%edi,	%edx
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	xchg	%eax,	%esi
	movl	var_x2,	%edi
	movl	$47,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	setle	%al
	xchg	%eax,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	setg	%al
	xchg	%eax,	%esi
	imull	%esi,	%ecx
	movl	var_x2,	%esi
	movl	var_x2,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	setl	%al
	xchg	%eax,	%esi
	movl	$573,	%edi
	movl	var_x2,	%edx
	movl	%edx,	0(%esp)
	imull	0(%esp),	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	setge	%al
	xchg	%eax,	%esi
	movl	$465,	%edi
	movl	var_x2,	%edx
	movl	%edx,	0(%esp)
	subl	0(%esp),	%edi
	movl	$85,	0(%esp)
	movl	var_x3,	%edx
	movl	%edx,	4(%esp)
	movl	0(%esp),	%edx
	movl	%eax,	0(%esp)
	xorl	%eax,	%eax
	cmp	4(%esp),	%edx
	setge	%al
	xchg	%eax,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	setl	%al
	xchg	%eax,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	setne	%al
	xchg	%eax,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	setge	%al
	xchg	%eax,	%ecx
	movl	%ebx,	%edx
	movl	%eax,	%ebx
	xorl	%eax,	%eax
	cmp	%ecx,	%edx
	setg	%al
	xchg	%eax,	%ebx
	movl	$837,	%ecx
	movl	$77,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	setge	%al
	xchg	%eax,	%ecx
	movl	$100,	%esi
	movl	$886,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	setle	%al
	xchg	%eax,	%esi
	subl	%esi,	%ecx
	movl	$231,	%esi
	movl	var_x3,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	sete	%al
	xchg	%eax,	%esi
	movl	var_x1,	%edi
	movl	var_x3,	%edx
	movl	%edx,	0(%esp)
	imull	0(%esp),	%edi
	addl	%edi,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	setge	%al
	xchg	%eax,	%ecx
	movl	$705,	%esi
	movl	var_x0,	%edi
	imull	%edi,	%esi
	movl	$334,	%edi
	movl	var_x0,	%edx
	movl	%edx,	0(%esp)
	subl	0(%esp),	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	$0,	%edi
	setne	%al
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	andl	%edi,	%eax
	xchg	%eax,	%esi
	movl	var_x3,	%edi
	movl	var_x2,	%edx
	movl	%edx,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	sete	%al
	xchg	%eax,	%edi
	movl	var_x2,	%edx
	movl	%edx,	0(%esp)
	movl	$444,	4(%esp)
	movl	0(%esp),	%edx
	movl	%eax,	0(%esp)
	xorl	%eax,	%eax
	cmp	4(%esp),	%edx
	setl	%al
	xchg	%eax,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	$0,	0(%esp)
	setne	%al
	movl	%eax,	0(%esp)
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	andl	0(%esp),	%eax
	xchg	%eax,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	setge	%al
	xchg	%eax,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	setne	%al
	xchg	%eax,	%ecx
	movl	var_x0,	%esi
	movl	$68,	%edi
	imull	%edi,	%esi
	movl	var_x3,	%edi
	movl	$933,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	sete	%al
	xchg	%eax,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	setle	%al
	xchg	%eax,	%esi
	movl	$290,	%edi
	movl	$890,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	$0,	0(%esp)
	setne	%al
	movl	%eax,	0(%esp)
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	andl	0(%esp),	%eax
	xchg	%eax,	%edi
	movl	$338,	0(%esp)
	movl	$594,	4(%esp)
	movl	4(%esp),	%edx
	subl	%edx,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	sete	%al
	xchg	%eax,	%edi
	imull	%edi,	%esi
	movl	$455,	%edi
	movl	var_x1,	%edx
	movl	%edx,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	sete	%al
	xchg	%eax,	%edi
	movl	$523,	0(%esp)
	movl	var_x3,	%edx
	movl	%edx,	4(%esp)
	movl	0(%esp),	%edx
	movl	%eax,	0(%esp)
	xorl	%eax,	%eax
	cmp	4(%esp),	%edx
	setge	%al
	xchg	%eax,	0(%esp)
	addl	0(%esp),	%edi
	movl	var_x2,	%edx
	movl	%edx,	0(%esp)
	movl	var_x1,	%edx
	movl	%edx,	4(%esp)
	movl	0(%esp),	%edx
	movl	%eax,	0(%esp)
	xorl	%eax,	%eax
	cmp	4(%esp),	%edx
	setl	%al
	xchg	%eax,	0(%esp)
	movl	$778,	4(%esp)
	movl	var_x0,	%edx
	movl	%edx,	8(%esp)
	movl	8(%esp),	%edx
	subl	%edx,	4(%esp)
	movl	4(%esp),	%edx
	addl	%edx,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	setge	%al
	xchg	%eax,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	setg	%al
	xchg	%eax,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	setl	%al
	xchg	%eax,	%ecx
	movl	%ebx,	%edx
	movl	%eax,	%ebx
	xorl	%eax,	%eax
	cmp	%ecx,	%edx
	setle	%al
	xchg	%eax,	%ebx
	movl	$613,	%ecx
	movl	$273,	%esi
	addl	%esi,	%ecx
	movl	var_x0,	%esi
	movl	var_x0,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	orl	%edi,	%edx
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	xchg	%eax,	%esi
	imull	%esi,	%ecx
	movl	$630,	%esi
	movl	$983,	%edi
	addl	%edi,	%esi
	movl	$926,	%edi
	movl	$889,	0(%esp)
	subl	0(%esp),	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	setl	%al
	xchg	%eax,	%esi
	addl	%esi,	%ecx
	movl	$935,	%esi
	movl	$629,	%edi
	imull	%edi,	%esi
	movl	var_x2,	%edi
	movl	var_x0,	%edx
	movl	%edx,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	setl	%al
	xchg	%eax,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	setg	%al
	xchg	%eax,	%esi
	movl	var_x2,	%edi
	movl	$748,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	sete	%al
	xchg	%eax,	%edi
	movl	var_x3,	%edx
	movl	%edx,	0(%esp)
	movl	$557,	4(%esp)
	movl	0(%esp),	%edx
	imull	4(%esp),	%edx
	movl	%edx,	0(%esp)
	subl	0(%esp),	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	setg	%al
	xchg	%eax,	%esi
	imull	%esi,	%ecx
	movl	var_x1,	%esi
	movl	var_x1,	%edi
	subl	%edi,	%esi
	movl	$585,	%edi
	movl	var_x0,	%edx
	movl	%edx,	0(%esp)
	imull	0(%esp),	%edi
	imull	%edi,	%esi
	movl	var_x0,	%edi
	movl	$493,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	setl	%al
	xchg	%eax,	%edi
	movl	var_x0,	%edx
	movl	%edx,	0(%esp)
	movl	var_x3,	%edx
	movl	%edx,	4(%esp)
	movl	0(%esp),	%edx
	movl	%eax,	0(%esp)
	xorl	%eax,	%eax
	cmp	4(%esp),	%edx
	sete	%al
	xchg	%eax,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	orl	0(%esp),	%edx
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	xchg	%eax,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	setg	%al
	xchg	%eax,	%esi
	movl	$778,	%edi
	movl	$516,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	orl	0(%esp),	%edx
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	xchg	%eax,	%edi
	movl	var_x2,	%edx
	movl	%edx,	0(%esp)
	movl	$268,	4(%esp)
	movl	0(%esp),	%edx
	movl	%eax,	0(%esp)
	xorl	%eax,	%eax
	cmp	4(%esp),	%edx
	setne	%al
	xchg	%eax,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	sete	%al
	xchg	%eax,	%edi
	movl	$980,	0(%esp)
	movl	$6,	4(%esp)
	movl	4(%esp),	%edx
	subl	%edx,	0(%esp)
	movl	$478,	4(%esp)
	movl	var_x1,	%edx
	movl	%edx,	8(%esp)
	movl	4(%esp),	%edx
	movl	%eax,	4(%esp)
	xorl	%eax,	%eax
	cmp	8(%esp),	%edx
	setne	%al
	xchg	%eax,	4(%esp)
	movl	0(%esp),	%edx
	movl	%eax,	0(%esp)
	xorl	%eax,	%eax
	cmp	$0,	4(%esp)
	setne	%al
	movl	%eax,	4(%esp)
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	andl	4(%esp),	%eax
	xchg	%eax,	0(%esp)
	imull	0(%esp),	%edi
	imull	%edi,	%esi
	subl	%esi,	%ecx
	movl	$137,	%esi
	movl	var_x3,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	setge	%al
	xchg	%eax,	%esi
	movl	$449,	%edi
	movl	var_x3,	%edx
	movl	%edx,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	sete	%al
	xchg	%eax,	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	sete	%al
	xchg	%eax,	%esi
	movl	$720,	%edi
	movl	$598,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	setg	%al
	xchg	%eax,	%edi
	movl	var_x2,	%edx
	movl	%edx,	0(%esp)
	movl	var_x2,	%edx
	movl	%edx,	4(%esp)
	movl	4(%esp),	%edx
	addl	%edx,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	setg	%al
	xchg	%eax,	%edi
	addl	%edi,	%esi
	movl	$122,	%edi
	movl	var_x0,	%edx
	movl	%edx,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	setne	%al
	xchg	%eax,	%edi
	movl	var_x3,	%edx
	movl	%edx,	0(%esp)
	movl	$335,	4(%esp)
	movl	0(%esp),	%edx
	movl	%eax,	0(%esp)
	xorl	%eax,	%eax
	cmp	$0,	4(%esp)
	setne	%al
	movl	%eax,	4(%esp)
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	andl	4(%esp),	%eax
	xchg	%eax,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	setl	%al
	xchg	%eax,	%edi
	movl	$614,	0(%esp)
	movl	var_x2,	%edx
	movl	%edx,	4(%esp)
	movl	0(%esp),	%edx
	movl	%eax,	0(%esp)
	xorl	%eax,	%eax
	cmp	4(%esp),	%edx
	setg	%al
	xchg	%eax,	0(%esp)
	movl	$852,	4(%esp)
	movl	$174,	8(%esp)
	movl	4(%esp),	%edx
	movl	%eax,	4(%esp)
	xorl	%eax,	%eax
	cmp	$0,	8(%esp)
	setne	%al
	movl	%eax,	8(%esp)
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	andl	8(%esp),	%eax
	xchg	%eax,	4(%esp)
	movl	0(%esp),	%edx
	movl	%eax,	0(%esp)
	xorl	%eax,	%eax
	cmp	$0,	4(%esp)
	setne	%al
	movl	%eax,	4(%esp)
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	andl	4(%esp),	%eax
	xchg	%eax,	0(%esp)
	subl	0(%esp),	%edi
	movl	%esi,	%edx
	movl	%eax,	%esi
	xorl	%eax,	%eax
	cmp	%edi,	%edx
	setge	%al
	xchg	%eax,	%esi
	movl	$931,	%edi
	movl	$453,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	0(%esp),	%edx
	setle	%al
	xchg	%eax,	%edi
	movl	$950,	0(%esp)
	movl	var_x2,	%edx
	movl	%edx,	4(%esp)
	movl	0(%esp),	%edx
	movl	%eax,	0(%esp)
	xorl	%eax,	%eax
	cmp	4(%esp),	%edx
	setl	%al
	xchg	%eax,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	xorl	%eax,	%eax
	cmp	$0,	0(%esp)
	setne	%al
	movl	%eax,	0(%esp)
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	andl	0(%esp),	%eax
	xchg	%eax,	%edi
	movl	var_x3,	%edx
	movl	%edx,	0(%esp)
	movl	var_x0,	%edx
	movl	%edx,	4(%esp)
	movl	0(%esp),	%edx
	movl	%eax,	0(%esp)
	orl	4(%esp),	%edx
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	xchg	%eax,	0(%esp)
	movl	$247,	4(%esp)
	movl	$676,	8(%esp)
	movl	4(%esp),	%edx
	movl	%eax,	4(%esp)
	xorl	%eax,	%eax
	cmp	8(%esp),	%edx
	setge	%al
	xchg	%eax,	4(%esp)
	movl	4(%esp),	%edx
	subl	%edx,	0(%esp)
	addl	0(%esp),	%edi
	movl	var_x0,	%edx
	movl	%edx,	0(%esp)
	movl	$917,	4(%esp)
	movl	0(%esp),	%edx
	movl	%eax,	0(%esp)
	xorl	%eax,	%eax
	cmp	4(%esp),	%edx
	setne	%al
	xchg	%eax,	0(%esp)
	movl	$4,	4(%esp)
	movl	var_x1,	%edx
	movl	%edx,	8(%esp)
	movl	4(%esp),	%edx
	movl	%eax,	4(%esp)
	xorl	%eax,	%eax
	cmp	8(%esp),	%edx
	setne	%al
	xchg	%eax,	4(%esp)
	movl	0(%esp),	%edx
	movl	%eax,	0(%esp)
	xorl	%eax,	%eax
	cmp	4(%esp),	%edx
	setle	%al
	xchg	%eax,	0(%esp)
	movl	var_x3,	%edx
	movl	%edx,	4(%esp)
	movl	$924,	8(%esp)
	movl	4(%esp),	%edx
	imull	8(%esp),	%edx
	movl	%edx,	4(%esp)
	movl	var_x2,	%edx
	movl	%edx,	8(%esp)
	movl	var_x2,	%edx
	movl	%edx,	12(%esp)
	movl	8(%esp),	%edx
	movl	%eax,	8(%esp)
	xorl	%eax,	%eax
	cmp	12(%esp),	%edx
	setl	%al
	xchg	%eax,	8(%esp)
	movl	4(%esp),	%edx
	movl	%eax,	4(%esp)
	xorl	%eax,	%eax
	cmp	8(%esp),	%edx
	setg	%al
	xchg	%eax,	4(%esp)
	movl	0(%esp),	%edx
	movl	%eax,	0(%esp)
	xorl	%eax,	%eax
	cmp	4(%esp),	%edx
	setg	%al
	xchg	%eax,	0(%esp)
	movl	%edi,	%edx
	movl	%eax,	%edi
	orl	0(%esp),	%edx
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	xchg	%eax,	%edi
	imull	%edi,	%esi
	movl	%ecx,	%edx
	movl	%eax,	%ecx
	xorl	%eax,	%eax
	cmp	%esi,	%edx
	setle	%al
	xchg	%eax,	%ecx
	movl	%ebx,	%edx
	movl	%eax,	%ebx
	xorl	%eax,	%eax
	cmp	%ecx,	%edx
	sete	%al
	xchg	%eax,	%ebx
	movl	%eax,	%edx
	orl	%ebx,	%edx
	xorl	%eax,	%eax
	cmp	$0,	%edx
	setne	%al
	movl	%eax,	var_y
	movl	var_y,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	%ebp,	%esp
	popl	%ebp
	xorl	%eax,	%eax
	ret
