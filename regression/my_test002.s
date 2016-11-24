	.data
	.comm	var_i,	4,	4
	.text
	.globl	main
function_end:
	movl	%ebp,	%esp
	popl	%ebp
	ret
fun_two:
	pushl	%ebp
	movl	%esp,	%ebp
	movl	$2,	%eax
	jmp	function_end
	movl	$3,	%eax
	jmp	function_end
fun_write_42:
	pushl	%ebp
	movl	%esp,	%ebp
	movl	$42,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	$0,	%eax
	jmp	function_end
fun_assert:
	pushl	%ebp
	movl	%esp,	%ebp
	movl	8(%ebp),	%eax
	cmp	$0,	%eax
	jz	else1
	movl	$0,	%eax
	jmp	function_end
	jmp	fin1
else1:
fin1:
start0:
	movl	$1,	%eax
	cmp	$0,	%eax
	jz	fin0
	jmp	start0
fin0:
fun_set_i:
	pushl	%ebp
	movl	%esp,	%ebp
	subl	$4,	%esp
	movl	8(%ebp),	%eax
	movl	%eax,	-4(%ebp)
	movl	$0,	%eax
	jmp	function_end
fun_useless:
	pushl	%ebp
	movl	%esp,	%ebp
	movl	$1000000000,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
main:
	pushl	%ebp
	movl	%esp,	%ebp
	call	fun_two
	movl	$2,	%ebx
	imull	%ebx,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	call	fun_write_42
	movl	$0,	%eax
	movl	$0,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	sete	%al
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	fun_assert
	addl	$4,	%esp
	movl	$3,	%eax
	movl	%eax,	var_i
	movl	$100500,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	fun_set_i
	addl	$4,	%esp
	movl	var_i,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	%ebp,	%esp
	popl	%ebp
	xorl	%eax,	%eax
	ret
