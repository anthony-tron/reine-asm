
	.data 
N:	.word 8				# const unsigned N = 0
SolutionNum: 
	.word 0				# unsigned SolutionNum = 0
Colonne:
	.word 1,2,3,4,5,6,7,8 		# unsigned Colonne[N] (rempli avec des valeurs de test)
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



# AfficherSolution : $a0: pointeur vers le tableau, $a1 : numéro de la solution N
AfficherSolution:
	or $t0,$zero,$a0		# $t0 <- Colonne[]
	or $t1,$zero,$a1 		# $t1 <- N
	ori $v0,$zero,4			# $v0 <- 4
	la $a0,StrSolution		# $a0 <- StrSolution
	syscall 			# affiche "Solution numero"
	ori $v0,$zero,1 		# $v0 <- 1
	or $a0,$zero,$t1		# $a0 <- N
	syscall				# cout << N
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
	beq $t5,$zero,AS_Fin_For_j	# si (i>=N) on termine la boucle

	bne $t5, 			# if (j == Colonne[i])
	
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
	
		

