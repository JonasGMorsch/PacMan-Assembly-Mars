.include "graphics.asm"
.include "macros.asm"
#.include ".asm"
#.data 
#stringTest98: .asciiz "test test test \n"
#.align 2

.text


############################################## *NUCLEAR TEST SITE* ##########################################
	#la 	$a0, pacman
	#la 	$a1, grid
	#jal	returnNextId
	#printString("\n Result: ")
	#printInt($v0)
	#EndProgram
	#lb $v0, grid	
	#printString("\n V0: ")	
	#printInt($v0)
	#EndProgram
#############################################################################################################    
 	#li 	$v0, 4
 	#la	$a0, stringTest98
    	#syscall
	#CHAMA DRAW GRID
	#add 	$a0, $zero, GRID_ROWS	#a0 = 35
	#add 	$a1, $zero, GRID_COLS	#a1 = 35
	#la 	$a0, grid				#a0 = &grid
	#jal 	drawGrid    			# void drawGrid(void)
	jal 	drawGridHardCoded   			# void drawGridLinear(void)
	
		#jal 	enableProcessorInterrupt
	jal 	enableKeyboardInterrupt	# void enableKeyboardInterrupt()
    	
#SysLock # While(1); Usefull to test imterrupts


#############################################################################################################    
main:
#animated_sprite (%name, %id, %pos_x, %pos_y, %mov_x, %mov_y)
#		ofset:	&  ,  0  ,   4  ,    8  ,   12  ,  16

	la 	$s0, pacman	# s0 = &pacman			# name
	lw 	$a0, 4($s0)	# a0 = pacman[1]		# pos_x
	lw 	$a1, 8($s0)	# a1 = pacman[2]		# pos_y
	lw 	$a2, 0($s0)	# a2 = pacman[0]		# id

	jal 	drawSprite	# void drawSprite(a0,a1,a2)	# 
	#EndProgram
	
	la 	$a0, pacman	# a0 = &pacman
	jal 	apply_movement	# void enableMovement(a0)
	
	la 	$s0, ghost0	# s0 = &ghost0
	lw 	$a0, 4($s0)	# a0 = ghost0[1]
	lw 	$a1, 8($s0)	# a1 = ghost0[2]
	lw 	$a2, 0($s0)	# a2 = ghost0[0]
	jal 	drawSprite	# void drawSprite(a0,a1,a2)
	
	la 	$s0, ghost1	# s0 = &ghost1
	lw 	$a0, 4($s0)	# a0 = ghost1[1]
	lw 	$a1, 8($s0)	# a1 = ghost1[2]
	lw 	$a2, 0($s0)	# a2 = ghost1[0]
	jal 	drawSprite	# void drawSprite(a0,a1,a2)
	
	la 	$s0, ghost2	# s0 = &ghost2
	lw 	$a0, 4($s0)	# a0 = ghost2[1]
	lw 	$a1, 8($s0)	# a1 = ghost2[2]
	lw 	$a2, 0($s0)	# a2 = ghost2[0]
	jal 	drawSprite	# void drawSprite(a0,a1,a2)
	
	la 	$s0, ghost3	# s0 = &ghost3
	lw 	$a0, 4($s0)	# a0 = ghost3[1]
	lw 	$a1, 8($s0)	# a1 = ghost3[2]
	lw 	$a2, 0($s0)	# a2 = ghost3[0]
	jal 	drawSprite	# void drawSprite(a0,a1,a2)

   	j 	main			# goto main
#############################################################################################################    

#############################################################################################################
 enableProcessorInterrupt: ###### Why this?
	add 	$t0, $zero, 1	# t0 = 1
	sll 	$t0, $t0, 8	# t0 = t0 << 8
	or 	$12, $t0, $12	# $12 = t0 | $12
	ori 	$12, $12, 1	# $12 = $12 | 1
	jr   	$ra		# return

 enableKeyboardInterrupt:
	add 	$t0, $zero, 0xffff0002	# t0 = 0xffff0002
	sw 	$t0, 0xffff0000		# *((uint32_t) 0xffff0000) = t0
	jr   $ra					# return
