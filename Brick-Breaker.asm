bricks struct

    x_brick dw ?
    y_brick dw ?

    collisions dw ?

    color_of_brick db ?

bricks ends

.model small
.stack 100h
.data

;;;;;;;;;;;;;;;;;;;;;;;;;;; menu things ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    string1 db "Brick Breaker Game$"
	INPUT_NAME db "ENTER USERNAME  $"
	USER_KA_NAAM db 10 dup("$")
	txt1 db "PRESS (I) FOR INSTRUCTIONS$"
	txt2 db "PRESS (H) FOR HIGHSCORE$"
	txt3 DB "PRESS (E) to exit from Main Menu$"
	txt4 db "NO HIGHSCORE yet$"
	txt5 db "INSTRUCTION will be shown here.$"
	txt6 db "1.USE ARROWS TO MOVE THE BOARD.$"
	txt7 db "2.YOU HAVE ONLY 3 LIVES.$"
	txt8 DB "3.IF BALL FAILS TO HIT THE BOARD,$"
    txt8_p2 DB "YOU LOSE 1 LIFE.$"
	txt9 DB "     4.IF BALL HITS THE BRICK,$"
    txt9_p2 DB "       YOU GAIN A POINT$"
	txt10 DB "PRESS SPACEBAR TO PAUSE/RESUME THE GAME$"
	txt11 db "GAME IS OVER$"
	txt12 db "PRESS (S) TO START$"
	txt13 db "Press SPACEBAR to RESUME$"
	txt14 db "GAME IS PAUSED$"
	txt15 db "USE SPACEBAR TO RESUME$"
    txt16 db "Press (E) to go to main menu again$"
	txt17 db "Press space to exit game$"
    HIGHSCORE_oup db "------------ HIGHSCORE ------------- $"
    HIGHSCORE_sytax db "NAME - SCORE - LEVEL$"

    level1_completion db "!!! LEVEL 1 COMPLETE !!!$"
    level1_completion_presskey db "Press 'K' to continue$"

    level2_completion db "!!! LEVEL 2 COMPLETE !!!$"

    game_completion db "!!! GAME COMPLETE !!!$"
    game_completion_presskey db "Press 'K' to go to main menu$"

    pause_exit db "Press 'E' to exit the game$"

;;;;;;;;;;;;;;;;;;;;;;;;;;  file handling tings ;;;;;;;;;;;;;;;;;;;;;;;;

    filename db "project.txt",0
    Filehandler dw ?
    buffer db 5000 dup("$")
    stringinp db 100 dup (0)
    score_in_a_string db 5 dup (0)

;;;;;;;;;;;;;;;;;;;;;;;;;; game things ;;;;;;;;;;;;;;;;;;;;;;;;;;;

    widthofwindow dw 320        ;width of the window
    heightofwindow dw 200       ;height of the window

    score dw 0                  ;score in the game
    score_text db "Score:$"     
    ;score_output db "0$"        ;score outputting in the window

    level db 1
    level_text db "Level:$"
    level1_output db "1$"       ;level outputting in the window
    level2_output db "2$"
    level3_output db "3$"

    bounds dw 6                 ;to bounce ball back early

    ball_x dw 5                 ;coordinate x current
    ball_y dw 100               ;coordinate y current

    ball_x_og dw 5              ;coordinate x orignal
    ball_y_og dw 100            ;coordinate y orignal

    ball_size dw 4              ;the size of pixel which is 4X4

    ball_speed_x dw 4           ;speed with ball moves in x
    ball_speed_y dw 2           ;speed with ball moves in y

    time_check db 0             ;prev time

    paddle_x dw 150             ;position of paddle on x axis
    paddle_y dw 185             ;position of paddle on y axis

    paddle_height dw 3          ;size of the paddle
    paddle_width dw 50

    paddle_speed dw 6           ;speed of the paddle with which it moves

    lives dw 3                 ;lives of the player 
    lives_text db "Lives:$"

    ;bricksarr BRICKS 16 DUP (<>)   ;array of all the bricks

    bricks_width dw 30          ;width of the bricks

    bricks_height dw 10         ;height of the brick

    ;;;;;;;;;;;;;;; row1 ;;;;;;;;;;;;;;;

    brick1 BRICKS <15,45,1,5>
    brick2 BRICKS <75,45,1,5>
    brick3 BRICKS <135,45,1,5>
    brick4 BRICKS <195,45,1,5>
    brick5 BRICKS <255,45,1,5>
    brick6 BRICKS <100,75,1,5>
    brick7 BRICKS <220,75,1,5>

;   temp for drawing bricks

    temp_brick_x dw 0
    temp_brick_y dw 0
    collision_temp dw 0
    color db 0

;   temp for checking bricks collisions

    bricks_x_val dw 0 
    bricks_y_val dw 0

;   all the levels max score

    level1_max dw 35

;   special brick check

    special_brick dw 0

.code

    mov ax,@data
    mov ds,ax
    mov ax,0

    jmp main

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;menus;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Game_starting proc

        ; ------video Graphy Mode----;
        mov ah,0
		mov al,10h
		int 10h
	;-----		--------;	
