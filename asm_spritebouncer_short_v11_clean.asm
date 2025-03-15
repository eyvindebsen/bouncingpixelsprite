;comments below of code
;everything is in ZP, mostly
;variable adresses

xloclo=$1b            ;spritex lo-location
xdir=$1e              ;sprite x direction
oldadd=$0c            ;the old sprite pos
oldbyte=$91           ;the old byte of sprite data (should contain FF)
dirtable=$1f          ;direction table, should be 3 zeroes here
postable=$25          ;a mem location within Y range, followed by 2 zeroes


sprloc=$40             ;sprite data location

                        ;Enable RUN from BASIC
*=$0801                 ;2025 sys2061
        byte $0b,$08,$e9,$07            ;line number (year)
        byte $9e, "2","0","6","1",0,0,0 ;sys 2061


*=$080D                 ;this is address 2061 (not rly needed)
        jsr $e544       ;clear screen sys call
        sei             ;disable interrupts

; SETUP START       

        ldx #3          ;start the sprite creation
        lda #$ff

slop1                    ;sprite setup loop1        
        sta sprloc-1,x   ;the top
        sta sprloc+59,x  ;the bottom
        dex
        bne slop1


sfirst  ldy #3
slop2     
        lda tabspr-2,y    ;saves a byte by lending the 1 from the xtable
        sta sprloc+3,x
        inx
        dey
        bne slop2
        cpx #$39
        bne sfirst         
        
        ;lda #$01         ;A is set to 1 already from sprite creation
        sta $07f8         ;set sprite pointer to #1, zp
        sta $d015         ;enable sprite
        sta $d017         ;expand in x
        sta $d01d         ;expand in y
       
        lda #14
        sta $d027         ;set sprite color
        
; SETUP END


mainlop      
        ;handle spritex pos in 16 bit

        lda xdir        ;do x direction first
        bne goxneg  

handlex                 ;handle x+
        ldx xloclo
        inx             ;change to dex during execution?
        stx xloclo
        bne skipxplus
        inc xloclo+1

skipxplus
        lda xloclo+1    ;above 255?
        beq handley    
        cpx #$29        ;above 297?
        bne handley
        inc xdir
        bne handley     ;changed JMP to bne

goxneg                  ;handle x-
        ldx xloclo
        dex             ;change to dex during execution?
        stx xloclo
        bne skipneg
        dec xloclo+1

skipneg
        lda xloclo+1
        bne handley     ;below 255?    
        cpx #$17        ;below 24?
        bne handley
        dec xdir        ;change direction
 

        ; now handle all Y (8 bit tables) sprY, Pixel X and Y
        
handley
        ;sprite x pos calculated, poke the positions
        sta $d010       ;hibit of X 
        stx $d000       ;lobit of X
        
        ldx #3          ;table index
yloop
        lda dirtable,x  ;what direction
        bne goyneg      ;go negative

        ldy postable,x
        iny
        sty postable,x
        tya             ;fix
        cmp boundtop,x
        bne nextY
        inc dirtable,x  ;change direction
        bne nextY       ;change JMP to a branch

goyneg
        ldy postable,x
        dey
        sty postable,x
        tya
        cmp boundbot,x
        bne nextY
        dec dirtable,x  ;change direction

nextY 
        dex
        bpl yloop
        sty $d001       ;set sprite y pos; its the last calc above


        ;now the pixel
        ldy postable+2  ;find the sprite location
        inx             ;x will be FF, so add to set to 0
                        ;need todo y*3

dvide
        cpy #0          ;what line of the sprite
        beq dvdon
        inx
        inx
        inx
        dey
        bne dvide


dvdon                   ;got the x byte y offset in reg-X
        lda postable+1
dvlop
        clc
        sbc #7          ;thought it was 8? hmm, all fixed now
        bmi alldon      ;<0 then the end
        
        inx             ;there is more in x
        bpl dvlop

alldon                  ;got the sprite location in x-reg                           
        ldy oldadd      ;restore old data and location
        lda oldbyte
        sta sprloc,y
       
        stx oldadd      ;save the new location

        lda sprloc,x    ;get the new data
        sta oldbyte     ;save the data

        lda postable+1  ;pixel x pos
        and #7          ;x and 7
        tay
        lda xtable,y    ;lookup table for 7-xand7
        ora oldbyte     ;or the new into the old
        sta sprloc,x    ;put it back in the sprite data
        
        
;-------routines end-----

;-------now raster stuff      

        lda #255
rlop    
       
        cmp $d012               ;wait raster
        bne rlop

        jmp mainlop

;-------End of code--------

;-------Tables     

xtable    byte 128,64,32,16,8,4,2,1        
tabspr    byte $00,$80 ;Spritedata in reverse. 
                       ;Dont need the #1, its declared in the xtable above
boundtop  byte $D2,$16,$13
boundbot  byte $32,$01,$01

;-------End of tables and all code
;

;
; Version 11
;
;  The sprite creation routine leaves a #1 in the accumulator,
;  so there is no need to LDA #1 after sprite creation.
;  2 bytes saved.
;  221 bytes.
;
; Version 10 *experiment
; 
; Version 9
;  No need to set sprite x and y. Must start somewhere on screen.
;   Changed xloclo to $1b, this contains a valid X pos.
;  Moved postable to memory location that contains a 
;   number>24 and <210, followed by zeroes. Location $25 seems fine.
;  Saved a byte, using the end of the X table for sprite creation
;  Optimized the sprite create; saved a byte
;
;  223 bytes total
;
;
; Version 8     
;  Changed JMPs to BNE, 2 bytes
;  223 bytes (+12 in stub) (233 with fre)
;
; 233 bytes.
;
;
; Version 7
;  Scrubbed down to 226 bytes, (+12 in stub) (236 with fre)
;  Put most variable at places in memory which is already
;  initialized to needed values. Mostly 0 and 255.
;  saves init time and space.
;  more to optimize...
;
;
;
; Version 6
;   will "optimize the loops", optimized the 8 bit loops with tables
;   got rid of alot of setup stuff and redudancy
;   253 bytes, (+12 in stub)
;
;
; Version 5
;  i can reuse the maths with the power of ASM;
;  selfmodifying code..
;  dont need to do sbs, just add FF instead ... or not
;  will cost...
;
; 
; Version 4 ...
;  Bugfixing
;
; Version 3 
;   Moved the sprite to ZP, #64, sprite pointer 1, saved 7 bytes.
;   Removed obsolete code from v1
;   jmp dvlop, becomes bpl dvlop. 
;   fixed a bug in handley, was no jmp
;   added music for fun. located under rom
;   
;   327 bytes.
;
;
; Version 2
;   Moved the sprite location to the tape buffer, address #832.
;   Set all variables to zero-page.
;   Messes up basic stuff, but its not needed, because of the SEI.
;   Saved around 56 bytes.
;   347 bytes. (+12)
;
;
; Version 1
;   First working version.
;   403+(basic stub of 12 bytes)=415 bytes.
