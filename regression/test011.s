	.data
	.comm	var_a,	4,	4
	.comm	var_b,	4,	4
	.comm	var_x,	4,	4
	.text
	.globl	main
function_end:
	movl	%ebp,	%esp
	popl	%ebp
	ret
fun_a:
	pushl	%ebp
	movl	%esp,	%ebp
	movl	8(%ebp),	%eax
	movl	12(%ebp),	%ebx
	addl	%ebx,	%eax
	jmp	function_end
fun_b:
	pushl	%ebp
	movl	%esp,	%ebp
	movl	$5,	%eax
	movl	%eax,	8(%ebp)
	movl	8(%ebp),	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	8(%ebp),	%eax
	jmp	function_end
main:
	pushl	%ebp
	movl	%esp,	%ebp
	movl	$2,	%eax
	movl	%eax,	var_x
	movl	var_x,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	fun_b
	addl	$4,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	$1,	%eax
	movl	%eax,	var_a
	movl	$2,	%eax
	movl	%eax,	var_b
	movl	var_a,	%eax
	movl	var_b,	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	fun_a
	addl	$8,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	%ebp,	%esp
	popl	%ebp
	xorl	%eax,	%eax
	ret