; BackGround Colour Change
  
  backgroungColor: 
		mov ah,0BH
		mov bx,0			     ; change here to change colour
		int 10h
		mov al, 0ch
        Square macro x1,y1

    	mov cx, x1		;600
		H1:
		cmp cx, 10
		JE EXIT
		mov ah, 0CH
		mov al, 011
		mov bh, 0
		mov dx, 10
		int 10h
	LOOP H1
	EXIT:
	mov dx, 10
	
	V1:
		cmp dx, y1		;320
		JE EXIT2
		mov ah, 0CH
		mov al, 011
		mov bh, 0
		mov cx, 10; move right left
		int 10h
		inc dx
	JMP V1
	EXIT2:
		
	mov cx, x1			;600
	H2:
		cmp cx, 10
		JE EXIT3
		mov ah, 0CH
		mov al, 11
		mov bh, 0
		mov dx, y1
		int 10h
	LOOP H2
	EXIT3:
		
	mov dx, 10
	V2:
		cmp dx, y1		;319
		JE EXIT4
		mov ah, 0CH
		mov al, 11
		mov bh, 0
		mov cx, x1
		int 10h
		inc dx
	JMP V2
	EXIT4:
		
endm
;------MACRO1 END----;
;---calling function---;
Square 620,330
Cursor1:	
		mov ah, 2
		mov dh, 5      ;row
		mov dl, 30     ;column
		int 10h
		mov dx,offset string1
		mov ah,09h
		int 21h	
PrintE:		                                  ;  printing "ENTER USERNAME"
		mov ah, 2
		mov dh, 10   ;row
		mov dl, 33   ;column
		int 10h
		mov dx,offset Input_NAME
		mov ah,09
		int 21h	

; setting the cursor's position
   Cursor:	
		mov ah, 2h
		mov dh, 12      ; row
		mov dl, 35     ; column
		int 10h
		
		mov ah,3fh
		mov dx,offset USER_KA_NAAM  
		int 21h
		
		mov ax,0
        mov AL,13                       ;video mode 320 X 200 resolution
        int 10h
 
	;;__________________________________________________________
        call Printmenu

        ret

Game_starting endp

winning proc

		mov ax,0
        mov AL,13                       ;video mode 320 X 200 resolution
        int 10h
		mov ah, 2
		mov dh, 10   ;row
		mov dl, 8   ;column
		int 10H
		mov dx,offset game_completion
		mov ah,09
		int 21h	

        mov dh, 13   ;row
		mov dl, 8   ;column
		int 10H
		mov dx,offset game_completion_presskey
		mov ah,09
		int 21h	

    enter_plz:

        mov ah,00h
		int 16h

        .if(al=='K' || al=='k')

		    call Printmenu

        .else

            jmp enter_plz

        .endif

ret

winning endp
Printmenu proc
	  ;;--- main menu---;

        mov ax,0						;clear screen
		mov AL,13                       ;video mode 320 X 200 resolution
		int 10h
		mov ah,0BH	                    ;background color
		mov bx,0			            ;change here to change colour
		int 10h
		mov al, 0ch
        Square 312,175
        ;---- 1 ---;
		mov ah, 2
		mov dh, 10   ;row
		mov dl, 8  ;column
		int 10H
		mov dx,offset txt1
		mov ah,09
		int 21h		
		;---- 2 ---;

		mov ah, 2
		mov dh, 12   ;row
		mov dl, 9   ;column
		int 10h
		mov dx,offset txt2
		mov ah,09
		int 21h	
		;---- 3 ---;
		mov ah, 2
		mov dh, 14   ;row
		mov dl, 5   ;column
		int 10h
		mov dx,offset txt3
		mov ah,09
		int 21h				
		;---- 4 ---;
		mov ah, 2
		mov dh, 16   ;row
		mov dl, 11  ;column
		int 10h
		mov dx,offset txt12
		mov ah,09
		int 21h		
        ;	

	WaitForKeyPress:

		mov ah,00h
		int 16h

	CheckPressedKey:

        .if(al=='S' || al=='s')			    ; FOR OPENING UP INSTRUCTION PAGE
            call level1

		.elseif(al=='I' || al=='i')			; FOR OPENING UP INSTRUCTION PAGE
			
            call INSTRUCTION

		.elseif( al =='E' || al =='e')		; TO EXIT TO MAIN MENU AGAINN TO END GAME
			
            mov ah,4ch
            int 21h

		.elseif( al =='H' || al =='h')		; OPEN HIGHSCORE PAGE
			
            call HIGHSCORE

		.else

			jmp WaitForKeyPress

		.endif

		    JMP ProgramEXIT

        ProgramEXIT:	
        mov ah,4ch
        int 21h


    ret

