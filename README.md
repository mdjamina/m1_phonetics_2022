# Utilisation du script Praat
## Prérequis
* Avoir installé le logiciel Praat sur votre ordinateur.
* Avoir les fichiers audio et TextGrid associés à utiliser avec le script.

## Configuration
1. Téléchargez le fichier de script Praat.
2. Ouvrez le fichier de script dans Praat.
3. Configurez les variables suivantes pour correspondre à vos fichiers :
 * sound_filepath$ : chemin d'accès au fichier audio.
 * text_grid_filepath$ : chemin d'accès au fichier TextGrid.
 * dico_filepath$ : chemin d'accès au fichier dictionnaire SAMPA.
 * synthese_filepath$ : chemin d'accès au fichier audio de synthèse.

## Utilisation
1. Exécutez le script en cliquant sur le bouton "Run".
2. Saisissez la phrase à synthétiser lorsque la fenêtre "Synthetiseur vocale" s'affiche.
3. Spécifiez si vous voulez lire le son synthetisé .
4. Spécifiez si vous voulez enregistrer le fichier audio de synthèse
5. Le script va alors effectuer la transcription SAMPA de la phrase entrée, la synthèse vocale et, si spécifié, enregistrer le fichier audio de synthèse.

## Note
* Assurez-vous que les fichiers audio et TextGrid associés au script sont correctement configurés et dans le format attendu.
* Le script peut être personnalisé pour répondre à vos besoins en modifiant les sections de code appropriées.
