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

	#CHAMA DRAW GRID
	jal 	drawGridHardCoded   			# void drawGridLinear(void)
	#EndProgram
	#jal 	enableProcessorInterrupt
	jal 	enableKeyboardInterrupt	# void enableKeyboardInterrupt()
    	
#SysLock # While(1); Usefull to test imterrupts

#############################################################################################################    
main:

	la 	$a0, pacman	# s0 = &pacman			# name
	jal 	drawSprite	# void drawSprite(struct animetedSprite)	
	#EndProgram

	la 	$a0, pacman	# a0 = &pacman
	jal 	moveSprite	# void enableMovement(a0)
	
	la 	$a0, ghost0	# s0 = &ghost0
	#jal 	drawSprite	# void drawSprite(struct animetedSprite)	
	
	la 	$a0, ghost1	# s0 = &ghost1
	#jal 	drawSprite	# void drawSprite(struct animetedSprite)	
	
	la 	$a0, ghost2	# s0 = &ghost2
	#jal 	drawSprite	# void drawSprite(struct animetedSprite)	
	
	la 	$a0, ghost3	# s0 = &ghost3
	#jal 	drawSprite	# void drawSprite(struct animetedSprite)	
	DelayMs(10)
	#DelayMs(500)
   	b 	main			# goto main
#############################################################################################################    

#########################################################################################################

.globl moveSprite
moveSprite:
	addi $sp, $sp, -64		#allocate 8 bytes on stack
	sw 	$ra, 12($sp)
	sw 	$s0, 16($sp)
	sw 	$s1, 20($sp)
	sw 	$s2, 24($sp)
 	sw 	$s3, 28($sp)
	sw 	$s4, 32($sp)
	sw 	$s5, 36($sp)
	sw 	$s6, 40($sp)
	sw 	$s7, 44($sp)
	
	##################### a0 = &sprite			
	lw 	$s0, 0($a0)	# sprite.id
	lw 	$s1, 4($a0)	# sprite.posX
	lw 	$s2, 8($a0)	# sprite.posY 
 	lw 	$s3, 12($a0)	# sprite.movX 
	lw 	$s4, 16($a0)	# sprite.movY 
	
	#jal	returnNextId
	jal	checkWall
	#printString("\n ID: ")
	#printInt($v0)
	bge	$v0,	69,	moveSpriteEnd	# (returnNextId(struct sprite) > 69) ? goto moveSpriteEnd
	#ble 	$v0,	83,	moveSpriteEnd
	
	bne	$s3, $zero, moveSpriteIsNotZero # (!s1) ? goto moveSpriteNonZero
	beq	$s4, $zero, moveSpriteEnd	# (s2) ? goto moveSpriteEnd
	#b	moveSpriteEnd
	
moveSpriteIsNotZero:	

	add 	$s1, $s1, $s3
	add 	$s2, $s2, $s4
	
	#la 	$a0, pacman
	
	sw 	$s1, 4($a0)	# sprite.posX
	sw 	$s2, 8($a0)	# sprite.posY 
	
	#b	moveSpriteEnd

moveSpriteEnd:
	lw 	$ra, 12($sp)
	lw 	$s0, 16($sp)
	lw 	$s1, 20($sp)
	lw 	$s2, 24($sp)
 	lw 	$s3, 28($sp)
	lw 	$s4, 32($sp)
	lw 	$s5, 36($sp)
	lw 	$s6, 40($sp)
	lw 	$s7, 44($sp)
	addi	$sp, $sp, 64		
    	jr  	$ra				# return
	
#############################################################################################################

#############################################################################################################
.globl checkWall
 checkWall:		# int ID checkWall(X,Y, *gride)
	addi $sp, $sp, -24
	sw 	$ra, 0($sp)
	sw 	$s0, 4($sp)
	sw 	$s1, 8($sp)
	sw 	$s2, 12($sp)
	sw 	$s3, 16($sp)
	sw 	$s4, 20($sp)
	
#animated_sprite (%name, %id, %pos_x, %pos_y, %mov_x, %mov_y)
#		ofset:	&  ,  0  ,   4  ,    8  ,   12  ,  16	
	lw	$s0, 4($a0) 	# s0 = animatedSprite.posX;
	lw	$s1, 8($a0) 	# s1 = animatedSprite.posY;
	lw	$s2, 12($a0)	# s2 = animatedSprite.movX;
	lw	$s3, 16($a0)	# s3 = animatedSprite.movY;
	la 	$s4,	grid

checkWallCheckUpLeft:
	jal 	checkWallMain
	add	$t0, $zero, $v0
	printString("\n UL: ")	
	printInt($t0)		

