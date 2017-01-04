	.data
	.comm	var_A,	4,	4
	.comm	var_B,	4,	4
	.text
	.globl	main
function_end:
	movl	%ebp,	%esp
	popl	%ebp
	ret
fun_printMatrix:
	pushl	%ebp
	movl	%esp,	%ebp
	subl	$20,	%esp
	movl	8(%ebp),	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	arrlen
	addl	$4,	%esp
	movl	%eax,	-20(%ebp)
	movl	-20(%ebp),	%eax
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
	movl	$0,	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	arrget
	addl	$8,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	arrlen
	addl	$4,	%esp
	movl	%eax,	-8(%ebp)
	movl	$0,	%eax
	movl	%eax,	-12(%ebp)
start0:
	movl	-12(%ebp),	%eax
	movl	-20(%ebp),	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setl	%al
	cmp	$0,	%eax
	jz	fin0
	movl	8(%ebp),	%eax
	movl	-12(%ebp),	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	arrget
	addl	$8,	%esp
	movl	%eax,	-4(%ebp)
	movl	$0,	%eax
	movl	%eax,	-16(%ebp)
start1:
	movl	-16(%ebp),	%eax
	movl	-8(%ebp),	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setl	%al
	cmp	$0,	%eax
	jz	fin1
	movl	-4(%ebp),	%eax
	movl	-16(%ebp),	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	arrget
	addl	$8,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	write
	addl	$4,	%esp
	movl	-16(%ebp),	%eax
	movl	$1,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	-16(%ebp)
	jmp	start1
fin1:
	movl	-12(%ebp),	%eax
	movl	$1,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	-12(%ebp)
	jmp	start0
fin0:
	movl	$0,	%eax
	jmp	function_end
fun_readMatrix:
	pushl	%ebp
	movl	%esp,	%ebp
	subl	$24,	%esp
	call	read
	movl	%eax,	-24(%ebp)
	call	read
	movl	%eax,	-12(%ebp)
	movl	-24(%ebp),	%eax
	movl	$0,	%ebx
	movl	%eax,	-4(%esp)
	movl	%ebx,	-8(%esp)
	subl	$8,	%esp
	call	Arrcreate
	movl	%eax,	%ebx
	addl	$4,	%esp
	popl	%eax
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	Arrmake
	addl	$8,	%esp
	movl	%eax,	-4(%ebp)
	movl	$0,	%eax
	movl	%eax,	-16(%ebp)
start3:
	movl	-16(%ebp),	%eax
	movl	-24(%ebp),	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setl	%al
	cmp	$0,	%eax
	jz	fin3
	movl	-12(%ebp),	%eax
	movl	$0,	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	arrmake
	addl	$8,	%esp
	movl	%eax,	-8(%ebp)
	movl	$0,	%eax
	movl	%eax,	-20(%ebp)
start4:
	movl	-20(%ebp),	%eax
	movl	-12(%ebp),	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setl	%al
	cmp	$0,	%eax
	jz	fin4
	movl	$1,	%eax
	movl	-8(%ebp),	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	read
	movl	%eax,	%ecx
	popl	%eax
	popl	%ebx
	movl	-20(%ebp),	%esi
	movl	%esi,	-4(%esp)
	movl	%ecx,	-8(%esp)
	movl	%ebx,	-12(%esp)
	movl	%eax,	-16(%esp)
	subl	$16,	%esp
	call	arrset
	addl	$16,	%esp
	movl	-20(%ebp),	%eax
	movl	$1,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	-20(%ebp)
	jmp	start4
fin4:
	movl	$1,	%eax
	movl	-4(%ebp),	%ebx
	movl	-8(%ebp),	%ecx
	movl	-16(%ebp),	%esi
	movl	%esi,	-4(%esp)
	movl	%ecx,	-8(%esp)
	movl	%ebx,	-12(%esp)
	movl	%eax,	-16(%esp)
	subl	$16,	%esp
	call	arrset
	addl	$16,	%esp
	movl	-16(%ebp),	%eax
	movl	$1,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	-16(%ebp)
	jmp	start3
fin3:
	movl	-4(%ebp),	%eax
	jmp	function_end
fun_multiplyMatrix:
	pushl	%ebp
	movl	%esp,	%ebp
	subl	$44,	%esp
	movl	8(%ebp),	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	arrlen
	addl	$4,	%esp
	movl	%eax,	-36(%ebp)
	movl	8(%ebp),	%eax
	movl	$0,	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	arrget
	addl	$8,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	arrlen
	addl	$4,	%esp
	movl	%eax,	-16(%ebp)
	movl	12(%ebp),	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	arrlen
	addl	$4,	%esp
	movl	%eax,	-40(%ebp)
	movl	12(%ebp),	%eax
	movl	$0,	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	arrget
	addl	$8,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	arrlen
	addl	$4,	%esp
	movl	%eax,	-20(%ebp)
	movl	-36(%ebp),	%eax
	movl	-20(%ebp),	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	sete	%al
	movl	-16(%ebp),	%ebx
	movl	-40(%ebp),	%ecx
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
	jz	else5
	movl	-36(%ebp),	%eax
	movl	$0,	%ebx
	movl	%eax,	-4(%esp)
	movl	%ebx,	-8(%esp)
	subl	$8,	%esp
	call	Arrcreate
	movl	%eax,	%ebx
	addl	$4,	%esp
	popl	%eax
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	Arrmake
	addl	$8,	%esp
	movl	%eax,	-4(%ebp)
	movl	$0,	%eax
	movl	%eax,	-24(%ebp)
