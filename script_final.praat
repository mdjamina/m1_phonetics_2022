clearinfo

select all
#pause
nocheck Remove

# Declaration of file access variables
# -------------------------------------
sound_filepath$ = "logatomes/faure.wav"
text_grid_filepath$ = "logatomes/faure.TextGrid"
dico_filepath$ = "dico2_sampa_ameliore.txt"
synthese_filepath$ = "son_synthese.wav"

# Opening the sound file
sound  = Read from file: sound_filepath$

# Sampling frequency: number of samples per second
frequency = Get sampling frequency

# Retrieving all intersections with 0
intersections = To PointProcess (zeroes): 1, "no", "yes"

# Opening the TextGrid file
text_grid =  Read from file: text_grid_filepath$

# Retrieving intervals from tier 1
nb_intervals = Get number of intervals: 1

# Reading the dictionary file containing French words and their corresponding SAMPA phonetic transcriptions
dico = Read Table from tab-separated file: dico_filepath$

# Creating a file to concatenate diphones
synthese_sound = Create Sound from formula: "sineWithNoise", 1, 0, 0.05, frequency, "0"

# BEGINNING OF THE PROGRAM

# Define the input text
text$ = "tzigane pour"

# Display the input text
appendInfoLine: "text:", text$

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
		
    # Select the "dico" table
    select 'dico'
    
    # Extract the row that corresponds to the current word "token$"
    row = Extract rows where column (text): "orthographe", "is equal to", token$
    
    # Get the SAMPA phonetic transcription of the word
    phonetic$ = Get value: 1, "phonetique"
    
    # Add the SAMPA phonetic transcription to the output text_phonetic$
    text_phonetic$ = text_phonetic$ + phonetic$ 
until ws = 0

text_phonetic$ = "_"+text_phonetic$+"_"

# Calculate the length of the text in phonetic form
len_text_phonetic = length(text_phonetic$)

# Loop over each character in the text
for char from 1 to len_text_phonetic  - 1

    # Get the current diphone
    diphone$ = mid$(text_phonetic$,char,2)
    
    # Get the first and second characters of the diphone
    char1_diphone$ = left$(diphone$,1)
    char2_diphone$ = right$(diphone$,1)

    # Loop over each interval in the grid
    for intvl from 1 to nb_intervals-1

        # Get the next interval
        next_intvl = intvl + 1

        # Select the text grid
        select 'text_grid'

        # Get the labels of the current and next intervals
        label_interval$ = Get label of interval: 1, intvl
        label_next_intvl$ = Get label of interval: 1, next_intvl

        # If the current and next intervals contain the characters of the diphone
        if (label_interval$ = char1_diphone$ and label_next_intvl$ = char2_diphone$ )

            # Get the start and end times of the current and next intervals
            start_interval = Get start time of interval: 1, intvl
            end_interval = Get end time of interval: 1, intvl
            end_next_intvl = Get end time of interval: 1, next_intvl
            
            # Calculate the middle time of the current interval
            middle_min =  (start_interval + end_interval) /2
            
            # Calculate the middle time of the next interval
            middle_max =  (end_interval + end_next_intvl) /2

            # Select the intersections object
            select 'intersections'

            # Get the nearest intersection with 0 to the middle of the current interval
            nearest_index = Get nearest index: middle_min
            time_min = Get time from index: nearest_index 

            # Get the nearest intersection with 0 to the middle of the next interval
            nearest_index = Get nearest index: middle_max
            time_max = Get time from index: nearest_index 

            # Select the sound
            select 'sound'
            
            # Extract the part of the sound corresponding to the diphone
            extract_phone = Extract part: time_min, time_max, "rectangular", 1, "no"

            

            # Select the synthesis sound and Concatenate the extracted diphone with the synthesis sound
            select 'synthese_sound'
            id = selected ("Sound")
            plus 'extract_phone'
            synthese_sound = Concatenate
            
            #netoyage 
	        selectObject: id
	        Remove
	        select 'extract_phone'
            Rename: "extract_" +diphone$
	        #Remove


        endif
    endfor
endfor



select 'synthese_sound'
Rename: "son synthese"

Play
Save as WAV file: synthese_filepath$

