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

.parse_done:
    xor esi, esi  ;очист
    xor edi, edi

    mov ebx, 10

.sum_loop:        ;eax - вх число, вих - esi (сума циф) edi (кількість циф), використ - edx
    test eax, eax
    jz .sum_done    ;завершити якщо eax 0

    xor edx, edx
    div ebx       ;edx:eax / ebx (10)

    add esi, edx  ;додати остачу до суми
    inc edi      ;збільшити кількість цифр

    jmp .sum_loop

.sum_done:
    mov ebp, edi

    mov eax, esi
    call .convert    ;конвертувати та вивести суму
    call .write

    mov eax, ebp
    call .convert    ;конвертувати та вивести кількість цифр
    call .write

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

    ret

.write:
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret


.exit:
    ; I/O: exit
    mov eax, 1
    xor ebx, ebx
    int 0x80