.section .bss
    cifra: .long 0
    intero: .long 0

.section .data
    esp_value: .long 0
    error: .ascii "Invalid\0"
    output: .ascii ""
    op: .byte 0
    neg: .byte 0

.section .text
    .global postfix

postfix:

    pushl %eax          #
    pushl %ebx          #
    pushl %ecx          # salvo i valori dei registri general purpose
    pushl %edx          #
    pushl %esi          # 
    pushl %edi          #

    movl %esp, esp_value

    movl 28(%esp), %esi     # recupero l'indirizzo di input
    movl 32(%esp), %edi     # recupero l'indirizzo di output

    movl $0, neg

cicle:

    xorl %ebx, %ebx     # azzero ebx
    movl $0, cifra      # azzero la cifra

    movb (%esi), %bl    # carico un carattere dall'input

    inc %esi            # punto al prossimo carattere

    cmp $0, %bl         # cifra == '\0'
    je check_result

    cmp $' ', %bl       # cifra == ' '
    je save_result

check_op:

    movb $1, op

    cmpb $'+', %bl          # somma
    je _sum

    cmpb $'-', %bl          # sottrazione
    je check_neg

    cmpb $'*', %bl          # moltiplicazione
    je _mul

    cmpb $'/', %bl          # divisione
    je _div

check_int:

    movb $0, op

    subl $'0', %ebx     # converto il carattere in intero

    cmp $0, %ebx        # il carattere non è intero (< 0)
    jl errore
    cmp $9, %ebx        # il carattere non è intero (> 9)
    jg errore

    movl %ebx, cifra    # salvo la cifra

    movl $10, %eax      # moltiplico l'intero per 10
    mull intero         # l'intero si troverà in eax 

    addl cifra, %eax    # sommo la cifra al nuovo intero
    movl %eax, intero   # salvo il nuovo intero

    # -----------------------

    jmp cicle

check_neg:

    cmpb $' ', (%esi)
    je _sub

    cmpb $0, (%esi)
    je _sub

    cmpb $'0', (%esi)      # il carattere non è intero (< 0)
    jl errore
    cmpb $'9', (%esi)      # il carattere non è intero (> 9)
    jg errore

    movb $1, neg

    jmp cicle

save_result:

    cmp $1, op
    je cicle

    movl intero, %eax
    cmp $0, neg
    je save_integer

    neg %eax

save_integer:

    pushl %eax

    movl $0, neg
    movl $0, intero

    jmp cicle

_sum:
    popl %eax               # carico il primo numero in eax
    addl %eax, (%esp)       # sommo e carico il risultato in eax
    jmp cicle

_sub:
    popl %eax
    sub %eax, (%esp)        # (%esp) = eax - ebx
    jmp cicle

_mul:
    popl %eax
    popl %ecx
    imul %ecx             # eax = eax * ecx
    pushl %eax
    jmp cicle

_div:
    xorl %edx, %edx
    popl %ecx
    popl %eax
    idiv %ecx             # eax = eax / ecx
    pushl %eax
    jmp cicle

errore:

    leal error, %esi    # carico l'indirizzo della variabile d'errore

    pushl %edi          # carico l'indirizzo di output
    pushl %esi          # carico l'indirizzo della variabile d'errore

    call strcpy         # chiamo la funzione di copia

    addl $8, %esp       #

    jmp fine

check_result:
    popl %eax
    cmp $0, %eax
    jge write_result

    neg %eax
    movl $'-', (%edi)
    incl %edi

write_result:

    #pushl %edi          # specifico l'output per la funzione itoa
    call itoa           # carico il risultato sull'output

fine:

    movl esp_value, %esp    # ripristino esp, ignorando tutti gli elementi pushati

    popl %edi           #
    popl %esi           #
    popl %edx           # ripristino i valori dei registri general purpose
    popl %ecx           #
    popl %ebx           #
    popl %eax           #

ret
