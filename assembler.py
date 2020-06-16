# Usage :
# python assembler.py > projet.asm

noms_fichiers = ['Main.asm', 'AfficherSolution.asm', 'SansConflit.asm', 'ReineR.asm', 'Reine.asm'] # les fichiers sont dans l'ordre d'assemblage

assemble = reduce( (lambda total, prev : total + open(prev, 'r').read() + '\n\n'), noms_fichiers, '' )

print(assemble)