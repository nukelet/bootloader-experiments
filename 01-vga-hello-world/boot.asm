[ORG 0x7c00]
[BITS 16]

; disable interrupts
cli
; set the data segment to 0
xor ax, ax
mov ds, ax
; set direction register to 0
; (string instructions) decrement `si`
cld
; set the stack segment to 0
xor ax, ax
mov ss, ax
; 0x2000 after code start
mov sp, 0x9c00

; ------- start --------
call vga_clear

mov si, msg
call vga_puts

jmp hang

; ----------------------------------------------------

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


; ----------------------------------------------------


hang:
  jmp hang

msg db 'stage 0 loaded, now loading stage 1 bootloader...', 0

times 510 - ($ - $$) db 0
db 0x55
db 0xaa