#############################################################################################################    
	
#############################################################################################################    

drawGridHardCoded:				# void drawGrid(byte *grid)
	la 	$s0, grid		# &grid
	li 	$s1, 0		# drawGridRows for
	la	$s2, FB_PTR	# Dysplay adress
	la 	$s3, colors	# color words adress
	li 	$s4, 0		# drawGridDrawPixelX for
	li 	$s5, 0		# drawGridDrawPixelY for
	li 	$s6, 0		# drawGridCols for
	
drawGridRows:					
	bge  $s1, GRID_ROWS, drawGridCols	# ((i => 1225) ? goto drawGridExit)
	addi $s1, $s1, 1			# s1++
				
	lb   $t1, ($s0)			# sprite.ID = *(animatedSprite.ID)
	addi $s0, $s0, 1			# &grid++
	addi $t1, $t1, GRID_ID_OFFSET	# sprite.ID -= 64
	mul	$t1, $t1, SPRITE_SIZE
	la 	$t2,sprites
	add 	$t1, $t1, $t2 

drawGridDrawPixelX:
	bge  $s4, X_SCALE, drawGridDrawPixelY	# ((t => 7) ? goto drawGridDrawPixelXEnd()	
	addi	$s4, $s4, 1
	lb 	$t2, ($t1)
	addi	$t1, $t1, 1	# &sprite++
	sll	$t2, $t2, 2	# color id * 4
	add	$t2, $t2, $s3 	# color id += &color 
	lw 	$t2, ($t2)
	sw	$t2, ($s2)
	addi	$s2, $s2, 4
	b drawGridDrawPixelX
		
drawGridDrawPixelY:
	bge  $s5, Y_SCALE, drawGridDrawSprite	# ((t => 7) ? goto drawGridDrawPixelXEnd()	
	addi	$s5, $s5, 1	
	add	$s4, $zero, $zero
	addi	$s2, $s2, 996 # (256-7)*4
	b drawGridDrawPixelX

drawGridDrawSprite:
	add	$s5, $zero, $zero
	add	$s4, $zero, $zero
	addi	$s2, $s2, -7168 # -256*4*7
	b drawGridRows
	
drawGridCols:	
	bge  $s6, GRID_COLS, drawGridEnd	# ((t => 7) ? goto drawGridDrawPixelXEnd()	
	addi	$s6, $s6, 1
	add	$s5, $zero, $zero
	add	$s4, $zero, $zero
	add	$s1, $zero, $zero
	addi	$s2, $s2, 6188 # (256*7*4)-(35*7*4)
	b drawGridRows
	
drawGridEnd:	
	jr $ra
#############################################################################################################    

#############################################################################################################
.globl drawGrid
drawGrid:				# void drawGrid(byte *grid)
	addi $sp, $sp, -40	# sp = sp -40
	sw 	$ra, 36($sp)	# sp[9] = ra
	sw 	$s0, 16($sp)	# sp[4] = s0
	sw 	$s1, 20($sp)	# sp[5] = s1
	sw 	$s2, 24($sp)	# sp[6] = s2
 	sw 	$s3, 28($sp)	# sp[7] = s3
	sw 	$s4, 32($sp)	# sp[8] = s4

	#move $s0, $a0				# &grid
	la 	$s0, grid				# &grid
	add 	$s3, $zero, $zero		# gridY = 0
drawGridLinha:					
	bge  $s3, GRID_ROWS, drawGridExit 		# ((s3 => 35) ? drawGridExit)
	add 	$s4, $zero, $zero		# gridX = 0				# GridX
