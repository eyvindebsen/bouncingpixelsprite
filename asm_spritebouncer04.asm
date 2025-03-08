;Asm math (CBM Studio friendly, make an asm file, copy paste and run)

; Goal: to implement the basic function
;
; fn a(b)=abs(t-int(t/b)*b)-b/2)
;
; into c64-assembler, so we can bounce a pixel in a sprite
; and bounce the sprite around the screen, saving memory.


; Version 4
;       not much yet, house cleaning, adding comments
;
;       473 bytes



; Version 3
;       added basic stub (12 bytes)
;       the function : fna(b)=abs(t-int(t/b)*b)-b/2)
;       now implemented using simple asm math
;
;       todo: add the sprite, add the frame, call the osci
;       spin it...
;        -- done!
;       really slow, and eats alot of mem, 478 bytes.
;       got alot of overhead, and an unneeded addition algo.
;       will keep all the math in this version.



; Version 2
;       Now got the oscillator running perfect... i hope :D
;       there was a problem turning negatives into positive numbers
;       was measuring on low byte, not high bytes
;       should be fixed now
;       250 bytes

;all i need now is to send the parameter, 544, 316, 42, 36
;for the bouncing sprite and pixel

;for debug
; ?peek(1024)+peek(1025)*256

;all math code loaned from
;https://codebase64.org/doku.php?id=base:6502_6510_maths
; routines working, all 16 bit (maybe not divide result):
;   divide, multiply, addition, subtraction
; the zeropage adresses are changed to not conflict (a mess)

;globals
time=   $02        ;T value. hi byte=$03; this will crash basic, but not needed
sprloc= $0340      ;sprite location
bvar =  $04        ;the B variable storage
tmpx =  $06        ;tmp store for x
oldadd= $08        ;old address of sprte (0..62)
oldbyte=$0a        ;old data of sprite

                  ;Enable RUN from BASIC
*=$0801           ;2025 sys2061
        byte $0b,$08,$e9,$07            ;basic line number
        byte $9e,"2","0","6","1",0,0,0  ;sys2061

*=$080D
        jmp start

;Subroutines start
;------ divide start

divisor   = $58   ;$59 used for hi-byte
dividend  = $fb   ;$fc used for hi-byte
remainder = $fd   ;$fe used for hi-byte
result = dividend ;save memory by reusing divident to store the result

mydivide  
        lda #0          ;preset remainder to 0
        sta remainder
        sta remainder+1
        ldx #16         ;repeat for each bit: ...

divloop asl dividend    ;dividend lb & hb*2, msb -> Carry
        rol dividend+1  
        rol remainder   ;remainder lb & hb * 2 + msb from carry
        rol remainder+1
        lda remainder
        sec
        sbc divisor     ;substract divisor to see if it fits in
        tay             ;lb result -> Y, for we may need it later
        lda remainder+1
        sbc divisor+1
        bcc divskip     ;if carry=0 then divisor didn't fit in yet

        sta remainder+1 ;else save substraction result as new remainder,
        sty remainder   
        inc result      ;and INCrement result cause divisor fit in 1 times

divskip    
        dex       
        bne divloop     
        rts
;------ divide end

;------ multiply start

multiplier      = $f0 
multiplicand    = $f2
product         = $f4
 
mymultiply

mult16          
        lda     #$00
        sta     product+2       ; clear upper bits of product
        sta     product+3 
        ldx     #$10            ; set binary count to 16 
shift_r lsr     multiplier+1    ; divide multiplier by 2 
        ror     multiplier
        bcc     rotate_r 
        lda     product+2       ; get upper half of product and add multiplicand
        clc
        adc     multiplicand
        sta     product+2
        lda     product+3 
        adc     multiplicand+1
rotate_r       
        ror                     ; rotate partial product 
        sta     product+3 
        ror     product+2
        ror     product+1 
        ror     product 
        dex
        bne     shift_r 
        rts

;------------------- multiply end

;------------------- add and subtract

num1lo = $62
;num1hi = $63
num2lo = $64
;num2hi = $65
reslo = $66
;reshi = $67

; adds numbers 1 and 2, writes result to separate location
;must be left out if not needed...

myaddition
        clc                     ; clear carry
        lda num1lo
        adc num2lo
        sta reslo               ; store sum of LSBs
        lda num1lo+1
        adc num2lo+1            ; add the MSBs using carry from
        sta reslo+1             ; the previous calculation
        rts

; subtracts number 2 from number 1 and writes result out

mysubtraction
        sec                      ; set carry for borrow purpose
        lda num1lo
        sbc num2lo               ; perform subtraction on the LSBs
        sta reslo
        lda num1lo+1             ; do the same for the MSBs, with carry
        sbc num2lo+1             ; set according to the previous result
        sta reslo+1
        rts

