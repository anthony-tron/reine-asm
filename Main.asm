.data

.text 

ReineR;			addi $sp, $sp, -8
			sw $a0 4($sp)			# empile i 	
			sw $a1 0($sp)			# empile adr. retour
RR_Else:		RR_for
RR_For:			slt $t1, $t0, $a1		# t1 vaut 1 si t0 < n
			beq $t1, $0, return 		# si t1 vaut 0: goto return
			if(sansConflit(i,k)), If	# if(sansConflit(i,k))
			addi $t0, $t0, 1 		# ++k
			j for
	
RR_If; 			Colonne[i] = k
ReineRRecursif:		addi $a1, $a1, +1
			jal ReineR
			blt $a1,$a0, RR_Else