drawGridColuna:	
	#bge  $s4, $s1, drawGridColunaExit
	bge  $s4, GRID_COLS, drawGridColunaExit	# ((s4 => 35) ? drawGridExit)

	mulu $a0, $s4, Y_SCALE		# posX = gridY * 7
	mulu $a1, $s3, X_SCALE		# posY = gridX * 7
	lb   $a2, ($s0)			# sprite.ID = *(animatedSprite.ID)
	addi $a2,$a2, -64			# sprite.ID -= 64
	jal  drawSprite			# drawSprite (posX, posY, animatedSprite.ID)
	
	addi $s0, $s0, 1			# gridY++
	addi $s4, $s4, 1			# gridX++
	j 	drawGridColuna
drawGridColunaExit:
	addi $s3, $s3, 1
	j 	drawGridLinha
drawGridExit:	
	lw 	$ra, 36($sp)
	lw 	$s0, 16($sp)
	lw 	$s1, 20($sp)
	lw 	$s2, 24($sp)
 	lw 	$s3, 28($sp)
 	lw 	$s4, 32($sp)
	addi $sp, $sp, 40
	jr   $ra
#############################################################################################################

# draw_sprite(X, Y, sprite_id) 
# draw_sprite(X, Y, sprite_id) 
.globl drawSprite
drawSprite:				# drawSprite()
	
	addi $sp, $sp, -40		#sp = &sp -40
	sw 	$ra, 36($sp)		#sp[9] = ra
	sw 	$s0, 16($sp)		#sp[4] = s0
	sw 	$s1, 20($sp)		#sp[5] = s1
	sw 	$s2, 24($sp)		#sp[6] = s2
 	sw 	$s3, 28($sp)		#sp[7] = s3
	sw 	$s4, 32($sp)		#sp[8] = s4
	
	move $s0, $a0			# s0 = a0
	move $s1, $a1			# s1 = a1
	# a2 = animatedSprite.ID
	
	la 	$s2, sprites 			# s2 = &sprites
	mul 	$a2, $a2, SPRITE_SIZE	# t1 = a2 * SPRITE_SIZE(49)
	add 	$s2, $a2, $s2			# s2 = t1 + s2
	
	la 	$s4, colors			# s4 = &colors
	add 	$s3, $zero, $zero		# s3 = 0
drawSpriteLoop:	
	bge 	$s3, SPRITE_SIZE, drawSpriteEnd	# ((s3 <= 49) ? drawSpriteEnd)

	lb	$t3, ($s2) 		# t3 = *(byte)s2
	#printString ("\n LOAD BYTE value")
	#printInt ($t3)
		
	sll 	$t3, $t3, 2		# t3 = t3 << 2
	add 	$t3, $t3, $s4		# t3 += s4
	lw  	$a2, ($t3)		# a2 = *(uint32_t*)t3
	div 	$t5, $s3, 7 		#t5 y
	mfhi $t6 				#t6 X
	add 	$a0, $s0, $t6		#a0 = s0 + t6
	add 	$a1, $s1, $t5		#a1 = s1 + t5
	

	###########################################
	#jal 	drawPixel
	
   	la  	$t0, FB_PTR
   	mul 	$a1, $a1, FB_XRES 	#(I*LINHAS)+J)*4 + adress
   	add 	$a0, $a0, $a1		# a0 += a1
   	sll 	$a0, $a0, 2		# a0 = a0 << 2
   	add 	$a0, $a0, $t0		# a0 += t0
   	sw  	$a2, ($a0)		# uint32_t *a0 = a2 ?
   	###########################################
   	
	addi $s3, $s3, 1 		# s3 = 1;
	addi $s2, $s2, 1		# s2 = 1;
	#b 	drawSpriteLoop
	j 	drawSpriteLoop
	
drawSpriteEnd:
	lw 	$ra, 36($sp)		# ra = sp[9]
	lw 	$s0, 16($sp)		# s0 = sp[4]
	lw 	$s1, 20($sp)		# s1 = sp[5]
	lw 	$s2, 24($sp)		# s2 = sp[6]
 	lw 	$s3, 28($sp)		# s3 = sp[7]
 	lw 	$s4, 32($sp)		# s4 = sp[8]
	addi	$sp, $sp, 40		# sp = sp + 40
    	jr  	$ra			# return
