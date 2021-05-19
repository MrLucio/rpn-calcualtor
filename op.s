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
    .ascii "+"

.section .text
    .global _start

_start:
    #3 2 +
    push $2
    push $3
    movl (test), %eax
    cmp %eax, (piu)
    je somma
    popl %ebx
    popl %eax
somma:
    add %ebx, %eax
    pushl %eax

    
