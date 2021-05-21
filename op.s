#comando compilazione
#as --32 -o op.o op.s && ld -m elf_i386 -o op.x op.o && rm op.o && ./op.x
#comando compilazione debugger
#as --32 -gstabs -o op.o op.s && ld -m elf_i386 -o op.x op.o && rm op.o && gdb op.x
#mostrare stack
#x/100x $sp

.section .data
piu:
    .ascii "+"
meno:
    .ascii "-"
per:
    .ascii "*"
div:
    .ascii "/"
test:
    .ascii "-"

.section .text
    .global _start

_start:
    #4 2 +
    push $4
    push $2
    popl %ebx
    popl %eax
    movb test, %cl

    #somma
    movb piu, %dl
    cmp %cl, %dl
    je somma

    #sottrazione
    movb meno, %dl
    cmp %cl, %dl
    je sottrazione

    #moltiplicazione
    movb per, %dl
    cmp %cl, %dl
    je moltiplicazione

    #divisione
    movb div, %dl
    cmp %cl, %dl
    je divisione

somma:
    add %ebx, %eax
    jmp exit

sottrazione:
    sub %ebx, %eax
    jmp exit

moltiplicazione:
    imul %ebx
    jmp exit

divisione:
    movl $0, %edx
    idiv %ebx
    jmp exit

exit:
    pushl %eax
    movl $1, %eax
    int $0x80