#############################################################################################################	

# drawPixel(X, Y, color)
.globl drawPixel
drawPixel:
   	la  	$t0, FB_PTR
   	mul 	$a1, $a1, FB_XRES 	#(I*LINHAS)+J)*4 + adress
   	add 	$a0, $a0, $a1		# a0 += a1
   	sll 	$a0, $a0, 2		# a0 = a0 << 2
   	add 	$a0, $a0, $t0		# a0 += t0
   	sw  	$a2, ($a0)		# uint32_t *a0 = a2 ?
   	jr  	$ra			# return
   	
.globl stop_sprite
stop_sprite:
 	sw 	$zero, 12($a0)
 	sw 	$zero, 16($a0)
 	jr 	$ra
 	
 	#move_sprite(*struct,mov_x, mov_y)
.globl move_sprite
move_sprite:
 	sw 	$a1, 12($a0) #MOVE SPRITE
 	sw 	$a2, 16($a0)
 	jr 	$ra
 	
 	#
.globl apply_movement
apply_movement:
 	addi $sp, $sp, -64
	sw 	$ra, 20($sp)
	sw 	$s0, 16($sp)
	
	move $s0, $a0
 
 	lw 	$t0, 4($s0)
 	lw 	$t1, 8($s0)
 	lw 	$t2, 12($s0)
	lw 	$t3, 16($s0)
	add 	$t0, $t0, $t2
	add 	$t1, $t1, $t3
	move $a0, $t0
	move $a1, $t1
	la 	$a2, grid
	####################################### testing returned values by returnNextId
	sw 	$a0, 24($sp)
	sw 	$a1, 28($sp)
	sw 	$a2, 24($sp)
	sw 	$a3, 28($sp)
	sw 	$v0, 28($sp)
	#jal 	checkWall
	la 	$a0, pacman
	la 	$a1, grid
	jal	returnNextId
	printString("\n V0: ")	
	printInt($v0)
	lw 	$a0, 24($sp)
	lw 	$a1, 28($sp)
	lw 	$a2, 24($sp)
	lw 	$a3, 28($sp)
	lw 	$v0, 28($sp)
	#######################################
	bnez 	$v0, end_apply
	sw 	$t0, 4($s0)
	sw 	$t1, 8($s0)
	b 	apply_final
end_apply:
	jal 	stop_sprite
apply_final:
	lw 	$ra, 20($sp)
	lw 	$s0, 16($sp)


	addi 	$sp, $sp, 64
	jr 	$ra
#############################################################################################################


 .globl returnId
 returnId:		 	# (X,Y, *gride)
	addi $sp, $sp, -32
	sw 	$ra, 24($sp)
	sw 	$s1, 16($sp)
	sw 	$s0, 20($sp)
	
	move $s0, $a0
	div  $s1, $a1, 7	# s1 = a1 / 7
	mfhi $s0			# ?
	add 	$s1, $s1, $a1	# s1 += a1
	add 	$s0, $s0, $a0	# s0 += a0	
	add  $s1, $s1,$s0 	# s1 += s0
	sll 	$s1, $s1, 2	# s1 = s1 << 2
	add  $s1,$s1, $a2	# s1 += a2
	#lbu $s1, 0($s1)	# ?
	lb   $s1, ($s1)	# ?
	addi $v0, $s1, -64	# v0 = s1 - 64
		
	lw 	$ra, 24($sp)
	lw 	$s1, 16($sp)
	lw 	$s0, 20($sp)
	addi $sp, $sp, 32	# sp = &sp + 32
	jr 	$ra			# Return
#############################################################################################################

.globl returnNextId
 returnNextId:		# int ID returnNextId(X,Y, *gride)
	addi $sp, $sp, -24
	sw 	$ra, 0($sp)
	sw 	$s0, 4($sp)
	sw 	$s1, 8($sp)
	sw 	$s2, 12($sp)
	sw 	$s3, 16($sp)
	
