program segment
org 100h
assume cs:program

start:

current_time1 db 0

mov ah,2ch
int 21h
mov current_time1,cl




mov [x_coords],0
mov [y_coords],0

mov ah,00h
mov al,03h
int 10h



mov ah,02h
mov bh,00h
mov dh,00h
mov dl,00h



int 10h


;variables
x_coords db 12 dup(0)
y_coords db 12 dup(0)

x_coords_stars db 25 dup(0)
y_coords_stars db 25 dup(0)

delay_var dw 40000
type_star db 25 dup(0)


all_stars dw 25


temp_x db 0
temp_y db 0

tail_x db 0
tail_y db 0

moving_up db 0
moving_down db 0
moving_right db 0
moving_left db 0





saved_bl db 0 

mov bl,0ffh

mov saved_bl,bl

mov bl,1




star_count dw 25

random_seed dw 0

c_par dw 1
a_par dw 57
m_par dw 80


;generating stars,coordinates,types of star
call get_seed
mov di,0
call gen_type_star



call get_seed
mov di,0
call generate_stars_x_cord
mov di,0
call get_seed
call generate_stars_y_cord
mov di,0
mov si,0
call check_for_duplicate
mov di,0
call draw_stars
mov di,0





mov dl,0
mov dh,0



main_loop:

	;main game loop

	mov di,0
	
	call read_input
	
	call arrows
		
	call quit

	call f_keys
	
	call move_down
	
	call move_up
	
	call move_right
	
	call move_left 
	
	call update_pos
	
	
	

	call delay_loop
	
	call draw_tile
	
	mov di,0
	call check_for_stars
	
	call check_for_time
	
	call star_count_draw
	
	call winning_condition
	

jmp main_loop
	



	;functions for moving snake in 4 directions

	move_down:
	cmp moving_down, 1
	jne not_move_down 
	
	cmp dh,25
	je skip_down
	
	
	mov ah, 02h
	inc dh
	int 10h


	
	ret
	
	skip_down:
	mov dh,0
	mov ah,02h
	int 10h
	ret 
	
	
	
	
not_move_down:
	ret
	
		
	move_up:
	cmp moving_up, 1
	jne not_move_up  
	
	cmp dh,0
	je skip_up
	
	
	mov ah, 02h
	dec dh
	int 10h

	ret
	
	skip_up:
	mov dh,24
	mov ah,02h
	int 10h
	ret 
	
	
	
	
not_move_up:
	ret
	
	
		
	move_right:
	cmp moving_right, 1
	jne not_move_right 
	
	cmp dl,79
	je skip_right
	
	
	mov ah, 02h
	inc dl
	int 10h
	
	ret
	
	skip_right:
	mov dl,0
	mov ah,02h
	int 10h
	ret 
	
	
	
	
not_move_right:
	ret
	
		
	move_left:
	cmp moving_left, 1
	jne not_move_left  
	
	cmp dl,00
	je skip_left
	
	
	mov ah, 02h
	dec dl
	int 10h
	

	ret
	
	skip_left:
	mov dl,79
	mov ah,02h
	int 10h
	ret 
	
	
	
	
not_move_left:
	ret
	
	
	
	
	draw_tile:
	
	
	
	mov ah, 09h
	mov al, ' '
	mov bh, 00h
	mov cx, 1
	mov bl, saved_bl
	int 10h
	
	
	

	
	ret
	
	
   
	delay_loop:
	;function for delaying movement of snake, so that is not instant
    mov cx, delay_var  
	delay_inner_loop:
    dec cx  
    jnz delay_inner_loop 
    ret 

	
	read_input:
    ;reading user input
	mov ah, 01h  
    int 16h
    jz no_key_pressed 

			
	key:
	
	mov ah,07h
	int 21h
	cmp al,00h
	je key
	
	ret 

	no_key_pressed:
	ret
	
	
	


	arrows:
	
	;updating flags for snake movement

	cmp al, up_arrow
    je up_arrow_read

    cmp al, down_arrow
    je down_arrow_read

    cmp al, left_arrow
    je left_arrow_read

    cmp al, right_arrow 
    je right_arrow_read
	
	
	
	ret 

	right_arrow_read:
	mov bl,1
	mov moving_right,bl
	mov bl,0
	mov moving_down,bl
	mov moving_up,bl
	mov moving_left,bl
	
	ret 
	
	left_arrow_read:
	
	
	mov bl,1
	mov moving_left,bl
	mov bl,0
	mov moving_right,bl
	mov moving_up,bl
	mov moving_down,bl
	
	ret 
	
	up_arrow_read:
	
	mov bl,1
	mov moving_up,bl
	mov bl,0
	mov moving_down,bl
	mov moving_right,bl
	mov moving_left,bl
	
	ret 
	
	down_arrow_read:
	mov bl,1
	mov moving_down,bl
		mov bl,0
	mov moving_right,bl
	mov moving_up,bl
	mov moving_left,bl
	
	ret 
	

	
	
	
