	.data
	.text
	.globl	main
main:
	pushl	%ebp
	movl	%esp,	%ebp
	subl	$12,	%esp
	movl	$1,	%eax
	movl	$2,	%ebx
	movl	$3,	%ecx
	movl	$4,	%esi
	movl	$5,	%edi
	movl	$6,	0(%esp)
	movl	$7,	4(%esp)
	movl	$8,	8(%esp)
	movl	4(%esp),	%edx
	imull	8(%esp),	%edx
	movl	%edx,	4(%esp)
	movl	0(%esp),	%edx
	imull	4(%esp),	%edx
	movl	%edx,	0(%esp)
	imull	0(%esp),	%edi
	imull	%edi,	%esi
	imull	%esi,	%ecx
	imull	%ecx,	%ebx
	imull	%ebx,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	%ebp,	%esp
	popl	%ebp
	xorl	%eax,	%eax
	ret
