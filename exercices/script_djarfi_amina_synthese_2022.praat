#Amina DJARFI MELOUAH

#Pour nettoyer la fenetre d'affichage clearinfo

clearinfo

son = Read from file: "logatomes\faure.wav"
grille = Read from file: "logatomes\faure.TextGrid"



###########################
#recuperer les lignes et synthetiser le mot vodka a partir de l'orthographe

mot_ortho$ = "femme"

table_complete = Read Table from tab-separated file: "dico2_sampa_ameliore.txt"

extraction = Extract rows where column (text): "orthographe", "is equal to", mot_ortho$

mot_phonetique$ = Get value: 1, "phonetique"
printline 'mot_phonetique$'

select 'table_complete'
Remove
###########################

# creation d'un fichier son vierge qui va recolter les diphones
son_vide = Create Sound from formula: "sineWithNoise", 1, 0, 0.01, 44100, "0"

#################################

#mot_phonetique$ = "femme"

longueur_mot = length(mot_phonetique$)

#mid$ fonction donne une série de 2 caracteres

for caractere from 1 to longueur_mot  - 1

	diphone$ = mid$(mot_phonetique$,caractere,2)      
        char1_diphone$ = left$(diphone$,1)
	char2_diphone$ = right$(diphone$,1)

	printline 'char1_diphone$'  /  'char2_diphone$'



#################################

#char1_diphone$ = "v"
#char2_diphone$ = "o"


#Selectionner la grille pour demander le nbr d'intervals de cette grille

select 'grille' 

nbr_intervals = Get number of intervals: 1


for intervalle from 1 to nbr_intervals-1

#pour demander le nbr de cases sur la couche 1 

	select 'grille'
	start_interval = Get start time of interval: 1, intervalle

	end_interval = Get end time of interval: 1, intervalle

	label_interval$ = Get label of interval: 1, intervalle

	#variable pour permettre de questionner le segment qui suit

	intervalle_suivant = intervalle + 1	

	label_interval_suivant$ = Get label of interval: 1, intervalle_suivant
	
	#printline label_interval$ 'label_interval$' ('intervalle')
	


	if (label_interval$ = char1_diphone$ and  label_interval_suivant$ = char2_diphone$ )
		
		m1 =  (start_interval + end_interval) /2

		end_interval_suivant = Get end time of interval: 1, intervalle_suivant

		m2 =  (end_interval + end_interval_suivant) /2

		#printline 'm1:3'  et 'm2:3'





		select 'son'
		extrait_son = Extract part: m1, m2, "rectangular", 1, "no"

		select 'son_vide'
		plus 'extrait_son'   
		son_vide = Concatenate

		#netoyage 
		select 'extrait_son'
		Remove

	endif

#printline label_interval$ 'label_interval$'

	endfor
endfor

 















	
