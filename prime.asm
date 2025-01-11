section .data

; put your data in this section using
; db (define byte) , dw (define word) , dd (define double word)
; assembler directives

number db 5	; decimal number to test
answer db 1	; decimal number 1 (serves as flag for prime, true)

not_prime_msg db 'Number is NOT prime', 0x0a	; message to be printed if not prime
						; ASCII 0x0a = LINE FEED (for new line)
lenDispMsgNotPrime equ $-not_prime_msg

prime_msg db 'Number is prime', 0x0a   ; message to be printed if prime
                                        ; ASCII 0x0a = LINE FEED (for new line)
lenDispMsgPrime equ $-prime_msg



section .bss

; put UNINITIALIZED data here using
; sum resb 5 format (read as sum reserve bytes 5)
; sum2 resw 5 (reserve 5 words)
; sum3 resd 5 (reserve 5 double words)

section .text

mick:
	mov eax, 4
	mov ebx, 1
	mov ecx, not_prime_msg
	mov edx, lenDispMsgNotPrime
	int 80h 
	ret		; return to ron
; Display that the number is not Prime

charlie: 
	mov eax, 4
	mov ebx, 1
	mov ecx, prime_msg
	mov edx, lenDispMsgPrime
	int 80h
	ret	; return to Done
; Display that the number is Prime

        global _start	; linking the object code file (ld)
			; marking _start as an entry point in 
			; the output executable.
			; run executable starting at _start.

_start:
			; put your code here.
			; THIS IS THE FIRST ASSEMBLY 
			; LANGUAGE INSTRUCTION

        mov esi, number ; load data 'number' 
			; into the complete 32 bits of 
			; a source index register 'esi'.
			; immediate addressing

; register esi is loaded with the address of memory location
; symbolically referred to by 'number'
; the loader will convert the symbol 'number' into some physical
; memory address at load time.

keith:  
	; THIS IS THE SECOND ASSEMBLY LANGUAGE INSTRUCTION

	mov eax, 0	; set register eax to 0 
			; immediate addressing
        mov al, [esi] 	; load data found in memory at address 				
			; 'esi' into register al.
			; register indirect addressing
        mov dl, al	; copy data in register al into register dl
			; the source data is found in the 
			; register al and the destination of 
			; the mov instruction is register dl
			; register addressing
        mov bl, 2 	; load 8 bit divisor (2) into register bl

; AX, the “accumulator”
; BX, the “base index”
; CX, the “count” register
; DX, the “data” register
; BP, the “base pointer” register
; DI, the “destination index” register
; SI, the “source index” register

	; THE REST OF THE PROGRAM IS ENTERED HERE

Looping: 
	div bl			; ax/bl with quotient in al 
				; and remainder in ah
				; unsigned division with result
				; into 16 bit register ax
        and ax, 1111111100000000b 	; ax = ax and immediate data
					; mask 1111111100000000b 
					; ah = remainder (prime if 1's remain)
					; al = quotient (don't care)
	cmp ax, 0	; updating flag with ax-0
			; is ax = 0 ?
	je ron		; if ax=0, jump to ron	
        inc bl		; add 1 to contents of bl register
			; occupies 2 bytes of machine code
			; increment divisor by 1
        cmp bl, dl	; updating flag with bl-dl
			; is bl = dl ?
        je Done		; if current divisor data = number data in dl
        mov eax, 0            	; reset register eax to 0
        mov al, [esi]         	; restore the number back into ax 
        jmp Looping		; loop again

ron: 
	mov byte[answer], 0     ; store 0 into memory location labeled 'answer'
                                ; not prime
                                ; byte specifies size of data being stored
; is the memory operand a byte, word, or doubleword (dword)
; it cannot be unambiguosly determined, hence the
; the assembler will report an error of the form
; error: operation size not specified

	call mick	; invoke the subroutine
			; the call instruction causes program execution
			; to continue with the instruction at label mick
			; the instructions comprising the subroutine
			; are fetched and executed and when the 'return'
			; instruction is executed, program control returns
			; to the instruction immediately following the
			; call mick instruction
	jmp Over	; exit program

Done:  
	call charlie	; invoke the subroutine
			; the call instruction causes program execution
			; to continue with the instruction at label charlie
			; the instructions comprising the subroutine
			; are fetched and executed and when the 'return'
			; instruction is executed, program control returns
			; to the instruction immediately following the
			; call charlie instruction
	jmp Over	; exit program
	
Over:
	mov eax, 1             	; The system call for exit 						
				; (sys_exit)
	mov ebx, 0		; Exit with return code of 0 
				; (no error)
	int 80h 		; control returned to Linux prompt