#animated_sprite (%name, %id, %pos_x, %pos_y, %mov_x, %mov_y)
#		ofset:	&  ,  0  ,   4  ,    8  ,   12  ,  16	
	lw	$s0, 4($a0) 	# s0 = animatedSprite.posX;
	lw	$s1, 8($a0) 	# s1 = animatedSprite.posY;
	lw	$s2, 12($a0)	# s2 = animatedSprite.movX;
	lw	$s3, 16($a0)	# s3 = animatedSprite.movY;
	
	beq 	$s2, -1, returnNextIdIfPosX	# animatedSprite.movX == -1 ? goto returnNextIdIfPosX;
	beq 	$s3, -1, returnNextIdIfPosY	# animatedSprite.movY == -1 ? goto returnNextIdIfPosY;
	b returnNextIdElse

returnNextIdIfPosX:
	add $s0, $s0, 6 		# tPosX=animatedSprite.posX + 6;
	b returnNextIdElse
	
returnNextIdIfPosY:
	add $s1, $s1, 6		# tPosY=animatedSprite.posY + 6;
	b returnNextIdElse

returnNextIdElse:	
	div $s0, $s0, X_SCALE	# tPosX /= 7;
	div $s1, $s1, Y_SCALE	# tPosY /= 7;
	
	add $s0, $s0, $s2		# tPosX += animatedSprite.movX;
	add $s1, $s1, $s3		# tPosY += animatedSprite.movY;
	
	mul $s1, $s1, GRID_COLS	# tPosY *= 35;
	add $s0, $s0, $s1		# tPosX += tPosY;

	
	add $a0, $s0, $a1		# tPosX += &grid 
	lb $v0, ($a0)			# v0 = grid[tPosX][tPosY];	

	lw 	$ra, 0($sp)
	lw 	$s0, 4($sp)
	lw 	$s1, 8($sp)
	lw 	$s2, 12($sp)
	lw 	$s3, 16($sp)
	addi $sp, $sp, 24	
	jr 	$ra				# return
#############################################################################################################

# (X,Y, *gride)
.globl checkWall 
checkWall:
	addi $sp, $sp, -24
	sw $ra, 16($sp)
	
	jal returnId
	bge $v0, 5, checkWallTrue
	#li $v0, 0
	add $v0, $zero, $zero
	b checkWallEnd
	
checkWallTrue:
	#li $v0, 1
	add $v0, $zero, 1
	
checkWallEnd: 	
 	lw $ra, 16($sp)
	addi $sp, $sp, 24
	jr $ra
#############################################################################################################

############################################################################################################# 	
    	  	  	
#animação + teclado + mov + stop + strcut

.ktext 0x80000180
#Create Interuptions Stack 
  	move  	$k0, $at      # $k0 = $at 
  	la    	$k1, kernelRegisters    
  	sw    	$k0, 0($k1)   
  	sw    	$v0, 4($k1)
  	sw    	$v1, 8($k1)
  	sw    	$a0, 16($k1)
  	sw    	$a1, 20($k1)
 	sw    	$a2, 24($k1)
  	sw    	$a3, 28($k1)
 	sw    	$t0, 32($k1)
	sw    	$t1, 36($k1) 
	sw    	$t2, 40($k1)
	sw    	$t3, 44($k1)
	sw    	$t4, 48($k1)
  	sw    	$t5, 52($k1)
	sw    	$t6, 56($k1)
	sw    	$t7, 60($k1)
	sw    	$s0, 64($k1)
	sw    	$s1, 68($k1)
	sw    	$s2, 72($k1)
	sw    	$s3, 76($k1) 
	sw    	$s4, 80($k1)
	sw    	$s5, 84($k1)
	sw    	$s6, 88($k1)
	sw    	$s7, 92($k1)
	sw    	$t8, 96($k1)
	sw    	$t9, 100($k1)
	sw    	$gp, 104($k1)
	sw    	$sp, 108($k1)
	sw    	$fp, 112($k1)
	sw    	$ra, 116($k1)
	mfhi  	$k0
  	sw    	$k0, 120($k1)
  	mflo  	$k0
  	sw    	$k0, 124($k1)
  	
  	#########################
  	#la    	$a0, stringGenericEx    
  	#li    	$v0, 4
  	#syscall    
  	printStringAdress(stringGenericEx)
	#########################
	
  	mfc0  	$a0, $13
  	andi  	$a0,$a0,0x007C
  	la 	$a1, jtable	#load andress of vector
  	add 	$a1, $a1, $a0 	# jtable adress
  	lw    	$a1, 0($a1)	# Carrego valor do elemento em $t0
  	#EndProgram
  	jr 	$a1
  
