BITS 32
GLOBAL _start

SECTION .bss
outbuf resb 16

SECTION .text
_start:
    mov eax, 55555

.convert:
    mov edi, outbuf + 15  ;вказівник в кінець буфера
    mov byte [edi], 10   ;\n кінець
    dec edi              ;зсунути назад

    mov ebx, 10  ;дільник

.convert_loop:
    xor edx, edx
    div ebx     ;ділення (EDX:EAX / EBX, EAX - ціле, EDX - остача)

    add dl, '0'    ;в ASCII
    mov [edi], dl  ;в буфер
    dec edi        ;зсунути

    test eax, eax
    jnz .convert_loop   ;якщо ZF = 0 (є остача) то повторити

    inc edi        ;піля закінч позиція перед першим сим, перемістити до першого
    mov ecx, edi   ;передати адрес строки в ecx

    mov edx, outbuf + 16
    sub edx, edi     ;кількість байт в edx

    mov eax, 4
    mov ebx, 1
    int 0x80


.exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80