Printmenu endp

    PAUSE_MENU proc

			mov ax,0						;clear screen
			mov AL,13                       ;video mode 320 X 200 resolution
			int 10h
			mov ah,0BH	                    ;background color
			mov bx,0			            ;change here to change colour
			int 10h
			mov al, 0ch

			mov ah, 2
			mov dh, 12                      ;row
			mov dl, 12                      ;column
			int 10h
			mov dx,offset txt14
			mov ah,09
			int 21h

			;--------------1-----------;

			mov ah, 2
			mov dh, 14   ;row
			mov dl, 10   ;column
			int 10h
			mov dx,offset txt15
			mov ah,09
			int 21h

            mov ah, 2
			mov dh, 16   ;row
			mov dl, 10   ;column
			int 10h
			mov dx,offset pause_exit
			mov ah,09
			int 21h

			LL:
				mov ah, 1
				int 16h
			JZ LL		

			mov ah,00h				        ;key detection:
			int 16h

			.if(al == 32)
				mov ax,0
				mov AL,13                   ;video mode 320 X 200 resolution
				int 10h
				ret

            .elseif( al =='E' || al =='e')		; TO EXIT TO MAIN MENU AGAINN TO END GAME
			
                mov ah,4ch
                int 21h

			.else

				JMP LL

			.endif

	    ret

    PAUSE_MENU endp

    gameover proc

		mov ax,0
        mov AL,13                       ;video mode 320 X 200 resolution
        int 10h
		mov ah, 2
		mov dh, 10   ;row
		mov dl, 10   ;column
		int 10H
		mov dx,offset txt11             ;game is over text
		mov ah,09
		int 21h	

        mov ah, 2
		mov dh, 13   ;row
		mov dl, 4   ;column
		int 10H
		mov dx,offset txt16             ;press e to go to main menu
		mov ah,09
		int 21h		

        mov ah, 2
		mov dh, 15   ;row
		mov dl, 4   ;column
		int 10H
		mov dx,offset txt17             ;press space to exit game
		mov ah,09
		int 21h		

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   file handling ;;;;;;;;;;;;;;;;;;;;;;;;;;;

        ;2. INT 21H Function 3DH: To open existing file

        mov ah, 3DH
        mov al, 2                           ; 0 for reading, 1 for writing. 2 for both
        mov dx, offset filename
        int 21h
        mov Filehandler,ax

        mov ax,0

        mov bx ,filehandler

        mov cx,0
        mov dx, 0
        mov ah,42h
        mov al,2                            ; 0 beginning of file, 2 end of file
        int 21h

        ;4. INT 21H Function 42H: To write in a file

        mov ah, 40H
        mov bx, Filehandler
        mov cx, 8
        mov dx, offset USER_KA_NAAM
        int 21h

        mov ah, 3Eh
        mov bx, filehandler
        int 21h

        mov si,0
        mov bx,0

        mov stringinp[si],'-'
        inc si
        
            mov cx,0
    
            mov ax,score

            ll:

                mov bx,10
                mov dx,0
                div bx
                push dx
                inc cx
                cmp ax,0
                jne ll
    
            l2:

                pop dx
                add dl,'0'
                
                    mov stringinp[si],dl

                    inc si

            loop l2

            mov stringinp[si],'-'
            inc si

            mov dl,level
            add dl,'0'
            mov stringinp[si],dl

            inc si
            mov stringinp[si],10

        mov ah, 3DH
        mov al, 2                           ; 0 for reading, 1 for writing. 2 for both
        mov dx, offset filename
        int 21h
        mov Filehandler,ax

        mov ax,0

        mov bx ,filehandler

        mov cx,0
        mov dx, 0
        mov ah,42h
        mov al,2                            ; 0 beginning of file, 2 end of file
        int 21h

        mov ah, 40H
        mov bx, Filehandler
        mov cx, 6
        mov dx, offset stringinp
        int 21h

        mov ah, 3Eh
        mov bx, filehandler
        int 21h

        ;closing file

        mov ah, 3Eh
        mov bx, filehandler
        int 21h

        mov dx,0

        mov dx,offset stringinp
        mov ah,3fh
        int 21h

        mov lives,3
        mov score,0
        mov brick1.collisions,1 
        mov brick2.collisions,1 
        mov brick3.collisions,1 
        mov brick4.collisions,1 
        mov brick5.collisions,1 
        mov brick6.collisions,1 
        mov brick7.collisions,1 

        mov brick1.color_of_brick,5 
        mov brick2.color_of_brick,5 
        mov brick3.color_of_brick,5 
        mov brick4.color_of_brick,5 
        mov brick5.color_of_brick,5 
        mov brick6.color_of_brick,5 
        mov brick7.color_of_brick,5 

        mov paddle_speed,6
        mov ball_speed_x,4
        mov ball_speed_y,2
        mov paddle_width,50

        mov level,1

        enter_the_key_wait:

            mov ah,00h
		    int 16h


		    .if( al =='E' || al =='e')		; TO EXIT TO MAIN MENU
			
                call Printmenu

		    .elseif( al == 32)		; OPEN HIGHSCORE PAGE
			
                mov ah,4ch
                int 21h

		    .else

			    jmp enter_the_key_wait

		    .endif

                mov ah,4ch
                int 21h     

    ret

gameover endp
;_________________________________________________________
; HIGH SCORE WALA PROC MA SIRF AAPNA FILE HANDLING KERNI HAI BAKI AGAR KOI B CHANGE HO BATANA I'LL DO THAT
;__________________________________________________________
		HIGHSCORE PROC		
			mov ax,0						;clear screen
			mov AL,13                       ;video mode 320 X 200 resolution
			int 10h
			mov ah,0BH	                    ;background color
			mov bx,0			            ; change here to change colour
			int 10h
			mov al, 0ch
        Square 312,175
            mov ah, 2
		    mov dh, 3   ;row
		    mov dl, 2   ;column
		    int 10H
		    mov dx,offset HIGHSCORE_oup             
		    mov ah,09
		    int 21h	

            mov ah, 2
		    mov dh, 5   ;row
		    mov dl, 5   ;column
		    int 10H
		    mov dx,offset HIGHSCORE_sytax             
		    mov ah,09
		    int 21h	
			
            mov ah, 3DH
            mov al, 2 ; 0 for reading, 1 for writing. 2 for both
            mov dx, offset filename
            int 21h
            mov Filehandler,ax

            mov ah, 3FH
            mov cx, 100
            mov dx, offset buffer
            mov bx, Filehandler
            int 21h

            mov ah, 2
		    mov dh, 7   ;row
		    mov dl, 10   ;column
		    int 10H
		    mov dx,offset buffer             
		    mov ah,09
		    int 21h	

            mov ah, 2
			mov dh, 15  	 ;row
			mov dl, 5 		 ;column
			int 10h
			mov dx,offset txt3
			mov ah,09
			int 21h	

			;key detection:

			mov ah,00h
			int 16h

			.if(al=='e'||al=='E')

					mov ax,0
					mov AL,13                       ;video mode 320 X 200 resolution
					int 10h

				call Printmenu

			.endif

			ret		
		HIGHSCORE endp
