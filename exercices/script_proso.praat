clearinfo

select all
#pause
nocheck Remove

# Opening the sound file
sound  = Read from file: "son_synthese.wav"
duration = Get total duration

select 'sound'
manipulation = To Manipulation: 0.01, 75, 600
pitch = Extract pitch tier
Remove points between: 0, duration


Add point: 0.5, 200
Add point: 1, 250






steps = round ((duration - 0.5) )
appendInfoLine: "duree:", duration, " | steps:",steps  

for i from 1 to steps - 1
	
	 appendInfoLine: "i:", i 
	p = i 
 appendInfoLine: "p1:", p 
	Add point: p, 230
	p = p + 0.7
 appendInfoLine: "p2:", p 
	Add point: p, 250
	p = p + 0.1
 appendInfoLine: "p3:", p 
	Add point: p, 250
	p = p + 0.1
 appendInfoLine: "p4:", p 
	Add point: p, 220

endfor


select 'pitch'
plus 'manipulation'
Replace pitch tier

select 'manipulation'
Get resynthesis (overlap-add)
