; bootloader.asm
; simple bootloader

org 0x7c00
bits 16
start: jmp boot

;; Constants and variable definitions
msg db "Welcome to My Operating System!", 0ah, 0h
msg2 db "This is a breaking line", 0ah, 0h

boot:
    cli ; no interrupts
    cld ; all that we need to init
    call InitCursor
    mov si, msg
    call Print
    mov si, msg2
    call Print
    hlt ; halt the system

; 512 bytes, clear the rest

; Variables
_CurX db 0
_CurY db 0



InitCursor:
    mov bh, 0
    mov ah, 3
    int 10h
    mov [_CurX], dl
    mov [_CurY], dh
    ret


;**************************************************;
;	MovCur ()
;		- Moves the cursor on the screen
;   dh = Y coordinate
;   dl = X coordinate
;**************************************************;

MovCur:
    mov bh, 0
    mov ah, 2
    int 10h

    mov [_CurX], dl
    mov [_CurY], dh
    ret


;**************************************************;
;	PutChar ()
;		- Prints a character to screen
;	AL = Character to print
;	BL = text color
;	CX = number of times character is display
;**************************************************;
PutChar:
    cmp al, 0ah ; if al == '\n'
    je lf

	mov bh, 0
	mov ah, 0ah
	int 10h

	add [_CurX], cx
	mov dl, [_CurX]
	mov dh, [_CurY]
	call MovCur
    ret

    lf: ; life feed
    mov bh, 0
    mov ah, 3
    add dh, 1
    mov dl, 0
    call MovCur

    ;add [_CurY], cx
    ;mov cx, 0
    ;mov [_CurX], cx
    ;mov dl, [_CurX]
    ;mov dh, [_CurY]
    ;call MovCur

	ret

;***************************************;
;	Prints a string
;	DS:SI: 0 terminated string
;***************************************;
Print:
.loop:
	lodsb					; load next byte from string from SI to AL
	or			al, al		; Does AL=0?
	jz			.done	; Yep, null terminator found-bail out
	mov cx, 1
  call PutChar
	jmp .loop		; Repeat until null terminator found
.done:
	ret					; we are done, so return



times 510 - ($-$$) db 0
dw 0xAA55 ; Boot signature




