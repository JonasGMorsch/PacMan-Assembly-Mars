
.macro SysLock
	vasckuadgfvuioqblavifeuvblo: 
	b vasckuadgfvuioqblavifeuvblo
.end_macro

.macro EndProgram
    li $v0, 10
    syscall
.end_macro

.macro printString (%str)
.data 
mStr: .asciiz %str
.text
	addi $sp, $sp, -8
	sw 	$a0, 0($sp)
	sw 	$v0, 4($sp)
	
	la $a0, mStr
	li $v0, 4
	syscall
	
	lw 	$a0, 0($sp)
	lw 	$v0, 4($sp)
	addi $sp, $sp, 8
.end_macro

.macro printInt (%x)
	addi $sp, $sp, -8
	sw 	$a0, 0($sp)
	sw 	$v0, 4($sp)

	add 	$a0, $zero, %x
	li 	$v0, 1
	syscall
	
	lw 	$a0, 0($sp)
	lw 	$v0, 4($sp)
	addi $sp, $sp, 8
.end_macro

.macro printStringAdress (%str)
	addi $sp, $sp, -8
	sw 	$a0, 0($sp)
	sw 	$v0, 4($sp)
	
	la $a0, %str
	li $v0, 4
	syscall
	
	lw 	$a0, 0($sp)
	lw 	$v0, 4($sp)
	addi $sp, $sp, 8
.end_macro

