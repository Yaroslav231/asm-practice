; practice3.asm
; I/O: int 80h
; blocks: I/O, parse, math/logic, loops, memory

BITS 32
GLOBAL _start

SECTION .bss
outbuf resb 16
buf resb 256

SECTION .text
_start:
    mov eax, 3
    mov ebx, 0
    mov ecx, buf
    mov edx, 255
    int 0x80

    xor eax, eax
    mov esi, buf

.parse_loop:           ;вхід esi - посилання на початок числа, вих - eax, використ - ebx, bl
    movzx ebx, byte [esi]

    cmp bl, 10 ;якщо результат 0 то встановити ZF
    je .parse_done ;перейти якщо ZF                    вийти якщо \n

    cmp bl, 0                                         ;вийти якщо 0
    je .parse_done

    sub ebx, '0'        ;перетворення ASCII цифри
    imul eax, eax, 10   ;додавання в десятичну систему зчислення
    add eax, ebx

    inc esi
    jmp .parse_loop

.parse_done:    ;обробка 0
    cmp eax, 0
    jne .convert  ;до convert якщо eax != 0

    mov byte [outbuf], '0' ;запис 0
    mov byte [outbuf + 1], 10  ;запис \n

    mov eax, 4
    mov ebx, 1
    mov ecx, outbuf       ;вивести 0
    mov edx, 2
    int 0x80

    jmp .exit

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
    jnz .convert_loop   ;якщо ZF = 0 (ціле не 0) то повторити

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
