section .data
      msg_num     db "number: ", 0
      msg_prime   db " prime", 10, 0
      msg_not     db " not prime", 10, 0

section .bss
      buffer resb 16

section .text
      global _start

_start:

      mov ax, 12              ; число в ax
      movzx ebx, ax              ; в ін регістр оскільки rax використов у syscall

      mov rax, 1
      mov rdi, 1
      mov rsi, msg_num                     ; вивести "Number: "
      mov rdx, 8
      syscall

      movsxd rax, ebx           ; число в rax для функ int2str
      lea rsi, [buffer]       ; запис у буфер для int2str
      call int2str

      mov rdx, buffer+16
      sub rdx, rsi         ; кількість байтів виводу
      mov rax, 1                              ; вивести число
      mov rdi, 1
      syscall

      mov eax, ebx
      cmp eax, 2
      jl not_prime

      mov ecx, 2              ; дільник

check_loop:
      mov eax, ebx   ; відновити число для ділення
      xor edx, edx
      div ecx

      test edx, edx
      jz not_prime     ;перехід до not_prime якщо ZF - 1

      inc ecx          ; інкремент дільника для наступної спроби
      cmp ecx, ebx
      jl check_loop       ; якщо ecx < ebx (SF не дорівн OF) то продовжити

prime:
      mov rax, 1
      mov rdi, 1
      mov rsi, msg_prime       ; вивести що число просте
      mov rdx, 8     ; 6 сим , \n , 0
      syscall
      jmp exit

not_prime:
      mov rax, 1
      mov rdi, 1
      mov rsi, msg_not           ; вивести що число не просте
      mov rdx, 12    ; 10 сим , \n , 0
      syscall

exit:
      mov rax, 60
      xor rdi, rdi                ; повернути 0
      syscall



int2str:
      mov rcx, 10       ; для ділення на 10
      add rsi, 16       ; до кінця буфера для запису
      mov byte [rsi], 0 ; null terminator (завершення рядка)

.loop:
      dec rsi          ; декремент посилання буфера для запису кодів символів

      xor rdx, rdx                                                                  ; rdx:rax - ділене, в rax - частка, в rdx - остача
      div rcx               ; ecx (10) - дільник

      add dl, '0'               ;додати код нуля для конвертації в код символу  (код цифри вміщується в 8 біт тому dl)
      mov [rsi], dl              ;записати код символу в буфер
      test rax, rax              ;встановити ZF якщо rax 0
      jnz .loop                  ;перехід до початку циклу якщо ZF - 0
      ret                  ;знімання адреси після call
