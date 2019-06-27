
.macro SysLock
	vasckuadgfvuioqblavifeuvblo: 
	b vasckuadgfvuioqblavifeuvblo
.end_macro

.macro EndProgram
    li $v0, 10
    syscall
.end_macro

.macro printInt (%x)
    li $v0, 1
    add $a0, $zero, %x
    syscall
.end_macro

.macro printString (%str)
.data 
mStr: .asciiz %str
.text
    li $v0, 4
    la $a0, mStr
    syscall
.end_macro
