[ORG 0x7e00]
[BITS 16]

mov si, msg_loaded
call vga_puts

; vga_puts(str: si)
vga_puts:
  push gs
  push ax
  push bx
  mov ax, 0xb000
  mov gs, ax
  mov bx, 0x8000
vga_puts_loop:
  ; magic breakpoint for debugging in bochs
  xchg bx, bx
  ; clear ax
  xor ax, ax

  ; 0x07 = gray text on black background
  mov ah, 0x07
  lodsb
  
  ; check if current char is 0 (null terminator)
  or al, al
  jz vga_puts_done

  mov [gs:bx], ax
  add bx, 2
  jmp vga_puts_loop
vga_puts_done:
  pop bx
  pop ax
  pop gs
  ret

; ----------------------------------------------------

vga_clear:
  push gs
  push ax
  push bx
  mov ax, 0xb000
  mov gs, ax
  mov bx, 0x8000
  ; 0x0700 = blank text on black background
  mov ax, 0x0700
vga_clear_loop:
  xchg bx, bx

  ; check if we're at the end of the
  ; VGA char buffer of size 80x25x2 = 0xfa0
  cmp bx, 0x8fa0
  jz vga_clear_done

  mov [gs:bx], ax
  inc bx
  jmp vga_clear_loop
vga_clear_done:
  pop bx
  pop ax
  pop gs
  ret

msg_loaded db 'loaded second stage bootloader!', 0
