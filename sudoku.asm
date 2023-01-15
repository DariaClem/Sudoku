.data
//long
	ok: .long 0

//space
	input: .space 1600
	matrice: .space 1600
	b: .space 1600
	x: .space 4
	m: .space 4
	n: .space 4
	inou: .space 4
	jnou: .space 4
	p: .space 4
	q: .space 4
	c: .space 4
	d: .space 4
	rez: .space 4
	
//asciz
	invalid: .asciz "Nu se poate genera o solutie.\n"
	formatscanf: .asciz "%[^\n]"
	formatprint: .asciz "%d "
	formatnul: .asciz "%s"
	nul: .asciz "\n"
	delim: .asciz " "
	
.text
verif:
	pushl %ebp
	movl %esp, %ebp
	
	movl $9, %eax
	xorl %edx, %edx
	movl 8(%ebp), %ebx
	mull %ebx
	addl 12(%ebp), %eax
	
	movl (%esi, %eax, 4), %ebx
	cmp $0, %ebx
	jne rau

linie:	
	xorl %ecx, %ecx
	movl %ecx, p
	
v1:
	movl p, %ecx
	cmp $9, %ecx
	je coloana 
	
	movl $9, %eax
	xorl %edx, %edx
	mull 8(%ebp)
	addl p, %eax
	
	movl (%esi, %eax, 4), %edx
	cmp 16(%ebp), %edx
	je rau
	movl p, %ecx
	incl %ecx
	movl %ecx, p
	jmp v1
	
coloana: 
	xorl %ecx, %ecx
	movl %ecx, q
	
v2:
	movl q, %ecx
	cmp $9, %ecx
	je patrat
	
	movl $9, %eax
	xorl %edx, %edx
	mull q
	addl 12(%ebp), %eax
	
	movl (%esi, %eax, 4), %edx
	cmp 16(%ebp), %edx
	je rau
	movl q, %ecx
	incl %ecx
	movl %ecx, q
	jmp v2
	
patrat:
	movl $3, %ebx
	xorl %edx, %edx
	movl 8(%ebp), %eax
	divl %ebx
	xorl %edx, %edx
	mull %ebx
	movl %eax, c
	
	movl $3, %ebx
	xorl %edx, %edx
	movl 12(%ebp), %eax
	divl %ebx
	xorl %edx, %edx
	mull %ebx
	movl %eax, d
	
	movl c, %eax
	movl %eax, p
	
	addl $3, %eax
	movl %eax, c
	
	movl d, %eax
	movl %eax, q
	movl %eax, rez
	
	addl $3, %eax
	movl %eax, d

v3i:
	movl p, %ecx
	cmp c, %ecx
	je bun
v3j:
	movl q, %ecx
	cmp d, %ecx
	je incri
	
	movl $9, %eax
	xorl %edx, %edx
	movl p, %ebx
	mull %ebx
	addl q, %eax
	
	movl (%esi, %eax, 4), %ebx
	movl %ebx, %eax
	
	movl 16(%ebp), %ebx
	cmp %eax, %ebx
	je rau
	
	movl q, %ecx
	incl %ecx
	movl %ecx, q
	jmp v3j
	
incri:
	movl rez, %ecx
	movl %ecx, q
	movl p, %ecx
	incl %ecx
	movl %ecx, p
	jmp v3i

bun: 
	movl $1, %eax
	popl %ebp
	ret

rau:
	xorl %eax, %eax
	popl %ebp
	ret

pozitie:
	pushl %ebp
	movl %esp, %ebp
	
	//i
	xorl %edx, %edx
	//j
	xorl %ecx, %ecx
	
ifor:
	cmp $9, %edx
	je returnarerea

jfor:
	cmp $9, %ecx
	je ipp
	
	pushl %ecx
	pushl %edx
	
	movl $9, %ebx
	movl %edx, %eax
	xorl %edx, %edx
	mull %ebx
	addl %ecx, %eax
	
	popl %edx
	popl %ecx
	
	movl (%esi, %eax, 4), %ebx
	cmp $0, %ebx
	je returnarebuna
	incl %ecx 
	jmp jfor
	
ipp:
	incl %edx
	xorl %ecx, %ecx
	jmp ifor
	
returnarerea:
	xorl %eax, %eax
	jmp la_revedere
	
returnarebuna:
	movl $1, %eax
	
la_revedere:
	popl %ebp
	ret
	
bkt:
	pushl %ebp
	movl %esp, %ebp
	
	movl $1, %ecx
	movl %ecx, x
	
// The counter will be %ecx and will remain unchanged
forbkt:
	movl x, %ecx
	cmp $9, %ecx
	jg returnare

	movl ok, %ebx
	cmp $1, %ebx
	je incrementarex
	
