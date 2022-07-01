;===========================================================;
; copyright (c) 2022 ITA18                                  ;
; Author:   Francisco Fischer                               ;
; Date:     06.28.2022                                      ;
;                                                           ;
; This bootloader loads the next 128 sectors after it into  ;
; RAM and gives control to the Kernel to allocate the rest  ;
;===========================================================;


[bits 16]

section .boot
global stage0
stage0:
    
    mov     [drive_number], dl      ; save the drive number for later

    call    clear_gprs              ; clear all general purpose registers

    ; although the int 13h function 2 assumes a floppy drive,
    ; the disk controller automatically translates the CHS to the correct address
    ; we will keep using it as if it were an actual
    ; floppy drive for simplicity reasons

    mov     ah, READ_SECTORS
    mov     al, 0x7f				; load 127 sectors
    mov     ch, CYLINDER_0			
    mov     cl, SECTOR_2
    mov     dl, [drive_number]
    mov     dh, HEAD_0
    int     DISK_SERVICE_13h
    jc      disk_err                ; carry flag is set upon error
    
	
	cli                             ; we stop bullying the processor
    mov     eax, cr0                ; get the current cr0 value
    or      eax, PM_BIT             ; set the protected mode bit
    mov     cr0, eax                ; set cr0 to the new value

    lgdt    [gdt_address]           ; load the gdtr with the descriptor address
    
    jmp    dword k_code_seg:protected  ; jump to sector 2 (CS:IP, CS = 8, IP = stage1)

[bits 32]

protected:
	
    jmp $
    mov     ax, 3
    jmp     hang

   
; ==clear all gprs==

[bits 16]

clear_gprs:
    
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx

    ret

; ==externally linked symbols==

extern stage1                       ; second sector (stage1.c)

; ==control register bits==

;==cr0==

PM_BIT      equ 1

;===========================================================;
;                 global descriptor table                   ;                   
;===========================================================;

; ==gdt attributes==

A           equ 0           ; accessed bit 
W           equ 1 << 1      ; write bit
R           equ ~(W) << 1   ; read bit
X           equ 1 << 3      ; execute bit
RO          equ ~(X) << 3   ; read-only bit
SET         equ 1 << 4      ; set bit
PRESENT     equ 1 << 7      ; present bit

; ==privilege levels==

RING_0      equ 0 << 5      ; Kernel space
RING_1      equ 1 << 5       
RING_2      equ 2 << 5      
RING_3      equ 3 << 5      ; User space

; ==gdt and descriptor addresses==

gdt_address                 equ (gdt_end - gdt_start) - 1
k_code_seg                  equ kernel_code - gdt_start
k_data_seg                  equ kernel_data - gdt_start

; ==global descriptor table==
dq 0xefbeadde
gdt_start:

null:
; dq    0
	dw 0x0000
	dw 0x0000

kernel_code:     
     
    dw 0xffff
    dw 0x0000
    db 0x00
    db ( A | R | X | SET | RING_0 | PRESENT ) ; 0x9a
    db 0xcf
	db 0x00

kernel_data:

    dw 0xffff
    dw 0x0000
    db 0x00
    db ( A | W | RO | SET | RING_0 | PRESENT ) ; 0x92
    db 0xcf
	db 0x00 

gdt_end:
dq 0xefbeadde
;===========================================================;
;                       disk managment                      ;                   
;===========================================================;

SECTOR_2                    equ 2
CYLINDER_0                  equ 0
HEAD_0                      equ 0
; DL will be loaded with the drive number at startup
; so we save it here

drive_number:
   
   db 0

disk_err:
    
    jmp hang
;==========================================================;
;               BIOS routines and functions                ;
;==========================================================;
DISK_SERVICE_13h            equ 0x13
READ_SECTORS                equ 2

;==========================================================;
;                    hang the cpu                          ;
;==========================================================;

hang:

    cli   
    hlt
    jmp hang














; there’s nothing to see down here...
; go somewhere else!

