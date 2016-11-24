	.data
	.comm	var_x,	4,	4
	.text
	.globl	main
function_end:
	movl	%ebp,	%esp
	popl	%ebp
	ret
fun_is_even:
	pushl	%ebp
	movl	%esp,	%ebp
	movl	8(%ebp),	%eax
	movl	$0,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	sete	%al
	cmp	$0,	%eax
	jz	else1
	movl	$1,	%eax
	jmp	function_end
	jmp	fin1
else1:
fin1:
	movl	8(%ebp),	%eax
	movl	$1,	%ebx
	subl	%ebx,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	fun_is_odd
	addl	$4,	%esp
	jmp	function_end
fun_is_odd:
	pushl	%ebp
	movl	%esp,	%ebp
	movl	8(%ebp),	%eax
	movl	$0,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	sete	%al
	cmp	$0,	%eax
	jz	else2
	movl	$0,	%eax
	jmp	function_end
	jmp	fin2
else2:
fin2:
	movl	8(%ebp),	%eax
	movl	$1,	%ebx
	subl	%ebx,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	fun_is_even
	addl	$4,	%esp
	jmp	function_end
main:
	pushl	%ebp
	movl	%esp,	%ebp
start0:
	call	read
	movl	%eax,	var_x
	movl	var_x,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	fun_is_even
	addl	$4,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	var_x,	%eax
	movl	$0,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	sete	%al
	cmp	$0,	%eax
	jz	start0
	movl	%ebp,	%esp
	popl	%ebp
	xorl	%eax,	%eax
	ret
