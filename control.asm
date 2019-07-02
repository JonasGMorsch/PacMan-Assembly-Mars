
.macro moveIntention (%name,%isValid,%X,%Y)
#		 	 offset:  &  ,    0   , 4, 8 
.data
%name:
.align 2
	.word %isValid
	.word %X
	.word %Y
.end_macro

moveIntention (kbBuffer, 0, 0 ,0)

moveIntention (ghost0Buffer, 0, 0 ,0)
moveIntention (ghost1Buffer, 0, 0 ,0)
moveIntention (ghost2Buffer, 0, 0 ,0)
moveIntention (ghost3Buffer, 0, 0 ,0)

