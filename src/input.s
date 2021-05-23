.section .bss
    cifra: .long 0
    totale: .long 0

.section .data

.section .text
    .global postfix

postfix:

    pushl %eax          #
    pushl %ebx          # salvo i valori dei registri general purpose
    pushl %ecx

    movl 16(%esp), %ebx # recupero l'indirizzo di input

ciclo:

    xorl %eax, %eax     # azzero eax

    movb (%ebx), %al    # carico un carattere dall'input

    inc %ebx            # aumento

    cmp $0, %al         # termine stringa
    je fine

    cmp $' ', %al
    je salva_totale

    subl $'0', %eax     # converto il carattere in intero

    movl %eax, cifra

    #cmp $' ', cifra    # spazio
    #je salva_totale

    movl $10, %eax

    mull totale

    addl cifra, %eax
    movl %eax, totale

    movl $0, cifra

    # -----------------------

    jmp ciclo

salva_totale:

    movl $0, totale
    jmp ciclo

fine:

    movl 20(%esp), %ebx  # recupero l'indirizzo di output
    movl totale, %eax

    movl %eax, (%ebx)   # carico il risultato sull'output

    popl %ecx
    popl %ebx           # ripristino i valori dei registri general purpose
    popl %eax           #

ret
