.data

.text 

ReineR;	addi $sp, $sp, -12		# alloue l’espace sur la pile
	sw $s0,8($sp)			# empile $s0
	sw $a0,4($sp)			# empile i 	
	sw $ra,0($sp)			# empile adr. retour
	la $t0,N			# on prend l’adresse de N
	lw $t0,($t0)			# $t0 <− N
	
	slt $t1, $a0, $t0		# $t1 vaut 1 si i ($a0) < N ($t0)
	beq $t1,0,RR_Affiche		# if(i>= N) goto RR_Affiche	
RR_Else:				# else
	or $s0,$zero,$zero		# k ($s0) <- 0
	
RR_For:	
	slt $t3,$s0,$t0			# $t3 <- k ($s0) < N ($t0)
	beq $t3, $zero, RR_Retour	# si k < N est faux, on quitte la boucle for et la fonction
	# $a0 est déjà égal à i, pas besoin de le charger
	or $a1,$zero,$s0 		# $a1 <- k ($s0)
	jal SansConflit			# SansConflit(i,k)
	beq $v0,0,RR_Fin_For		# si SansConflit renvoie faux, on passe à la prochaine itération
	la $t4,Colonne			# $t4 <- @Colonne
	sll $t5,$a0,2 			# $t5 <- i ($a0) * 4
	add $t5,$t5,$t4			# $t5 <- déplacement de i + @Colonne 
	sw $s0,($t5)			# Colonne[i] = k
	addi $a0,$a0,1			# i ($a0) <- i+1  
	jal ReineR			# ReineR(i+1)
	addi $a0,$a0,-1			# on restaure i 
RR_Fin_For:
	addi $s0, $s0, 1 		# ++k
	j RR_For
	
			
RR_Affiche:
	la $a0,Colonne			# $a0 <- @Colonne
	or $a1,$t0,$zero		# $a1 <- N ($t0)
	jal AfficherSolution		# AfficherSolution(Colonne,N)
	j RR_Retour			# on a plus rien à faire, on retourne 


RR_Retour:
	lw $s0,8($sp) 			# dépile $s0
	lw $a0,4($sp)			# dépile i
	lw $ra,0($sp)			# dépile l’adresse de retour
	addi $sp,$sp,12			# on rend l’espace
	jr $ra				# retour  de la fonction