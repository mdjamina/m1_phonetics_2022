#Amina DJARFI MELOUAH


clearinfo
#################################


sound = Read from file: "logatomes/faure.wav"
grille = Read from file: "logatomes/faure.TextGrid"


mot_phonetique$ = "vodka"

longueur_mot = length(mot_phonetique$)

for caractere from 1 to longueur_mot  - 1

	diphone$ = mid$(mot_phonetique$,caractere,2)
    char1_diphone$ = left$(diphone$,1)
	char2_diphone$ = right$(diphone$,1)

	printline 'char1_diphone$'  /  'char2_diphone$'

	#Selectionner la grille pour demander le nbr d'intervals de cette grille

	select 'grille' 

	nbr_intervals = Get number of intervals: 1


	for intervalle from 1 to nbr_intervals-1

	#pour demander le nbr de cases sur la couche 1 (68)

		select 'grille'
		start_interval = Get start time of interval: 1, intervalle

		end_interval = Get end time of interval: 1, intervalle

		label_interval$ = Get label of interval: 1, intervalle

		#variable pour permettre de questionner le segment qui suit

		intervalle_suivant = intervalle + 1	

		label_interval_suivant$ = Get label of interval: 1, intervalle_suivant
		
		#printline label_interval$ 'label_interval$' ('intervalle')
		
	#si l'interval contient "v" et le suivant "o" , mesurer l'interval du milieu du "v "

		if (label_interval$ = char1_diphone$ and  label_interval_suivant$ = char2_diphone$ )
			
			milieu1 =  (start_interval + end_interval) /2

			end_interval_suivant = Get end time of interval: 1, intervalle_suivant

			milieu2 =  (end_interval + end_interval_suivant) /2

			printline label_interval$ 'label_interval$' label_interval_suivant$ 'label_interval_suivant$'

			printline 'milieu1:3'  et 'milieu2:3'

		endif

	#printline label_interval$ 'label_interval$'

	endfor






endfor

