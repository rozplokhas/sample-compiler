	.data
	.comm	var_D,	4,	4
	.comm	var_S,	4,	4
	.comm	var_i,	4,	4
string_0:
	.int 22
	.ascii "I will remember April."
string_1:
	.int 8
	.ascii "remember"
	.text
	.globl	main
function_end:
	movl	%ebp,	%esp
	popl	%ebp
	ret
fun_printStr:
	pushl	%ebp
	movl	%esp,	%ebp
	subl	$4,	%esp
	movl	$0,	%eax
	movl	%eax,	-4(%ebp)
start2:
	movl	-4(%ebp),	%eax
	movl	8(%ebp),	%ebx
	movl	%eax,	-4(%esp)
	movl	%ebx,	-8(%esp)
	subl	$8,	%esp
	call	str_len
	movl	%eax,	%ebx
	addl	$4,	%esp
	popl	%eax
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setl	%al
	cmp	$0,	%eax
	jz	fin2
	movl	8(%ebp),	%eax
	movl	-4(%ebp),	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	str_get
	addl	$8,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	-4(%ebp),	%eax
	movl	$1,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	-4(%ebp)
	jmp	start2
fin2:
	movl	$0,	%eax
	jmp	function_end
main:
	pushl	%ebp
	movl	%esp,	%ebp
	movl	$string_0,	%eax
	movl	%eax,	var_S
	movl	var_S,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	fun_printStr
	addl	$4,	%esp
	movl	$0,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	var_S,	%eax
	movl	$7,	%ebx
	movl	$8,	%ecx
	movl	%ecx,	-4(%esp)
	movl	%ebx,	-8(%esp)
	movl	%eax,	-12(%esp)
	subl	$12,	%esp
	call	str_sub
	addl	$12,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	fun_printStr
	addl	$4,	%esp
	movl	$0,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	$string_1,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	fun_printStr
	addl	$4,	%esp
	movl	$0,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	var_S,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	str_len
	addl	$4,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	var_S,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	str_dup
	addl	$4,	%esp
	movl	%eax,	var_D
	movl	$0,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	$0,	%eax
	movl	%eax,	var_i
start0:
	movl	var_i,	%eax
	movl	var_S,	%ebx
	movl	%eax,	-4(%esp)
	movl	%ebx,	-8(%esp)
	subl	$8,	%esp
	call	str_len
	movl	%eax,	%ebx
	addl	$4,	%esp
	popl	%eax
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setl	%al
	cmp	$0,	%eax
	jz	fin0
	movl	var_S,	%eax
	movl	var_i,	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	str_get
	addl	$8,	%esp
	movl	$105,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	sete	%al
	cmp	$0,	%eax
	jz	else1
	movl	var_S,	%eax
	movl	var_i,	%ebx
	movl	$106,	%ecx
	movl	%ecx,	-4(%esp)
	movl	%ebx,	-8(%esp)
	movl	%eax,	-12(%esp)
	subl	$12,	%esp
	call	str_set
	addl	$12,	%esp
	jmp	fin1
else1:
fin1:
	movl	var_i,	%eax
	movl	$1,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	var_i
	jmp	start0
fin0:
	movl	var_S,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	fun_printStr
	addl	$4,	%esp
	movl	$0,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	var_D,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	fun_printStr
	addl	$4,	%esp
	movl	$0,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	var_S,	%eax
	movl	var_D,	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	str_cat
	addl	$8,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	fun_printStr
	addl	$4,	%esp
	movl	var_S,	%eax
	movl	var_D,	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	str_cmp
	addl	$8,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	var_D,	%eax
	movl	var_S,	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	str_cmp
	addl	$8,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	var_S,	%eax
	movl	var_S,	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	str_cmp
	addl	$8,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	%ebp,	%esp
	popl	%ebp
	xorl	%eax,	%eax
	ret