case0:
    	#########################
    	#print HWInterrupt
	#li 	$v0, 4
	#la 	$a0, stringHWInterruptEx 
	#syscall
	printStringAdress(stringHWInterruptEx)
	#########################
	
	mfc0  	$a0, $14
	addi 	$a0, $a0, -4
	mtc0  	$a0, $14
    
	la 	$a2, 0xffff0000  	#Load keyboard info on $a2 to the right address
	lw 	$a1, 4($a2)		#Carregando dados lidos pelo teclado
    
	beq 	$a1,100, hwInterruptGoRight	# Key d, go Right
	beq 	$a1, 68, hwInterruptGoRight	# Key D, go Right
	beq 	$a1, 97, hwInterruptGoLeft	# Key a, go Left
	beq 	$a1, 65, hwInterruptGoLeft	# Key A, go Left
	beq 	$a1,119, hwInterruptGoUp		# Key w, go Up
	beq 	$a1, 87, hwInterruptGoUp		# Key W, go Up
	beq 	$a1,115, hwInterruptGoDown	# Key s, go Down
	beq 	$a1, 83, hwInterruptGoDown	# Key S, go Down
	beq 	$a1, 32, hwInterruptPause	# Key Space, Pause game
	j   	switchCaseBreak
    
hwInterruptGoRight:
	li  	$a1, 1	#x
	li  	$a2, 0	#y
 	j 	hwInterruptEnd
 	
hwInterruptGoLeft:
	li  	$a1, -1	#x
	li  	$a2, 0	#y
 	j 	hwInterruptEnd
 	
hwInterruptPause:
	li  	$a1, 0	#x
	li  	$a2, 0	#y
 	j 	hwInterruptEnd
 	
hwInterruptGoUp:
	li  	$a1, 0	#x
	li  	$a2, -1	#y
 	j 	hwInterruptEnd
 	
hwInterruptGoDown:
	li  	$a1, 0	#x
	li  	$a2, 1	#y
 	j 	hwInterruptEnd
 	
hwInterruptEnd:
    	la  	$a0, pacman	# Load Sprite adress , Sprite Name
	la  	$v0, move_sprite
	jalr $v0
	#jal	move_sprite	#branch can't handle this
	j   	switchCaseBreak

case4:
#print ADDRL
    	li 	$v0, 4
    	la 	$a0, stringLoadErrorEx
    	syscall
    	j   	switchCaseBreak
case5:
#print ADDRS 
    	li 	$v0, 4
    	la 	$a0, stringStoreErrorEx
    	syscall
    	j   	switchCaseBreak
case6:
#print IBUS
    	li 	$v0, 4
    	la 	$a0, stringBusInstErrorEx
    	syscall
    	j   	switchCaseBreak
case7:
#print Bus error on dara load or store
    	li 	$v0, 4
    	la 	$a0, stringBusLSErrorEx
    	syscall
    	j   	switchCaseBreak
case8:
#print syscal instruction
    	li 	$v0, 4
    	la 	$a0, stringInvalidSyscallEx
    	syscall
    	j   	switchCaseBreak
case9:
#print Breakpoint instruction
    	li 	$v0, 4
    	la 	$a0, stringBreakPointEx
    	syscall
    	j   	switchCaseBreak
