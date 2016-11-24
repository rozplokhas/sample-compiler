	.data
	.comm	var_s1,	4,	4
	.comm	var_s2,	4,	4
string_3:
	.int 3
	.ascii "aaa"
string_2:
	.int 2
	.ascii "ab"
string_1:
	.int 2
	.ascii "hi"
string_0:
	.int 3
	.ascii "man"
	.text
	.globl	main
main:
	pushl	%ebp
	movl	%esp,	%ebp
	call	str_read
	movl	%eax,	var_s1
	call	str_read
	movl	%eax,	var_s2
	movl	var_s1,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	str_write
	addl	$4,	%esp
	movl	$5,	%eax
	movl	$101,	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	str_make
	addl	$8,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	str_write
	addl	$4,	%esp
	movl	var_s1,	%eax
	movl	$4,	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	str_get
	addl	$8,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	$string_0,	%eax
	movl	$1,	%ebx
	movl	$101,	%ecx
	movl	%ecx,	-4(%esp)
	movl	%ebx,	-8(%esp)
	movl	%eax,	-12(%esp)
	subl	$12,	%esp
	call	str_set
	addl	$12,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	str_write
	addl	$4,	%esp
	movl	$string_1,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	str_dup
	addl	$4,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	str_write
	addl	$4,	%esp
	movl	var_s1,	%eax
	movl	var_s2,	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	str_cat
	addl	$8,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	str_write
	addl	$4,	%esp
	movl	$string_2,	%eax
	movl	$string_3,	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	str_cmp
	addl	$8,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	var_s2,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	str_len
	addl	$4,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	var_s1,	%eax
	movl	$0,	%ebx
	movl	$4,	%ecx
	movl	%ecx,	-4(%esp)
	movl	%ebx,	-8(%esp)
	movl	%eax,	-12(%esp)
	subl	$12,	%esp
	call	str_sub
	addl	$12,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	str_write
	addl	$4,	%esp
	movl	%ebp,	%esp
	popl	%ebp
	xorl	%eax,	%eax
	ret
