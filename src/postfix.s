.section .data
    integer: .long 0
    esp_value: .long 0
    invalid_str: .ascii "Invalid\0"
    op: .byte 0
    neg: .byte 0

.section .text
    .global postfix

.type postfix, @function

postfix:

    pushl %ebx          #
    pushl %ecx          #
    pushl %edx          # salvo i valori dei registri general purpose
    pushl %esi          # 
    pushl %edi          #

    movl %esp, esp_value

    movl 24(%esp), %esi     # recupero l'indirizzo di input
    movl 28(%esp), %edi     # recupero l'indirizzo di output

    movl $0, neg

cicle:                  # ciclo i caratteri di input

    xorl %ebx, %ebx     # azzero ebx

    movb (%esi), %bl    # carico un carattere dall'input

    inc %esi            # punto al prossimo carattere

    cmpb $0, %bl        # char == '\0'
    je check_result

    cmpb $' ', %bl      # char == ' '
    je save_result

check_op:               # controllo se il carattere è un operando

    movb $1, op         # op = true

    cmpb $'+', %bl      # char == '+'
    je _sum

    cmpb $'-', %bl      # char == '-'
    je check_neg

    cmpb $'*', %bl      # char == '*'
    je _mul

    cmpb $'/', %bl      # char == '/'
    je _div

check_int:

    movb $0, op         # op = false

    cmpb $'0', %bl      # il carattere non rappresenta un intero (< '0')
    jl errore
    cmpb $'9', %bl      # il carattere non rappresenta un intero (> '9')
    jg errore

    subb $'0', %bl      # converto il carattere nell'intero rappresentato

    movl $10, %eax      # moltiplico l'intero per 10
    mull integer        # l'intero si troverà in eax 

    addl %ebx, %eax    # sommo la cifra al nuovo intero
    movl %eax, integer  # salvo il nuovo intero

    jmp cicle           # ricomincio il ciclo

check_neg:              # 

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

    cmpb $' ', (%esi)       # presenza di due caratteri spazio
    je errore

    cmpb $1, op             # il carattere precedente era un operando
    je cicle

    movl integer, %eax      # salvo l'intero letto con l'opportuno segno
    cmpb $0, neg
    je save_integer

    neg %eax

save_integer:

    pushl %eax

    movl $0, neg
    movl $0, integer

    jmp cicle

_sum:
    popl %eax
    addl %eax, (%esp)     # (esp) = (esp) + eax
    jmp cicle

_sub:
    popl %eax
    subl %eax, (%esp)      # (esp) = (esp) - eax
    jmp cicle

_mul:
    popl %eax
    popl %ecx
    imull %ecx             # eax = eax * ecx
    pushl %eax
    jmp cicle

_div:
    xorl %edx, %edx       # pulisco edx
    popl %ecx
    popl %eax
    idivl %ecx             # eax = eax / ecx
    pushl %eax
    jmp cicle

errore:

    leal invalid_str, %esi    # carico l'indirizzo della variabile d'errore

    pushl %edi          # carico l'indirizzo di output
    pushl %esi          # carico l'indirizzo della variabile d'errore

    call strcpy         # chiamo la funzione di copia

    jmp fine

check_result:

    popl %eax           # l'ultimo elemento sullo stack sarà il risultato
    cmpl $0, %eax        # controllo se il risultato è negativo
    jge write_result

    neg %eax            # il risultato è negativo, lo nego e diventa positivo
    movl $'-', (%edi)   # aggiungo il segno meno come primo carattere di output
    incl %edi

write_result:

    pushl %edi          # specifico l'output per la funzione itoa
    call itoa           # carico il risultato sull'output

fine:

    movl esp_value, %esp    # ripristino esp, ignorando tutti gli elementi pushati

    popl %edi           #
    popl %esi           #
    popl %edx           # ripristino i valori dei registri general purpose
    popl %ecx           #
    popl %ebx           #

ret
