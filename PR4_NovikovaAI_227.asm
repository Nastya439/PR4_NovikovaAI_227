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
     xor ax, ax ; ��������� �������� AX
    MOV DX, OFFSET vvod_N ; �������� ������ ������ ����������� ��� ����� N � DX
    MOV AH, 9 ; ��������� ������� DOS ��� ������ ������
    INT 21h ; ����� DOS ��� ������ ������
    MOV AH, 1 ; ��������� ������� DOS ��� ����� ������� � ����������
    INT 21h ; ����� DOS
    SUB AL, 30h ; �������������� ASCII ���� ����� � �������� ��������
    CBW ; ���������� ����� AL � AX (AX=AL ��� �������� ����� �

    MOV N, AX ; ���������� ���������� �������� N � ���������� N
   
    MOV CX, N ; ��������� �������� CX ��������� N (������� �����)
    MOV AX, 0 ; ��������� �������� AX (����� S)
    MOV BX, 3 ; ��������� ���������� �������� BX = 2 (B)
@repeat: ; ������ �����
    ADD AX, BX ; ���������� BX � AX (S = S + B)
    MOV P, AX   
    XOR AX, AX    
    MOV AX,BX
    MOV DL, 3
    MUL DL
    MOV BX,AX
    XOR AX,AX
    MOV AX, P
    LOOP @repeat ; ��������� CX � ������� � ����� @repeat, ���� CX != 0
    MOV S, AX ; ���������� ���������� ���������� S � ���������� S
    MOV DX, OFFSET perenos; �������� ������ ������ �������� ������ � DX
    MOV AH, 9 ; ��������� ������� DOS ��� ������ ������
    INT 21h ; ����� DOS ��� ������ ������
    MOV DX, OFFSET vivod_S; �������� ������ ������ "S=$" � DX
    MOV AH, 9 ; ��������� ������� DOS ��� ������ ������
    INT 21h ; ����� DOS ��� ������ ������
    MOV AX, S ; �������� �������� S � AX
Lower: ;����� ������������� ����� �� �����
    PUSH -1 ; ����� ������ ������ �����, �������� ������ � ����
    MOV CX, 10 ; ��������� �������� 10 � CX
L1:
    MOV DX, 0 ; ��������� DX (������� ����� �������� ��� DIV)
    DIV CX ; ������� AX �� 10, ��������� � AX, ������� � DX
    PUSH DX ; ��������� ������� � ���� (����� �����)
    CMP AX, 0 ; ��������, ����� �� ��������� ������� 0
    JNE L1 ; ������� � L1, ���� ��������� �� 0
    MOV AH, 2 ; ��������� ������� DOS ��� ������ �������
L2:
    POP DX ; ���������� ����� �� �����
    CMP DX, -1 ; ��������, �������� �� �������
    JE sled8 ; ������� � sled8, ���� �������� �������
    ADD DL, 30h ; �������������� ����� � ASCII ���
    INT 21h ; ����� DOS ��� ������ �������
    JMP L2 ; ������� � L2 ��� ��������� �����
sled8:
    MOV DX, OFFSET perenos; �������� ������ ������ �������� ������ � DX
    MOV AH, 9 ; ��������� ������� DOS ��� ������ ������
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
