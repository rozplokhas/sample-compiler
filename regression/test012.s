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
	movl	8(%esp),	%edx
	addl	%edx,	4(%esp)
	movl	4(%esp),	%edx
	addl	%edx,	0(%esp)
	addl	0(%esp),	%edi
	addl	%edi,	%esi
	addl	%esi,	%ecx
	addl	%ecx,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	%ebp,	%esp
	popl	%ebp
	xorl	%eax,	%eax
	ret
