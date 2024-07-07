; boot.asm
[ORG 0x7c00]

; magic breakpoint for Bochs
  xchg bx, bx
; disable interrupts
  cli

; 16-bit segmentation: XXXX:YYYY = 16 * XXXX + YYYY
  xor ax, ax
; note this means we start from 0x10 * 0x07c0 == 0x7c00
  mov ds, ax
; this is a fun one... x86 has a register called
; DF (direction flag) that defines the direction of
; increment/decrement for string operations;
; for example, `lodsb` reads a byte from [ds:si]
; and increments si if df == 0, or decrements it
; if df == 1. fun! cld = clear DF, std = set DF
  cld

  mov si, msg
  call bios_print
  jmp hang

bios_print:
  ; lodsb: load byte at [ds:si] into al
  lodsb
  or al, al
  jz bios_print_done
  mov ah, 0x0E
  ; mov bh, 0
  int 0x10
  jmp bios_print
bios_print_done:
  ret

hang:
  jmp hang


  msg db 'Hello world!', 0x00

; this adds zero-padding until the last 2 bytes,
; where we then write the BIOS magic number
; (0xAA55, litte-endian)
  times 510 - ($ - $$) db 0
  db 0x55
  db 0xAA
