# NASM_Calculator

Uma calculadora simples de inteiros escrita em Assembly x86 (NASM) para sistemas Linux de 32 bits.  
Permite realizar operações básicas: adição, subtração, multiplicação e divisão.

## 🛠 Requisitos

- Linux (x86)
- [NASM](https://www.nasm.us/) (Netwide Assembler)
- `ld` (link editor do binutils)

## 📦 Compilação

```bash
nasm -f elf32 calculator.asm -o calculator.o
ld -m elf_i386 calculator.o -o calculator
```

## ▶️ Execução

```bash
./calculator
```

## 💻 Exemplo de uso

```
=== Calculadora em Assembly x86 ===
Escolha a operação (+, -, *, /): +
Digite o primeiro número: 20
Digite o segundo número: 30
Resultado: 50
```

## 📄 Arquivos

- `calculator.asm` — código-fonte da calculadora.

## 📚 Aprendizado

Esse projeto teve como objetivo exercitar:

- Manipulação de strings e inteiros em Assembly
- Uso de chamadas de sistema Linux via `int 0x80`
- Entrada/saída padrão (stdin/stdout)
- Lógica de controle e conversão numérica manual (sem bibliotecas)

## 🧠 Observações

- Só aceita inteiros positivos.
- As entradas devem conter apenas números (sem validação robusta ainda).
- Divisão por zero é ignorada silenciosamente.

