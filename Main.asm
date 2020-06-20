	.data 
N:	.word 8				# const unsigned N = 0
SolutionNum: 
	.word 0				# unsigned SolutionNum = 0
Colonne:
	.word 0,1,2,3,4,5,6,7 		# unsigned Colonne[N] (rempli avec des valeurs de test)
StrSolution:
	.asciiz "Solution numero " 	# constante texte
StrDeuxPoints:
	.asciiz ":"			# pour afficher ':'
StrRetLigne:
	.asciiz "\n"			# caractère pour le retour à la ligne
StrReine:
	.asciiz "R"			# caractère pour la reine
StrVide:
	.asciiz "+"			# caractère pour une case vide
StrSetwDeux:
	.asciiz " "			# juste un espace pour le setw, comme les deux caractères ont une taille de 1
	.text

# Main
main:
	jal Reine			# appeel de Reine(void)
	ori $v0,$zero,10 		# $v0 <− 10
	syscall				# return 0

# AfficherSolution : $a0: pointeur vers le tableau, $a1 : numéro de la solution N
AfficherSolution:
	or $t0,$zero,$a0		# $t0 <- Colonne[]
	or $t1,$zero,$a1 		# $t1 <- N
	ori $v0,$zero,4			# $v0 <- 4
	la $a0,StrSolution		# $a0 <- StrSolution
	syscall 			# affiche "Solution numero"
	la $t9,SolutionNum		# chargement de l’adresse où est stocké SolutionNum dans $t9
	lw $a0,0($t9)			# $a0 <- SolutionNum
	addi $a0,$a0,1			# ++SolutionNum
	sw $a0,0($t9)			# on stocke la nouvelle valeur de SolutionNum
	ori $v0,$zero,1 		# $v0 <- 1
	syscall				# cout << SolutionNum
	ori $v0,$zero,4			# $v0 <- 4
	la $a0,StrDeuxPoints		# $a0 <- StrDeuxPoints
	syscall 			# affciche ':'
	la $a0,StrRetLigne		# $a0 <- StrRetLigne
	syscall 			# affciche '\n'	

	or $t3,$zero,$zero		# i ($t3) <- 0
AS_For_i:
	slt $t5,$t3,$t1			# $t5 = (i<N)
	beq $t5,$zero,AS_Fin_For_i	# si (i>=N) on termine la boucle
	or $t4,$zero,$zero		# j ($t4) <- 0
AS_For_j:
	slt $t5,$t4,$t1			# $t5 = (j<N)
	beq $t5,$zero,AS_Fin_For_j	# si (j>=N) on termine la boucle
	
	sll $t6,$t3,2			# $t6 <- i*4
	add $t6,$t0,$t6			# $t6 (emplacement de la case à charger) <- $t0 (@Colonne) + offset
	lw $t7,0($t6)			# $t7 <- Colonne[i]

	bne $t4,$t7,AS_Else		# if (j == Colonne[i])
	
	ori $v0,$zero,4			# $v0 <- 4
	la $a0,StrSetwDeux		# $a0 <- StrSetwDeux
	syscall 			# affiche l’espacement
	la $a0,StrReine			# $a0 <- StrReine
	syscall 			# affiche "R"
	j AS_Fin_if			# on va 
AS_Else:
	ori $v0,$zero,4			# $v0 <- 4
	la $a0,StrSetwDeux		# $a0 <- StrSetwDeux
	syscall				# affiche l’espacement
	la $a0,StrVide			# $a0 <- StrVide
	syscall 			# affiche "+"
AS_Fin_if:
	addi $t4,$t4,1
	j AS_For_j
AS_Fin_For_j:
	ori $v0,$zero,4			# $v0 <- 4
	la $a0,StrRetLigne		# $a0 <- StrSetwDeux
	syscall				# retour à la ligne
	addi $t3,$t3,1			# ++i
	j AS_For_i

AS_Fin_For_i:
	or $a0,$t0,$zero		# restauration de $a0 ($t0 n’a pas été modifié)
	or $a1,$t1,$zero		# restauration de $a1 ($t1 n’a pas été modifié)
	jr $ra
	
	
Reine:
	addi $sp,$sp,-8			# "allocation" de l’espace dans la pile
	sw $ra,4($sp)			# sauvegarde de l’adresse de retour
	sw $a0,0($sp)			# sauvegarde du registre d’argument qui va être modifié
	or $a0,$zero,$zero		# passage de 0 en argument de ReineR
	
	jal ReineR			# appel de ReineR
	
	lw $ra,4($sp)			# on dépile $ra
	lw $a0,0($sp)			# on dépile $a0
	addi $sp,$sp,8			# on rend l’espace dans la pile
	jr $ra				# retour de la fonction
	



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
