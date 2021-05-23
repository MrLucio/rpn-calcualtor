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
neg:
    .byte 1
test:
    .ascii "-4"

.section .text
    .global _start

_start:
    #4 2 +
    push $4
    push $2
    popl %ebx
    popl %eax
    movb $0, neg
    leal test, %esi
    movb (%esi), %cl

    #somma
    cmpb %cl, piu
    je somma

    #sottrazione
    cmp %cl, meno
    je minus

    #moltiplicazione
    cmp %cl, per
    je moltiplicazione

    #divisione
    cmp %cl, div
    je divisione

somma:
    add %ebx, %eax
    jmp exit

minus:
    cmpb $' ', 1(%esi) 
    je sottrazione
    movb $1, neg
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
