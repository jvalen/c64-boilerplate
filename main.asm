        !cpu 6502
        !to "build/bp.prg",cbm                  ; output file

        * = $0801                               ; BASIC start address (#2049)
        !byte $0d,$08,$dc,$07,$9e,$20,$34,$39   ; BASIC loader to start at $c000
        !byte $31,$35,$32,$00,$00,$00           ; puts BASIC line 2012 SYS 49152
        * = $c000     				; start address for 6502 code

        sei

        jsr init_screen                         ; clear the screen
        jsr sid_init                            ; init music routine now

        ldy #$7f    ; $7f = %01111111
        sty $dc0d   ; Turn off CIAs Timer interrupts
        sty $dd0d   ; Turn off CIAs Timer interrupts
        lda $dc0d   ; cancel all CIA-IRQs in queue/unprocessed
        lda $dd0d   ; cancel all CIA-IRQs in queue/unprocessed

        lda #$01    ; Set Interrupt Request Mask...
        sta $d01a   ; ...we want IRQ by Rasterbeam

        lda $d011   ; Bit#0 of $d011 is basically...
        and #$7f    ; ...the 9th Bit for $d012
        sta $d011   ; we need to make sure it is set to zero

        lda #<irq   ; point IRQ Vector to our custom irq routine
        ldx #>irq
        sta $314    ; store in $314/$315
        stx $315

        lda #$00    ; trigger first interrupt at row zero
        sta $d012

        cli         ; clear interrupt disable flag
        jmp *       ; infinite loop

; custom interrupt routine
irq     dec $d019        ; acknowledge IRQ

        jsr sid_play	 ; jump to play music routine
        inc $d020        ; flash color background

        jmp $ea81        ; return to kernel interrupt routine


; load source
!source "src/constants.asm"

!source "src/init_clearscreen.asm"

!source "src/load_res.asm"
