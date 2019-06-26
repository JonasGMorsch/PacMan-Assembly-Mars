
.include "graphics.asm"
.include "macros.asm"
#.include ".asm"
#.data 
#stringTest98: .asciiz "test test test \n"
#.align 2

.text
 	#li 	$v0, 4
 	#la	$a0, stringTest98
    	#syscall
 
	#CHAMA DRAW GRID
	add 	$a0, $zero, GRID_ROWS	#a0 = 35
	add 	$a1, $zero, GRID_COLS	#a1 = 35
	la 	$a2, grid		#a2 = &grid
	jal 	drawGrid    		# void drawGrid(a0,a1,a2)
	
	#jal enableProcessorInterrupt
	jal enableKeyboardInterrupt	# void enableKeyboardInterrupt()
    	
    	#SysLock #While(1); Usefull to test imterrupts

   	#la $s5, 0xffff0000
	#li $s6, 0x02
	#sw $s6, 0($s5)
	
main:
	la 	$s0, pacman	# s0 = &pacman
	lw 	$a0, 4($s0)	# a0 = pacman[1]
	lw 	$a1, 8($s0)	# a1 = pacman[2]
	lw 	$a2, 0($s0)	# a2 = pacman[0]
	jal 	drawSprite	# void drawSprite(a0,a1,a2)
	
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

   	j 	main		# goto main
#############################################################################################################    

 enableProcessorInterrupt:
	add $t0, $zero, 1	# t0 = 1
	sll $t0, $t0, 8		# t0 = t0 << 8
	or $12, $t0, $12	# $12 = t0 | $12
	ori $12, $12, 1		# $12 = $12 | 1
	jr   $ra		# return

 enableKeyboardInterrupt:
	add 	$t0, $zero, 0xffff0002	# t0 = 0xffff0002
	sw 	$t0, 0xffff0000		# 0xffff0002 = &0xffff0000
	jr   	$ra			# return
#############################################################################################################    
	
# draw_grid(width, height, *grid_table)
.globl drawGrid
drawGrid:
	addi $sp, $sp, -40
	sw $ra, 36($sp)
	sw $s0, 16($sp)
	sw $s1, 20($sp)
	sw $s2, 24($sp)
 	sw $s3, 28($sp)
	sw $s4, 32($sp)
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	
	#li   $s3, 0
	add $s3, $zero, $zero
	
drawGridLinha:	
	bge  $s3, $s0, drawGridExit #exit_grid
	#li   $s4, 0
	add $s4, $zero, $zero
drawGridColuna:	
	bge  $s4, $s1, drawGridColunaExit#exit_coluna
	lb   $a2, 0($s2)
	addi $a2,$a2,-64
	mulu $a1, $s3, 7 
	mulu $a0, $s4, 7 
	jal  drawSprite
	addi $s2,$s2,1
	addi $s4, $s4, 1
	j drawGridColuna
drawGridColunaExit:
	addi 	$s3, $s3, 1
	j 	drawGridLinha
drawGridExit:	
	lw $ra, 36($sp)
	lw $s0, 16($sp)
	lw $s1, 20($sp)
	lw $s2, 24($sp)
 	lw $s3, 28($sp)
 	lw $s4, 32($sp)
	addi $sp, $sp, 40
	jr   $ra
#############################################################################################################

# draw_sprite(X, Y, sprite_id) 
# draw_sprite(X, Y, sprite_id) 
.globl drawSprite
drawSprite:
	
	addi $sp, $sp, -40		#sp = sp -40
	sw $ra, 36($sp)			#sp[9] = ra
	sw $s0, 16($sp)			#sp[4] = s0
	sw $s1, 20($sp)			#sp[5] = s1
	sw $s2, 24($sp)			#sp[6] = s2
 	sw $s3, 28($sp)			#sp[7] = s3
	sw $s4, 32($sp)			#sp[8] = s4
	
	move $s0, $a0			# s0 = a0
	move $s1, $a1			# s1 = a1
	
	la $s2, sprites 		# s2 = &sprites
	mul $t1, $a2, SPRITE_SIZE	# t1 = a2 * SPRITE_SIZE(49)
	add $s2, $t1, $s2		# s2 = t1 + s2

	
	la $s4, colors			# s4 = &colors
	add $s3, $zero, $zero		# s3 = 0
drawSpriteLoop:	
	bge $s3, SPRITE_SIZE, drawSpriteEnd
	#bge $zero, SPRITE_SIZE, drawSpriteEnd
	lbu $t3, 0($s2)
	sll $t3, $t3, 2
	add $t3, $t3, $s4
	lw  $a2, 0($t3)
	div $t5, $s3, 7 #t5 y
	mfhi $t6 #t6 X
	add $a0, $s0, $t6
	add $a1, $s1, $t5
	
	jal drawPixel
	addi $s3, $s3, 1 #div por 7 o resto vai ser x e outro y
	addi $s2, $s2, 1
	b drawSpriteLoop
	
