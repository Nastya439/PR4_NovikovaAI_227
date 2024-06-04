; multi-segment executable file template.

data SEGMENT
    ; add your data here!
    S DW ? ; ?????????? ??? ???????? ?????????? S (??????? ?????,16 ???)
N DW ? ; ?????????? ??? ???????? ?????????? ???????? N(??????? ?????, 16 ???)
perenos DB 13,10,"$" ; ??????? ???????? ?????? (CR ? LF) ? ?????? ??????????? ??? DOS
vvod_N DB 13,10,"Vvedite N=$" ; ????????? ??????????? ??? ????? N,?????????????? ???????? ????? ??????
vivod_S DB "S=$" ; ????????? ??? ?????? ???????? S
  P DW ?
    pkey DB "press any key...$"
ENDS

stack SEGMENT
    DW   128  dup(0)
ENDS

code SEGMENT
start:
; set segment registers:
    MOV AX, data
    MOV DS, AX
    MOV ES, AX

    ; add your code here
     xor ax, ax ; Обнуление регистра AX
    MOV DX, OFFSET vvod_N ; Загрузка адреса строки приглашения для ввода N в DX
    MOV AH, 9 ; Установка функции DOS для вывода строки
    INT 21h ; Вызов DOS для вывода строки
    MOV AH, 1 ; Установка функции DOS для ввода символа с клавиатуры
    INT 21h ; Вызов DOS
    SUB AL, 30h ; Преобразование ASCII кода цифры в числовое значение
    CBW ; Расширение знака AL в AX (AX=AL для младшего байта и

    MOV N, AX ; Сохранение введенного значения N в переменную N
   
    MOV CX, N ; Установка регистра CX значением N (счётчик цикла)
    MOV AX, 0 ; Обнуление регистра AX (сумма S)
    MOV BX, 3 ; Установка начального значения BX = 2 (B)
@repeat: ; Начало цикла
    ADD AX, BX ; Добавление BX к AX (S = S + B)
    MOV P, AX   
    XOR AX, AX    
    MOV AX,BX
    MOV DL, 3
    MUL DL
    MOV BX,AX
    XOR AX,AX
    MOV AX, P
    LOOP @repeat ; Декремент CX и переход к метке @repeat, если CX != 0
    MOV S, AX ; Сохранение результата вычислений S в переменную S
    MOV DX, OFFSET perenos; Загрузка адреса строки перевода строки в DX
    MOV AH, 9 ; Установка функции DOS для вывода строки
    INT 21h ; Вызов DOS для вывода строки
    MOV DX, OFFSET vivod_S; Загрузка адреса строки "S=$" в DX
    MOV AH, 9 ; Установка функции DOS для вывода строки
    INT 21h ; Вызов DOS для вывода строки
    MOV AX, S ; Загрузка значения S в AX
Lower: ;Вывод многозначного числа на экран
    PUSH -1 ; Метка начала вывода числа, помещаем маркер в стек
    MOV CX, 10 ; Установка делителя 10 в CX
L1:
    MOV DX, 0 ; Обнуление DX (старшая часть делимого для DIV)
    DIV CX ; Деление AX на 10, результат в AX, остаток в DX
    PUSH DX ; Помещение остатка в стек (цифра числа)
    CMP AX, 0 ; Проверка, равен ли результат деления 0
    JNE L1 ; Переход к L1, если результат не 0
    MOV AH, 2 ; Установка функции DOS для вывода символа
L2:
    POP DX ; Извлечение цифры из стека
    CMP DX, -1 ; Проверка, достигли ли маркера
    JE sled8 ; Переход к sled8, если достигли маркера
    ADD DL, 30h ; Преобразование числа в ASCII код
    INT 21h ; Вызов DOS для вывода символа
    JMP L2 ; Переход к L2 для следующей цифры
sled8:
    MOV DX, OFFSET perenos; Загрузка адреса строки перевода строки в DX
    MOV AH, 9 ; Установка функции DOS для вывода строки
    INT 21h     ; output string at ds:dx       
    LEA DX, pkey
    MOV AH, 9
    INT 21h        ; output string at ds:dx
    
    ; wait for any key....    
    MOV AH, 1
    INT 21h
    
    MOV AX, 4c00h ; exit to operating system.
    INT 21h    
ENDS

END start ; set entry point and stop the assembler.
