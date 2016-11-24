	.data
	.text
	.globl	main
function_end:
	movl	%ebp,	%esp
	popl	%ebp
	ret
fun_fac:
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
	call	fun_fac
	movl	%eax,	%ebx
	addl	$4,	%esp
	popl	%eax
	imull	%ebx,	%eax
	jmp	function_end
fin0:
fun_pow:
	pushl	%ebp
	movl	%esp,	%ebp
	subl	$8,	%esp
	movl	$0,	%eax
	movl	%eax,	-4(%ebp)
	movl	$1,	%eax
	movl	%eax,	-8(%ebp)
start1:
	movl	-4(%ebp),	%eax
	movl	12(%ebp),	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setl	%al
	cmp	$0,	%eax
	jz	fin1
	movl	-8(%ebp),	%eax
	movl	8(%ebp),	%ebx
	imull	%ebx,	%eax
	movl	%eax,	-8(%ebp)
	movl	-4(%ebp),	%eax
	movl	$1,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	-4(%ebp)
	jmp	start1
fin1:
	movl	-8(%ebp),	%eax
	jmp	function_end
fun_fib:
	pushl	%ebp
	movl	%esp,	%ebp
	subl	$12,	%esp
	movl	$0,	%eax
	movl	%eax,	-12(%ebp)
	movl	$0,	%eax
	movl	%eax,	-4(%ebp)
	movl	$1,	%eax
	movl	%eax,	-8(%ebp)
start2:
	movl	-12(%ebp),	%eax
	movl	8(%ebp),	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setl	%al
	cmp	$0,	%eax
	jz	fin2
	movl	-8(%ebp),	%eax
	movl	-4(%ebp),	%ebx
	addl	%ebx,	%eax
	movl	%eax,	-8(%ebp)
	movl	-8(%ebp),	%eax
	movl	-4(%ebp),	%ebx
	subl	%ebx,	%eax
	movl	%eax,	-4(%ebp)
	movl	-12(%ebp),	%eax
	movl	$1,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	-12(%ebp)
	jmp	start2
fin2:
	movl	-4(%ebp),	%eax
	jmp	function_end
main:
	pushl	%ebp
	movl	%esp,	%ebp
	movl	$10,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	fun_fac
	addl	$4,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	$2,	%eax
	movl	$10,	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	fun_pow
	addl	$8,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	$2,	%eax
	movl	$4,	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	fun_pow
	addl	$8,	%esp
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
