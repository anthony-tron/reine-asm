# reine-asm

Un projet en langage assembleur MIPS proposé par [Vincent Risch](https://pageperso.lis-lab.fr/vincent.risch/) d'[Aix-Marseille Université](https://www.univ-amu.fr/).

Réalisé par PONSARD Nils, TRON Anthony, et PATALANO Alexis.

Lien vers le sujet : https://pageperso.lis-lab.fr/vincent.risch/teaching/ARCHITECTURE/projet2_Reines.pdf

## Convention de nommage des labels pour traduire une  fonction

\<initiales de la fonction\>_\<label\>

## Format de stockage du plateau

Le tableau Colonne[] enregistre la position de la reine, puisqu’il n’y en a qu’une seule par colonne.

## Vérifier que les fonctions font la même chose en C++ et en MIPS

On a écrit une fonction en C++ qui teste SansConflit() avec toutes les valeurs d'arguments possibles, puis on la traduit en MIPS. **Si la traduction de SansConflit() en MIPS est bonne, alors les deux tests écrivent la même chose sur la sortie standard**. Dans le cas spécifique de SansConflit(), on fait 3 tests.

On peut remarquer que dans la fonction de test en MIPS, on utilise les registres **\$s0** et **\$s1** pour ne pas avoir à sauvegarder et restaurer les registres (en manipulant la pile).

## Traduire SansConflit() sans conflit

Comment traduire cet extrait de code, sachant qu'il faut respecter la sémantique du programme ?
```c++
if ((i1 == i2)    // A
    || (j1 == j2) // B
    || ((i1 - j1) == (i2 - j2)) // C
    || ((i1 + j1) == (i2 + j2))) // D
      return false;
```

On sait que si A est évaluée vrai, alors l'instruction `return false` est atteint en ayant ignoré les autres expressions B C et D.

De ce fait, on peut pré-traduire ce schéma conditionnel en :

```c++
if (i1 == i2) return false; // A
if (j1 == j2) return false; // B
if ((i1 - j1) == (i2 - j2)) return false; // C
if ((i1 + j1) == (i2 + j2)) return false; // D
```

La traduction en assembleur MIPS est maintenant plus évidente :

```asm
...
				beq $t4, $t0, SC_ReturnFalse	  #A if (i1 == i2) return false;

				beq $t5, $t1, SC_ReturnFalse 	  #B if (j1 == j2) return false;

				sub $t7, $t4, $t5 # t7= i1 - j1
				sub $t8, $t0, $t1 # t8= i2 - j2
				beq $t7, $t8, SC_ReturnFalse 	  #C if (i1 - j1) == (i2 - j2) return false;

				add $t7, $t4, $t5 # t7 = i1 -j1
				add $t8, $t0, $t1 # t8 =  i2 - j2
				beq $t7, $t8, SC_ReturnFalse	  #D if (i1 + j1) == (i2 + j2) return false;
...
SC_ReturnFalse: ori $v0, $zero, 0
				jr $ra
...
```

