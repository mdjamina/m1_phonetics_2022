clearinfo

select all
#pause
nocheck Remove


form Synthetiseur vocale (TAL M1)
    comment Quelle phrase voulez-vous synthétiser ?
    text text la femme dit que le succès pour moi échouer sept fois et se relever huit sans doute

   comment _________________________________________________________________________________
   comment Voulez-vous enregistrer le fichier .wav à la fin ?
       boolean Enregistrement 1

endform



# Afficher le texte d'entrée
appendInfoLine: "text:", text$