int 0x80 - програмне переривання в x86 асемблері, яке використовується зазвичай в 32-бітному linux для звернення до ядра

зазвичай використовуэться така схема аргументів:
EAX	номер системного виклику
EBX	1 аргумент
ECX	2 аргумент
EDX	3 аргумент
ESI	4 аргумент
EDI	5 аргумент
EBP	6 аргумент


найбільш часто використовувані системні виклики:

Syscall	EAX	аргументи	призначення
exit	1	EBX — код	завершити програму
fork	2	—	        створити процес
read	3	EBX — fd,   читати данні
            ECX — buffer,
            EDX — size
write	4	EBX — fd,   записати данні
            ECX — buffer,
            EDX — size
open	5	EBX — path, відкрити файл
            ECX — flags,
            EDX — mode	
close	6	EBX — fd	закрити файл
execve	11	EBX — path, запустити програму
            ECX — argv,
            EDX — envp
chdir	12	EBX — path	змінити каталог
mkdir	39	EBX — path, створити каталог
            ECX — mode	
unlink	10	EBX — path	видалити файл
getpid	20	—	        отримати PID
brk	    45	EBX — address	управління heap
