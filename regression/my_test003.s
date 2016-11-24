	.data
	.comm	var_i,	4,	4
	.text
	.globl	main
function_end:
	movl	%ebp,	%esp
	popl	%ebp
	ret
fun_foo:
	pushl	%ebp
	movl	%esp,	%ebp
	movl	8(%ebp),	%eax
	movl	$5,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setle	%al
	cmp	$0,	%eax
	jz	else1
	movl	8(%ebp),	%eax
	movl	$1,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	sete	%al
	cmp	$0,	%eax
	jz	else3
	movl	$0,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	jmp	fin3
else3:
	movl	8(%ebp),	%eax
	movl	$2,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	sete	%al
	cmp	$0,	%eax
	jz	else4
	movl	$1,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	jmp	fin4
else4:
	movl	8(%ebp),	%eax
	movl	$3,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	sete	%al
	cmp	$0,	%eax
	jz	else5
	movl	$2,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	jmp	fin5
else5:
	movl	8(%ebp),	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
fin5:
fin4:
fin3:
	jmp	fin1
else1:
	movl	8(%ebp),	%eax
	movl	$8,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setge	%al
	cmp	$0,	%eax
	jz	else2
	movl	$10,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	jmp	fin2
else2:
fin2:
fin1:
	movl	$0,	%eax
	jmp	function_end
main:
	pushl	%ebp
	movl	%esp,	%ebp
	movl	$1,	%eax
	movl	%eax,	var_i
start0:
	movl	var_i,	%eax
	movl	$10,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setle	%al
	cmp	$0,	%eax
	jz	fin0
	movl	var_i,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	fun_foo
	addl	$4,	%esp
	movl	var_i,	%eax
	movl	$1,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	var_i
	jmp	start0
fin0:
	movl	%ebp,	%esp
	popl	%ebp
	xorl	%eax,	%eax
	ret
