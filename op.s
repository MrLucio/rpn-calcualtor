#comando compilazione
#as --32 -o op.o op.s && ld -m elf_i386 -o op.x op.o && rm op.o && ./op.x
#comando compilazione debugger
#as --32 -gstabs -o op.o op.s && ld -m elf_i386 -o op.x op.o && rm op.o && gdb op.x
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
    .ascii "/"

.section .text
    .global _start

_start:
    #4 2 +
    push $4
    push $2
    popl %eax
    popl %ebx
    movl (test), %ecx
    cmp %ecx, (piu)
    je somma
    cmp %ecx, (meno)
    je sottrazione
    cmp %ecx, (per)
    je moltiplicazione
    cmp %ecx, (div)
    je divisione

somma:
    add %ebx, %eax
    jmp exit

sottrazione:
    sub %ebx, %eax
    jmp exit

moltiplicazione:
    imul %ebx
    movl %edx, %eax
    jmp exit

divisione:
    idiv %ebx
    jmp exit

exit:
    pushl %eax
    movl $1, %eax
    int $0x80
