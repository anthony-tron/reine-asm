# Test1
				.data
Colonne:		.word 1, 2, 3, 4, 5, 6, 7, 1
StrEspace:		.asciiz " "

				.text
				
MainTest:		or $s0, $zero, $zero # i = 0
				

MT_For:			beq $s0, 8, MT_For

				ori $a0, $zero, 3
				or $a1, $zero, $s0 # $a1 = i
				jal SansConflit

				or $a0, $zero, $v0 # entier à afficher : a0 (retour fct)
				or $v0, $zero, 1 # je me prepare afficher un entier
				syscall # affichage
				
				ori $v0, $zero, 4 # je vais afficher un espace
				la $a0, StrEspace # l'espace à afficher
				syscall # affichage
				
				addi $s0, $s0, 1 # ++i
				j MT_For
				
MT_Exit:		ori $v0, $zero, 10
				syscall # fin



# Arguments :
#	unsigned& Lign : $a0
#	unsigned& Coln : $a1
# Valeur de retour :
#	$v0 qui vaut 0 (faux) ou 1 (vrai)
SansConflit:		or $t0, $a0, $zero 				# $t0 : i2 = Ligne
					or $t1, $a1, $zero 				# $t1 : j2 = Coln
				
					or $t2, $zero, $zero 			# $t2 : k = 0
					la $t6, Colonne					# $t6 = Colonne
				
	SC_For:			slt $t3, $t2, $t0 				# si k < Ligne, t3 = 1, sinon t3 = 0
					beq $t3, $zero, SC_ReturnTrue 	# si t3 == 0, sortir de la boucle
				
					or $t4, $zero, $t2 				# i1 = k
					
					sll $t5, $t2, 2 				# (calcul du décalage)
					add $t5, $t5, $t6 				# (calcul de l'adresse de la case courante)
					lw $t5, 0($t5) 					# j1 = Colonne[k]
					
					beq $t4, $t0, SC_ReturnFalse	# if (i1 == i2) return false;
					#
					beq $t5, $t1, SC_ReturnFalse 	# if (j1 == j2) return false;
					#
					sub $t7, $t4, $t5 # t7= i1 - j1
					sub $t8, $t0, $t1 # t8= i2 - j2
					beq $t7, $t8, SC_ReturnFalse 	# if (i1 - j1) == (i2 - j2) return false;
					#
					add $t7, $t4, $t5 # t7 = i1 -j1
					add $t8, $t0, $t1 # t8 =  i2 - j2
					beq $t7, $t8, SC_ReturnFalse	# if (i1 + j1) == (i2 + j2) return false;
					
					
					addi $t2, $t2, 1  				# k++
					j SC_For
			
	SC_ReturnTrue:	ori $v0, $zero, 1
					jr $ra
				
	SC_ReturnFalse: ori $v0, $zero, 0
					jr $ra

# # # # # # # # # # # # # # # # #
# Fonction de base à traduire : #
# # # # # # # # # # # # # # # # #
#
# bool SansConflit(const unsigned &Ligne, const unsigned &Coln) {
#  unsigned i1, j1, i2 = Ligne, j2 = Coln;
#
#  for (unsigned k = 0; k < Ligne; ++k) {
#    i1 = k;
#    j1 = Colonne[k];
#
#    if ((i1 == i2)    // meme colonne
#        || (j1 == j2) // meme ligne
#        || ((i1 - j1) == (i2 - j2)) // meme diagonale
#        || ((i1 + j1) == (i2 + j2))) // meme diagonale
#      return false;
#  }
#  return true;
#} // SansConflit()
