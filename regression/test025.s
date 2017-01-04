	.data
	.comm	var_n,	4,	4
	.text
	.globl	main
function_end:
	movl	%ebp,	%esp
	popl	%ebp
	ret
fun_fact:
	pushl	%ebp
	movl	%esp,	%ebp
	movl	8(%ebp),	%eax
	movl	$2,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setl	%al
	cmp	$0,	%eax
	jz	else0
	movl	$1,	%eax
	jmp	function_end
	jmp	fin0
else0:
	movl	8(%ebp),	%eax
	movl	8(%ebp),	%ebx
	movl	$1,	%ecx
	subl	%ecx,	%ebx
	movl	%eax,	-4(%esp)
	movl	%ebx,	-8(%esp)
	subl	$8,	%esp
	call	fun_fact
	movl	%eax,	%ebx
	addl	$4,	%esp
	popl	%eax
	imull	%ebx,	%eax
	jmp	function_end
fin0:
main:
	pushl	%ebp
	movl	%esp,	%ebp
	call	read
	movl	%eax,	var_n
	movl	var_n,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	fun_fact
	addl	$4,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	%ebp,	%esp
	popl	%ebp
	xorl	%eax,	%eax
	ret
