clearinfo

select all
#pause
nocheck Remove

# Déclaration des variables d'accès aux fichiers
sound_filepath$ = "djarfi.wav"
text_grid_filepath$ = "djarfi.TextGrid"
dico_filepath$ = "dico2_sampa_ameliore.txt"
synthese_filepath$ = "son_synthese.wav"

# Ouverture du fichier son
sound  = Read from file: sound_filepath$

# Fréquence d'échantillonnage du fichier son
frequency = Get sampling frequency

# Récupération de toutes les intersections (zeroes)
intersections = To PointProcess (zeroes): 1, "no", "yes"

# Ouverture du fichier TextGrid
text_grid =  Read from file: text_grid_filepath$

# Récupération des intervalles à partir du tier 1
nb_intervals = Get number of intervals: 1

# Lecture du fichier dictionnaire contenant les mots français et leur transcription phonétique SAMPA correspondante
dico = Read Table from tab-separated file: dico_filepath$

# Création d'un fichier pour la concaténation des diphones
synthese_sound = Create Sound from formula: "sineWithNoise", 1, 0, 0.05, frequency, "0"

# DEBUT DU PROGRAMME


form Synthetiseur vocale (TAL M1)
    comment Quelle phrase voulez-vous synthétiser ?
        text text la femme dit que le succès pour moi c'est échouer sept fois et se relever huit sans doute

    comment Voulez-vous lire le son synthetisé?
        boolean play 0


   comment Voulez-vous enregistrer le fichier .wav?
       boolean save 0

endform

# Afficher le texte d'entrée
appendInfoLine: "text:", text$

# Initialiser le texte de sortie text_phonétique$ en une chaîne vide
text_phonetic$ = ""

# la longueur du texte d'entrée
len_text = length(text$)

# Transcription phonétique SAMPA
# Répétion du processus suivant jusqu'à ce qu'il n'y ait plus d'espaces dans text$
repeat 
    # Trouver l'index du premier espace dans text$
    ws = index(text$, " ")
    
    # Extraire le premier mot dans text$
    token$ = left$(text$, ws-1)
    
    # Redéfinir text$ pour ne contenir que la partie de la chaîne après le premier espace
    text$ = right$(text$, len_text - ws)
    
    # Mettre à jour la longueur de text$
    len_text = length(text$)
    
    # Gérer le dernier mot de la phrase (il n'y a pas d'espace après le dernier mot)
    if ws = 0
        token$ = text$
    endif	
		
    # Select the "dico" table
    select 'dico'
    
    # Extraire la ligne qui correspond au mot actuel "token$"
    row = Extract rows where column (text): "orthographe", "is equal to", token$
    
    # Obtenir la transcription phonétique SAMPA du mot
    phonetic$ = Get value: 1, "phonetique"
    
    # Ajouter la transcription phonétique SAMPA à la sortie text_phonetic$.
    text_phonetic$ = text_phonetic$ + phonetic$ 
until ws = 0

text_phonetic$ = "_"+text_phonetic$+"_"

appendInfoLine: "Transcription SAMPA:", text_phonetic$

#SYNTHESE
# Calculer la longueur du texte sous forme phonétique.
len_text_phonetic = length(text_phonetic$)

# Parcourir chaque caractère dans le texte
for char from 1 to len_text_phonetic  - 1

    # Obtenir le diphone actuel.
    diphone$ = mid$(text_phonetic$,char,2)
    
    # Obtenir les premiers et deuxièmes caractères du diphone.
    char1_diphone$ = left$(diphone$,1)
    char2_diphone$ = right$(diphone$,1)

    # Parcourir chaque intervalle dans la grille
    for intvl from 1 to nb_intervals-1

        # Obtenir le prochain intervalle
        next_intvl = intvl + 1

        # Sélectionner la grille de texte
        select 'text_grid'

        # Récupérer les étiquettes des intervalles courant et suivant.
        label_interval$ = Get label of interval: 1, intvl
        label_next_intvl$ = Get label of interval: 1, next_intvl

        # Si les intervalles actuels et suivants contiennent les caractères du diphone
        if (label_interval$ = char1_diphone$ and label_next_intvl$ = char2_diphone$ )

            # Obtenir les temps de début et de fin des intervalles courant et suivant
            start_interval = Get start time of interval: 1, intvl
            end_interval = Get end time of interval: 1, intvl
            end_next_intvl = Get end time of interval: 1, next_intvl
            
            # Calculer le temps du milieu de l'intervalle en cours
            middle_min =  (start_interval + end_interval) /2
            
            # Calculer le temps du milieu du prochain intervalle
            middle_max =  (end_interval + end_next_intvl) /2

            # Sélectionner l'objet intersections
            select 'intersections'

            # Obtenir l'intersection la plus proche de 0 avec le milieu de l'intervalle actuel
            nearest_index = Get nearest index: middle_min
            time_min = Get time from index: nearest_index 

            # Obtenir la prochaine intersection avec 0 au milieu de l'intervalle suivant.
            nearest_index = Get nearest index: middle_max
            time_max = Get time from index: nearest_index 

            # Select the sound
            select 'sound'
            
            # Extraire la partie du son correspondant au diphone
            extract_diphone = Extract part: time_min, time_max, "rectangular", 1, "no"

            

            # Concaténer le diphone extrait avec le son de synthèse.
            select 'synthese_sound'
            id = selected ("Sound")
            plus 'extract_diphone'
            synthese_sound = Concatenate
            
            #netoyage 
	        selectObject: id
	        Remove
	        select 'extract_diphone'
            Rename: "extract " +diphone$ 
	        #Remove


        endif
    endfor
endfor



select 'synthese_sound'
Rename: "son synthese"

select 'synthese_sound'


# Calculer la durée du son
duration = Get total duration

# Convert the sound to a Manipulation object
manipulation = To Manipulation: 0.01, 75, 600

# Extract the pitch tier from the sound
pitch = Extract pitch tier

# Supprimer tous les points pitch existants
Remove points between: 0, duration

# Ajouter des points pitch initiale pour donner une hauteur de ton de départ au son
Add point: 0.5, 200
Add point: 1, 250





# Calculer le nombre d'intervalles de répétition du pitch.
steps = round ((duration - 0.5) )

# Bouclez à travers chaque étape
for i from 1 to steps - 1
	p = i 
 	Add point: p, 230
	p = p + 0.7
	Add point: p, 250
	p = p + 0.1
	Add point: p, 250
	p = p + 0.1
 	Add point: p, 220

endfor

# Remplacer la tier de hauteur dans le son avec le nouveau pitch.
select 'pitch'
plus 'manipulation'
Replace pitch tier

# Régénérer le son à partir de l'objet Manipulation
select 'manipulation'
synthese_sound = Get resynthesis (overlap-add)

# FIN DU PROGRAMME


# Lire le son resynthetisé.
if ( play )
    Play
endif



# Enregistrement du fichier son obtenu
if ( save )
	Save as WAV file: synthese_filepath$
    appendInfoLine: "Enregistrement du fichier:", synthese_filepath$

endif



