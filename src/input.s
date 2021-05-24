.section .bss
    cifra: .long 0
    intero: .long 0

.section .data
    error: .ascii "Invalid\0"
    output: .ascii ""
    op: .byte 1
    neg: .byte 1

.section .text
    .global postfix

postfix:

    pushl %eax          #
    pushl %ebx          #
    pushl %ecx          # salvo i valori dei registri general purpose
    pushl %edx          #
    pushl %esi          # 
    pushl %edi          #

    movl 28(%esp), %esi # recupero l'indirizzo di input
    movl 32(%esp), %edi # recupero l'indirizzo di output

ciclo:

    xorl %ebx, %ebx     # azzero ebx
    movl $0, cifra      # azzero la cifra

    movb (%esi), %bl    # carico un carattere dall'input

    inc %esi            # punto al prossimo carattere

    cmp $0, %bl         # cifra == '\0'
    je fine

    cmp $' ', %bl       # cifra == ' '
    je salva_intero

check_op:

    cmpb $'+', %bl          # somma
    je my_sum

    cmpb $'-', %bl          # sottrazione
    je check_neg

    cmpb $'*', %bl          # moltiplicazione
    je my_mul

    cmpb $'/', %bl          # divisione
    je my_div

check_int:

    subl $'0', %ebx     # converto il carattere in intero

    cmp $0, %ebx        # il carattere non è intero (< 0)
    jl errore
    cmp $9, %ebx        # il carattere non è intero (> 9)
    jg errore

    movl %ebx, cifra    # salvo la cifra

    movl $10, %eax      # moltiplico l'intero per 10
    mull intero         # l'intero si troverà in eax 

    addl cifra, %eax    # sommo la cifra al nuovo intero
    movl %eax, intero   # 

    # -----------------------

    jmp ciclo

check_neg:

    cmpb $' ', 1(%esi)
    je my_sub

    cmpb $0, 1(%esi)
    je my_sub

    cmpb $'0', 1(%esi)      # il carattere non è intero (< 0)
    jl errore
    cmpb $'9', 1(%esi)      # il carattere non è intero (> 9)
    jg errore

    movb $1, neg

    jmp ciclo

my_sum:
    popl %eax               # carico il primo numero in eax
    addl %eax, (%esp)       # sommo e carico il risultato in eax
    jmp ciclo

my_sub:
    popl %eax
    sub %eax, (%esp)        # (%esp) = eax - ebx
    jmp ciclo

my_mul:
    popl %eax
    popl %ecx
    imul %ecx             # eax = eax * ecx
    pushl %eax
    jmp ciclo

my_div:
    xorl %edx, %edx
    popl %ecx
    popl %eax
    idiv %ecx             # eax = eax / ecx
    pushl %eax
    jmp ciclo

salva_intero:

    pushl intero

    movl $0, neg
    movl $0, intero

    jmp ciclo

errore:

    leal error, %esi    # carico l'indirizzo della variabile d'errore

    pushl %edi          # carico l'indirizzo di output
    pushl %esi          # carico l'indirizzo della variabile d'errore

    call strcpy         # chiamo la funzione di copia

    addl $8, %esp       #

fine:

    popl %eax
    movl %eax, (%edi)  # carico il risultato sull'output

    popl %edi           #
    popl %esi           # ripristino i valori dei registri general purpose
    popl %edx           #
    popl %ecx           #
    popl %ebx           #
    popl %eax           #

ret