checkWallCheckUpRight:
	add 	$s0, $s0,	6 		# tPosX=animatedSprite.posX + 6;
	jal 	checkWallMain
	
	sgt	$t1, $v0, $t0
	beq	$t1, $zero, checkWallCheckDownRight
	add	$t0, $zero, $v0
	printString("\n UR: ")	
	printInt($t0)			

checkWallCheckDownRight:
	add 	$s1, $s1,	6 		# tPosY=animatedSprite.posY + 6;
	jal 	checkWallMain
	
	sgt	$t1, $v0, $t0
	beq	$t1, $zero, checkWallCheckDownbLeft
	add	$t0, $zero, $v0
	printString("\n DR: ")	
	printInt($t0)		

checkWallCheckDownbLeft:
	add	$s0, $s0, -6 		# tPosX=animatedSprite.posX - 6;
	jal 	checkWallMain
	
	sgt	$t1, $v0, $t0
	beq	$t1, $zero, checkWallEnd
	add	$t0, $zero, $v0
	printString("\n DL: ")	
	printInt($t0)		
	
	j	checkWallEnd
	
checkWallMain:	

	add $t2, $s0, $s2		# tPosX += animatedSprite.movX;
	add $t3, $s1, $s3		# tPosY += animatedSprite.movY;
	
	div $t2, $t2, X_SCALE	# tPosX /= 7;
	div $t3, $t3, Y_SCALE	# tPosY /= 7;
	
	mul	$t3, $t3, GRID_COLS	# tPosY *= 35;
	add	$t2, $t2, $t3		# tPosX += tPosY;
	
	add	$t2, $t2,	$s4		# (tPosX + tPosY) += &grid 
	lb	$v0, ($t2)		# v0 = grid[tPosX][tPosY];	
	jr 	$ra				# return	
	
checkWallEnd:
	add	$v0, $zero, $t0
	lw 	$ra, 0($sp)
	lw 	$s0, 4($sp)
	lw 	$s1, 8($sp)
	lw 	$s2, 12($sp)
	lw 	$s3, 16($sp)
	lw 	$s4, 20($sp)
	addi $sp, $sp, 24
	jr 	$ra				# return		

#############################################################################################################

#############################################################################################################    

.globl returnNextId
 returnNextId:		# int ID returnNextId(X,Y, *gride)
	addi $sp, $sp, -24
	sw 	$ra, 0($sp)
	sw 	$s0, 4($sp)
	sw 	$s1, 8($sp)
	sw 	$s2, 12($sp)
	sw 	$s3, 16($sp)
	sw 	$s4, 20($sp)
	
#animated_sprite (%name, %id, %pos_x, %pos_y, %mov_x, %mov_y)
#		ofset:	&  ,  0  ,   4  ,    8  ,   12  ,  16	
	lw	$s0, 4($a0) 	# s0 = animatedSprite.posX;
	lw	$s1, 8($a0) 	# s1 = animatedSprite.posY;
	lw	$s2, 12($a0)	# s2 = animatedSprite.movX;
	lw	$s3, 16($a0)	# s3 = animatedSprite.movY;
	la 	$s4,	grid
	
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
	
	mul	$s1, $s1, GRID_COLS	# tPosY *= 35;
	add	$s0, $s0, $s1		# tPosX += tPosY;
	
	add	$s4, $s0,	$s4			# tPosX += &grid 
	lb	$v0, ($s4)			# v0 = grid[tPosX][tPosY];	

	lw 	$ra, 0($sp)
	lw 	$s0, 4($sp)
	lw 	$s1, 8($sp)
	lw 	$s2, 12($sp)
	lw 	$s3, 16($sp)
	lw 	$s4, 20($sp)
	addi $sp, $sp, 24	
	jr 	$ra				# return
	
#############################################################################################################

#############################################################################################################    

drawGridHardCoded:		# void drawGrid(byte *grid)
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
				
	lb   $t1, ($s0)			# t1 = *(grid) 
	addi $s0, $s0, 1			# &grid++
	addi $t1, $t1, GRID_ID_OFFSET	# sprite.ID -= 64
	mul	$t1, $t1, SPRITE_SIZE	#
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
	# compensate display pointer adress to draw the next pixel
	b drawGridDrawPixelX
		
drawGridDrawPixelY:
	bge  $s5, Y_SCALE, drawGridDrawSprite	# ((t => 7) ? goto drawGridDrawPixelXEnd()	
	addi	$s5, $s5, 1	
	add	$s4, $zero, $zero
	addi	$s2, $s2, 996 # s2 += (256-7)*4 
	# compensate display pointer adress to draw the next pixel line
	b drawGridDrawPixelX

