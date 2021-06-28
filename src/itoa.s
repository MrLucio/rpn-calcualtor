.section .data
    neg: .byte 0

.section .text
	.global itoa

.type itoa, @function		# dichiarazione della funzione itoa che
				# converte un intero in una stringa
				# il numero da convertire deve essere
				# stato caricato nel registro %eax

itoa:
    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl %edi

    movl 20(%esp), %edi

	movl $0, %ecx		# carica il numero 0 in %ecx

    cmp $0, %eax
    jge compara
    neg %eax
    movl $1, neg

compara:
    cmp $10, %eax
    jge dividi
    inc %ecx
    push %eax
    jmp stampa

dividi:
    xorl %edx, %edx
    movl $10, %ebx
    divl %ebx
    inc %ecx
    push %edx
    jmp compara

stampa_neg:
    movl $'-', (%edi)
    inc %edi
    movl $0, neg
    jmp stampa

stampa:
    cmp $1, neg
    je stampa_neg
    popl %eax
    addl $'0', %eax
    movl %eax, (%edi)
    inc %edi
    loop stampa

fine:

    popl %edi
    popl %edx
    popl %ecx
    popl %ebx

    ret