case10:
#print Reserved instructoin exception
    	li 	$v0, 4
    	la 	$a0, stringReservedEx
    	syscall
    	j   	switchCaseBreak
case12:
    #Arithmetic overflow wxception
    	li 	$v0, 4
	la 	$a0, stringArithmeticEx
    	syscall
    	j   	switchCaseBreak
case13:
#print Excection caused by trap instruction
    	li 	$v0, 4
    	la 	$a0, stringTrapEx
    	syscall
    	j   	switchCaseBreak 
case1:
case2:
case3:
case11:
case14:
    #print invalid exception 
    	li 	$v0, 4
    	la 	$a0, stringInvalidEx
    	syscall
    	j   	switchCaseBreak
    
case15:
#print Floating point
    	li 	$v0, 4
    	la 	$a0, stringFloatInstEx
    	syscall
    	j   	switchCaseBreak

default:
    #print out_of_range
    	li 	$v0, 4
    	la 	$a0, stringOutOfRangeEx
    	syscall
switchCaseBreak:
#Restore Interuptions Stack 
	la    	$k1, kernelRegisters
	lw    	$k0, 0($k1)
	lw    	$v0, 4($k1)
	lw    	$v1, 8($k1)
	lw    	$a0, 16($k1)
	lw    	$a1, 20($k1)
	lw    	$a2, 24($k1)
	lw    	$a3, 28($k1)
	lw    	$t0, 32($k1)
	lw    	$t1, 36($k1) 
	lw    	$t2, 40($k1)
	lw    	$t3, 44($k1)
	lw    	$t4, 48($k1)
	lw    	$t5, 52($k1)
	lw    	$t6, 56($k1)
	lw    	$t7, 60($k1)
	lw    	$s0, 64($k1)
	lw    	$s1, 68($k1)
	lw    	$s2, 72($k1)
	lw    	$s3, 76($k1) 
	lw    	$s4, 80($k1)
	lw    	$s5, 84($k1)
	lw    	$s6, 88($k1)
	lw    	$s7, 92($k1)
	lw    	$t8, 96($k1)
	lw    	$t9, 100($k1)
	lw    	$gp, 104($k1)
	lw    	$sp, 108($k1)
	lw    	$fp, 112($k1)
	lw    	$ra, 116($k1)
	lw    	$k0, 120($k1)
	mthi  	$k0
	lw    	$k0, 124($k1)
	mtlo  	$k0
	mfc0  	$k0, $14      # $k0 = EPC 
	addiu 	$k0, $k0, 4   # Increment $k0 by 4 
	mtc0  	$k0, $14      # EPC = point to next instruction 
	eret
.kdata
jtable: .word case0, case1, case2, case3, case4, case5, case6, case7, case8, case9, case10, case11, case12, case13, case14, case15, default

# Excepion String Table
stringGenericEx: 	.asciiz "Exception Occurred: "
stringHWInterruptEx:	.asciiz "HW Interrupt\n"	  
stringLoadErrorEx: 	.asciiz "Address Error caused by load or instruction fetch\n"
stringStoreErrorEx: 	.asciiz "Address Error caused by store instruction\n"
stringBusInstErrorEx: 	.asciiz "Bus error on instruction fetch\n"
stringBusLSErrorEx: 	.asciiz "Bus error on data load or store\n"
stringInvalidSyscallEx: .asciiz "Error caused by invalid Syscall\n"
stringBreakPointEx: 	.asciiz "Error caused by Break instruction\n"
stringReservedEx: 	.asciiz "Reserved instruction error\n"
stringArithmeticEx:	.asciiz "Erro de overflow\n"
stringTrapEx: 		.asciiz "Error caused by trap instruction\n"
stringInvalidEx: 	.asciiz "Invalid Exception\n"
stringFloatInstEx: 	.asciiz "Error caused by floating_point instruction\n"
stringOutOfRangeEx: 	.asciiz "Out Of Range\n"
.align 2
kernelRegisters: .space    128
