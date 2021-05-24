.section .data

.section .text
    .global strcpy

.type strcpy, @function

strcpy:

    pushl %eax          #
    pushl %esi          # salvo i valori dei registri general purpose
    pushl %edi          #

    movl 16(%esp), %esi
    movl 20(%esp), %edi

ciclo:

    cmp $0, (%esi)
    je fine

    movb (%esi), %al
    movb %al, (%edi)

    inc %esi
    inc %edi

    jmp ciclo    

fine:

    popl %edi           #
    popl %esi           # salvo i valori dei registri general purpose
    popl %eax           #

ret