f_keys:	

	;f-keys for choosing your snake color

	cmp al,f1_key
	je f1_key_check
	
	cmp al,f2_key
	je f2_key_check

	cmp al,f3_key
	je f3_key_check
	
	cmp al,f4_key
	je f4_key_check
	
	cmp al,f5_key
	je f5_key_check

	cmp al,f6_key
	je f6_key_check
	
	cmp al,f7_key
	je f7_key_check
	
	cmp al,f8_key
	je f8_key_check
	
	
	ret 
	
	f1_key_check:	
	mov bl, 070h
	mov saved_bl,bl 
	
	ret
	
	f2_key_check:	
	mov bl,010h
	mov saved_bl,bl 
	ret
	
	f3_key_check:	
	mov bl,020h
	mov saved_bl,bl 
	ret 
	f4_key_check:	
	mov bl,090h
	mov saved_bl,bl 
	ret 
	
	f5_key_check:	
	mov bl,040h
	mov saved_bl,bl 
	ret
	
	f6_key_check:	
	mov bl,0d0h
	mov saved_bl,bl 
	ret 
	
	f7_key_check:	
	mov bl,060h
	mov saved_bl,bl 
	ret 
	
	f8_key_check:	
	mov bl,0F0h
	mov saved_bl,bl 
	ret 
	
	
	



;function for quitting the program
quit:

cmp al,esc_key
je esc_key_read 

ret


esc_key_read:
    mov ah, 4Ch      
    int 21h
	
	ret 
	
	





update_pos:

;function for updating snake position

cmp si,12 
jge delete_tile

mov [x_coords+si],dl 
mov [y_coords+si],dh 
inc si
ret



delete_tile:


;function for deleting a previous snake tile

mov al,[x_coords]


mov tail_x,al
 
mov al,[y_coords]

mov tail_y,al 


jmp rewrite





rewrite:

cmp di,11
jge array_end




mov al,[x_coords+di+1]
mov [x_coords+di],al

mov al,[y_coords+di+1]
mov [y_coords+di],al 

inc di 
jmp rewrite 
 


array_end:

mov di,11

mov [x_coords+di],dl 
mov [y_coords+di],dh 






mov ah,02h
mov dl,tail_x
mov dh,tail_y
int 10h



mov ah,09h
mov al, ' '
mov cx,1
mov bl,000h
int 10h

mov bl,saved_bl 

mov ah,02h
mov dl,[x_coords+11]
mov dh,[y_coords+11]
int 10h


ret 


generate_stars_x_cord:

	;function for generating x coordinates of stars


	cmp di,25
	jge gen_end
	

	  
	  
	
	  
    call generate_random_coordinates  

	
	rng_number:
    mov ax, random_seed  
    xor dx, dx          
    mov cx, 80          
    div cx              
    mov [temp_x], dl   
	
	cmp dl,79
	jge minus
	
	
	
	move_to_array:
	 mov [x_coords_stars + di], dl  
    inc di  
     
	 
	jmp generate_stars_x_cord
    
	
	
	minus:
	cmp dl,80
	jl move_to_array
	sub dl,80
	jmp minus
	
	
	
	
	gen_end:
    ret