drawGridDrawSprite:
	add	$s5, $zero, $zero
	add	$s4, $zero, $zero
	addi	$s2, $s2, -7168 # s2 += -256*4*7
	# compensate display pointer adress to draw the next sprite
	b drawGridRows
	
drawGridCols:	
	bge  $s6, GRID_COLS, drawGridEnd	# ((t => 7) ? goto drawGridDrawPixelXEnd()	
	addi	$s6, $s6, 1
	add	$s5, $zero, $zero
	add	$s4, $zero, $zero
	add	$s1, $zero, $zero
	addi	$s2, $s2, 6188 #s2 += (256*7*4)-(35*7*4)
	# compensate display pointer adress to draw the next sprite line
	b drawGridRows
	
drawGridEnd:	
	jr $ra
	
#############################################################################################################    

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
   	jr  	$ra				# return
 	
#############################################################################################################

#############################################################################################################    

.globl stopSprite
stopSprite:
 	sw 	$zero, 12($a0)
 	sw 	$zero, 16($a0)
 	jr 	$ra
 	
 	#move_sprite(*struct,mov_x, mov_y)

#############################################################################################################

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

#############################################################################################################    

# (X,Y, *gride)
#.globl checkWall 
#checkWall:
#	addi $sp, $sp, -24
#	sw $ra, 16($sp)
#	
#	jal returnId
#	bge $v0, 5, checkWallTrue
#	#li $v0, 0
#	add $v0, $zero, $zero
#	b checkWallEnd
	
#checkWallTrue:
#	#li $v0, 1
#	add $v0, $zero, 1
	
#checkWallEnd: 	
 #	lw $ra, 16($sp)
#	addi $sp, $sp, 24
#	jr $ra
#############################################################################################################

#############################################################################################################    

.globl drawSprite
drawSprite:				# void drawSprite(struct animetedSprite)	
	
	addi $sp, $sp, -64		#allocate 8 bytes on stack
	sw 	$ra, 12($sp)
	sw 	$s0, 16($sp)
	sw 	$s1, 20($sp)
	sw 	$s2, 24($sp)
 	sw 	$s3, 28($sp)
	sw 	$s4, 32($sp)
	sw 	$s5, 36($sp)
	sw 	$s6, 40($sp)
	sw 	$s7, 44($sp)
	
	##################### a0 = &pacman			# sprite.name
	lw 	$s0, 0($a0)	# s0 = pacman[0]		# sprite.id
	lw 	$s1, 4($a0)	# s1 = pacman[1]		# sprite.posX
	lw 	$s2, 8($a0)	# s2 = pacman[2]		# sprite.posY 
	la 	$s3, sprites 	# s3 = &sprites
	la 	$s4, colors	# s4 = &colors
	add 	$s5, $zero, $zero	# s5 = 0
	la	$s6, FB_PTR	# Dysplay adress
	add 	$s7, $zero, $zero	# s7 = 0
	
	mul	$s1,	$s1, 4 #256 * 4
	add 	$s6,	$s6,	$s1
	mul	$s2,	$s2, 1024 #256 * 4
	add 	$s6,	$s6,	$s2
	
	mul 	$t0, $s0, SPRITE_SIZE	# t0 = sprite.id * 49
	add 	$s3, $t0, $s3			# &sprites += sprite.id * 49

drawSpritePixelX:	
	bge 	$s5, X_SCALE, drawSpritePixelY	# ((s3 <= 49) ? drawSpriteEnd)
	addi	$s5, $s5, 1

	lb 	$t2, ($s3)
	addi	$s3, $s3, 1	# &sprite++
	sll	$t2, $t2, 2	# color id * 4
	add	$t2, $t2, $s4 	# color id += &color 
	lw 	$t2, ($t2)
	sw	$t2, ($s6)
	addi	$s6, $s6, 4
	# compensate display pointer adress to draw the next pixel
	b drawSpritePixelX
		
drawSpritePixelY:
	bge  $s7, Y_SCALE, drawSpriteEnd	# ((t => 7) ? goto drawGridDrawPixelXEnd()	
	addi	$s7, $s7, 1	
	add	$s5, $zero, $zero
	addi	$s6, $s6, 996 # s2 += (256-7)*4 
	# compensate display pointer adress to draw the next pixel line
	b drawSpritePixelX
	
drawSpriteEnd:
	lw 	$ra, 12($sp)
	lw 	$s0, 16($sp)
	lw 	$s1, 20($sp)
	lw 	$s2, 24($sp)
 	lw 	$s3, 28($sp)
	lw 	$s4, 32($sp)
	lw 	$s5, 36($sp)
	lw 	$s6, 40($sp)
	lw 	$s7, 44($sp)
	addi	$sp, $sp, 64		
    	jr  	$ra				# return
    	
