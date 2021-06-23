.section .text
    .global strcpy

.type strcpy, @function

strcpy:

    pushl %esi          # salvo i valori dei registri general purpose
    pushl %edi          #

    movl 12(%esp), %esi
    movl 16(%esp), %edi

    cld # clear direction flag

ciclo:

    cmp $0, (%esi)
    je fine

    movsb

    jmp ciclo

fine:

    movb $0, (%edi)

    popl %edi           #
    popl %esi           # salvo i valori dei registri general purpose

ret
