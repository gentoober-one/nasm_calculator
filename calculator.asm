section .data
    mensagem_boas_vindas db '=== Calculadora em Assembly x86 ===', 0x0A, 0x00
    tamanho_boas_vindas equ $ - mensagem_boas_vindas

    msg_escolha_operacao db 'Escolha a operação (+, -, *, /): ', 0x00
    tamanho_msg_operacao equ $ - msg_escolha_operacao

    msg_digite_num1 db 'Digite o primeiro número: ', 0x00
    tamanho_msg_num1 equ $ - msg_digite_num1

    msg_digite_num2 db 'Digite o segundo número: ', 0x00
    tamanho_msg_num2 equ $ - msg_digite_num2

    msg_resultado db 'Resultado: ', 0x00
    tamanho_msg_resultado equ $ - msg_resultado

    quebra_linha db 0x0A, 0x00
    tamanho_quebra_linha equ $ - quebra_linha

section .bss
    operacao    resb 0x02
    numero1     resb 0x0A
    numero2     resb 0x0A
    resultado   resb 0x0A
    buffer_temp resb 0x0A

section .text
    global _start

_start:
    call imprimir_boas_vindas
    call obter_operacao
    call obter_numero1
    call obter_numero2

    ; Converter strings para inteiros
    mov eax, numero1
    call str_para_int
    mov ebx, eax

    mov eax, numero2
    call str_para_int
    mov ecx, eax

    call executar_operacao
    call imprimir_resultado

    ; Encerrar programa
    mov eax, 0x01
    xor ebx, 0x00
    int 0x80

; ---------------------------------------
imprimir_boas_vindas:
    mov eax, 0x04
    mov ebx, 0x01
    mov ecx, mensagem_boas_vindas
    mov edx, tamanho_boas_vindas
    int 0x80
    ret

obter_operacao:
    mov eax, 0x04
    mov ebx, 0x01
    mov ecx, msg_escolha_operacao
    mov edx, tamanho_msg_operacao
    int 0x80

    mov eax, 0x03
    mov ebx, 0x00
    mov ecx, operacao
    mov edx, 0x02
    int 0x80
    ret

obter_numero1:
    mov eax, 0x04
    mov ebx, 0x01
    mov ecx, msg_digite_num1
    mov edx, tamanho_msg_num1
    int 0x80

    mov eax, 0x03
    mov ebx, 0x00
    mov ecx, numero1
    mov edx, 0x0A
    int 0x80
    ret

obter_numero2:
    mov eax, 0x04
    mov ebx, 0x01
    mov ecx, msg_digite_num2
    mov edx, tamanho_msg_num2
    int 0x80

    mov eax, 0x03
    mov ebx, 0x00
    mov ecx, numero2
    mov edx, 0x0A
    int 0x80
    ret

; ---------------------------------------
executar_operacao:
    mov al, [operacao]
    cmp al, '+'
    je operacao_soma
    cmp al, '-'
    je operacao_subtracao
    cmp al, '*'
    je operacao_multiplicacao
    cmp al, '/'
    je operacao_divisao
    jmp fim_operacao

operacao_soma:
    add ebx, ecx
    jmp armazenar_resultado

operacao_subtracao:
    sub ebx, ecx
    jmp armazenar_resultado

operacao_multiplicacao:
    imul ebx, ecx
    jmp armazenar_resultado

operacao_divisao:
    cmp ecx, 0x00
    je fim_operacao
    xor edx, edx
    mov eax, ebx
    idiv ecx
    mov ebx, eax
    jmp armazenar_resultado

armazenar_resultado:
    mov eax, ebx
    call int_para_str
    ret

; ---------------------------------------
imprimir_resultado:
    mov eax, 0x04
    mov ebx, 0x01
    mov ecx, msg_resultado
    mov edx, tamanho_msg_resultado
    int 0x80

    mov eax, 0x04
    mov ebx, 0x01
    mov ecx, resultado
    mov edx, 0x0A
    int 0x80

    mov eax, 0x04
    mov ebx, 0x01
    mov ecx, quebra_linha
    mov edx, tamanho_quebra_linha
    int 0x80
    ret

fim_operacao:
    ret

; ---------------------------------------
; Converte string para inteiro
str_para_int:
    mov esi, eax
    xor eax, eax
    xor edx, edx
.conversao_loop:
    mov dl, [esi]
    cmp dl, 0x00
    je .fim
    cmp dl, 0x0A   ; '\n'
    je .fim
    cmp dl, 0x0D   ; '\r'
    je .fim
    sub dl, '0'
    cmp dl, 0x09
    ja .fim
    imul eax, 0x0A
    add eax, edx
    inc esi
    jmp .conversao_loop
.fim:
    ret

; ---------------------------------------
; Converte inteiro para string
int_para_str:
    ; Limpar buffer de saída
    mov edi, resultado
    mov ecx, 0x0A
.limpar_loop:
    mov byte [edi], 0x00
    inc edi
    loop .limpar_loop

    ; Preparar para conversão
    mov esi, buffer_temp
    mov edi, resultado
    mov ebx, 0x0A
    xor ecx, ecx

.conversao_itoa:
    xor edx, edx
    div ebx
    add dl, '0'
    mov [esi + ecx], dl
    inc ecx
    test eax, eax
    jnz .conversao_itoa

    ; Inverter
    mov eax, ecx
    mov esi, buffer_temp
    add edi, ecx
    mov byte [edi], 0x00

.inverter_loop:
    dec edi
    mov dl, [esi]
    mov [edi], dl
    inc esi
    loop .inverter_loop
    ret