drawSpriteEnd:
	lw $ra, 36($sp)			# ra = sp[9]
	lw $s0, 16($sp)			# s0 = sp[4]
	lw $s1, 20($sp)			# s1 = sp[5]
	lw $s2, 24($sp)			# s2 = sp[6]
 	lw $s3, 28($sp)			# s3 = sp[7]
 	lw $s4, 32($sp)			# s4 = sp[8]
	addi $sp, $sp, 40		# sp = sp + 40
    	jr   $ra			# return
#############################################################################################################	

# drawPixel(X, Y, color)
.globl drawPixel
drawPixel:
   	la  	$t0, FB_PTR
   	mul 	$a1, $a1, FB_XRES #(I*LINHAS)+J)*4 + ENDEREÇO
   	add 	$a0, $a0, $a1
   	sll 	$a0, $a0, 2
   	add 	$a0, $a0, $t0
   	sw  	$a2, 0($a0)
   	jr  	$ra
   	
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
 	addi 	$sp, $sp, -24
	sw 	$ra, 20($sp)
	sw 	$s0, 16($sp)
	
	move 	$s0, $a0
 
 	lw 	$t0, 4($s0)
 	lw 	$t1, 8($s0)
 	lw 	$t2, 12($s0)
	lw 	$t3, 16($s0)
	add 	$t0, $t0, $t2
	add 	$t1, $t1, $t3
	move 	$a0, $t0
	move 	$a1, $t1
	la 	$a2, grid
	#jal 	checkWall
	bnez 	$v0, end_apply
	sw 	$t0, 4($s0)
	sw 	$t1, 8($s0)
	b 	apply_final
end_apply:
	jal 	stop_sprite
apply_final:
	lw 	$ra, 20($sp)
	lw 	$s0, 16($sp)

	addi 	$sp, $sp, 24
	jr 	$ra
#############################################################################################################

 # (X,Y, *gride)
 # Mult por linha, soma coluna, mult por 4 e soma com endere�o base
 .globl returnId
 returnId:
	addi 	$sp, $sp, -32
	sw 	$ra, 24($sp)
	sw 	$s1, 16($sp)
	sw 	$s0, 20($sp)
	
	move 	$s0, $a0
	div  	$s1, $a1, 7
	mfhi 	$s0
	add 	$s1, $s1, $a1
	add 	$s0, $s0, $a0
	add  	$s1, $s1,$s0 #((s1*linha)+s0)
	sll 	$s1, $s1, 2
	add  	$s1,$s1, $a2
	lbu   	$s1, 0($s1)
	addi 	$v0, $s1, -64
		
	lw 	$ra, 24($sp)
	lw 	$s1, 16($sp)
	lw 	$s0, 20($sp)
	addi 	$sp, $sp, 32	# &sp = &sp + 32
	jr 	$ra		# Return
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
  	la    	$a0, stringGenericEx    
  	li    	$v0, 4
  	syscall
    	#jal 	printString          

  	mfc0  	$a0, $13
  	andi  	$a0,$a0,0x007C
  	la 	$a1, jtable	#load andress of vector
  	add 	$a1, $a1, $a0 	# jtable adress
  	lw    	$a1, 0($a1)	# Carrego valor do elemento em $t0
  	#EndProgram
  	jr 	$a1
  
case0:
    	#print HWInterrupt
	li 	$v0, 4
	la 	$a0, stringHWInterruptEx 
	syscall
	#########################
	
	mfc0  	$a0, $14
	addi 	$a0, $a0, -4
	mtc0  	$a0, $14
    
	la 	$a2, 0xffff0000  #Load keyboard info on $a2 to the right address
	lw 	$a1, 4($a2)	#Carregando dados lidos pelo teclado
    
	beq 	$a1,100, hwInterruptGoRight	# Key d, go Right
	beq 	$a1, 68, hwInterruptGoRight	# Key D, go Right
	beq 	$a1, 97, hwInterruptGoLeft	# Key a, go Left
	beq 	$a1, 65, hwInterruptGoLeft	# Key A, go Left
	beq 	$a1,119, hwInterruptGoUp	# Key w, go Up
	beq 	$a1, 87, hwInterruptGoUp	# Key W, go Up
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
    	la  	$a0, pacman	# Load Sprite, Sprite Name
	la  	$v0, move_sprite
	jalr 	$v0
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