;________________________________________________________________________

    INSTRUCTION PROC
			mov ax,0						; clear screen
       		mov AL,13                       ;video mode 320 X 200 resolution
        	int 10h
			mov ah,0BH
			mov bx,0			     ; change here to change colour
			int 10h
			mov al, 0ch
            
        Square 312,175
		;------ 0--------;
			mov ah, 2
			mov dh, 6  	 ;row
			mov dl, 6 		 ;column
			int 10h
			mov dx,offset txt3
			mov ah,09
			int 21h		
		;------ 1 --------;
			mov ah, 2
			mov dh, 8  	 ;row
			mov dl, 6 		 ;column
			int 10h
			mov dx,offset txt6
			mov ah,09
			int 21h		
		;------ 2 ------;
			mov ah, 2
			mov dh, 10  	 ;row
			mov dl, 6 		 ;column
			int 10h
			mov dx,offset txt7
			mov ah,09
			int 21h		
			call endl
		;------ 3 ------;
			mov ah, 2
			mov dh, 12  	 ;row
			mov dl, 6 		 ;column
			int 10h
			mov dx,offset txt8
			mov ah,09
			int 21h		

		;------ 4 ------;
        call endl
			mov ah, 2
			mov dh, 6  	 ;row
			mov dl, 0		 ;column
			int 21h
			mov dx,offset txt9
			mov ah,09
			int 21h		
            ;;--------;;
            call endl
            
            mov ah, 2
			mov dh, 4     	 ;row
			mov dl, 18		 ;column
			int 21h
			mov dx,offset txt9_p2
			mov ah,09
			int 21h		
;--------------------   
call endl
            ;endll
			LL:
				mov ah, 1
				int 16h
			JZ LL
			;key detection:
			mov ah,00h
			int 16h
			.if(al=='e'||al=='E')
				mov ax,0
				mov AL,13                       ;video mode 320 X 200 resolution
				int 10h
				JMP Printmenu
			.else
				JMP LL
			.endif

			ret
			INSTRUCTION endp
	endl PROC
		mov dx,10
		mov ah,2
		int 21h
		mov dx,13
		mov ah,2
		int 21h
	ret 
	endl endp

    ;;;;;;;;;;;;;;;;;;;;;; UI including score lives and level number ;;;;;;;;;;;;;;;;

    draw_UI PROC

        ;setting cursor position

        ;outputting the text "Score:"

        mov ah, 2
        mov dh, 2      ;row
        mov dl, 30     ;column
        int 10h

        mov ah,09h
        mov dx,offset score_text
        int 21h

        ;outputting the actual score value

        mov ah, 2
        mov dh, 2      ;row
        mov dl, 37     ;column
        int 10h

        call Updating_score_text

        ;outputting the text "Level:"

        mov ah, 2
        mov dh, 2      ;row
        mov dl, 15     ;column
        int 10h

        mov ah,09h
        mov dx,offset level_text
        int 21h

        ;outputting the actual score value

        mov ah, 2
        mov dh, 2      ;row
        mov dl, 22     ;column
        int 10h

        .if (level == 1)

            mov ah,09h
            mov dx,offset level1_output
            int 21h

        .elseif (level == 2)

            mov ah,09h
            mov dx,offset level2_output
            int 21h
        
        .elseif (level == 3)

            mov ah,09h
            mov dx,offset level3_output
            int 21h

        .endif

        ;outputting the text "Lives:"

        mov ah, 2
        mov dh, 2     ;row
        mov dl, 2     ;column
        int 10h

        mov ah,09h
        mov dx,offset lives_text
        int 21h

        call heart

        RET

    draw_UI ENDP

    heart PROC

        mov cx,0
        mov cx,lives

        .while (cx > 0)

            mov ah, 2
            mov dh, 2     ;row
            mov dl, 8     ;column
            int 10h

            mov al,3    ;ASCII code of Character 
            mov bx,0
            mov bl,4    ;red color

            mov ah,09h
            int 10h

            dec cx

        .endw

        ret

    heart ENDP

    Updating_score_text PROC

        mov cx,0
    
        mov ax,score

    ll:
        mov bx,10
        mov dx,0
        div bx
        push dx
        inc cx
        cmp ax,0
        jne ll
    
    l2:
        pop dx
        mov ah,2
        add dl,'0'
        int 21h
        loop l2

        RET

    Updating_score_text ENDP

    ;;;;;;;;;;;;;;;;;;;;;; drawing the boundary ;;;;;;;;;;;;;;;;;

    draw_boundary PROC

        mov dx,30
        mov cx,1

        .while (cx <= 316)

            mov ah,0Ch              ;draw pixel
            mov al,0Ch              ;white color of pixel
            mov bh,00h              ;page number in bh
   
            int 10h

            inc cx

        .endw

        .while (dx <= 199)

            mov ah,0Ch              ;draw pixel
            mov al,0Ch              ;white color of pixel
            mov bh,00h              ;page number in bh
   
            int 10h

            inc dx

        .endw

        mov dx,30
        mov cx,1

        .while (dx <= 199)

            mov ah,0Ch              ;draw pixel
            mov al,0Ch              ;white color of pixel
            mov bh,00h              ;page number in bh
   
            int 10h

            inc dx

        .endw

        RET
    
    draw_boundary ENDP