#############################################################################################################	

#############################################################################################################
 enableProcessorInterrupt: ###### Why this?
	add 	$t0, $zero, 1	# t0 = 1
	sll 	$t0, $t0, 8	# t0 = t0 << 8
	or 	$12, $t0, $12	# $12 = t0 | $12
	ori 	$12, $12, 1	# $12 = $12 | 1
	jr   $ra			# return

 enableKeyboardInterrupt:
	add 	$t0, $zero, 0xffff0002	# t0 = 0xffff0002
	sw 	$t0, 0xffff0000		# *((uint32_t) 0xffff0000) = t0
	jr   $ra					# return
	
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
  	
  	printStringAdress(stringGenericEx)
	
  	mfc0	$s0, $13
  	#andi	$s1,$s0,0XFC
  	#printString("\n s1: ")	
	#printInt($s1)
	
	andi	$s0,$s0,0xFC  #00x7C
	#printString("\n s0: ")	
	printInt($s0)

  	la 	$s1, jtable	#load andress of vector
  	add 	$s1, $s1, $s0 	# jtable adress
  	lw	$s1, 0($s1)	# Carrego valor do elemento em $a1
  	jr 	$s1
  
case0:
	printStringAdress(stringHWInterruptEx)
	
	mfc0	$s0, $14
	addi	$s0, $s0, -4
	mtc0	$s0, $14
    
	la 	$s1, 0xffff0000  	#Load keyboard info on $s1 to the right address
	lw 	$s2, 4($s1)		#Carregando dados lidos pelo teclado
    
	beq 	$s2,100, hwInterruptGoRight	# Key d, go Right
	beq 	$s2, 68, hwInterruptGoRight	# Key D, go Right
	beq 	$s2, 97, hwInterruptGoLeft	# Key a, go Left
	beq 	$s2, 65, hwInterruptGoLeft	# Key A, go Left
	beq 	$s2,119, hwInterruptGoUp		# Key w, go Up
	beq 	$s2, 87, hwInterruptGoUp		# Key W, go Up
	beq 	$s2,115, hwInterruptGoDown	# Key s, go Down
	beq 	$s2, 83, hwInterruptGoDown	# Key S, go Down
	beq 	$s2, 32, hwInterruptPause	# Key Space, Pause game
	b   	switchCaseBreak
    
hwInterruptGoRight:
	li  	$s1, 1	#x
	li  	$s2, 0	#y
 	b 	hwInterruptEnd
 	
hwInterruptGoLeft:
	li  	$s1, -1	#x
	li  	$s2, 0	#y
 	b 	hwInterruptEnd
 	
hwInterruptPause:
	li  	$s1, 0	#x
	li  	$s2, 0	#y
 	b 	hwInterruptEnd
 	
hwInterruptGoUp:
	li  	$s1, 0	#x
	li  	$s2, -1	#y
 	b 	hwInterruptEnd
 	
hwInterruptGoDown:
	li  	$s1, 0	#x
	li  	$s2, 1	#y
 	b 	hwInterruptEnd
 	
hwInterruptEnd:
    	la  	$s0, pacman	# Load Sprite adress , Sprite Name
 	sw 	$s1, 12($s0) #MOVE SPRITE
 	sw 	$s2, 16($s0)
	b   	switchCaseBreak

case4:
	printStringAdress(stringLoadErrorEx)
    	b   	switchCaseBreak
case5:
	printStringAdress(stringStoreErrorEx)
    	b   	switchCaseBreak
case6:
	printStringAdress(stringBusInstErrorEx)
    	b   	switchCaseBreak
case7:
	printStringAdress(stringBusLSErrorEx)
    	b   	switchCaseBreak
case8:
	printStringAdress(stringInvalidSyscallEx)
    	b   	switchCaseBreak
case9:
	printStringAdress(stringBreakPointEx)
    	b   	switchCaseBreak
case10:
	printStringAdress(stringReservedEx)
    	b   	switchCaseBreak
case12:
	printStringAdress(stringArithmeticEx)
    	b   	switchCaseBreak
case13:
	printStringAdress(stringTrapEx)
    	b   	switchCaseBreak 
case1:
case2:
case3:
case11:
case14:
	printStringAdress(stringInvalidEx)
    	b   	switchCaseBreak
    
case15:
	printStringAdress(stringFloatInstEx)
    	b   	switchCaseBreak

default:
	printStringAdress(stringOutOfRangeEx)
	
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
