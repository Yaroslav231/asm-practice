section .bss                         ; сегмент не ініціал даних
      buffer resb 16                 ; виділити 16 байт


section .text
      global _start


_start:
      mov rax, 1234567
      lea rsi, [buffer]
      call int2str
                          ; rsi після int2str = перший символ рядка
      mov rdx, buffer+16  ; кінець буфера
      sub rdx, rsi        ; rdx = довжина рядка

      mov rax, 1
      mov rdi, 1
      syscall

      mov rax, 60
      xor rdi, rdi             ;повернути 0
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
      test rax, rax              ;встановити ZF якщо eax 0
      jnz .loop                  ;перехід до початку циклу якщо ZF - 0
      ret                  ;знімання адреси після call