;;;;;;;;;;;;;;;;;;;;;;;; drawing bricks ;;;;;;;;;;;;;;;;;;;;

    draw_bricks PROC

    .if (collision_temp > 0)

        mov cx,temp_brick_x         ;initial column or x
        mov dx,temp_brick_y         ;initial line or y

        brickdrawing:

            mov ah,0Ch              ;draw pixel
            mov al,color            ;white color of pixel
            mov bh,00h              ;page number in bh
   
            int 10h

            inc cx
            mov ax,0
            mov ax,cx
            sub ax,temp_brick_x

            cmp ax,bricks_width
            jng brickdrawing

            inc dx
            mov cx,temp_brick_x

            mov bx,0
            mov bx,dx
            sub bx,temp_brick_y

            cmp bx,bricks_height
            jng brickdrawing

            ret

    .endif

    ret

    draw_bricks ENDP

    ;;;;;;;;;;;;;;;;;;;;;;; padel drawing ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    draw_paddel PROC

        mov cx,paddle_x         ;initial column or x
        mov dx,paddle_y         ;initial line or y

    drawing_dapaddel:

        mov ah,0Ch              ;draw pixel
        mov al,0Ch              ;white color of pixel
        mov bh,00h              ;page number in bh
   
        int 10h

        inc cx
        mov ax,0
        mov ax,cx
        sub ax,paddle_x

        cmp ax,paddle_width
        jng drawing_dapaddel

        inc dx
        mov cx,paddle_x

        mov bx,0
        mov bx,dx
        sub bx,paddle_y

        cmp bx,paddle_height
        jng drawing_dapaddel

        ret

    draw_paddel ENDP

;;;;;;;;;;;;;;;;;;;;;;; ball drawing ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    draw_ball PROC

        mov cx,ball_x           ;initial column or x
        mov dx,ball_y           ;initial line or y

    drawing_daball:

        mov ah,0Ch              ;draw pixel
        mov al,09               ;white color of pixel
        mov bh,00h              ;page number in bh
   
        int 10h

        inc cx
        mov ax,0
        mov ax,cx
        sub ax,ball_x

        cmp ax,ball_size
        jng drawing_daball

        inc dx
        mov cx,ball_x

        mov bx,0
        mov bx,dx
        sub bx,ball_y

        cmp bx,ball_size
        jng drawing_daball

        ret
        
    draw_ball ENDP

    ;clearing the screen everytime,this refreshes the screen every 1/100th of a second

    clear_screen PROC
        
        mov ax,0
        mov AL,13                       ;video mode 320 X 200 resolution
        int 10h

        mov ah,0Bh
        mov bh,00h                      ;set background
        mov bl,0                        ;set black color in bl
        int 10h

        ret

    clear_screen ENDP

;;;;;;;;;;;;;;;;;;;;;;; ball moving and collsions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    bricks_collision PROC

;       checking if the ball is colliding with the paddle

;       (ball_x + ball_size >= paddle_x) 1st && (ball_x <= paddle_x + paddle_width) 2nd
;        && (ball_y + ball_size >= paddle_y) 3rd && (ball_y <= paddle_y + paddle_height) 4th

