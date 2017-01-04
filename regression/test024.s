	.data
	.comm	var_n,	4,	4
	.text
	.globl	main
function_end:
	movl	%ebp,	%esp
	popl	%ebp
	ret
fun_fib:
	pushl	%ebp
	movl	%esp,	%ebp
	movl	8(%ebp),	%eax
	movl	$2,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setle	%al
	cmp	$0,	%eax
	jz	else0
	movl	$1,	%eax
	jmp	function_end
	jmp	fin0
else0:
	movl	8(%ebp),	%eax
	movl	$1,	%ebx
	subl	%ebx,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	fun_fib
	addl	$4,	%esp
	movl	8(%ebp),	%ebx
	movl	$2,	%ecx
	subl	%ecx,	%ebx
	movl	%eax,	-4(%esp)
	movl	%ebx,	-8(%esp)
	subl	$8,	%esp
	call	fun_fib
	movl	%eax,	%ebx
	addl	$4,	%esp
	popl	%eax
	addl	%ebx,	%eax
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
	call	fun_fib
	addl	$4,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	%ebp,	%esp
	popl	%ebp
	xorl	%eax,	%eax
	ret
