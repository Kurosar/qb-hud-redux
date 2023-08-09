**PLEASE NOTE : The developpement has ceased on this project for now, you can still use it but things will not be updated anymore.**

![image](https://i.imgur.com/tdTjVME.png)
# QB-HUD-Redux v2.1
Original idea based on the [QB-Hud](https://github.com/qbcore-framework/qb-hud) for the QB Framework.  
Realized by [Jakats](https://github.com/Jakats) and [Kurøsår](https://github.com/Kurosar/).  
Thanks to [GhzGarage(Kakarot)](https://github.com/GhzGarage/) / [Cosmo_Hud](https://github.com/GhzGarage/cosmo_hud) and [Nojdh](https://github.com/nojdh/cosmo_hud) for the Seatbelt and Cruise part.  

**Now also comes with a "lite version"** (This is the same hud as normal, but with a more "horizontal" design)
![image](https://i.imgur.com/f5wIne5.png)


## Installation
**Prerequisite:** [qb-core](https://github.com/qbcore-framework/qb-core)  
**Download:** [Latest version](https://github.com/Kurosar/qb-hud-redux/releases/latest)  

Clone or download the repo, extract it and move the ***qb-hud-redux*** OR ***qb-hud-redux-lite*** (not both!) folder inside your **resources/** folder.  
Make sure to add  the following line to your **server.cfg** (lines 14 > 20)  
> ensure qb-hud-redux  
or  
> ensure qb-hud-redux-lite  

## Features
• Health, Armor, Bleeding, Lungs, Stamina, Voice (Activity+Distance, compatible with PMA-Voice and rp-radio/qb-radio)  
• Current time, money on your person, current ID, current street name and direction  
• Blinking alerts when values are low, you can edit this in **html\js\app.js**  
• Vehicle hud with speed, seatbelt and cruise indicators  
• Low tick/ms usage  
• Fully ready for the QB-Core Framework  

## Media
Blinking alerts (Example with the lite version) :  
https://streamable.com/9vrbwl

## Commands  
**G** to use the seatbelt.  
**Y** to use the cruise.  
**/togglehud** show/hide the entire hud.  
**/togglehudextra** show/hide the into texts (location etc..)  
Those keys can then be changed by the players in their options menu.  

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

**Question:** Should I use the normal or the lite version ?  
**Answer:** Due to popular request, we decided to make two versions, a normal, and a lite version (more horizontal for those who prefer this style).  
Definitely use the one that you prefer ;)  

**Question:** My voice indicator does not indicate the voice range properly, how to fix it ?  
**Answer:** You probably changed your default PMA-Voice ranges, please reflect those changes in **html/js/app.js** (lines 215 > 225)  

**Question:** The cruise feature is not working as intended, how to fix it ?  
**Answer:** If you are using **qb-smallresources** you have to edit **qb-smallresources/fxmanifest.lua** and comment the 'client/cruise.lua' line.  
You can also do the same for seatbelt.lua (comment it out) to avoid conflicts with qb-smallresources seatbelt and the hud seatbelt.  
![image](https://user-images.githubusercontent.com/4887819/126051690-67598943-7a55-4108-bb23-117dea32876c.png)


[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2FKurosar%2Fqb-hud-redux&count_bg=%2334BCF6&title_bg=%23555555&icon=github.svg&icon_color=%23E7E7E7&title=VISITORS&edge_flat=true)](https://hits.seeyoufarm.com)