;       bx is the number of collisions of the brick

    .if (bx > 0 )

        mov ax,ball_x
        add ax,ball_size
        cmp ax,bricks_x_val             ;1st condition
        jng nocollision

        mov ax,bricks_x_val
        add ax,bricks_width
        cmp ball_x,ax                   ;2nd condition
        jnl nocollision

        mov ax,ball_y
        add ax,ball_size
        cmp ax,bricks_y_val             ;3rd condition
        jng nocollision

        mov ax,bricks_y_val
        add ax,bricks_width
        cmp ball_y,ax                   ;4th condition
        jnl nocollision

        ;ball is coliding with brick if it reaches here

        neg ball_speed_y                ;directing ball back

        .if (bx != 100)

        add score,5                     ;increasing score by 5

        dec bx
        dec dl

        .endif

        push bx 
        push dx
        call beep
        pop dx
        pop bx

        .if (level == 1)

            .if (score == 35)

                call level2

            .endif

        .endif

        .if (level == 2)

            .if (score == 105)

                call level3                        ;level 3 insert
                
            .endif

        .endif

        .if (level == 3)

            .if (score == 205)

                call winning                       ;game complete
                
            .endif

        .endif

        ret

    .endif    

        nocollision:

        ret

    bricks_collision ENDP

    all_bricks_collisions PROC

        ; brick 1

        mov ax,brick1.x_brick
        mov bricks_x_val,ax
        mov ax,brick1.y_brick
        mov bricks_y_val,ax
        mov bx,brick1.collisions

        mov dl,brick1.color_of_brick

        call bricks_collision

        mov brick1.collisions,bx
        mov brick1.color_of_brick,dl

        ; brick 2

        mov ax,brick2.x_brick
        mov bricks_x_val,ax
        mov ax,brick2.y_brick
        mov bricks_y_val,ax

        .if (level == 3)

            mov brick2.collisions,100
            mov brick2.color_of_brick,10

        .endif

        mov bx,brick2.collisions

        mov dl,brick2.color_of_brick

        call bricks_collision

        mov brick2.collisions,bx
        mov brick2.color_of_brick,dl

        ; brick 3

        mov ax,brick3.x_brick
        mov bricks_x_val,ax
        mov ax,brick3.y_brick
        mov bricks_y_val,ax
        mov bx,brick3.collisions
        
        .if ( level == 3 )

            mov brick3.color_of_brick,14

        .endif

        mov dl,brick3.color_of_brick

        call bricks_collision

        .if (level == 3 && bx != brick3.collisions)

            mov bx,0
            mov brick3.collisions,0
            mov brick1.collisions,0
            mov brick7.collisions,0

            add score,45 

        .endif

        mov brick3.collisions,bx
        mov brick3.color_of_brick,dl

        ; brick 4

        mov ax,brick4.x_brick
        mov bricks_x_val,ax
        mov ax,brick4.y_brick
        mov bricks_y_val,ax

        .if (level == 3)

            mov brick4.collisions,100
            mov brick4.color_of_brick,10

        .endif

        mov bx,brick4.collisions

        mov dl,brick4.color_of_brick

        call bricks_collision

        mov brick4.collisions,bx
        mov brick4.color_of_brick,dl

        ; brick 5

        mov ax,brick5.x_brick
        mov bricks_x_val,ax
        mov ax,brick5.y_brick
        mov bricks_y_val,ax
        mov bx,brick5.collisions

        mov dl,brick5.color_of_brick

        call bricks_collision

        mov brick5.collisions,bx
        mov brick5.color_of_brick,dl

        ; brick 6

        mov ax,brick6.x_brick
        mov bricks_x_val,ax
        mov ax,brick6.y_brick
        mov bricks_y_val,ax

        mov bx,brick6.collisions

        mov dl,brick6.color_of_brick

        call bricks_collision

        mov brick6.collisions,bx
        mov brick6.color_of_brick,dl

        ; brick 7

        mov ax,brick7.x_brick
        mov bricks_x_val,ax
        mov ax,brick7.y_brick
        mov bricks_y_val,ax
        mov bx,brick7.collisions

        mov dl,brick7.color_of_brick

        call bricks_collision

        mov brick7.collisions,bx
        mov brick7.color_of_brick,dl

        RET

    all_bricks_collisions ENDP

    mov_ball PROC
        
        mov ax,ball_speed_x 
        add ball_x,ax

        cmp ball_x,4                    ;bouncing back of left boundry
        jl negball_x

        mov ax,widthofwindow
        sub ax,ball_size
        sub ax,bounds
        cmp ball_x,ax                   ;bouncing back of right boundry
        jg negball_x

        mov ax,ball_speed_y
        add ball_y,ax

        cmp ball_y,30                    ;bouncing back of top boundry
        jl negball_y

        mov ax,heightofwindow
        sub ax,ball_size
        sub ax,bounds
        cmp ball_y,ax                   ;bouncing back of bottom boundry
        jg reset_position

;       checking if the ball is colliding with the bricks

        call all_bricks_collisions

;       checking if the ball is colliding with the paddle

;       (ball_x + ball_size >= paddle_x) 1st && (ball_x <= paddle_x + paddle_width) 2nd
;        && (ball_y + ball_size >= paddle_y) 3rd && (ball_y <= paddle_y + paddle_height) 4th

        mov ax,ball_x
        add ax,ball_size
        cmp ax,paddle_x                 ;1st condition
        jng ending_ball

        mov ax,paddle_x
        add ax,paddle_width
        cmp ball_x,ax                   ;2nd condition
        jnl ending_ball

        mov ax,ball_y
        add ax,ball_size
        cmp ax,paddle_y                 ;3rd condition
        jng ending_ball

        mov ax,paddle_y
        add ax,paddle_height
        cmp ball_y,ax                   ;4th condition
        jnl ending_ball

        ;ball is coliding with paddle if it reaches here

        neg ball_speed_y                ;directing ball back

        ret

        negball_x:

            neg ball_speed_x            ;changing balls direction on x axis
            ret

        negball_y:

            neg ball_speed_y            ;changing balls direction on y axis
            ret

        backtonormal:

            call reset_position

            ret

        ending_ball:

            ret

    mov_ball ENDP

