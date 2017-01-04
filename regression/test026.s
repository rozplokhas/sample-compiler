	.data
	.comm	var_m,	4,	4
	.comm	var_n,	4,	4
	.text
	.globl	main
function_end:
	movl	%ebp,	%esp
	popl	%ebp
	ret
fun_A:
	pushl	%ebp
	movl	%esp,	%ebp
	movl	8(%ebp),	%eax
	movl	$0,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	sete	%al
	cmp	$0,	%eax
	jz	else0
	movl	12(%ebp),	%eax
	movl	$1,	%ebx
	addl	%ebx,	%eax
	jmp	function_end
	jmp	fin0
else0:
	movl	8(%ebp),	%eax
	movl	$0,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setg	%al
	movl	12(%ebp),	%ebx
	movl	$0,	%ecx
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
	cmp	$0,	%eax
	jz	else1
	movl	8(%ebp),	%eax
	movl	$1,	%ebx
	subl	%ebx,	%eax
	movl	$1,	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	fun_A
	addl	$8,	%esp
	jmp	function_end
	jmp	fin1
else1:
	movl	8(%ebp),	%eax
	movl	$1,	%ebx
	subl	%ebx,	%eax
	movl	8(%ebp),	%ebx
	movl	12(%ebp),	%ecx
	movl	$1,	%esi
	subl	%esi,	%ecx
	movl	%eax,	-4(%esp)
	movl	%ecx,	-8(%esp)
	movl	%ebx,	-12(%esp)
	subl	$12,	%esp
	call	fun_A
	movl	%eax,	%ebx
	addl	$8,	%esp
	popl	%eax
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	fun_A
	addl	$8,	%esp
	jmp	function_end
fin1:
fin0:
main:
	pushl	%ebp
	movl	%esp,	%ebp
	call	read
	movl	%eax,	var_m
	call	read
	movl	%eax,	var_n
	movl	var_m,	%eax
	movl	var_n,	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	fun_A
	addl	$8,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	%ebp,	%esp
	popl	%ebp
	xorl	%eax,	%eax
	ret
