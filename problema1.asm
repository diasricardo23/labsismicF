;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
			mov		#vetor,R5				; Inicializar vetor em R5
			call	#ORDENA					; Chamar subrotina ORDENA
			jmp		$						; Travar execução ao retornar da subrotina

ORDENA:		mov		@R5,R10					; Guardar tamanho do vetor em R10 (contador)
			sub		#1,R10					; Varrer o vetor n-1 vezes
			mov		@R10,R11				; Guardar tamanho do vetor em R11 (contador auxiliar)
			inc		R5						; Posicionar R5 no primeiro valor do vetor (ponteiro)
			mov		R5,R9					; Guardar posição na memória em R9 (ponteiro auxiliar)
ORD:		mov		@R5,R6					; Guardar valor de R5 em R6
			inc		R5						; Incrementar R5
			cmp		@R5,R6					; Comparar R5(segundo valor) com R6(primeiro valor)
			jlo		ORD2					; Caso R5 seja maior que R6, está ordenado
			mov.b	@R5,R7					; Colocar valor de R5 em R7
			mov.b	R6,0(R5)				; Colocar valor de R6 em R5
			dec		R5						; Decrementar R5
			mov.b	R7,0(R5)				; Colocar valor de R7 em R5
			inc		R5						; Incrementar R5
ORD2:		dec		R9						; Decrementar R9
			jnz		ORD						; Caso não seja zero, pular para ORD
			dec		R10						; Decrementar R10
			jz		FIM						; Contador zerado, ordenação acabou
			mov		R9,R5					; Apontar R5 para posição inicial do vetor
			jmp		ORD
FIM:		ret



                                            

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
            .data
vetor:		.byte	12,"PEDRORICARDO"
