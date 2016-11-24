	.data
	.text
	.globl	main
function_end:
	movl	%ebp,	%esp
	popl	%ebp
	ret
fun_g:
	pushl	%ebp
	movl	%esp,	%ebp
	movl	8(%ebp),	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	12(%ebp),	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	16(%ebp),	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	20(%ebp),	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	20(%ebp),	%eax
	movl	$0,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	sete	%al
	cmp	$0,	%eax
	jz	else0
	movl	$4,	%eax
	movl	$5,	%ebx
	movl	$6,	%ecx
	movl	$7,	%esi
	movl	%esi,	-4(%esp)
	movl	%ecx,	-8(%esp)
	movl	%ebx,	-12(%esp)
	movl	%eax,	-16(%esp)
	subl	$16,	%esp
	call	fun_f
	addl	$16,	%esp
	jmp	fin0
else0:
fin0:
	movl	$0,	%eax
	jmp	function_end
fun_f:
	pushl	%ebp
	movl	%esp,	%ebp
	movl	20(%ebp),	%eax
	movl	8(%ebp),	%ebx
	movl	16(%ebp),	%ecx
	movl	12(%ebp),	%esi
	movl	%esi,	-4(%esp)
	movl	%ecx,	-8(%esp)
	movl	%ebx,	-12(%esp)
	movl	%eax,	-16(%esp)
	subl	$16,	%esp
	call	fun_g
	addl	$16,	%esp
	movl	20(%ebp),	%eax
	movl	16(%ebp),	%ebx
	movl	12(%ebp),	%ecx
	movl	8(%ebp),	%esi
	movl	%esi,	-4(%esp)
	movl	%ecx,	-8(%esp)
	movl	%ebx,	-12(%esp)
	movl	%eax,	-16(%esp)
	subl	$16,	%esp
	call	fun_g
	addl	$16,	%esp
	movl	$0,	%eax
	jmp	function_end
main:
	pushl	%ebp
	movl	%esp,	%ebp
	movl	$0,	%eax
	movl	$1,	%ebx
	movl	$2,	%ecx
	movl	$3,	%esi
	movl	%esi,	-4(%esp)
	movl	%ecx,	-8(%esp)
	movl	%ebx,	-12(%esp)
	movl	%eax,	-16(%esp)
	subl	$16,	%esp
	call	fun_f
	addl	$16,	%esp
	movl	$3,	%eax
	movl	$2,	%ebx
	movl	$1,	%ecx
	movl	$0,	%esi
	movl	%esi,	-4(%esp)
	movl	%ecx,	-8(%esp)
	movl	%ebx,	-12(%esp)
	movl	%eax,	-16(%esp)
	subl	$16,	%esp
	call	fun_f
	addl	$16,	%esp
	movl	%ebp,	%esp
	popl	%ebp
	xorl	%eax,	%eax
	ret
