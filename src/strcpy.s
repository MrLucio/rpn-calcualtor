.section .text
    .global strcpy

.type strcpy, @function

strcpy:

    pushl %esi          # salvo i valori dei registri general purpose
    pushl %edi          #

    movl 12(%esp), %esi
    movl 16(%esp), %edi

    cld                 # clear direction flag

cicle:

    cmp $0, (%esi)      # controllo se ho raggiunto lo \0
    je end

    movsb               # copia il primo byte dalla posizione
                        # puntata da esi al primo byte
                        # della posizione puntata da edi

    jmp cicle

end:

    movb $0, (%edi)

    popl %edi           #
    popl %esi           # ripristino i valori dei registri general purpose

ret