p1:
	pushl %ecx
	pushl 12(%ebp)
	pushl 8(%ebp)
	call verif
	popl %ebx
	popl %ebx
	popl %ecx
	
	cmp $0, %eax
	je incrementarex
	
atribuire:
	movl 8(%ebp), %eax
	movl %eax, m
	movl 12(%ebp), %eax
	movl %eax, n
	movl $9, %eax
	xorl %edx, %edx
	mull m
	addl n, %eax
	movl %ecx, (%esi, %eax, 4)
	
	pushl %ecx
	pushl n
	pushl m
	call pozitie
	popl m
	popl n
	movl %edx, inou
	movl %ecx, jnou
	popl %ecx
	
	cmp $0, %eax
	je rezultat
	
	pushl m
	pushl n
	pushl %ecx
	
	pushl jnou
	pushl inou
	call bkt
	popl %ebx
	popl %ebx
	
	popl %ecx
	popl n
	popl m
	
	movl ok, %ebx
	cmp $1, %ebx
	je incrementarex
	
	movl $0, %ebx
	movl $9, %eax
	xorl %edx, %edx
	mull m
	addl n, %eax
	movl %ebx, (%esi, %eax, 4)
	
	jmp incrementarex	

incrementarex:
	incl %ecx
	movl %ecx, x
	jmp forbkt

rezultat: 
	movl $1, %ebx
	movl %ebx, ok
	jmp incrementarex
	
returnare:
	popl %ebp
	ret
	
.global main
main:
	pushl $input
	pushl $formatscanf
	call scanf
	popl %ebx
	popl %ebx
	
	lea matrice, %edi
	lea b, %esi
	
	xorl %ecx, %ecx 
	xorl %ebx, %ebx 
	
fori:
	cmp $9, %ecx
	je pasul1	

forj:
	cmp $9, %ebx
	je iplus
	
	cmp $0, %ecx
	je el00
	
adaugare:
	pushl %ecx
	
	pushl $delim
	pushl $0
	call strtok
	popl %edx
	popl %edx
	
	pushl %eax
	call atoi
	popl %edx

	popl %ecx
	
	pushl %ebx
	pushl %eax
	
	movl $9, %eax	
	xorl %edx, %edx
	mull %ecx
	addl %ebx, %eax
	
	movl %eax, %ebx
	popl %eax
	
	movl %eax, (%edi, %ebx, 4)
	movl %eax, (%esi, %ebx, 4)
	
	popl %ebx
	
	incl %ebx
	jmp forj
	
iplus:
	incl %ecx
	xorl %ebx, %ebx
	jmp fori
	
el00:
	cmp $0, %ebx
	je primulnr
	jmp adaugare

primulnr:
	pushl %ecx
	pushl $delim
	pushl $input
	call strtok
	popl %edx
	popl %edx
	
	pushl %eax
	call atoi
	popl %edx
	popl %ecx
	
	pushl %ebx
	pushl %eax
	
	movl $9, %eax
	xorl %edx, %edx
	mull %ecx
	addl %ebx, %eax
	
	movl %eax, %ebx
	popl %eax
	
	movl %eax, (%edi, %ebx, 4)
	movl %eax, (%esi, %ebx, 4)
	popl %ebx
	
	incl %ebx
	jmp forj

pasul1:
	xorl %eax, %eax
	xorl %ecx, %ecx
	pushl %eax
	pushl %ecx
	call pozitie
	popl %eax
	popl %eax

z:
	pushl %ecx
	pushl %edx
	call bkt
	popl %edx
	popl %edx
asa:	
	movl ok, %eax
	cmp $0, %eax
	je condamnat
	
afisare:
	xorl %ebx, %ebx
	xorl %ecx, %ecx
	
i:
	cmp $9, %ecx
	je exit
	
j:	
	cmp $9, %ebx
	je incrementi
	
	pushl %ebx
	
	movl $9, %eax
	xorl %edx, %edx
	mull %ecx
	addl %ebx, %eax
	
	movl %eax, %ebx
	
	movl (%esi, %ebx, 4), %eax
	popl %ebx  
	
	pushl %ecx
	pushl %eax
	pushl $formatprint
	call printf
	popl %edx
	popl %edx
	popl %ecx
	
	incl %ebx
	jmp j
	
incrementi:
	incl %ecx
	xorl %ebx, %ebx
	
	pushl %ecx
	
	pushl $nul
	pushl $formatnul
	call printf
	popl %edx
	popl %edx
	
	popl %ecx
	
	jmp i

condamnat:
	pushl $invalid
	pushl $formatnul
	call printf
	popl %edx
	popl %edx
	
exit:
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
	
	