;math routines end
;now we do
; fn a(b)=abs(t-int(t/b)*b)-b/2)
;
calcfn  ;load B variable in bvar, lo hi

        lda time                ;setup: divide t/b
        sta dividend
        lda time+1
        sta dividend+1

        lda bvar      
        sta divisor
        lda bvar+1
        sta divisor+1
        
        jsr mydivide            ;divide t/b, integer result
       
        ;todo: should reuse vars here and precalculate (b/2) ?
     
        lda result              ;setup: multiply with b
        sta multiplier
        lda result+1
        sta multiplier+1

        lda bvar
        sta multiplicand
        lda bvar+1
        sta multiplicand+1
        
        jsr mymultiply           ;multiply the result with b
                                 

        lda time                ; now subtract the result from T
        sta num1lo
        lda time+1
        sta num1lo+1
        
        lda product
        sta num2lo
        lda product+1
        sta num2lo+1
        
        jsr mysubtraction        ;(t-int(t/b)*b)
        

        ;now calculate b/2

        lda bvar                ;need b/2, can possible ror this faster?
        sta dividend
        lda bvar+1
        sta dividend+1
        lda #2
        sta divisor
        lda #0
        sta divisor+1
        
        jsr mydivide


        lda reslo               ;now subract the result from b/2
        sta num1lo
        lda reslo+1
        sta num1lo+1
        lda result
        sta num2lo
        lda result+1
        sta num2lo+1

        jsr mysubtraction       ;(t-int(t/b)*b)-b/2)

        ;check if its negative and go positive, ABS
        
        lda reslo+1       ;if number is negative, convert it to positive
        bpl notsigned     ;chatgpt version lol
        ;lda reslo        ;but works. to be optimized!
        eor #$FF        
        sta reslo+1
        lda reslo
        eor #$FF
        sta reslo
        clc
        lda reslo
        adc #$01        ;add 1 and with carry
        sta reslo
        lda reslo+1     
        adc #$00
        sta reslo+1     
        

         ;my version of check if negative and correct
         ;needs to add #1, not sure it will overflow
         ;but smaller

;        lda reslo+1
;        bpl notsigned
;        lda #$FF ; lets do 65536-the number to get positive
;        sta num1lo
;        sta num1lo+1
;        lda reslo
;        sta num2lo
;        lda reslo+1
;        sta num2lo+1 
;        jsr mysubtraction

notsigned
        ;all calculations done. result in reslo, reslo+1
        
        rts

;end of subroutines


;---------- start setup

start
        
; SETUP START

        lda #147
        jsr $ffd2        ;clear screen

        sei              ;disable interrupts
        
        ldx #0           ;start the sprite creation
        lda #$ff         ;quick and dirty

slop1                    ;sprite setup loop1        
        sta sprloc,x     ;the top
        sta sprloc+60,x  ;and the bottom
        inx
        cpx #$03
        bne slop1
;        ldy #0
slop2                     ;x-reg should be 3 now
        lda #128          ;draw the sprite frame      
        sta sprloc,x      ;128
        inx
        lda #0
;        tya
        sta sprloc,x      ;0
        inx
;        adc # $1
        lda #1 
        sta sprloc,x      ;1
        inx
        cpx #$3c
        bne slop2         ;loop again

        ;sprite done

        lda #13
        sta $07f8         ;set sprite pointer to #13 (#832)
        sta $d015         ;enable sprite
        sta $d017         ;expand in x
        sta $d01d         ;expand in y
        lda #14
        sta $d027         ;set color

        lda #62           ;set old values, start in lower left bottom
        sta oldadd
        lda #255
        sta oldbyte 

        lda #0            ;set T (time) to 0
        sta time
        sta time+1      

        ;jmp mainlop

mainlop
        ;calculate the function with parmameter 544, X
        lda #$20
        sta bvar
        lda #$02
        sta bvar+1
        jsr calcfn

        ;move the sprite X
        clc             ; add the offset 24
        lda reslo
        adc #24
        sta reslo
        lda reslo+1
        adc #0
        sta reslo+1
        
        lda reslo
        sta $d000
        lda reslo+1
        sta $d010       ;high bit of X

        ;calculate the function with parmameter 316, Y
        lda #$3c
        sta bvar
        lda #$01
        sta bvar+1
        jsr calcfn

        ;move the sprite Y
        clc             ;add the offset 50
        lda reslo
        adc #50
        sta $d001


        ;calculate the function with parmameter 42, x-pixel
        lda #$2A
        sta bvar
        lda #$0
        sta bvar+1
        jsr calcfn

        ;result in reslo
        lda reslo
        sta tmpx        ;save x to tmp area

        ;calculate the function with parmameter 36, y-pixel
        lda #$24
        sta bvar
        lda #$0
        sta bvar+1
        jsr calcfn
        ;result in reslo
        

;now calculate the pixel position
        ldy reslo                 ;find the sprite location
        ldx #0

dvide   ;8 bit mulitplication. quick?

        cpy #0                  ;find line of the sprite
        beq dvdon
        inx
        inx
        inx
        dey
        bne dvide

dvdon                           ;now i got the x byte y offset in reg-X
        lda tmpx
dvlop
        clc
        sbc #7                  ;thought it was 8? hmm, all fixed now
        bmi alldon              ;<0 then the end
        
        inx                     ;there is more
        bpl dvlop
        

alldon                          ;now i got the sprite location in x-reg
                            
        ldy oldadd              ;restore old data and location
        lda oldbyte
        sta sprloc,y
       

        stx oldadd              ;save the new location

        lda sprloc,x            ;get the new data
        sta oldbyte             ;save the data

        ;plot the pixel in the sprite

        lda tmpx                ;pixel x pos
        and #7                  ;x and 7
        tay
        lda xtable,y            ;lookup table for 7-xand7
        ora oldbyte             ;OR the new into the old
        sta sprloc,x            ;put it back in the sprite data


        ;show result -- for debug
;        lda reslo
;        sta $0400
;        lda reslo+1
;        sta $0401
                        ;result must be 60
                        ;?peek(1024)+peek(1025)*256
        
theend
        
        ;do t=t+1
        clc
        lda time
        adc #01
        sta time
        lda time+1
        adc #0
        sta time+1
        

        ;raster stuff

        dec $d020
        lda #255
rlop    cmp $d012
        bne rlop
        inc $d020
        jmp mainlop
        
        
;        cli
;        rts
        
xtable byte 128,64,32,16,8,4,2,1
