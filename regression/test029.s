	.data
	.comm	var_A,	4,	4
	.text
	.globl	main
function_end:
	movl	%ebp,	%esp
	popl	%ebp
	ret
fun_printArray:
	pushl	%ebp
	movl	%esp,	%ebp
	subl	$4,	%esp
	movl	$0,	%eax
	movl	%eax,	-4(%ebp)
start0:
	movl	-4(%ebp),	%eax
	movl	8(%ebp),	%ebx
	movl	%eax,	-4(%esp)
	movl	%ebx,	-8(%esp)
	subl	$8,	%esp
	call	arrlen
	movl	%eax,	%ebx
	addl	$4,	%esp
	popl	%eax
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setl	%al
	cmp	$0,	%eax
	jz	fin0
	movl	8(%ebp),	%eax
	movl	-4(%ebp),	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	arrget
	addl	$8,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	-4(%ebp),	%eax
	movl	$1,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	-4(%ebp)
	jmp	start0
fin0:
	movl	$0,	%eax
	jmp	function_end
fun_readArray:
	pushl	%ebp
	movl	%esp,	%ebp
	subl	$4,	%esp
	movl	$0,	%eax
	movl	%eax,	-4(%ebp)
start1:
	movl	-4(%ebp),	%eax
	movl	8(%ebp),	%ebx
	movl	%eax,	-4(%esp)
	movl	%ebx,	-8(%esp)
	subl	$8,	%esp
	call	arrlen
	movl	%eax,	%ebx
	addl	$4,	%esp
	popl	%eax
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setl	%al
	cmp	$0,	%eax
	jz	fin1
	movl	$1,	%eax
	movl	8(%ebp),	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	read
	movl	%eax,	%ecx
	popl	%eax
	popl	%ebx
	movl	-4(%ebp),	%esi
	movl	%esi,	-4(%esp)
	movl	%ecx,	-8(%esp)
	movl	%ebx,	-12(%esp)
	movl	%eax,	-16(%esp)
	subl	$16,	%esp
	call	arrset
	addl	$16,	%esp
	movl	-4(%ebp),	%eax
	movl	$1,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	-4(%ebp)
	jmp	start1
fin1:
	movl	8(%ebp),	%eax
	jmp	function_end
main:
	pushl	%ebp
	movl	%esp,	%ebp
	subl	$4,	%esp
	movl	$5,	%eax
	movl	$0,	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	arrmake
	addl	$8,	%esp
	movl	%eax,	var_A
	movl	var_A,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	fun_readArray
	addl	$4,	%esp
	movl	%eax,	var_A
	movl	var_A,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	fun_printArray
	addl	$4,	%esp
	movl	$5,	%eax
	movl	$1,	%ebx
	movl	$2,	%ecx
	movl	$3,	%esi
	movl	$4,	%edi
	movl	$5,	0(%esp)
	movl	0(%esp),	%edx
	movl	%edx,	-4(%esp)
	movl	%edi,	-8(%esp)
	movl	%esi,	-12(%esp)
	movl	%ecx,	-16(%esp)
	movl	%ebx,	-20(%esp)
	movl	%eax,	-24(%esp)
	subl	$28,	%esp
	call	arrcreate
	addl	$24,	%esp
	movl	%eax,	var_A
	movl	var_A,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	fun_printArray
	addl	$4,	%esp
	movl	%ebp,	%esp
	popl	%ebp
	xorl	%eax,	%eax
	ret
