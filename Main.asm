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
					
					# TODO ~
					#    if ((i1 == i2)    // meme colonne
					#        || (j1 == j2) // meme ligne
					#        || ((i1 - j1) == (i2 - j2)) // meme diagonale
					#        || ((i1 + j1) == (i2 + j2))) // meme diagonale
					#      return false;
					
					addi $t2, $t2, 1  				# k++
					j SC_For
			
	SC_ReturnTrue:	ori $v0, $zero, 1
					jr $ra
				
	SC_ReturnFalse: ori $v0, $zero, 0
					jr $ra

# bool SansConflit(const unsigned &Ligne, const unsigned &Coln) {
#  unsigned i1, j1, i2 = Ligne, j2 = Coln;

#  for (unsigned k = 0; k < Ligne; ++k) {
#    i1 = k;
#    j1 = Colonne[k];

#    if ((i1 == i2)    // meme colonne
#        || (j1 == j2) // meme ligne
#        || ((i1 - j1) == (i2 - j2)) // meme diagonale
#        || ((i1 + j1) == (i2 + j2))) // meme diagonale
#      return false;
#  }
#  return true;
#} // SansConflit()