generate_random_coordinates:
	
	call add_rng
	
	mov ax, random_seed    
    mul a_par      
    add ax, c_par  
    mov dx, 0
    div m_par     
    mov random_seed, dx  
	
	
    ret
     

	draw_stars:
	

	;function for generating 25 stars on whole "map"

	cmp di,25
	jg draw_stars_end
	
	mov dl,[x_coords_stars+di]
	mov dh,[y_coords_stars+di]


	mov cl,[type_star+di]
	
	
	
	cmp cl,1
	je red_star
	
	cmp cl,2
	je blue_star
	
	cmp cl,3
	je green_star
	
	
	
	red_star:
	mov bl,04h
	jmp make_star
	
	
	blue_star:
	mov bl,01h
	jmp make_star
	
	green_star:
	mov bl,02h
	jmp make_star
	
	
	
	
	
	
	
	make_star:



	mov ah,02h
	int 10h
	
	
	mov ah,09h
	mov bh,00h
	mov al,'*'
	mov cx,1
	int 10h
	

	inc di

	
	jmp draw_stars
	
	
	
	draw_stars_end:
	ret 
	
	
	
	
	;functions for manipulating PRNG
	
get_seed:
  
   mov ah, 2Ch    
int 21h      
push dx   
xor dx, dx   
mov cx, 1000h  
div cx  
pop dx  
mov random_seed, dx 
ret


add_rng:


cmp di,10
jge addRNG

ret 

addRNG:
inc c_par
dec m_par
dec random_seed
ret




generate_stars_y_cord:


	;function for generating y coordinates of stars

	cmp di,25
	jge gen2_end
	
    call generate_random_coordinates 

	
	rng_number2:
    mov ax, random_seed  
    xor dx, dx          
    mov cx, 24   
    div cx    
    mov [temp_x], dl 
	
	cmp dl,24
	jge minus2
	
	
	
	move_to_array2:
	 mov [y_coords_stars + di], dl 
    inc di 
     
	 
	jmp generate_stars_y_cord
    
	
	
	minus2:
	cmp dl,25
	jl move_to_array2
	sub dl,24
	jmp minus2
	
	
	
	
	gen2_end:
    ret


	check_for_stars:
	
	;function for checking if snake head hits the star
	
	mov dl,[x_coords+11]
	mov dh,[y_coords+11]
	
	mov cl,[x_coords_stars+di]
	mov ch,[y_coords_stars+di]
	
	cmp di,25
	jge toreturn
	

	cmp dl,cl
	je check_for_y
	
	inc di
	jmp check_for_stars
	
	check_for_y:
	
	cmp dh,ch
	je remove_star
	

	inc di
	jmp check_for_stars
	
	
	
	
	remove_star:

	;function for removing star and adding faster movement of snake
	
	mov dl,[type_star+di]
	
	cmp dl,1
	je delay1
	
	cmp dl,2
	je delay2
	
	cmp dl,3
	je delay3
	
	
	delay1:
	sub delay_var,200
	jmp removing
	
	delay2:
	sub delay_var,400
	jmp removing
	
	
	delay3:
	sub delay_var,600
	jmp removing
	
	removing:
	
	mov dl,255
	mov dh,255

	mov [x_coords_stars+di],dl
	mov [y_coords_stars+di],dh
	
	sub star_count,1
	
	
	inc di
	jmp check_for_stars
	
	toreturn:
	ret

	
	
	winning_condition:
	
	;if stars==0 then program ends
	
	cmp star_count,0
	je end_program
	
	
	ret
	
	end_program:
	mov ah,4ch
	int 21h



	gen_type_star:

	;function for generating colored stars

	cmp di,24
	jge gen3_end
	
    call generate_random_coordinates 

	
	rng_number3:
    mov ax, random_seed  
    xor dx, dx          
    mov cx, 24      
    div cx       
    mov [temp_x], dl  
	
	cmp dl,3
	jge minus3
	
	
	
	move_to_array3:
	 mov [type_star + di], dl  
    inc di  
     
	 
	jmp gen_type_star
    
	
	
	minus3:
	cmp dl,4
	jl move_to_array3
	sub dl,3
	jmp minus3
	
	
	
	
	gen3_end:
    ret


check_for_time:

	;function for checking if 2 minutes passed if so faster movement of snake will be
    push ax
    push dx

    mov ah, 2Ch         
    int 21h
    mov al, current_time1 

  
    sub al, cl           
 
    cmp al, 2
    jae remove_time

 
    mov current_time1, cl

    pop dx
    pop ax
    ret

remove_time:
    sub delay_var, 500   
    mov current_time1, cl 
    pop dx
    pop ax
    ret
	
	
	
	star_count_draw:
	
	;function for generating star count in left bottom corner
	
	
	mov ah,02h
	mov dl,0
	mov dh,24

	int 10h

	
	mov ah,02h
	mov dl,'['
	int 21h
	
	mov ah,02h
	mov dl,1
	mov dh,24

	int 10h

	
	
	
	
	
	 mov ax, star_count     
    xor cx, cx            
	mov bx, 10  




	cmp ax, 10
	jb print_from_0_to_9













