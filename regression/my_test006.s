	.data
	.comm	var_s,	4,	4
string_2:
	.int 0
	.ascii ""
string_0:
	.int 8
	.ascii "This is "
string_3:
	.int 4
	.ascii "not "
string_1:
	.int 11
	.ascii "palindrome."
	.text
	.globl	main
function_end:
	movl	%ebp,	%esp
	popl	%ebp
	ret
fun_check:
	pushl	%ebp
	movl	%esp,	%ebp
	subl	$20,	%esp
	movl	8(%ebp),	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	str_write
	addl	$4,	%esp
	movl	8(%ebp),	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	str_len
	addl	$4,	%esp
	movl	$0,	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	str_make
	addl	$8,	%esp
	movl	%eax,	-16(%ebp)
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
	movl	-16(%ebp),	%eax
	movl	-4(%ebp),	%ebx
	movl	8(%ebp),	%ecx
	movl	8(%ebp),	%esi
	movl	%ecx,	-4(%esp)
	movl	%ebx,	-8(%esp)
	movl	%eax,	-12(%esp)
	movl	%esi,	-16(%esp)
	subl	$16,	%esp
	call	str_len
	movl	%eax,	%esi
	addl	$4,	%esp
	popl	%eax
	popl	%ebx
	popl	%ecx
	movl	-4(%ebp),	%edi
	subl	%edi,	%esi
	movl	$1,	%edi
	subl	%edi,	%esi
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	movl	%esi,	-12(%esp)
	movl	%ecx,	-16(%esp)
	subl	$16,	%esp
	call	str_get
	movl	%eax,	%ecx
	addl	$8,	%esp
	popl	%eax
	popl	%ebx
	movl	%ecx,	-4(%esp)
	movl	%ebx,	-8(%esp)
	movl	%eax,	-12(%esp)
	subl	$12,	%esp
	call	str_set
	addl	$12,	%esp
	movl	-4(%ebp),	%eax
	movl	$1,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	-4(%ebp)
	jmp	start2
fin2:
	movl	$string_0,	%eax
	movl	%eax,	-8(%ebp)
	movl	$string_1,	%eax
	movl	%eax,	-20(%ebp)
	movl	8(%ebp),	%eax
	movl	-16(%ebp),	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	str_cmp
	addl	$8,	%esp
	movl	$0,	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	sete	%al
	cmp	$0,	%eax
	jz	else1
	movl	$string_2,	%eax
	movl	%eax,	-12(%ebp)
	jmp	fin1
else1:
	movl	$string_3,	%eax
	movl	%eax,	-12(%ebp)
fin1:
	movl	-8(%ebp),	%eax
	movl	-12(%ebp),	%ebx
	movl	-20(%ebp),	%ecx
	movl	%eax,	-4(%esp)
	movl	%ecx,	-8(%esp)
	movl	%ebx,	-12(%esp)
	subl	$12,	%esp
	call	str_cat
	movl	%eax,	%ebx
	addl	$8,	%esp
	popl	%eax
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	str_cat
	addl	$8,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	str_write
	addl	$4,	%esp
	movl	$0,	%eax
	jmp	function_end
main:
	pushl	%ebp
	movl	%esp,	%ebp
start0:
	call	str_read
	movl	%eax,	var_s
	movl	var_s,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	fun_check
	addl	$4,	%esp
	movl	var_s,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	str_len
	addl	$4,	%esp
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
