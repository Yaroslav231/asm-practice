section .bss
    line_buf  resb 512

section .text
    global _start

_start:
    mov rax, 100
    mov rbx, 50

    mov r12, rax
    mov r13, rbx     ;зберегти

    mov rax, r12
    dec rax          ;r14 = width - 1
    mov r14, rax

    mov rax, r13
    dec rax          ;r15 = height - 1
    mov r15, rax

    mov rax, r14
    xor rdx, rdx
    mov rcx, 2       ;поділити на 2 ширину - 1(нумерація з 0) (центр) рез - r8
    div rcx
    mov r8, rax

    mov rax, r15
    xor rdx, rdx
    mov rcx, 2       ;поділити на 2 висоту - 1(нумерація з 0) (центр) рез - r9
    div rcx
    mov r9, rax

    lea rbx, [line_buf]

    xor r10, r10

.y_loop:
    cmp r10, r13                               ;r10 - рахує позицію у строці
    jge .done


    cmp r10, 0
    je .fill_border    ;якщо перший рядок - намалювати полосу

    mov rax, r13
    dec rax            ;якщо останній рядок - намалювати полосу
    cmp r10, rax
    je .fill_border


    mov rax, r10     ;зкопіювати y
    mov rcx, r13
    dec rcx
    mov rbx, rcx
    sub rbx, r10                                        ;обчисл height-1-y
    cmp rax, rbx
    cmova rax, rbx

    mov r11, rax      ;зкопіювати

    cmp r9, 0
    je .zero_centerY   ;якщо centerY == 0 переход к .zero_centerY

    mov rax, r8
    xor rdx, rdx      ;розрахунок позиції по діагоналі
    imul rax, r11

    mov rcx, r9
    shr rcx, 1     ;округлити
    add rax, rcx

    xor rdx, rdx
    mov rcx, r9                            ; розрах координату x по координаті y
    div rcx

    mov r11, rax ;зберегти
    jmp .have_pos

.zero_centerY:
    xor r11, r11

.have_pos:
    mov rax, r14
    sub rax, r11             ;розрахунок x правої діагоналі рез -
    mov r15, rax

    xor rdi, rdi
    lea rsi, [line_buf]          ;підготовка для цикла
.fill_chars:
    cmp rdi, r12
    jge .after_fill_chars       ;поки x < width

    mov byte [rsi + rdi], ' '   ;за амовчуванням пробіл

    cmp rdi, 0
    je .put_star     ;якщо x == 0 - ліва границя, додати '*'

    mov rax, r12
    dec rax
    cmp rdi, rax     ;якщо права границя, додати '*'
    je .put_star

    cmp rdi, r11
    je .put_star   ;якщо x == поз лівої діагоналі

    cmp rdi, r15
    je .put_star  ;якщо x == поз правої діагоналі

    jmp .inc_x    ;наступна позиція

.put_star:
    mov byte [rsi + rdi], '*'     ;додати зірку

.inc_x:
    inc rdi
    jmp .fill_chars      ;наступний байт (позиція)

.after_fill_chars:
    mov rax, r12
    mov byte [rsi + rax], 10     ;додати \n

    mov rax, 1
    mov rdi, 1
    mov rdx, r12
    inc rdx
    mov rsi, rsi
    syscall              ;вивести строку

    inc r10
    jmp .y_loop



;-------------------------------друкує строку заповнену '*' для початку та нінця {
.fill_border:
    lea rsi, [line_buf]
    xor rdi, rdi
.fill_border_loop:
    cmp rdi, r12
    jge .after_border_fill
    mov byte [rsi + rdi], '*'        ;заповнити буфер (додавати поки rdi < width)
    inc rdi
    jmp .fill_border_loop
.after_border_fill:
    mov rax, r12
    mov byte [rsi + rax], 10     ;додати \n
    mov rax, 1
    mov rdi, 1
    mov rdx, r12
    inc rdx
    mov rsi, rsi
    syscall             ;надрукувати
    inc r10
    jmp .y_loop
;-------------------------------}


.done:
    mov rax, 60
    xor rdi, rdi
    syscall
