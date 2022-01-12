;===============================================================================
;____| PROJECT DESCRIPTION |____________________________________________________    
; Name: Assembly project template
;
; MCU: PIC16F628A     FOSC: 4 MHz (HS)     TOSC: 1 us
;
; Author: Julio Cesar Kochhann
;                                                                              
; Date: DD.MM.YYYY
;                                                                              
;===============================================================================
;____| RELEASE DATE |__________| VERSION |__________| DEVICE ID |_______________
;       DD.MM.YYYY                 1.0                 H'FFFF'
;
;===============================================================================
;____| WISHLIST |_______________________________________________________________
; 1. New features go here
;
;===============================================================================
;____| KNOWN BUGS |_____________________________________________________________
; 1. Problems that need to be fixed go here
;
;===============================================================================


;===============================================================================
;____| Processor List |_________________________________________________________
    list    P=16F628A


;===============================================================================
;____| Definitions File |_______________________________________________________
    include <p16f628a.inc>


;===============================================================================
;____| Fuse Bits Configuration |________________________________________________
    __CONFIG _FOSC_HS & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF  ; __config 0xFF6A


;===============================================================================
;____| Memory Pagination |______________________________________________________
    #define bank0       bcf     STATUS,RP0      ; Switch to RAM Bank 0
    #define bank1       bsf     STATUS,RP0      ; Switch to RAM Bank 1


;===============================================================================
;____| Global Variables |_______________________________________________________
    cblock  H'20'               ; General Purpose Registers (GPR) start address

        W_TEMP                  ; Temporary registers for context saving
        STATUS_TEMP

        FLAGS1                  ; Flags 1 register

    endc


;===============================================================================
;____| Flags |__________________________________________________________________
    #define MY_FLAG     FLAGS1,0                ; Define MY_FLAG at bit 0 of FLAGS1


;===============================================================================
;____| Constants |______________________________________________________________
TEMPO_DELAY             equ     500     ; EQU associates a number to a name


;===============================================================================
;____| Hardware Mapping |_______________________________________________________
; Inputs
    #define BTN1        PORTA,0         ; Button 1 at RA0
                                        ; 0 -> Button released
                                        ; 1 -> Button pressed

; Outputs
    #define LED1        PORTB,0         ; LED 1 at RB0
                                        ; 0 -> LED off
                                        ; 1 -> LED on


;===============================================================================
;____| Reset Vector |___________________________________________________________
    org     H'0000'                     ; Program start address
    goto    main                        ; Jumps to label 'main'


;===============================================================================
;____| Interrupt Vector |_______________________________________________________
; Context saving
    org     H'0004'                     ; Interrupt start address

    movwf   W_TEMP
    swapf   STATUS,W
    movwf   STATUS_TEMP

; Interrupt service routine body
    nop

; Restore context
exit_ISR:
    swapf   STATUS_TEMP,W
    movwf   STATUS
    swapf   W_TEMP,F
    swapf   W_TEMP,W
    
    retfie                              ; Return from interrupt


;===============================================================================
;____| Macros |_________________________________________________________________
macro1: macro
    bsf     LED1
    endm


;===============================================================================
;____| Program Entry Point |____________________________________________________
main:
    bank0                           ; Switch to RAM bank 0
    
    clrw                            ; Clears accumulator (W)
    movwf   PORTB                   ; Move W to PORTB file (register)
    
    bank1                           ; Switch to RAM bank 1
    
    movlw   B'11111111'             ; Move H'FF' to Work (W)
    movwf   TRISA                   ; Define all PORTA IOs as inputs
    movlw   B'00000000'             ;
    movwf   TRISB                   ; Define all PORTB IOs as outputs

    movlw   B'11000000'             ;
    movwf   OPTION_REG              ; Define operation options

    movlw   B'00000000'             ;
    movwf   INTCON                  ; Define interrupt options
    
    bank0                           ; Return to bank 0
    
    movlw   7                       ;
    movwf   CMCON                   ; Configure CMCON: 7 = disable comparators

; Global variables initialization
    bcf     MY_FLAG                 ; Clear MY_FLAG

    bcf     LED1                    ; Turn off LED 1
    
    movlw   D'255'
    movwf   PORTB


;===============================================================================
;____| Loop Routine |___________________________________________________________
loop:
    ; Loop body

    goto    loop


;===============================================================================
;____| Routines |_______________________________________________________________
routine:
    ; Routine body

    return                          ; Return from routine


;===============================================================================
;____| Program Exit Point |_____________________________________________________
    end