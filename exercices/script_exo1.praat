#Amina DJARFI MELOUAH


clearinfo
#################################

mot_phonetique$ = "vodka"

longueur_mot = length(mot_phonetique$)

for caractere from 1 to longueur_mot  - 1

	diphone$ = mid$(mot_phonetique$,caractere,2)
    char1_diphone$ = left$(diphone$,1)
	char2_diphone$ = right$(diphone$,1)

	printline 'char1_diphone$'  /  'char2_diphone$'

endfor