start6:
	movl	-24(%ebp),	%eax
	movl	-36(%ebp),	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setl	%al
	cmp	$0,	%eax
	jz	fin6
	movl	-20(%ebp),	%eax
	movl	$0,	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	arrmake
	addl	$8,	%esp
	movl	%eax,	-8(%ebp)
	movl	8(%ebp),	%eax
	movl	-24(%ebp),	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	arrget
	addl	$8,	%esp
	movl	%eax,	-12(%ebp)
	movl	$0,	%eax
	movl	%eax,	-28(%ebp)
start7:
	movl	-28(%ebp),	%eax
	movl	-20(%ebp),	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setl	%al
	cmp	$0,	%eax
	jz	fin7
	movl	$0,	%eax
	movl	%eax,	-44(%ebp)
	movl	$0,	%eax
	movl	%eax,	-32(%ebp)
start8:
	movl	-32(%ebp),	%eax
	movl	-16(%ebp),	%ebx
	movl	%eax,	%edx
	xorl	%eax,	%eax
	cmp	%ebx,	%edx
	setl	%al
	cmp	$0,	%eax
	jz	fin8
	movl	-44(%ebp),	%eax
	movl	-12(%ebp),	%ebx
	movl	-32(%ebp),	%ecx
	movl	%eax,	-4(%esp)
	movl	%ecx,	-8(%esp)
	movl	%ebx,	-12(%esp)
	subl	$12,	%esp
	call	arrget
	movl	%eax,	%ebx
	addl	$8,	%esp
	popl	%eax
	movl	12(%ebp),	%ecx
	movl	-32(%ebp),	%esi
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	movl	%esi,	-12(%esp)
	movl	%ecx,	-16(%esp)
	subl	$16,	%esp
	call	arrget
	movl	%eax,	%ecx
	addl	$8,	%esp
	popl	%eax
	popl	%ebx
	movl	-28(%ebp),	%esi
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	movl	%esi,	-12(%esp)
	movl	%ecx,	-16(%esp)
	subl	$16,	%esp
	call	arrget
	movl	%eax,	%ecx
	addl	$8,	%esp
	popl	%eax
	popl	%ebx
	imull	%ecx,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	-44(%ebp)
	movl	-32(%ebp),	%eax
	movl	$1,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	-32(%ebp)
	jmp	start8
fin8:
	movl	$1,	%eax
	movl	-8(%ebp),	%ebx
	movl	-44(%ebp),	%ecx
	movl	-28(%ebp),	%esi
	movl	%esi,	-4(%esp)
	movl	%ecx,	-8(%esp)
	movl	%ebx,	-12(%esp)
	movl	%eax,	-16(%esp)
	subl	$16,	%esp
	call	arrset
	addl	$16,	%esp
	movl	-28(%ebp),	%eax
	movl	$1,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	-28(%ebp)
	jmp	start7
fin7:
	movl	$1,	%eax
	movl	-4(%ebp),	%ebx
	movl	-8(%ebp),	%ecx
	movl	-24(%ebp),	%esi
	movl	%esi,	-4(%esp)
	movl	%ecx,	-8(%esp)
	movl	%ebx,	-12(%esp)
	movl	%eax,	-16(%esp)
	subl	$16,	%esp
	call	arrset
	addl	$16,	%esp
	movl	-24(%ebp),	%eax
	movl	$1,	%ebx
	addl	%ebx,	%eax
	movl	%eax,	-24(%ebp)
	jmp	start6
fin6:
	movl	-4(%ebp),	%eax
	jmp	function_end
	jmp	fin5
else5:
	movl	$0,	%eax
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	Arrcreate
	addl	$4,	%esp
	jmp	function_end
fin5:
main:
	pushl	%ebp
	movl	%esp,	%ebp
	call	fun_readMatrix
	movl	%eax,	var_A
	call	fun_readMatrix
	movl	%eax,	var_B
	movl	var_A,	%eax
	movl	var_B,	%ebx
	movl	%ebx,	-4(%esp)
	movl	%eax,	-8(%esp)
	subl	$8,	%esp
	call	fun_multiplyMatrix
	addl	$8,	%esp
	movl	%eax,	-4(%esp)
	subl	$4,	%esp
	call	fun_printMatrix
	addl	$4,	%esp
	movl	%ebp,	%esp
	popl	%ebp
	xorl	%eax,	%eax
	ret
