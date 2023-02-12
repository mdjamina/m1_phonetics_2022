clearinfo

select all
#pause
nocheck Remove


# Define the input text
text$ = "la femme dit que le succès pour moi échouer sept fois et se relever huit sans doute"

# Display the input text
appendInfoLine: "text:", text$

# Read the dictionary file containing French words and their corresponding SAMPA phonetic transcriptions
dico = Read Table from tab-separated file: "dico2_sampa_ameliore.txt"

# Initialize the output text_phonetic$ to an empty string
text_phonetic$ = ""

# Get the length of the input text
len_text = length(text$)

# Repeat the following process until there are no more spaces in text$
repeat 
    # Find the index of the first space in text$
    ws = index(text$, " ")
    
    # Extract the first word in text$
    token$ = left$(text$, ws-1)
    
    # Redefine text$ to only contain the part of the string after the first space
    text$ = right$(text$, len_text - ws)
    
    # Update the length of text$
    len_text = length(text$)
    
    # Handle the last word in the sentence (there is no space after the last word)
    if ws = 0
        token$ = text$
    endif	

    # Display the current word
    #appendInfoLine: "token:|", token$ ,"|"
		
    # Select the "dico" table
    select 'dico'
    
    # Extract the row that corresponds to the current word "token$"
    Extract rows where column (text): "orthographe", "is equal to", token$
    
    # Get the SAMPA phonetic transcription of the word
    phonetic$ = Get value: 1, "phonetique"
    
    # Add the SAMPA phonetic transcription to the output text_phonetic$
    text_phonetic$ = text_phonetic$ + phonetic$ 
until ws = 0

# Display the final SAMPA phonetic transcription of the input text
appendInfoLine: "text_phonetic:", text_phonetic$
