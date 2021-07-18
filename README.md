![image](https://i.imgur.com/vimKDV9.png)
# QB-HUD-Redux
Original idea based on the [QB-Hud](https://github.com/qbcore-framework/qb-hud) for the QB Framework.  
Realized by [Jakats](https://github.com/Jakats) and [Kurøsår](https://github.com/Kurosar/).  
Thanks to [GhzGarage(Kakarot)](https://github.com/GhzGarage/) / [Cosmo_Hud](https://github.com/GhzGarage/cosmo_hud) for the Seatbelt and Cruise part.  

Now also available as a "lite version"
![image](https://user-images.githubusercontent.com/4887819/126052425-57aabbe1-c0aa-4dd3-910f-fd9cf1df2d9a.png)


## Installation
**Prerequisite :** [qb-core](https://github.com/qbcore-framework/qb-core)

Clone or download the repo, extract it and move the ***qb-hud-redux*** folder inside your **resources/** folder.
Make sure to add  the following line to your **server.cfg** (lines 14 > 20)
> Ensure qb-hud-redux

## Features
• Health, Armor, Bleeding, Lungs, Stamina, Voice (Activity+Distance, compatible with PMA-Voice and rp-radio/qb-radio)  
• Current time, money on your person, current ID, current street name and direction  
• Blinking alerts when values are low, you can edit this in **html\js\app.js**  
• Vehicle hud with speed, seatbelt and cruise indicators  
• Low tick/ms usage  
• Fully ready for the QB-Core Framework  

## Media
Main HUD (on foot) :  
![image](https://user-images.githubusercontent.com/4887819/126051327-dc5b3802-6801-4c5b-b401-42ba4781b601.png)


Vehicle HUD (in a car) :  
![image](https://user-images.githubusercontent.com/4887819/126051341-10b71bb0-3b49-43d8-baa3-b9a420640040.png)

Blinking alerts :  
https://streamable.com/2g0o67

## FAQ
**Question:** My hud is not working  
**Answer:** Make sure you change the line **72** of **main.lua** to reflect the name of the radio script you use (By default "rp-radio"), for example, if you use qb-radio, juste replace by "qb-radio".  

**Question:** How do I switch from KM/H to MP/H ?  
**Answer:** You have to edit config.lua and change the following lines :   
> QBHud.MPH = false to QBHud.MPH = true  
> QBHud.ejectVelocity = (60 / 3.6) to QBHud.ejectVelocity = (60 / 2.236936)  
> QBHud.unknownEjectVelocity = (70 / 3.6) to QBHud.unknownEjectVelocity = (70 / 2.236936)  

**Question:** How do I enable the seatbelt sounds ?  
**Answer:** You have to download **[interact-sound](https://cdn.discordapp.com/attachments/831653036148654101/862145450865459200/interact-sound.zip)** and install it to your **resources/** folder.  

**Question:** Are you going to add Nitrous ?  
**Answer:** We decided to not include nitrous for now, maybe at a later point (or if someone wants to make a PR).  

**Question:** My voice indicator does not indicate the voice range properly, how to fix it ?  
**Answer:** You probably changed your default PMA-Voice ranges, please reflect those changes in **html/js/app.js** (lines 215 > 225)  

**Question:** The cruise feature is not working as intended, how to fix it ?  
**Answer:** If you are using **qb-smallresources** you have to edit **qb-smallresources/fxmanifest.lua** and comment the 'client/cruise.lua' line.  
![image](https://user-images.githubusercontent.com/4887819/126051690-67598943-7a55-4108-bb23-117dea32876c.png)
