.section .data
    neg: .byte 0

.section .text
	.global itoa

.type itoa, @function   # il numero da convertire si trova in eax

itoa:
    pushl %ebx          #
    pushl %ecx          #
    pushl %edx          #  salvo i valori dei registri general purpose
    pushl %edi          #

    movl 20(%esp), %edi

	movl $0, %ecx		# carica il numero 0 in %ecx

    cmpl $0, %eax       # controllo se il numero è minore di 0
    jge cicle
    neg %eax            # nego il numero
    movl $1, neg

cicle:
    cmpl $10, %eax      # controllo se il numero ha più di una cifra
    jge divide
    inc %ecx            # incremento il contatore di cifre trovate
    push %eax           # salvo la cifra (sarà l'ultima)
    jmp write

divide:
    xorl %edx, %edx
    movl $10, %ebx
    divl %ebx           # eax = eax / ebx
    inc %ecx            # incremento il contatore di cifre trovate
    push %edx           # la cifra si trova in edx, la carico sullo stack
    jmp cicle

write_neg:
    movl $'-', (%edi)   # aggiugno il carattere '-' sull'output
    inc %edi
    movl $0, neg

write:
    cmpb $1, neg        # controllo se il numero è negativo
    je write_neg
    popl %eax           # recupero una cifra dallo stack
    addl $'0', %eax     # converto la cifra in carattere
    movl %eax, (%edi)   # scrivo il carattere sulla posizione di output
    inc %edi            # punto alla prossima posizione di output
    loop write          # continuo finchè ecx != 0

fine:

    popl %edi           #
    popl %edx           #
    popl %ecx           # ripristino i valori dei registri general purpose
    popl %ebx           #

    ret