;;;;;;;;;;;;;;;;;;;;;;; padel moving ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    move_paddle PROC

        mov ah,01                       ;checking for keyboard input
        int 16h

        ;zero flag = 1 no key was pressed and if its 0 it means a key was pressed

        jz ending_pad

        mov ah,00                       ;to get keyboard input (AL = ASCII code , AH = Scan code)
        int 16h

        cmp ah,04Bh                     ; left key to move left
        je move_padd_left

        cmp ah,04Dh                     ; right key to move right
        je move_padd_right

        .if  ( al == 32 )

            call PAUSE_MENU

        .endif

        .if ( al == 50 )                 ; '2' key to go to level 2
        
            call level2
        
        .endif

        .if ( al == 51 )                 ; '2' key to go to level 2
        
            call level3
        
        .endif

        move_padd_left:

                mov ax,paddle_speed
                sub paddle_x,ax

                mov ax,bounds
                cmp paddle_x,ax         ;checking if paddle crossed the left boudary
                jle stop_paddle_left

                jmp ending_pad

        stop_paddle_left:

                mov ax,bounds           ;to stop paddle from leaving the left boundary wall
                mov paddle_x,ax
                jmp ending_pad

        move_padd_right:

                mov ax,paddle_speed
                add paddle_x,ax

                mov ax,widthofwindow
                sub ax,bounds
                mov dx,paddle_x
                add dx,paddle_width
                cmp dx,ax               ;checking if paddle crossed the right boudary
                jge stop_paddle_right
                
                jmp ending_pad 

        stop_paddle_right:

                mov ax,widthofwindow
                sub ax,bounds
                sub ax,paddle_width     ;to stop paddle from leaving the right boundary wall
                mov paddle_x,ax
                jmp ending_pad

        ending_pad:

        ret

    move_paddle ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Reseting the ball position if it misses the paddle ;;;;;;;;;;;;;;;;;

    reset_position PROC

        mov ax,ball_x_og
        mov ball_x,ax

        mov ax,ball_y_og
        mov ball_y,ax

        dec lives

            .if (lives == 0)

                call gameover

            .endif

        ret
        
    reset_position ENDP

    drawing_all_bricks PROC
    
    ; color is the color of brick

        ; brick1

        mov ax,brick1.x_brick
        mov temp_brick_x,ax
        mov ax,0

        mov ax,brick1.y_brick
        mov temp_brick_y,ax
        mov ax,0

        mov ax,brick1.collisions
        mov collision_temp,ax
        mov ax,0

        mov al,brick1.color_of_brick
        mov color,al

        call draw_bricks

        ;; brick2

        mov ax,brick2.x_brick
        mov temp_brick_x,ax
        mov ax,0

        mov ax,brick2.y_brick
        mov temp_brick_y,ax
        mov ax,0

        mov ax,brick2.collisions
        mov collision_temp,ax
        mov ax,0

        mov al,brick2.color_of_brick
        mov color,al

        call draw_bricks

        ;; brick3

        mov ax,brick3.x_brick
        mov temp_brick_x,ax
        mov ax,0

        mov ax,brick3.y_brick
        mov temp_brick_y,ax
        mov ax,0

        mov ax,brick3.collisions
        mov collision_temp,ax
        mov ax,0

        mov al,brick3.color_of_brick
        mov color,al

        call draw_bricks   

        ;; brick4

        mov ax,brick4.x_brick
        mov temp_brick_x,ax
        mov ax,0

        mov ax,brick4.y_brick
        mov temp_brick_y,ax
        mov ax,0

        mov ax,brick4.collisions
        mov collision_temp,ax
        mov ax,0

        mov al,brick4.color_of_brick
        mov color,al


        call draw_bricks    

        ;; brick5

        mov ax,brick5.x_brick
        mov temp_brick_x,ax
        mov ax,0

        mov ax,brick5.y_brick
        mov temp_brick_y,ax
        mov ax,0

        mov ax,brick5.collisions
        mov collision_temp,ax
        mov ax,0

        mov al,brick5.color_of_brick
        mov color,al

        call draw_bricks    

        ;; brick6

        mov ax,brick6.x_brick
        mov temp_brick_x,ax
        mov ax,0

        mov ax,brick6.y_brick
        mov temp_brick_y,ax
        mov ax,0

        mov ax,brick6.collisions
        mov collision_temp,ax
        mov ax,0

        mov al,brick6.color_of_brick
        mov color,al

        call draw_bricks  

        ;; brick7

        mov ax,brick7.x_brick
        mov temp_brick_x,ax
        mov ax,0

        mov ax,brick7.y_brick
        mov temp_brick_y,ax
        mov ax,0

        mov ax,brick7.collisions
        mov collision_temp,ax
        mov ax,0

        mov al,brick7.color_of_brick
        mov color,al

        call draw_bricks  

        RET

    drawing_all_bricks ENDP   

    ;---------------a procedure that produces a beep sound-------------;
beep proc               

        mov     al, 182         ; Prepare the speaker for the
        out     43h, al         ;  note.
        mov     ax, 120         ; Frequency number (in decimal)
                                ;  for middle C.
        out     42h, al         ; Output low byte.
        mov     al, ah          ; Output high byte.
        out     42h, al 
        in      al, 61h         ; Turn on note (get value from
                                ;  port 61h).
        or      al, 00000011b   ; Set bits 1 and 0.
        out     61h, al         ; Send new value.
        mov     bx, 2          ; Pause for duration of note.
pause1:
        mov     cx, 65535
pause2:
        dec     cx
        jne     pause2
        dec     bx
        jne     pause1
        in      al, 61h         ; Turn off note (get value from
                                ;  port 61h).
        and     al, 11111100b   ; Reset bits 1 and 0.
        out     61h, al         ; Send new value.


ret
beep endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;       level 1     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

