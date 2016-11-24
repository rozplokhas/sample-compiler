	.data
	.text
	.globl	main
function_end:
	movl	%ebp,	%esp
	popl	%ebp
	ret
fun_f:
	pushl	%ebp
	movl	%esp,	%ebp
	subl	$4,	%esp
	movl	8(%ebp),	%eax
	movl	$1,	%ebx
	addl	%ebx,	%eax
	movl	$2,	%ebx
	addl	%ebx,	%eax
	movl	$3,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	-4(%ebp)
	movl	8(%ebp),	%eax
	movl	-4(%ebp),	%ebx
	addl	%ebx,	%eax
	movl	$4,	%ebx
	addl	%ebx,	%eax
	movl	$5,	%ebx
	addl	%ebx,	%eax
	movl	$6,	%ebx
	addl	%ebx,	%eax
	movl	$7,	%ebx
	movl	$8,	%ecx
	addl	%ecx,	%ebx
	movl	$9,	%ecx
	addl	%ecx,	%ebx
	movl	$10,	%ecx
	addl	%ecx,	%ebx
	movl	$11,	%ecx
	addl	%ecx,	%ebx
	addl	%ebx,	%eax
	jmp	function_end
main:
	pushl	%ebp
	movl	%esp,	%ebp
	movl	$1,	%eax
	movl	$2,	%ebx
	imull	%ebx,	%eax
	movl	$3,	%ebx
	imull	%ebx,	%eax
	movl	$0,	%ebx
	movl	%eax,	-4(%esp)
	movl	%ebx,	-8(%esp)
	subl	$8,	%esp
	call	fun_f
	movl	%eax,	%ebx
	addl	$4,	%esp
	popl	%eax
	imull	%ebx,	%eax
	movl	$1,	%ebx
	movl	$2,	%ecx
	addl	%ecx,	%ebx
	movl	$1,	%ecx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	movl	%ecx,	-12(%esp)
	subl	$12,	%esp
	call	fun_f
	movl	%eax,	%ecx
	addl	$4,	%esp
	popl	%eax
	popl	%ebx
	addl	%ecx,	%ebx
	imull	%ebx,	%eax
	movl	$1,	%ebx
	movl	$2,	%ecx
	addl	%ecx,	%ebx
	movl	$3,	%ecx
	addl	%ecx,	%ebx
	movl	$2,	%ecx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	movl	%ecx,	-12(%esp)
	subl	$12,	%esp
	call	fun_f
	movl	%eax,	%ecx
	addl	$4,	%esp
	popl	%eax
	popl	%ebx
	addl	%ecx,	%ebx
	imull	%ebx,	%eax
	movl	$4,	%ebx
	imull	%ebx,	%eax
	movl	$5,	%ebx
	imull	%ebx,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	%ebp,	%esp
	popl	%ebp
	xorl	%eax,	%eax
	ret
