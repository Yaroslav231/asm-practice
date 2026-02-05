section .data
      msg_input     db "input: ", 0
      msg_factorial   db "factorial: ", 0

section .bss
      strBuffer resb 100
      inputBuffer resb 16

section .text
      global _start

_start:
      mov rax, 1
      mov rdi, 1
      mov rsi, msg_input                     ; вивести "input: "
      mov rdx, 8
      syscall

      mov rax, 0
      mov rdi, 0
      lea rsi, [inputBuffer]                 ;rsi - адреса буфера в памяті, rdx - макс байт, rax - кількість прочитаних байт
      mov rdx, 10
      syscall

      xor rcx, rcx         ;використ у strToInt
      xor rax, rax
      call strToInt        ;rsi - буфер з рядком байтів, в rax результат

      mov rcx, rax         ; лічильник
      mov rax, 1           ; акумулятор факторіалу
      call factorial       ; результат - rax

      lea rsi, [strBuffer]       ; посилання на вих буфер для int2str
      call int2str               ; число - rax, початок рядка - rsi
      mov rbx, rsi  ; перенести в інший бо далі syscall

      mov rax, 1
      mov rdi, 1
      mov rsi, msg_factorial                   ; вивести "factorial: "
      mov rdx, 12
      syscall

      mov rsi, rbx
      mov rdx, strBuffer+100
      sub rdx, rsi         ; кількість байтів виводу
      mov rax, 1                              ; вивести число
      mov rdi, 1
      syscall

      mov rax, 60        ; sys_exit
      xor rdi, rdi       ; exit code = 0
      syscall





factorial:
    cmp rcx, 1
    jbe factorial_done

    imul rax, rcx
    dec rcx
    jmp factorial

factorial_done:
    ret



strToInt:
    mov bl, [rsi + rcx]
    cmp bl, 10          ; '\n'
    je strToInt_done

    movzx rbx, bl

    sub rbx, '0'
    imul rax, rax, 10
    add rax, rbx

    inc rcx
    jmp strToInt

strToInt_done:
    ret




int2str:
      mov rcx, 10       ; для ділення на 10
      add rsi, 16       ; до кінця буфера для запису

      mov byte [rsi], 0
      dec rsi
      mov byte [rsi], 10 ; '\n'

.loop:
      dec rsi          ; декремент посилання буфера для запису кодів символів

      xor rdx, rdx                                                                  ; rdx:rax - ділене, в rax - частка, в rdx - остача
      div rcx               ; ecx (10) - дільник

      add dl, '0'               ;додати код нуля для конвертації в код символу  (код цифри вміщується в 8 біт тому dl)
      mov [rsi], dl              ;записати код символу в буфер
      test rax, rax              ;встановити ZF якщо rax 0
      jnz .loop                  ;перехід до початку циклу якщо ZF - 0
      ret                  ;знімання адреси після call