level1 PROC

        call clear_screen

        mov lives,3
        
        fps:

        mov ah,2Ch              ;to find system time
        int 21h                 ;CH = hour CL = minute DH = second DL = 1/100 seconds
        
        cmp dl,time_check       ;checking dl= (current time) with time_check= (previous time)
        je fps                  ;if equal start loop again

        mov time_check,dl       ;if not equal move dl in time_check(previous time)

        call clear_screen

        call mov_ball

        call draw_ball

        call move_paddle

        call draw_paddel

        call draw_boundary

        call draw_UI

        ;; drawing all the bricks

        call drawing_all_bricks

        ; MOV     CX, 2
        ; MOV     DX, 4000
        ; MOV     AH, 86H
        ; INT     15H

        ; mov ax,0
        ; mov bx,0
        ; mov cx,0
        ; mov dx,0

        jmp fps


    RET

level1 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;       level-2     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

level1_complete proc

		mov ax,0
        mov AL,13                       ;video mode 320 X 200 resolution
        int 10h
		mov ah, 2
		mov dh, 10   ;row
		mov dl, 8   ;column
		int 10H
		mov dx,offset level1_completion
		mov ah,09
		int 21h	
        call endl

        mov dh, 13   ;row
		mov dl, 8   ;column
		int 10H
		mov dx,offset level1_completion_presskey
		mov ah,09
		int 21h	
    enter_kr_bhi_de:

        mov ah,00h
		int 16h

        .if(al=='K' || al=='k')

		    ret

        .else

            jmp enter_kr_bhi_de

        .endif

ret

level1_complete endp

level2 PROC

        .if( level < 2)

        call level1_complete

        add paddle_speed,2
        
        add ball_speed_x,1           ;increase speed of ball moving in x
        add ball_speed_y,1           ;increase speed of ball moving in y

        sub paddle_width,5           ;decreasing the width of the paddle

        mov score,35

        inc level

        mov brick1.collisions,2 
        mov brick2.collisions,2 
        mov brick3.collisions,2 
        mov brick4.collisions,2 
        mov brick5.collisions,2 
        mov brick6.collisions,2 
        mov brick7.collisions,2 

        mov brick1.color_of_brick,5 
        mov brick2.color_of_brick,5  
        mov brick3.color_of_brick,5  
        mov brick4.color_of_brick,5  
        mov brick5.color_of_brick,5  
        mov brick6.color_of_brick,5  
        mov brick7.color_of_brick,5  

        inc lives

        .endif

        call clear_screen

        call reset_position
        
        fps:

        mov ah,2Ch                  ;to find system time
        int 21h                     ;CH = hour CL = minute DH = second DL = 1/100 seconds
        
        cmp dl,time_check           ;checking dl= (current time) with time_check= (previous time)
        je fps                      ;if equal start loop again

        mov time_check,dl           ;if not equal move dl in time_check(previous time)

        call clear_screen

        call mov_ball

        call draw_ball

        call move_paddle

        call draw_paddel

        call draw_boundary

        call draw_UI

        ;; drawing all the bricks

        call drawing_all_bricks

        ; MOV     CX, 2
        ; MOV     DX, 4000
        ; MOV     AH, 86H
        ; INT     15H

        ; mov ax,0
        ; mov bx,0
        ; mov cx,0
        ; mov dx,0

        jmp fps


    RET

level2 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;       level3      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

level2_complete proc

		mov ax,0
        mov AL,13                       ;video mode 320 X 200 resolution
        int 10h
		mov ah, 2
		mov dh, 10   ;row
		mov dl, 8   ;column
		int 10H
		mov dx,offset level2_completion
		mov ah,09
		int 21h	

        call endl
        mov dh, 13   ;row
		mov dl, 8   ;column
		int 10H
		mov dx,offset level1_completion_presskey
		mov ah,09
		int 21h	

    enter_kr_bhi_de_pls:

        mov ah,00h
		int 16h

        .if(al=='K' || al=='k')

		    ret

        .else

            jmp enter_kr_bhi_de_pls

        .endif

ret

level2_complete endp

level3 PROC

        .if( level < 3)

        call level2_complete

        add paddle_speed,2
        
        add ball_speed_x,1           ;increase speed of ball moving in x
        add ball_speed_y,1           ;increase speed of ball moving in y

        ;sub paddle_width,5           ;decreasing the width of the paddle

        mov score,105

        inc level

        mov brick1.collisions,3 
        mov brick2.collisions,3 
        mov brick3.collisions,3 
        mov brick4.collisions,3 
        mov brick5.collisions,3 
        mov brick6.collisions,3 
        mov brick7.collisions,3 

        mov brick1.color_of_brick,5 
        mov brick2.color_of_brick,5  
        mov brick3.color_of_brick,5  
        mov brick4.color_of_brick,5  
        mov brick5.color_of_brick,5  
        mov brick6.color_of_brick,5  
        mov brick7.color_of_brick,5  

        inc lives

        .endif

        call clear_screen

        call reset_position
        
        fps:

        mov ah,2Ch                  ;to find system time
        int 21h                     ;CH = hour CL = minute DH = second DL = 1/100 seconds
        
        cmp dl,time_check           ;checking dl= (current time) with time_check= (previous time)
        je fps                      ;if equal start loop again

        mov time_check,dl           ;if not equal move dl in time_check(previous time)

        call clear_screen

        call mov_ball

        call draw_ball

        call move_paddle

        call draw_paddel

        call draw_boundary

        call draw_UI

        call drawing_all_bricks

        jmp fps

    RET

level3 ENDP
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;       main        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

main PROC
        
    call Game_starting

main ENDP



end