divide_loop:
    xor dx, dx          
    div bx               
    push dx
    inc cx            
    test ax, ax        
    jnz divide_loop  

	jmp print_loop


print_from_0_to_9:

call print_from_0_to_9_v2

ret



print_loop:
    pop dx     
    add dl, '0'   
    mov ah, 02h   
    int 21h

	mov ah,08h
	int 10h

    loop print_loop  

 
	mov ah,02h
	mov dl,3
	mov dh,24

	int 10h

	
	mov ah,02h
	mov dl,'/'
	int 21h

	mov ah,02h
	mov dl,4
	mov dh,24

	int 10h

	jmp all_stars_2


	all_stars_2:
	mov ax, all_stars    
    xor cx, cx   
	mov bx, 10 




divide_loop3:
    xor dx, dx  
    div bx      
    push dx  
    inc cx     
    test ax, ax    
    jnz divide_loop3   



print_loop3:
    pop dx        
    add dl, '0'    
    mov ah, 02h    
    int 21h     
    loop print_loop3    


	mov ah,02h
	mov dl,6
	mov dh,24

	int 10h


	mov ah,02h
	mov dl,']'
	int 21h
	




	mov bl,saved_bl 
	mov ah,02h
	mov dl,[x_coords+11]
	mov dh,[y_coords+11]
	int 10h

	
	
	ret
	
	
	check_for_duplicate:
	
	
	
	mov dl,[x_coords_stars+di]
	mov dh,[x_coords_stars+di+1]
	
	
	cmp dl,dh
	je check_y_dup
	
	
	inc di
	inc si
	
	
	cmp di,26
	je dup_end
	
	
	
	jmp check_for_duplicate
	
	
	
	check_y_dup:
	
	mov dl,[y_coords_stars+si]
	mov dh,[y_coords_stars+si+1]
	
	
	
	cmp dl,dh
	je increment_star
	
	
	
	
	
	
	
	
	
	ret 
	
	
	
	
	
	
	ret 
	
	
	
	
	
	increment_star:
	
	
	inc dh
	mov [y_coords_stars+si+1],dh
	
	
	
	jmp check_for_duplicate
	
	
	
	dup_end:
	ret

	




	print_from_0_to_9_v2:




	xor cx,cx


divide_loop_9:
    xor dx, dx          
    div bx               
    push dx
    inc cx            
    test ax, ax        
    jnz divide_loop_9  





	print_loop_v2:
    pop dx     
    add dl, '0'   
    mov ah, 02h   
    int 21h

    loop print_loop_v2  

 
	mov ah,02h
	mov dl,2
	mov dh,24

	int 10h

	
	mov ah,02h
	mov dl,'/'
	int 21h

	mov ah,02h
	mov dl,3
	mov dh,24

	int 10h

	jmp all_stars_2_2


	all_stars_2_2:
	mov ax, all_stars    
    xor cx, cx   
	mov bx, 10 




divide_loop3_v2:
    xor dx, dx  
    div bx      
    push dx  
    inc cx     
    test ax, ax    
    jnz divide_loop3_v2   



print_loop3_v2:
    pop dx        
    add dl, '0'    
    mov ah, 02h    
    int 21h     
    loop print_loop3_v2    


	mov ah,02h
	mov dl,5
	mov dh,24

	int 10h


	mov ah,02h
	mov dl,']'
	int 21h

		mov ah,02h
	mov dl,6
	mov dh,24

	int 10h


	mov ah,02h
	mov dl,' '
	int 21h

	




	mov bl,saved_bl 
	mov ah,02h
	mov dl,[x_coords+11]
	mov dh,[y_coords+11]
	int 10h




	ret

   
up_arrow equ 48h      
esc_key equ 1Bh       
down_arrow equ 50h   
left_arrow equ 4Bh     
right_arrow equ 4Dh  

f1_key equ 3bh
f2_key equ 3ch
f3_key equ 3dh
f4_key equ 3eh
f5_key equ 3fh
f6_key equ 40h
f7_key equ 41h
f8_key equ 42h





program ends
end start
