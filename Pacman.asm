;Muhammad Zohaib Raza 22I-1331 BCS-H COAL LAB
include Irvine32.inc
INCLUDE macros.inc
includelib winmm.lib
.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword
BUFFER_SIZE = 5000
NumbToStr   PROTO :DWORD,:DWORD

PlaySound PROTO,
        pszSound:PTR BYTE, 
        hmod:DWORD, 
        fdwSound:DWORD

.data
SND_FILENAME DWORD 00020000h
SND_LOOP DWORD  00000008h
SND_ASYNC DWORD 00000001h
file BYTE "nusic.wav" , 0
error BYTE "Error opening file",0
buffer BYTE BUFFER_SIZE DUP(?)
sizeofbuffer dd 0
filename    BYTE "HighScore.txt",0
fileHandle  dword ?
space db " ",0
stringLength dd 1000
bbff        db 11 dup(?)

ground BYTE "--------------------------------------------------------------------------------------------------------------------------",0
ground1 BYTE "||",0ah,0
ground2 BYTE "||",0

temp byte ?

strScore BYTE "Your score is: ",0
score dd 0

xPos BYTE 83
yPos BYTE 43


xPosG BYTE 84
yPosG BYTE 19

xCoinPos BYTE ?
yCoinPos BYTE ?

inputChar BYTE ?
level BYTE 1

prompt db "Enter 1 for Start Game",0
prompt1 db "Enter x for Exit Game",0
pacmana db " _____                                                                            _____" ,0ah  ,0 
pacmanb db "( ___ )                                                                          ( ___ )" ,0ah  ,0
pacmanc db " |   |",0
pacmanc1 db "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~",0
pacmanc2 db "|   |" ,0ah  ,0 
pacmand db " |   |                                                                            |   |" ,0ah  ,0 
pacmane db " |   |     _______     __       ______   ___      ___       __      _____  ___    |   |" ,0ah  ,0 
pacmanf db " |   |    |   __  \   /  \     / _    \ |   \    /   |     /  \    (\    \|   \   |   |" ,0ah  ,0 
pacmang db " |   |    (. |__) :) /    \   (: ( \___) \   \  //   |    /    \   |.\\   \    |  |   |" ,0ah  ,0 
pacmanh db " |   |    |:  ____/ /' /\  \   \/ \      /\\  \/.    |   /' /\  \  |: \.   \\  |  |   |" ,0ah  ,0 
pacmani db " |   |    (|  /    //  __'  \  //  \ _  |: \.        |  //  __'  \ |.  \    \. |  |   |" ,0ah  ,0 
pacmanj db " |   |   /|__/ \  /   /  \\  \(:   _) \ |.  \    /:  | /   /  \\  \|    \    \ |  |   |" ,0ah  ,0 
pacmank db " |   |  (_______)(___/    \___)\_______)|___|\__/|___|(___/    \___)\___|\____\)  |   |" ,0ah  ,0 
pacmanl db " |   |                                                                            |   |" ,0ah  ,0 
pacmanm db " |___|",0
pacmanm1 db "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~",0
pacmanm2 db "|___|" ,0ah  ,0 
pacmann db "(_____)                                                                          (_____)" ,0ah  ,0

startgamea db "  __     ____  ____  __   ____  ____        __ _  ____  _  _         ___   __   _  _  ____" ,0ah  ,0 
startgameb db " /  \   / ___)(_  _)/ _\ (  _ \(_  _)      (  ( \(  __)/ )( \       / __) / _\ ( \/ )(  __)" ,0ah  ,0
startgamec db "(_/ / _ \___ \  )( /    \ )   /  )(        /    / ) _) \ /\ /      ( (_ \/    \/ \/ \ ) _)" ,0ah  ,0 
startgamed db " (__)(_)(____/ (__)\_/\_/(__\_) (__)       \_)__)(____)(_/\_)       \___/\_/\_/\_)(_/(____)" ,0ah  ,0

resumegamea db "  __     ____  ____  ____  _  _  _  _  ____ " ,0ah  ,0
resumegameb db " /  \   (  _ \(  __)/ ___)/ )( \( \/ )(  __)" ,0ah  ,0
resumegamec db "(_/ / _  )   / ) _) \___ \) \/ (/ \/ \ ) _) " ,0ah  ,0
resumegamed db " (__)(_)(__\_)(____)(____/\____/\_)(_/(____)" ,0ah  ,0

restartgamea db " ____     ____  ____  ____  ____  __   ____  ____ " ,0ah  ,0
restartgameb db "(___ \   (  _ \(  __)/ ___)(_  _)/ _\ (  _ \(_  _)" ,0ah  ,0
restartgamec db " / __/ _  )   / ) _) \___ \  )( /    \ )   /  )(  " ,0ah  ,0
restartgamed db "(____)(_)(__\_)(____)(____/ (__)\_/\_/(__\_) (__) " ,0ah  ,0

levelsa db " ____     __    ____  _  _  ____  __    ____" ,0ah  ,0 
levelsb db "(___ \   (  )  (  __)/ )( \(  __)(  )  / ___)" ,0ah  ,0
levelsc db " / __/ _ / (_/\ ) _) \ \/ / ) _) / (_/\\___ \" ,0ah  ,0
levelsd db "(____)(_)\____/(____) \__/ (____)\____/(____/" ,0ah  ,0

instructionsa db " ____     __  __ _  ____  ____  ____  _  _   ___  ____  __  __   __ _  ____" ,0ah  ,0 
instructionsb db "( __ \   (  )(  ( \/ ___)(_  _)(  _ \/ )( \ / __)(_  _)(  )/  \ (  ( \/ ___)" ,0ah  ,0
instructionsc db " (__ ( _  )( /    /\___ \  )(   )   /) \/ (( (__   )(   )((  O )/    /\___ \" ,0ah  ,0
instructionsd db "(____/(_)(__)\_)__)(____/ (__) (__\_)\____/ \___) (__) (__)\__/ \_)__)(____/" ,0ah  ,0

instructions1a db " __  __ _  ____  ____  ____  _  _   ___  ____  __  __   __ _  ____" ,0ah  ,0 
instructions1b db "(  )(  ( \/ ___)(_  _)(  _ \/ )( \ / __)(_  _)(  )/  \ (  ( \/ ___)" ,0ah  ,0
instructions1c db " )( /    /\___ \  )(   )   /) \/ (( (__   )(   )((  O )/    /\___ \" ,0ah  ,0
instructions1d db "(__)\_)__)(____/ (__) (__\_)\____/ \___) (__) (__)\__/ \_)__)(____/" ,0ah  ,0

HighScoresa db "  ___     _  _  __  ___  _  _  ____   ___  __  ____  ____  ____" ,0ah  ,0
HighScoresb db " / _ \   / )( \(  )/ __)/ )( \/ ___) / __)/  \(  _ \(  __)/ ___)" ,0ah  ,0
HighScoresc db "(__  ( _ ) __ ( )(( (_ \) __ (\___ \( (__(  O ))   / ) _) \___ \" ,0ah  ,0
HighScoresd db "  (__/(_)\_)(_/(__)\___/\_)(_/(____/ \___)\__/(__\_)(____)(____/" ,0ah  ,0

HighScores1a db " _  _  __  ___  _  _  ____   ___  __  ____  ____  ____" ,0ah  ,0
HighScores1b db "/ )( \(  )/ __)/ )( \/ ___) / __)/  \(  _ \(  __)/ ___)" ,0ah  ,0
HighScores1c db ") __ ( )(( (_ \) __ (\___ \( (__(  O ))   / ) _) \___ \" ,0ah  ,0
HighScores1d db "\_)(_/(__)\___/\_)(_/(____/ \___)\__/(__\_)(____)(____/" ,0ah  ,0

exita db "  ___     ____  _  _  __  ____" ,0ah  ,0  
exitb db " / __)   (  __)( \/ )(  )(_  _)" ,0ah  ,0 
exitc db "(___ \ _  ) _)  )  (  )(   )(" ,0ah  ,0   
exitd db "(____/(_)(____)(_/\_)(__) (__)" ,0ah  ,0  

level1a db "  __     __    ____  _  _  ____  __           __" ,0ah  ,0 
level1b db " /  \   (  )  (  __)/ )( \(  __)(  )         (  )" ,0ah  ,0
level1c db "(_/ / _ / (_/\ ) _) \ \/ / ) _) / (_/\        )(" ,0ah  ,0 
level1d db " (__)(_)\____/(____) \__/ (____)\____/       (__)" ,0ah  ,0

level2a db " ____     __    ____  _  _  ____  __           __  __" ,0ah  ,0 
level2b db "(___ \   (  )  (  __)/ )( \(  __)(  )         (  )(  )" ,0ah  ,0
level2c db " / __/ _ / (_/\ ) _) \ \/ / ) _) / (_/\        )(  )(" ,0ah  ,0 
level2d db "(____)(_)\____/(____) \__/ (____)\____/       (__)(__)" ,0ah  ,0

level3a db " ____     __    ____  _  _  ____  __           __  __  __" ,0ah  ,0 
level3b db "( __ \   (  )  (  __)/ )( \(  __)(  )         (  )(  )(  )" ,0ah  ,0
level3c db " (__ ( _ / (_/\ ) _) \ \/ / ) _) / (_/\        )(  )(  )(" ,0ah  ,0 
level3d db "(____/(_)\____/(____) \__/ (____)\____/       (__)(__)(__)" ,0ah  ,0

return1a db "  __     ____  ____  ____  _  _  ____  __ _" ,0ah  ,0 
return1b db " /  \   (  _ \(  __)(_  _)/ )( \(  _ \(  ( \" ,0ah  ,0
return1c db "(  0 )_  )   / ) _)   )(  ) \/ ( )   //    /" ,0ah  ,0
return1d db " \__/(_)(__\_)(____) (__) \____/(__\_)\_)__)" ,0ah  ,0

mainmenua db " ____     _  _   __   __  __ _  _  _  ____  __ _  _  _ " ,0ah  ,0
mainmenub db "( __ \   ( \/ ) / _\ (  )(  ( \( \/ )(  __)(  ( \/ )( \" ,0ah  ,0
mainmenuc db " (__ ( _ / \/ \/    \ )( /    // \/ \ ) _) /    /) \/ (" ,0ah  ,0
mainmenud db "(____/(_)\_)(_/\_/\_/(__)\_)__)\_)(_/(____)\_)__)\____/" ,0ah  ,0

gameovera db "  ___   __   _  _  ____         __   _  _  ____  ____ " ,0ah  ,0
gameoverb db " / __) / _\ ( \/ )(  __)       /  \ / )( \(  __)(  _ \" ,0ah  ,0
gameoverc db "( (_ \/    \/ \/ \ ) _)       (  O )\ \/ / ) _)  )   /" ,0ah  ,0
gameoverd db " \___/\_/\_/\_)(_/(____)       \__/  \__/ (____)(__\_)" ,0ah  ,0
 
ins1 db "1. PRESS W KEY TO MOVE PAC-MAN UP.",0ah,0
ins2 db "2. PRESS S KEY TO MOVE PAC-MAN DOWN.",0ah,0
ins3 db "3. PRESS A KEY TO MOVE PAC-MAN LEFT.",0ah,0
ins4 db "4. PRESS D KEY TO MOVE PAC-MAN RIGHT.",0ah,0
ins8 db "8. PRESS 0 KEY TO RETURN TO MAINMENU.",0ah,0
ins5 db "5. Collect all pellets to complete the level.",0ah,0
ins7 db "7. Avoid ghosts; they will try to catch you.",0ah,0
ins6 db "6. Complete levels to advance through the game.",0ah,0

grid01maze01 db "======================================================================================================================",0ah,0
grid01maze02 db " . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ",0ah,0
grid01maze03 db "===================== . =============================================================== . ============================",0ah,0
grid01maze04 db "===================== . =============================================================== . ============================",0ah,0
grid01maze05 db "===== . . . . . . . . . . . . . . . . . . . ========================== . . . . . . . . . . . . . . . . . . . . . =====",0ah,0
grid01maze06 db "===================== . =============================================================== . ============================",0ah,0
grid01maze07 db "===== . . . . . . . . . . . . . . . . . . . ========================== . . . . . . . . . . . . . . . . . . . . . =====",0ah,0
grid01maze08 db "========================================= . ========================== . =============================================",0ah,0
grid01maze09 db " . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  . . . . . . ",0ah,0
grid01maze10 db " . ,--------------, . ,--------------, . ,--------------, . ,--------------, . ,---------------, . ,--------------, . ",0ah,0  
grid01maze11 db " . |   ________   | . |     ____     | . |  ____  ____  | . |      __      | . |     ______    | . |   ______     | . ",0ah,0  
grid01maze12 db " . |  |  __   _|  | . |   .'    `.   | . | |_   ||   _| | . |     /  \     | . |    |_    _|   | . |  |_   _ \    | . ",0ah,0  
grid01maze13 db " . |  |_/  / /    | . |  /  .--.  \  | . |   | |__| |   | . |    / /\ \    | . |      |  |     | . |    | |_) |   | . ",0ah,0  
grid01maze14 db " . |     .'.' _   | . |  | |    | |  | . |   |  __  |   | . |   / ____ \   | . |      |  |     | . |    |  __'.   | . ",0ah,0  
grid01maze15 db " . |   _/ /__/ |  | . |  \  `--'  /  | . |  _| |  | |_  | . | _/ /    \ \_ | . |     _|  |_    | . |   _| |__) |  | . ",0ah,0  
grid01maze16 db " . |  |________|  | . |   `.____.'   | . | |____||____| | . ||____|  |____|| . |    |______|   | . |  |_______/   | . ",0ah,0  
grid01maze17 db " . |              | . |              | . |              | . |              | . |               | . |              | . ",0ah,0  
grid01maze18 db " . '--------------' . '--------------' . '--------------' . '--------------' . '---------------' . '--------------' . ",0ah,0
grid01maze19 db " . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  . . . . . . ",0ah,0
grid01maze20 db "========================================= . ========================== . =============================================",0ah,0
grid01maze21 db "===== . . . . . . . . . . . . . . . . . . . ========================== . . . . . . . . . . . . . . . . . . . . . =====",0ah,0
grid01maze22 db "===================== . =============================================================== . ============================",0ah,0
grid01maze23 db "===== . . . . . . . . . . . . . . . . . . . ========================== . . . . . . . . . . . . . . . . . . . . . =====",0ah,0
grid01maze24 db "===================== . =============================================================== . ============================",0ah,0
grid01maze25 db "===================== . =============================================================== . ============================",0ah,0
grid01maze26 db " . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ",0ah,0
grid01maze27 db "======================================================================================================================",0ah,0

grid02maze01 db "______________________________________________________________________________________________________________________",0ah,0
grid02maze02 db " . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ",0ah,0
grid02maze03 db " . ,____________ . ____________, . _____________________ .  . _____________________ . ,___________________________, . ",0ah,0
grid02maze04 db " . | . . . . . . . . . . . . . | . . . . . . . . . . . . .  . . . . . . . . . . . . . | . . . . . . . . . . . . . | . ",0ah,0
grid02maze05 db " . | . _____________________ . | . ________________________________________________ . | . _____________________ . | . ",0ah,0
grid02maze06 db " . | . . . . . . . . . . . . . | . ________________________________________________ . | . . . . . . . . . . . . . | . ",0ah,0
grid02maze07 db " . |___________________________| . . . . ____________________________________ . . . . |____________ . ____________| . ",0ah,0
grid02maze08 db " . _____________________________ . ________________________________________________ . _____________ . _____________ . ",0ah,0
grid02maze09 db " . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  . . . . . . . . . . . . . . . . . . . . . . . . ",0ah,0
grid02maze10 db " . ,--------------, . ,--------------, . ,--------------, . ,--------------, . ,---------------, . ,--------------, . ",0ah,0  
grid02maze11 db " . |   ________   | . |     ____     | . |  ____  ____  | . |      __      | . |     ______    | . |   ______     | . ",0ah,0  
grid02maze12 db " . |__|  __   _|__| . |___,'    `,___| . |_|_   ||   _|_| . |_____/  \_____| . |____|_    _|___| . |__|_   _ \____| . ",0ah,0  
grid02maze13 db " . .  |_/  / /    . . .  /  ,--,  \  . . .   | |__| |   . . .    / /\ \  . . . . . .  |  |     . . . .  | |_) |   . . ",0ah,0  
grid02maze14 db " . .     ,',' _   . . .  | |    | |  . . .   |  __  |   . . .   / ____ \ . . . . . .  |  |     . . . .  |  __ \   . . ",0ah,0  
grid02maze15 db " . .   _/ /__/ |  . . .  \  `--'  /  . . .  _| |  | |_  . . . _/ /    \ \_ . . . . . _|  |_    . . . . _| |__) |  . . ",0ah,0  
grid02maze16 db " . ,__|________|__, . ,___`,____,'___, . ,_|____||____|_, . ,|____|  |____|, . ,____|______|___, . ,__|_______/___, . ",0ah,0  
grid02maze17 db " . |              | . |              | . |              | . |              | . |               | . |              | . ",0ah,0  
grid02maze18 db " . '--------------' . '--------------' . '--------------' . '--------------' . '---------------' . '--------------' . ",0ah,0
grid02maze19 db " . . . . . . . . .  . . . . . . . . .  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  . . . . . ",0ah,0
grid02maze20 db " . _____________________________ . _______________________________________________ . _____________ . ______________ . ",0ah,0
grid02maze21 db " . ,___________________________, . . . . ___________________________________ . . . . ,____________ . _____________, . ",0ah,0
grid02maze22 db " . | . . . . . . . . . . . . . | . _______________________________________________ . | . . . .  . . . . . . . . . | . ",0ah,0
grid02maze23 db " . | . _____________________ . | . _______________________________________________ . | . ______________________ . | . ",0ah,0
grid02maze24 db " . | . . . . . . . . . . . . . | . . . . . . . . . . . . .  . . . . . . . . . . .  . | . . . .  . . . . . . . . . | . ",0ah,0
grid02maze25 db " . |____________ . ____________| . _____________________ .  . ____________________ . |____________________________| . ",0ah,0
grid02maze26 db " . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  . . . . . . . .  . . . . . . . . . . . .  . . . . . . . . ",0ah,0
grid02maze27 db "______________________________________________________________________________________________________________________",0ah,0

grid03maze01 db "======================================================================================================================",0ah,0
grid03maze02 db " . . . . . . . . . | | . . . . . . . . . . . . . . . . | | . | | .|. | | . .  .  |(^_^)|     |. . . .|  . . . . . . . ",0ah,0
grid03maze03 db " . ,-----------, . | | . ,----------, . ,----------, . | | . | | .|. | |====   .  =====      |. .====|.  . __________ ",0ah,0
grid03maze04 db " . |           | . |_| . | ,________| . |________, | . | | . | | .|. | |. . | | .  =======   |. . . .|.  . |(^____^)| ",0ah,0
grid03maze05 db " . |   =====   | . . . . | | . . . . . . . . . . | | . | | . | | .|. |=== . | | .| |(^_^)|   | ===. .      ---------- ",0ah,0
grid03maze06 db " . |     .     | . ,-, . | | . ,-------------, . | | . | | . | | .|. |   |. | | .| =======   |. . . .| . . . . . . .  ",0ah,0
grid03maze07 db " . |____ . ____| . | | . | | . |_____________| . | | . | | . | | .|. |   |. . . .|     ========   ====================",0ah,0
grid03maze08 db " . . . . . . . . . | | . |_|   __________________|_| . |_| . | | .|. |   |. | | .|  |         |  |=                   ",0ah,0
grid03maze09 db "________ . ________| | .  .  .  .  .  .  .  .  .  .  .  .  . | | .|. |   |. | | .|  |   --    | .|=                   ",0ah,0
grid03maze10 db " . . . . . . . . . | |----------------, . ,--------------, . | | .|. |   |. | |== ==   |^^|   |  |=  _________        ",0ah,0
grid03maze11 db " . ,-----------, . | |________________| . |______________| . | | . . . . . . . . . . . . . |^^| .    || ^_^ ||        ",0ah,0
grid03maze12 db " . |___________| . | | .  =============          . . . . . . |    ==================== | . ,--- .|=  ---------        ",0ah,0
grid03maze13 db " . . . . . . . . . | | .  |                    |. . . . . .  |  |  . . . . . .  . . . .| . |   . |=                   ",0ah,0
grid03maze14 db "-------- . --------|_| .  |  .    |(^_^)|     . . . . . . . .    . . . . .|^_^|. . . . | .  .  . |=___________________",0ah,0          
grid03maze15 db " . . . . . . . . |-|   .  |       -------      |. . . . . . .  |          -----. . . . | . |                          ",0ah,0
grid03maze16 db " . ,---------, . | |   .  ====================== . . . ===| . . . =====================| .  ==========================",0ah,0                       
grid03maze17 db " . |  ,___,  | . | |  .  . . . . . . . . . . . . . . . . . . . . . . .  . .. . . . |   | . . . .   . . . . . . . . . !",0ah,0
grid03maze18 db " . |  | . |  | . | | .   =========== . . =========== . . . . . . . . . . . . . .  . . .|. . . . .  . . . . . . . . . !",0ah,0
grid03maze19 db " . |  | . |  | . | | .  | |========= . . ========||. . . . . . . . . . . . . . . . . . . .  ||  .  | ,---------, . | !",0ah,0
grid03maze20 db " . . .  . |  | . | | .  | |                      || . .  .|.| |/\| |\/| . |           |  .  ||  .  | |  | . .  | . | !",0ah,0
grid03maze21 db " . |__| . |  | . | |.   | |                      ||== . . |.| |==| |/\| . ,----. .----,  .  ||  .  | |  ,___,  | . | !",0ah,0
grid03maze22 db " ---------'  | . | |  . | |      __________      || .  . =|.| |==| |--| . |    . .    |  .  ||  .  | |  | . |  | . | !",0ah,0
grid03maze23 db " ------------' . | |   .| |     | (^____^) |     ||=.  .  |.| |==| |\/| . |           |  .  ||  .  | |__| . |  | . | !",0ah,0                      
grid03maze24 db " . . . . . . . . | |   .| |     |__________|     || .  . =|.| |\/| |/\| . |___________|  .  ||  .  | . .  . |  | . | !",0ah,0                  
grid03maze25 db " . --------------| | .  | |                      ||==. . . . . . . . . . . . . . . . . . . . . .    ------ .  .  . | !",0ah,0                            
grid03maze26 db " . . . . . . . . . .    | |======================||. . .  |||||||||||||. . . . . . . . . . . . .    ---------------| !",0ah,0                     
grid03maze27 db "======================================================================================================================",0ah,0

EnterName db "Enter your name: ",0
namePlayer1 db "Player Name",0
PlayerScore db "Player Score",0
namePlayer db 20 dup(?)
playernamelength dd 0
validup db 0
updownleftright db 0
DodgeScore dd 0
ghostmove dd 0
updownleftrightG db 0
validupG db 0
checkGhost1 db 0
moveLeftRight db 0
moveUpDown db 0
ghostDot db 0
lives dd 3
livesprint db "Lives: ",0
food db 0
speeddelayofghost dd 80
highhhhh db "Score   Level   Playername ",0ah,0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                        MainProc                          ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.code
main PROC
;call FileHandling
call clrscr
mov eax, SND_FILENAME  ;; pszSound is a file name
or eax, SND_LOOP       ;; Play in a loop
or eax, SND_ASYNC      ;; Play in the background
invoke PlaySound, addr file, 0, eax 
call Pacman
mov dl,39
mov dh,18
call Gotoxy
mov edx, offset EnterName
call writestring
mov eax,blue + (gray * 64)
call SetTextColor
mov ecx,22
mov edx, offset namePlayer
call readstring
mov playernamelength,eax
call MainMenu

INVOKE ExitProcess,0
main ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                     FileHandling                         ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FileHandling PROC
	mov edx,OFFSET filename
	call OpenInputFile
	mov fileHandle,eax
	cmp eax,INVALID_HANDLE_VALUE
	jne file_ok
	mWrite <"Cannot open file",0dh,0ah>
	jmp quit
	file_ok:
	mov edx,OFFSET buffer
	mov ecx,BUFFER_SIZE
	call ReadFromFile
	jnc check_buffer_size
	mWrite "Error reading file. "
	call WriteWindowsMsg
	jmp close_file
	check_buffer_size:
	cmp eax,BUFFER_SIZE
	jb buf_size_ok
	mWrite <"Error: Buffer too small for the file",0dh,0ah>
	jmp quit
	buf_size_ok:
	mov buffer[eax],0
    mov ebx,0
    mov ecx,3
 
    mov dh ,22
mov temp,dh
L1:
    mov dl,67
    mov dh,temp
call Gotoxy
L2: 
   cmp buffer[ebx],0ah
je endloop
 call gotoxy
     mov al,buffer[ebx]
	call Writechar
     inc dl
    inc ebx
jmp L2
endloop:
inc ebx
	inc temp
	loop L1
	call Crlf
	close_file:

	mov eax,fileHandle
	call CloseFile
quit:
ret
FileHandling ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                        DrawGhost                         ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawGhost PROC
    ; draw ghost at (xPos,yPos):
    mov eax,green ;(blue*16)
    call SetTextColor
    mov dl,xPosG
    mov dh,yPosG
    call Gotoxy
cmp level,1
je level1Ghost
cmp level,2
je level2Ghost
cmp level,3
je level3Ghost
level1Ghost:

    mov al,"G"
	jmp movnext
level2Ghost:
	mov al,"P"
	jmp movnext
level3Ghost:	
	mov al,"B"
	jmp movnext
	movnext:
    call WriteChar
    ret
DrawGhost ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                       UpdateGhost                        ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

UpdateGhost PROC
	mov eax, blue + (gray * 64)
	call SetTextColor
    mov dl,xPosG
    mov dh,yPosG
    call Gotoxy
	cmp ghostDot,1
	je ghostDot1
    mov al," "
    call WriteChar
	jmp last
ghostDot1:
mov al,"."
call WriteChar
last:
mov al ,xPosG
cmp xcoinpos,al
   jne notsame
      mov al ,yPosG
cmp ycoinpos,al
   jne notsame
	mov eax, green + (gray * 64)
	call SetTextColor
     mov dl,xcoinpos
     mov dh,ycoinpos
     call Gotoxy
	  mov al,"$"
call WriteChar
notsame:
mov eax, blue + (gray * 64)
call SetTextColor
    ret
UpdateGhost ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                   DrawPlayerDead                         ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawPlayerDead PROC
	call clrscr
	call Pacman
	call GameOverDisplay
	call Exit1

	mov eax, red + (gray * 64)
	call SetTextColor
	mov dl,60
	mov dh,25
	call Gotoxy
	mov edx, offset namePlayer1
	call writestring
	mov dl,90
	mov dh,25
	call Gotoxy
	mov edx, offset PlayerScore
	call writestring
	mov dl,60
	mov dh,27
	call Gotoxy
	mov edx,offset namePlayer
	call WriteString
	mov dl,95
	mov dh,27
	call Gotoxy
	mov eax,score
	call Writedec
	mov dl,75
	mov dh,30
	call Gotoxy
reaaaaadd:
	call readchar
	cmp al,"5"
	je retaaaaaaaa
	jmp reaaaaadd
retaaaaaaaa:
ret
DrawPlayerDead ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                       DrawPlayer                         ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawPlayer PROC
    ; draw player at (xPos,yPos):
    mov eax,yellow ;(blue*16)
    call SetTextColor
    mov dl,xPos
    mov dh,yPos
    call Gotoxy
    mov al,"X"
    call WriteChar
    ret
DrawPlayer ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                       UpdatePlayer                       ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

UpdatePlayer PROC
    mov dl,xPos
    mov dh,yPos
    call Gotoxy
    mov al," "
    call WriteChar
	ret
UpdatePlayer ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                       DrawCoin                           ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawCoin PROC
   	mov eax, green + (gray * 64)
    call SetTextColor
    mov dl,xCoinPos
    mov dh,yCoinPos
    call Gotoxy
    mov al,"$"
    call WriteChar
    ret
DrawCoin ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                  CreateRandomCoin                        ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CreateRandomCoin PROC
    mov eax,117
    call RandomRange
	add eax,27
    mov xCoinPos,al
	cmp level,3
	je level3Coin
    mov yCoinPos,36
	ret
level3Coin:
    mov yCoinPos,34
    ret
CreateRandomCoin ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                    CheckLevelGrid                        ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CheckLevelGrid PROC
	cmp level,1
	jne level2GridCheck
	call GridLevel1
	jmp reeeturn
	level2GridCheck:
		cmp level,2
	jne level3GridCheck
		call GridLevel2
		jmp reeeturn
	level3GridCheck:
		call GridLevel3
		jmp reeeturn
	reeeturn:
		ret
CheckLevelGrid ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                        StartGame                         ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

StartGame proc
thisisstart:
    call clrscr
	call pacman
	call CheckLevelGrid
	; call CreateRandomCoin
    ; draw ground at (0,29):
    mov eax,red ;(black * 16)
    call SetTextColor
    mov dl,24
    mov dh,45
    call Gotoxy
    mov edx,OFFSET ground
    call WriteString
    mov dl,24
    mov dh,17
    call Gotoxy
    mov edx,OFFSET ground
    call WriteString

    mov ecx,27
    mov dh,18
	mov temp,dh
    l1:
	mov dh,temp
    mov dl,24
    call Gotoxy
    mov edx,OFFSET ground1
    call WriteString
	inc temp
    ;inc dh
    loop l1

    mov ecx,27
    mov dh,18
    mov temp,dh
    l2:
    mov dh,temp
    mov dl,144
    call Gotoxy
    mov edx,OFFSET ground2
    call WriteString
    inc temp
    loop l2
    call DrawPlayer
	call DrawGhost

    call CreateRandomCoin
    call DrawCoin

    call Randomize
	jmp gameLoop
	level1complete:
		call clrscr
		mov xPos,83
		mov yPos,43
		mov xPosG,84
		mov yPosG,19
		mov level,2
		mov speeddelayofghost,40
		jmp thisisstart
	level2complete:
		call clrscr
		mov xPos,83
		mov yPos,43
		mov xPosG,84
		mov yPosG,19
		mov level,3
		mov speeddelayofghost,20
		jmp thisisstart
	level3complete:
		jmp gameover


    gameLoop:
cmp lives,0
je gameover
cmp food,0
je chkfood
 call CreateRandomCoin
    call DrawCoin
    call Randomize
	mov food,0
chkfood:
	     mov al,xpos
	    cmp al,xCoinPos
		jne noteaten   
		    mov al,ypos
			cmp al,yCoinPos
			jne noteaten
				;call UpdatePlayer
				call DrawPlayer
				mov food,1
				add score,30
				mov eax,red+(black*16)
				call SetTextColor
				mov dl,xCoinPos
				mov dh,yCoinPos
				call Gotoxy
			;	mov al," "
			;	call WriteChar
noteaten:
        ; getting points:
     ;   mov bl,xPos
     ;   cmp bl,xCoinPos
     ;   jne notCollecting
     ;   mov bl,yPos
     ;   cmp bl,yCoinPos
     ;   jne notCollecting
     ;   ; player is intersecting coin:
     ;   add score,30
     ;   call CreateRandomCoin
     ;   call DrawCoin
     ;   notCollecting:
		mov bl,xPosG
		cmp bl,xPos
		jne notlivesdec
		mov bl,yPosG
		cmp bl,yPos
		jne notlivesdec
		dec lives
		mov xPos,83
		mov yPos,43
		call DrawPlayer
		notlivesdec:


		cmp DodgeScore,15920
		jge level3complete1
		cmp DodgeScore,8045
		jge level2complete1
		cmp DodgeScore,2355
		jge level1complete1
		jmp nexttttttt
level1complete1:
		cmp level,1
		je level1complete
		jmp nexttttttt
level2complete1:
		cmp level,2
		je level2complete
		jmp nexttttttt
level3complete1:
		cmp level,3
		je level3complete
		jmp nexttttttt

		nexttttttt:

ghostmovement:
		cmp moveUpDown,1
		je upaa123
		cmp moveUpDown,0
		je downaa123
Upaa123:
		cmp moveLeftRight,0
		je leftaa1234
		cmp moveLeftRight,1
		je rightaa1234

Downaa123:
		cmp moveLeftRight,0
		je leftaa123
		cmp moveLeftRight,1
		je rightaa123
	
leftaa123:
		mov updownleftrightG,1
		call CheckValidMovementG
		cmp validupG,1
		je ghostmovement1
		mov updownleftrightG,4
		call CheckValidMovementG
		cmp validupG,1
		je ghostmovement1
		mov moveLeftRight,1
		jmp ghostmovement
rightaa123:
		mov updownleftrightG,3
		call CheckValidMovementG
		cmp validupG,1
		je ghostmovement1
		mov updownleftrightG,1
		call CheckValidMovementG
		cmp validupG,1
		je ghostmovement1
		mov moveLeftRight,0
		jmp ghostmovement

leftaa1234:
		mov updownleftrightG,2
		call CheckValidMovementG
		cmp validupG,1
		je ghostmovement1
		mov updownleftrightG,4
		call CheckValidMovementG
		cmp validupG,1
		je ghostmovement1
		mov moveLeftRight,1
		jmp ghostmovement
rightaa1234:
		mov updownleftrightG,3
		call CheckValidMovementG
		cmp validupG,1
		je ghostmovement1
		mov updownleftrightG,2
		call CheckValidMovementG
		cmp validupG,1
		je ghostmovement1
		mov moveLeftRight,0
		jmp ghostmovement

	;	mov eax,5
	;	inc eax
	;	call RandomRange
		ghostmovement1:
		cmp yPosG,19
		jne n1
		mov moveUpDown,0
		n1:
		cmp yPosG,43
		jne n2
		mov moveUpDown,1
		n2:
		;mov updownleftrightG,al
		call CheckValidMovementG
		cmp validupG,1
		jne ghostmovement
		call CheckPosition
		cmp updownleftrightG,2
		je ghostmoveup
		cmp updownleftrightG,1
		je ghostmovedown
		cmp updownleftrightG,4
		je ghostmoveleft
		cmp updownleftrightG,3
		je ghostmoveright
	
		ghostmoveup:
		;	cmp yPosG,18
		;	je ghostmovedown
			call UpdateGhost
			mov ghostDot,0
			dec yPosG
			call DrawGhost
			mov eax,speeddelayofghost
			call Delay
			jmp nexttttttt1
		ghostmovedown:
		;	cmp yPosG,44
		;	je ghostmoveup
			call UpdateGhost
			mov ghostDot,0
			inc yPosG
			call DrawGhost
			mov eax,speeddelayofghost
			call Delay
			jmp nexttttttt1
		ghostmoveleft:
		;	cmp xPosG,26
		;	je ghostmoveright
			call UpdateGhost
			mov ghostDot,0	
			dec xPosG
			call DrawGhost
			mov eax,speeddelayofghost
			call Delay
			jmp nexttttttt1
		ghostmoveright:
		;	cmp xPosG,143
		;	je ghostmoveleft
			call UpdateGhost
			mov ghostDot,0
			inc xPosG
			call DrawGhost
			mov eax,speeddelayofghost
			call Delay
			jmp nexttttttt1

		
		nexttttttt1:
		mov validupG,0
        mov eax,red (black * 16)
        call SetTextColor

		

        ; draw score:
        mov dl,25
        mov dh,16
        call Gotoxy
        mov edx,OFFSET strScore
        call WriteString
        mov eax,score
        call WriteDec

		; draw lives:
		mov dl,135
		mov dh,16
		call Gotoxy
		mov edx,OFFSET livesprint
		call WriteString
		mov eax,lives
		call WriteDec

      ;  ; gravity logic:
      ;  gravity:
      ;  cmp yPos,27
      ;  jg onGround
      ;  ; make player fall:
      ;  call UpdatePlayer
      ;  inc yPos
      ;  call DrawPlayer
      ;  mov eax,80
      ;  call Delay
      ;  jmp gravity
      ;  onGround:

        ; get user key input:
        call Readkey
        mov inputChar,al

        ; exit game if user types 'x':
        cmp inputChar,"x"
        je gameover

		cmp inputChar,"p"
		je pausemenucall

        cmp inputChar,"w"
        je moveUp

        cmp inputChar,"s"
        je moveDown

        cmp inputChar,"a"
        je moveLeft

        cmp inputChar,"d"
        je moveRight



		jmp gameLoop

        moveUp:
        cmp yPos,18
        je gameLoop
		mov updownleftright,2
		call CheckValidMovement
		cmp validup,1
		jne gameLoop
		mov validup,0
        ; allow player to jump:
        mov ecx,1
        jumpLoop:
            call UpdatePlayer
            dec yPos
            call DrawPlayer
            mov eax,70
            call Delay
        loop jumpLoop
        jmp gameLoop

        moveDown:
        cmp yPos,44
        je gameLoop
		mov updownleftright,1
		call CheckValidMovement
		cmp validup,1
		jne gameLoop
        call UpdatePlayer
        inc yPos
        call DrawPlayer
		mov validup,0
        jmp gameLoop

        moveLeft:
        cmp xPos,26
        je gameLoop
		mov updownleftright,4
		call CheckValidMovement
		cmp validup,1
		jne gameLoop
        call UpdatePlayer
        dec xPos
        call DrawPlayer
		mov validup,0
        jmp gameLoop

        moveRight:
        cmp xPos,143
		je gameLoop
		mov updownleftright,3
		call CheckValidMovement
		cmp validup,1
		jne gameLoop
        call UpdatePlayer
        inc xPos
        call DrawPlayer
		mov validup,0
        jmp gameLoop

	pausemenucall:
		call PauseMenu

    jmp gameLoop

gameover:
	call DrawPlayerDead

    exitGame:
		call clrscr
call filehandlingfunc
;		mov edx,OFFSET filename
;		call OpenInputFile
;		mov fileHandle,eax
;		mov edx,OFFSET buffer
;		mov ecx,BUFFER_SIZE
;		call ReadFromFile
;         push eax
;        mov eax, fileHandle
;		call CloseFile
;        mov edx,offset buffer
;		mov ecx,playernamelength
;		mov esi,OFFSET namePlayer
;		pop eax
;		L12345:
;          
;		mov bl,[esi]
;		mov buffer[eax],bl
;		inc eax
;		inc esi
;		loopw L12345
;		mov buffer[eax],' '
;		inc eax
;		mov buffer[eax],':'
;		inc eax
;		mov buffer[eax],' '
;		inc eax
;		mov edx,OFFSET filename
;		call createoutputfile
;		mov fileHandle,eax
;		mov ecx,lengthof buffer
;		mov eax,fileHandle		
;		mov edx,OFFSET buffer
;		call WriteToFile
;		close_file:
;		mov eax,fileHandle
;		call CloseFile
	    mov edx,OFFSET strScore
        call WriteString
        mov eax,score
        call Writedec
quit:
exit

ret
StartGame endp


filehandlingfunc PROC

 mov edx, OFFSET filename
    call OpenInputFile
    mov fileHandle, eax

    cmp eax, INVALID_HANDLE_VALUE; error opening file ?
    jne file_ok1

        mWrite <"Cannot open file", 0dh, 0ah>
        jmp quit1
    file_ok1:
    mov edx, OFFSET buffer
    mov ecx, BUFFER_SIZE
    call ReadFromFile
    jnc check_buffer_size
        mWrite "Error reading file. "
        call WriteWindowsMsg
        jmp close_file1
    check_buffer_size:
    mov sizeofbuffer, eax
    cmp eax, BUFFER_SIZE
    jb buf_size_ok1
    mWrite <"Error: Buffer too small for the file", 0dh, 0ah>
    jmp quit1
    buf_size_ok1:
    mov buffer[eax], 0
   
    call WriteDec
    call Crlf
    mov dl, 45
    mov dh, 17
    call GOTOXY
    mov edx, OFFSET buffer
   ; call WriteString
    call Crlf
    close_file1:
    mov eax, fileHandle
    call CloseFile

    quit1:


   mov edx, OFFSET filename
call CreateOutputFile
mov fileHandle, eax

cmp eax, INVALID_HANDLE_VALUE; error found ?
jne file_ok
    mov edx, OFFSET error
    call WriteString
    jmp quit

file_ok:

mov eax, OFFSET buffer

mov eax,fileHandle
mov edx, offset buffer
mov ecx, sizeofbuffer
call WriteToFile

mov ecx, eax
mov sizeofbuffer, ecx
mov stringLength, ecx
mov edi, offset buffer


;mov eax,0
;mov eax,score
;add eax, 0
; aaa
;or eax, 3030h
;mov[edi], ah
;inc edi
invoke  NumbToStr,score,ADDR bbff
push eax
push ecx
push esi
mov esi,offset bbff
mov ecx,lengthof bbff
l1111111:
     mov dl,[esi]
mov[edi], dl
inc edi
inc esi
loop l1111111
pop esi
pop ecx
pop eax
mov esi, offset space
mov dl, [esi]
mov[edi], dl
inc edi

mov eax,0
mov al,level
add eax, 0
aas
or eax, 303030h

mov[edi], al
inc edi
mov esi, offset space
mov dl, [esi]
mov[edi], dl
inc edi

mov esi,offset namePlayer
mov ecx,lengthof namePlayer
l1:
mov dl,[esi]
mov[edi], dl
inc edi
inc esi
loop l1
mov al,0ah
mov [edi],al
inc edi


mov eax, fileHandle
add sizeofbuffer, 27

mov edx, OFFSET buffer
;mov stringLength, sizeofarr
mov ecx, sizeofbuffer

call WriteToFile

mov edx, offset filename
mov eax, filehandle
call CloseFile


call Crlf

quit:
ret
filehandlingfunc ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                    Print PauseMenu                       ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PauseMenu PROC
pausem1:
	call clrscr
;Title Color
	mov eax , red + (gray * 64)
	call SetTextColor
;Title
	call Pacman
;Resume title
	call resumeGame
;Restart title
	call restartGame
;MainMenu title
	call mainmenu1
;highscores title
	call highscores
;Exit title
	call Exit1

	call readchar
	cmp al,"1"
	je p1
	cmp al,"2"
	je p2
	cmp al,"3"
	je p3
	cmp al,"4"
	je p4
	cmp al,"5"
	je p5

	jmp pausem1
p1:
	call clrscr
	call StartGame
	jmp retmmm3
p2:
	call clrscr
	call StartGame
	jmp retmmm3
p3:
	call clrscr
	call MainMenu
	jmp retmmm3
p4:
	call clrscr
	call highscoresmenu
	jmp pausem1
p5:
	call clrscr
	call Exit2
retmmm3:
	ret
PauseMenu ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                    Print GameOver                        ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GameOverDisplay proc
	mov eax, red + (gray * 64)
	call SetTextColor
	mov dl,55
	mov dh,16
	call Gotoxy
	mov edx, offset gameovera
	call writestring

	mov dl,55
	mov dh,17
	call Gotoxy
	mov edx, offset gameoverb
	call writestring

	mov dl,55
	mov dh,18
	call Gotoxy
	mov edx, offset gameoverc
	call writestring

	mov dl,55
	mov dh,19
	call Gotoxy
	mov edx, offset gameoverd
	call writestring
ret
GameOverDisplay endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                    Print ResumeGame                      ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

resumeGame proc
	mov eax, red + (gray * 64)
	call SetTextColor
	mov dl,37
	mov dh,16
	call Gotoxy
	mov edx, offset resumegamea
	call writestring

	mov dl,37
	mov dh,17
	call Gotoxy
	mov edx, offset resumegameb
	call writestring

	mov dl,37
	mov dh,18
	call Gotoxy
	mov edx, offset resumegamec
	call writestring

	mov dl,37
	mov dh,19
	call Gotoxy
	mov edx, offset resumegamed
	call writestring
ret
resumeGame endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                   Print RestartGame                      ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

restartGame proc
	mov eax, red + (gray * 64)
	call SetTextColor
	mov dl,37
	mov dh,21
	call Gotoxy
	mov edx, offset restartgamea
	call writestring

	mov dl,37
	mov dh,22
	call Gotoxy
	mov edx, offset restartgameb
	call writestring

	mov dl,37
	mov dh,23
	call Gotoxy
	mov edx, offset restartgamec
	call writestring

	mov dl,37
	mov dh,24
	call Gotoxy
	mov edx, offset restartgamed
	call writestring
ret
restartGame endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                    Print mainmenu                        ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mainmenu1 proc
	mov eax, red + (gray * 64)
	call SetTextColor
	mov dl,37
	mov dh,26
	call Gotoxy
	mov edx, offset mainmenua
	call writestring

	mov dl,37
	mov dh,27
	call Gotoxy
	mov edx, offset mainmenub
	call writestring

	mov dl,37
	mov dh,28
	call Gotoxy
	mov edx, offset mainmenuc
	call writestring

	mov dl,37
	mov dh,29
	call Gotoxy
	mov edx, offset mainmenud
	call writestring
ret
mainmenu1 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                    Print MainMenu                        ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MainMenu Proc
main1:
	call clrscr
;Title Color
    mov eax , red + (gray * 64)
    call SetTextColor
;Title
    call Pacman
;Start game title
    call StartGame1
;Levels title
    call Levels
;Instructions title
    call Instructions
;HighScores title
	call HighScores
;Exit title
    call Exit1

    call readchar
    cmp al,"1"
    je c1
    cmp al,"2"
    je c2
    cmp al,"3"
    je c3
    cmp al,"4"
    je c4
    cmp al,"5"
    je c5

    jmp main1

c1:
	call clrscr
    call startgame
c2:
	call clrscr
    call LevelMenu
    jmp main1
c3:
	call clrscr
    call InstructionMenu
    jmp main1
c4:
	call clrscr
	call HighScoresMenu
	jmp main1

c5:
	call clrscr
    call Exit2

    ret
MainMenu ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                    Print LevelMenu                       ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LevelMenu Proc
levelm1:
	call clrscr
;Title Color
	mov eax , red + (gray * 64)
	call SetTextColor
;Title
	call Pacman
;Level1 title
	call level1
;Level2 title
	call level2
;Level3 title
	call level3
;Return title
	call Return1
    
    call readchar
    cmp al,"1"
    je l1
    cmp al,"2"
    je l2
    cmp al,"3"
    je l3
    cmp al,"0"
    je e1

    jmp levelm1

l1:
	mov level,1
	mov DodgeScore,0
		mov xPos,83
		mov yPos,43
		mov xPosG,84
		mov yPosG,19
    jmp e1
l2:
	mov level,2
	mov DodgeScore,2355
		mov xPos,83
		mov yPos,43
		mov xPosG,84
		mov yPosG,19
		mov speeddelayofghost,40
    jmp e1
l3:
	mov level,3
	mov DodgeScore,8045
		mov xPos,83
		mov yPos,43
		mov xPosG,84
		mov yPosG,19
		mov speeddelayofghost,20
    jmp e1


    e1:
	ret
LevelMenu ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                    Print PacMan                          ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Pacman PROC
    mov eax, red + (gray * 64)
	call SetTextColor
    mov dl,39
    mov dh,1
    call Gotoxy
    mov edx, offset pacmana
    call writestring

    mov dl,39
    mov dh,2
    call Gotoxy
    mov edx, offset pacmanb
    call writestring

    mov dl,39
    mov dh,3
    call Gotoxy
    mov edx, offset pacmanc
    call writestring

    mov dl,45
    mov dh,3
    call Gotoxy
    mov edx, offset pacmanc1
    call writestring

    mov dl,121
    mov dh,3
    call Gotoxy
    mov edx, offset pacmanc2
    call writestring

    mov dl,39
    mov dh,4
    call Gotoxy
    mov edx, offset pacmand
    call writestring

    mov dl,39
    mov dh,5
    call Gotoxy
    mov edx, offset pacmane
    call writestring

    mov dl,39
    mov dh,6
    call Gotoxy
    mov edx, offset pacmanf
    call writestring

    mov dl,39
    mov dh,7
    call Gotoxy
    mov edx, offset pacmang
    call writestring

    mov dl,39
    mov dh,8
    call Gotoxy
    mov edx, offset pacmanh
    call writestring

    mov dl,39
    mov dh,9
    call Gotoxy
    mov edx, offset pacmani
    call writestring

    mov dl,39
    mov dh,10
    call Gotoxy
    mov edx, offset pacmanj
    call writestring

    mov dl,39
    mov dh,11
    call Gotoxy
    mov edx, offset pacmank
    call writestring

    mov dl,39
    mov dh,12
    call Gotoxy
    mov edx, offset pacmanl
    call writestring

    mov dl,39
    mov dh,13
    call Gotoxy
    mov edx, offset pacmanm
    call writestring

    mov dl,45
    mov dh,13
    call Gotoxy
    mov edx, offset pacmanm1
    call writestring

    mov eax, red + (gray * 64)
	call SetTextColor

    mov dl,121
    mov dh,13
    call Gotoxy
    mov edx, offset pacmanm2
    call writestring

    mov dl,39
    mov dh,14
    call Gotoxy
    mov edx, offset pacmann
    call writestring

    ret
Pacman ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                    Print StartGame                       ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

StartGame1 PROC
	mov eax, red + (gray * 64)
	call SetTextColor
	mov dl,37
	mov dh,16
	call Gotoxy
	mov edx, offset startgamea
	call writestring

	mov dl,37
	mov dh,17
	call Gotoxy
	mov edx, offset startgameb
	call writestring

	mov dl,37
	mov dh,18
	call Gotoxy
	mov edx, offset startgamec
	call writestring

	mov dl,37
	mov dh,19
	call Gotoxy
	mov edx, offset startgamed
	call writestring

	ret
StartGame1 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                    Print Levels                          ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Levels PROC
	mov eax, red + (gray * 64)
	call SetTextColor
	mov dl,37
	mov dh,21
	call Gotoxy
	mov edx, offset levelsa
	call writestring

	mov dl,37
	mov dh,22
	call Gotoxy
	mov edx, offset levelsb
	call writestring

	mov dl,37
	mov dh,23
	call Gotoxy
	mov edx, offset levelsc
	call writestring

	mov dl,37
	mov dh,24
	call Gotoxy
	mov edx, offset levelsd
	call writestring

	ret
Levels ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                    Print Level1                          ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

level1 PROC
	mov eax, red + (gray * 64)
	call SetTextColor
	mov dl,37
	mov dh,16
	call Gotoxy
	mov edx, offset level1a
	call writestring

	mov dl,37
	mov dh,17
	call Gotoxy
	mov edx, offset level1b
	call writestring

	mov dl,37
	mov dh,18
	call Gotoxy
	mov edx, offset level1c
	call writestring

	mov dl,37
	mov dh,19
	call Gotoxy
	mov edx, offset level1d
	call writestring

	ret
level1 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                    Print Level2                          ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

level2 PROC
	mov eax, red + (gray * 64)
	call SetTextColor
	mov dl,37
	mov dh,21
	call Gotoxy
	mov edx, offset level2a
	call writestring

	mov dl,37
	mov dh,22
	call Gotoxy
	mov edx, offset level2b
	call writestring

	mov dl,37
	mov dh,23
	call Gotoxy
	mov edx, offset level2c
	call writestring

	mov dl,37
	mov dh,24
	call Gotoxy
	mov edx, offset level2d
	call writestring

	ret
level2 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                    Print Level3                          ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

level3 PROC
	mov eax, red + (gray * 64)
	call SetTextColor
	mov dl,37
	mov dh,26
	call Gotoxy
	mov edx, offset level3a
	call writestring

	mov dl,37
	mov dh,27
	call Gotoxy
	mov edx, offset level3b
	call writestring

	mov dl,37
	mov dh,28
	call Gotoxy
	mov edx, offset level3c
	call writestring

	mov dl,37
	mov dh,29
	call Gotoxy
	mov edx, offset level3d
	call writestring

	ret
level3 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                    Print Return                          ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Return1 PROC
	mov eax, red + (gray * 64)
	call SetTextColor
	mov dl,37
	mov dh,31
	call Gotoxy
	mov edx, offset return1a
	call writestring

	mov dl,37
	mov dh,32
	call Gotoxy
	mov edx, offset return1b
	call writestring

	mov dl,37
	mov dh,33
	call Gotoxy
	mov edx, offset return1c
	call writestring

	mov dl,37
	mov dh,34
	call Gotoxy
	mov edx, offset return1d
	call writestring

	ret
Return1 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                    Print Instructions                    ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Instructions PROC
	mov eax, red + (gray * 64)
	call SetTextColor
	mov dl,37
	mov dh,26
	call Gotoxy
	mov edx, offset instructionsa
	call writestring

	mov dl,37
	mov dh,27
	call Gotoxy
	mov edx, offset instructionsb
	call writestring

	mov dl,37
	mov dh,28
	call Gotoxy
	mov edx, offset instructionsc
	call writestring

	mov dl,37
	mov dh,29
	call Gotoxy
	mov edx, offset instructionsd
	call writestring

	ret
Instructions ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                    Print Instructions1                    ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Instructions1 PROC
	mov eax, red + (gray * 64)
	call SetTextColor
	mov dl,49
	mov dh,16
	call Gotoxy
	mov edx, offset instructions1a
	call writestring

	mov dl,49
	mov dh,17
	call Gotoxy
	mov edx, offset instructions1b
	call writestring

	mov dl,49
	mov dh,18
	call Gotoxy
	mov edx, offset instructions1c
	call writestring

	mov dl,49
	mov dh,19
	call Gotoxy
	mov edx, offset instructions1d
	call writestring

	ret
Instructions1 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                 Print InstructionMenu                    ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

InstructionMenu proc
main1:
	call clrscr
;Title Color
	mov eax , red + (gray * 64)
	call SetTextColor
;Title
	call Pacman
;Instructions title
	call Instructions1

mov dl,39
mov dh,22
call Gotoxy
mov edx, offset ins1
call writestring
mov dl,39
mov dh,23
call Gotoxy
mov edx, offset ins2
call writestring
mov dl,39
mov dh,24
call Gotoxy
mov edx, offset ins3
call writestring
mov dl,39
mov dh,25
call Gotoxy
mov edx, offset ins4
call writestring
mov dl,39
mov dh,26
call Gotoxy
mov edx, offset ins5
call writestring
mov dl,39
mov dh,27
call Gotoxy
mov edx, offset ins6
call writestring
mov dl,39
mov dh,28
call Gotoxy
mov edx, offset ins7
call writestring
mov dl,39
mov dh,29
call Gotoxy
mov edx, offset ins8
call writestring
;Return title
	call Return1

call readchar
	cmp al,"0"
	je c1
	jmp main1

c1:
    ret
InstructionMenu endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                 Print HighScores                         ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

HighScores PROC
	mov eax, red + (gray * 64)
	call SetTextColor
	mov dl,37
	mov dh,31
	call Gotoxy
	mov edx, offset HighScoresa
	call writestring

	mov dl,37
	mov dh,32
	call Gotoxy
	mov edx, offset HighScoresb
	call writestring

	mov dl,37
	mov dh,33
	call Gotoxy
	mov edx, offset HighScoresc
	call writestring

	mov dl,37
	mov dh,34
	call Gotoxy
	mov edx, offset HighScoresd
	call writestring

	ret
HighScores ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                 Print HighScores1                        ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

HighScores1 PROC
	mov eax, red + (gray * 64)
	call SetTextColor
	mov dl,53
	mov dh,16
	call Gotoxy
	mov edx, offset HighScores1a
	call writestring

	mov dl,53
	mov dh,17
	call Gotoxy
	mov edx, offset HighScores1b
	call writestring

	mov dl,53
	mov dh,18
	call Gotoxy
	mov edx, offset HighScores1c
	call writestring

	mov dl,53
	mov dh,19
	call Gotoxy
	mov edx, offset HighScores1d
	call writestring

	ret
HighScores1 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                Print HighScoresMenu                      ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

HighScoresMenu proc
main1:
	call clrscr
;Title Color
	mov eax , red + (gray * 64)
	call SetTextColor
;Title
	call Pacman
;HighScores title
	call HighScores1
;filehandling
	mov dl,67
	mov dh,21
	call Gotoxy
	mov edx, offset highhhhh
	call writestring
call crlf
	call filehandling

;Return title
	call Return1

	call readchar
	cmp al,"0"
	je c1
	jmp main1

c1:
	ret
HighScoresMenu endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                    Print Exit                            ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Exit1 PROC
	mov eax, red + (gray * 64)
	call SetTextColor
	mov dl,37
	mov dh,36
	call Gotoxy
	mov edx, offset exita
	call writestring

	mov dl,37
	mov dh,37
	call Gotoxy
	mov edx, offset exitb
	call writestring

	mov dl,37
	mov dh,38
	call Gotoxy
	mov edx, offset exitc
	call writestring

	mov dl,37
	mov dh,39
	call Gotoxy
	mov edx, offset exitd
	call writestring

	ret
Exit1 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                       ExitGame                           ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Exit2 PROC
    Exit
	ret
Exit2 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                    Print GridLevel1                      ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GridLevel1 PROC
	mov eax, blue + (gray * 64)
	call SetTextColor
	mov dl,26
    mov dh,18
    call Gotoxy
    mov edx,OFFSET grid01maze01
	call WriteString
	mov dl,26
	mov dh,19
	call Gotoxy
	mov edx,OFFSET grid01maze02
	call WriteString
	mov dl,26
	mov dh,20
	call Gotoxy
	mov edx,OFFSET grid01maze03
	call WriteString
	mov dl,26
	mov dh,21
	call Gotoxy
	mov edx,OFFSET grid01maze04
	call WriteString
	mov dl,26
	mov dh,22
	call Gotoxy
	mov edx,OFFSET grid01maze05
	call WriteString
	mov dl,26
	mov dh,23
	call Gotoxy
	mov edx,OFFSET grid01maze06
	call WriteString
	mov dl,26
	mov dh,24
	call Gotoxy
	mov edx,OFFSET grid01maze07
	call WriteString
	mov dl,26
	mov dh,25
	call Gotoxy
	mov edx,OFFSET grid01maze08
	call WriteString
	mov dl,26
	mov dh,26
	call Gotoxy
	mov edx,OFFSET grid01maze09
	call WriteString
	mov dl,26
	mov dh,27
	call Gotoxy
	mov edx,OFFSET grid01maze10
	call WriteString
	mov dl,26
	mov dh,28
	call Gotoxy
	mov edx,OFFSET grid01maze11
	call WriteString
	mov dl,26
	mov dh,29
	call Gotoxy
	mov edx,OFFSET grid01maze12
	call WriteString
	mov dl,26
	mov dh,30
	call Gotoxy
	mov edx,OFFSET grid01maze13
	call WriteString
	mov dl,26
	mov dh,31
	call Gotoxy
	mov edx,OFFSET grid01maze14
	call WriteString
	mov dl,26
	mov dh,32
	call Gotoxy
	mov edx,OFFSET grid01maze15
	call WriteString
	mov dl,26
	mov dh,33
	call Gotoxy
	mov edx,OFFSET grid01maze16
	call WriteString
	mov dl,26
	mov dh,34
	call Gotoxy
	mov edx,OFFSET grid01maze17
	call WriteString
	mov dl,26
	mov dh,35
	call Gotoxy
	mov edx,OFFSET grid01maze18
	call WriteString
	mov dl,26
	mov dh,36
	call Gotoxy
	mov edx,OFFSET grid01maze19
	call WriteString
	mov dl,26
	mov dh,37
	call Gotoxy
	mov edx,OFFSET grid01maze20
	call WriteString
	mov dl,26
	mov dh,38
	call Gotoxy
	mov edx,OFFSET grid01maze21
	call WriteString
	mov dl,26
	mov dh,39
	call Gotoxy
	mov edx,OFFSET grid01maze22
	call WriteString
	mov dl,26
	mov dh,40
	call Gotoxy
	mov edx,OFFSET grid01maze23
	call WriteString
	mov dl,26
	mov dh,41
	call Gotoxy
	mov edx,OFFSET grid01maze24
	call WriteString
	mov dl,26
	mov dh,42
	call Gotoxy
	mov edx,OFFSET grid01maze25
	call WriteString
	mov dl,26
	mov dh,43
	call Gotoxy
	mov edx,OFFSET grid01maze26
	call WriteString
	mov dl,26
	mov dh,44
	call Gotoxy
	mov edx,OFFSET grid01maze27
	call WriteString
	ret
GridLevel1 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                    Print GridLevel2                      ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GridLevel2 PROC
	mov eax, blue + (gray * 64)
	call SetTextColor
	mov dl,26
    mov dh,18
    call Gotoxy
    mov edx,OFFSET grid02maze01
	call WriteString
	mov dl,26
	mov dh,19
	call Gotoxy
	mov edx,OFFSET grid02maze02
	call WriteString
	mov dl,26
	mov dh,20
	call Gotoxy
	mov edx,OFFSET grid02maze03
	call WriteString
	mov dl,26
	mov dh,21
	call Gotoxy
	mov edx,OFFSET grid02maze04
	call WriteString
	mov dl,26
	mov dh,22
	call Gotoxy
	mov edx,OFFSET grid02maze05
	call WriteString
	mov dl,26
	mov dh,23
	call Gotoxy
	mov edx,OFFSET grid02maze06
	call WriteString
	mov dl,26
	mov dh,24
	call Gotoxy
	mov edx,OFFSET grid02maze07
	call WriteString
	mov dl,26
	mov dh,25
	call Gotoxy
	mov edx,OFFSET grid02maze08
	call WriteString
	mov dl,26
	mov dh,26
	call Gotoxy
	mov edx,OFFSET grid02maze09
	call WriteString
	mov dl,26
	mov dh,27
	call Gotoxy
	mov edx,OFFSET grid02maze10
	call WriteString
	mov dl,26
	mov dh,28
	call Gotoxy
	mov edx,OFFSET grid02maze11
	call WriteString
	mov dl,26
	mov dh,29
	call Gotoxy
	mov edx,OFFSET grid02maze12
	call WriteString
	mov dl,26
	mov dh,30
	call Gotoxy
	mov edx,OFFSET grid02maze13
	call WriteString
	mov dl,26
	mov dh,31
	call Gotoxy
	mov edx,OFFSET grid02maze14
	call WriteString
	mov dl,26
	mov dh,32
	call Gotoxy
	mov edx,OFFSET grid02maze15
	call WriteString
	mov dl,26
	mov dh,33
	call Gotoxy
	mov edx,OFFSET grid02maze16
	call WriteString
	mov dl,26
	mov dh,34
	call Gotoxy
	mov edx,OFFSET grid02maze17
	call WriteString
	mov dl,26
	mov dh,35
	call Gotoxy
	mov edx,OFFSET grid02maze18
	call WriteString
	mov dl,26
	mov dh,36
	call Gotoxy
	mov edx,OFFSET grid02maze19
	call WriteString
	mov dl,26
	mov dh,37
	call Gotoxy
	mov edx,OFFSET grid02maze20
	call WriteString
	mov dl,26
	mov dh,38
	call Gotoxy
	mov edx,OFFSET grid02maze21
	call WriteString
	mov dl,26
	mov dh,39
	call Gotoxy
	mov edx,OFFSET grid02maze22
	call WriteString
	mov dl,26
	mov dh,40
	call Gotoxy
	mov edx,OFFSET grid02maze23
	call WriteString
	mov dl,26
	mov dh,41
	call Gotoxy
	mov edx,OFFSET grid02maze24
	call WriteString
	mov dl,26
	mov dh,42
	call Gotoxy
	mov edx,OFFSET grid02maze25
	call WriteString
	mov dl,26
	mov dh,43
	call Gotoxy
	mov edx,OFFSET grid02maze26
	call WriteString
	mov dl,26
	mov dh,44
	call Gotoxy
	mov edx,OFFSET grid02maze27
	call WriteString
	ret
GridLevel2 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                    Print GridLevel3                      ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GridLevel3 PROC
	mov eax, blue + (gray * 64)
	call SetTextColor
	mov dl,26
    mov dh,18
    call Gotoxy
    mov edx,OFFSET grid03maze01
	call WriteString
	mov dl,26
	mov dh,19
	call Gotoxy
	mov edx,OFFSET grid03maze02
	call WriteString
	mov dl,26
	mov dh,20
	call Gotoxy
	mov edx,OFFSET grid03maze03
	call WriteString
	mov dl,26
	mov dh,21
	call Gotoxy
	mov edx,OFFSET grid03maze04
	call WriteString
	mov dl,26
	mov dh,22
	call Gotoxy
	mov edx,OFFSET grid03maze05
	call WriteString
	mov dl,26
	mov dh,23
	call Gotoxy
	mov edx,OFFSET grid03maze06
	call WriteString
	mov dl,26
	mov dh,24
	call Gotoxy
	mov edx,OFFSET grid03maze07
	call WriteString
	mov dl,26
	mov dh,25
	call Gotoxy
	mov edx,OFFSET grid03maze08
	call WriteString
	mov dl,26
	mov dh,26
	call Gotoxy
	mov edx,OFFSET grid03maze09
	call WriteString
	mov dl,26
	mov dh,27
	call Gotoxy
	mov edx,OFFSET grid03maze10
	call WriteString
	mov dl,26
	mov dh,28
	call Gotoxy
	mov edx,OFFSET grid03maze11
	call WriteString
	mov dl,26
	mov dh,29
	call Gotoxy
	mov edx,OFFSET grid03maze12
	call WriteString
	mov dl,26
	mov dh,30
	call Gotoxy
	mov edx,OFFSET grid03maze13
	call WriteString
	mov dl,26
	mov dh,31
	call Gotoxy
	mov edx,OFFSET grid03maze14
	call WriteString
	mov dl,26
	mov dh,32
	call Gotoxy
	mov edx,OFFSET grid03maze15
	call WriteString
	mov dl,26
	mov dh,33
	call Gotoxy
	mov edx,OFFSET grid03maze16
	call WriteString
	mov dl,26
	mov dh,34
	call Gotoxy
	mov edx,OFFSET grid03maze17
	call WriteString
	mov dl,26
	mov dh,35
	call Gotoxy
	mov edx,OFFSET grid03maze18
	call WriteString
	mov dl,26
	mov dh,36
	call Gotoxy
	mov edx,OFFSET grid03maze19
	call WriteString
	mov dl,26
	mov dh,37
	call Gotoxy
	mov edx,OFFSET grid03maze20
	call WriteString
	mov dl,26
	mov dh,38
	call Gotoxy
	mov edx,OFFSET grid03maze21
	call WriteString
	mov dl,26
	mov dh,39
	call Gotoxy
	mov edx,OFFSET grid03maze22
	call WriteString
	mov dl,26
	mov dh,40
	call Gotoxy
	mov edx,OFFSET grid03maze23
	call WriteString
	mov dl,26
	mov dh,41
	call Gotoxy
	mov edx,OFFSET grid03maze24
	call WriteString
	mov dl,26
	mov dh,42
	call Gotoxy
	mov edx,OFFSET grid03maze25
	call WriteString
	mov dl,26
	mov dh,43
	call Gotoxy
	mov edx,OFFSET grid03maze26
	call WriteString
	mov dl,26
	mov dh,44
	call Gotoxy
	mov edx,OFFSET grid03maze27
	call WriteString
	ret
GridLevel3 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                   CheckValidMovement                     ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CheckValidMovement PROC
	pushad
	movzx eax,xPos
	sub eax,26
	mov ecx,eax
	movzx ebx,yPos
	cmp updownleftright,1
	je downaa
	cmp updownleftright,2
	je upaa
	cmp updownleftright,3
	je rightaa
	cmp updownleftright,4
	je leftaa
upaa:
	cmp ebx,44
	je checkgrid26
	cmp ebx,43
	je checkgrid25
	cmp ebx,42
	je checkgrid24
	cmp ebx,41
	je checkgrid23
	cmp ebx,40
	je checkgrid22
	cmp ebx,39
	je checkgrid21
	cmp ebx,38
	je checkgrid20
	cmp ebx,37
	je checkgrid19
	cmp ebx,36
	je checkgrid18
	cmp ebx,35
	je checkgrid17
	cmp ebx,34
	je checkgrid16
	cmp ebx,33
	je checkgrid15
	cmp ebx,32
	je checkgrid14
	cmp ebx,31
	je checkgrid13
	cmp ebx,30
	je checkgrid12
	cmp ebx,29
	je checkgrid11
	cmp ebx,28
	je checkgrid10
	cmp ebx,27
	je checkgrid9
	cmp ebx,26
	je checkgrid8
	cmp ebx,25
	je checkgrid7
	cmp ebx,24
	je checkgrid6
	cmp ebx,23
	je checkgrid5
	cmp ebx,22
	je checkgrid4
	cmp ebx,21
	je checkgrid3
	cmp ebx,20
	je checkgrid2
	jmp return11a
downaa:
	cmp ebx,19
	je checkgrid3
	cmp ebx,20
	je checkgrid4
	cmp ebx,21
	je checkgrid5
	cmp ebx,22
	je checkgrid6
	cmp ebx,23
	je checkgrid7
	cmp ebx,24
	je checkgrid8
	cmp ebx,25
	je checkgrid9
	cmp ebx,26
	je checkgrid10
	cmp ebx,27
	je checkgrid11
	cmp ebx,28
	je checkgrid12
	cmp ebx,29
	je checkgrid13
	cmp ebx,30
	je checkgrid14
	cmp ebx,31
	je checkgrid15
	cmp ebx,32
	je checkgrid16
	cmp ebx,33
	je checkgrid17
	cmp ebx,34
	je checkgrid18
	cmp ebx,35
	je checkgrid19
	cmp ebx,36
	je checkgrid20
	cmp ebx,37
	je checkgrid21
	cmp ebx,38
	je checkgrid22
	cmp ebx,39
	je checkgrid23
	cmp ebx,40
	je checkgrid24
	cmp ebx,41
	je checkgrid25
	cmp ebx,42
	je checkgrid26
	jmp return11a
rightaa:
	cmp ecx,119
	jge return11a
	add eax,1
	cmp ebx,43
	je checkgrid26
	cmp ebx,42
	je checkgrid25
	cmp ebx,41
	je checkgrid24
	cmp ebx,40
	je checkgrid23
	cmp ebx,39
	je checkgrid22
	cmp ebx,38
	je checkgrid21
	cmp ebx,37
	je checkgrid20
	cmp ebx,36
	je checkgrid19
	cmp ebx,35
	je checkgrid18
	cmp ebx,34
	je checkgrid17
	cmp ebx,33
	je checkgrid16
	cmp ebx,32
	je checkgrid15
	cmp ebx,31
	je checkgrid14
	cmp ebx,30
	je checkgrid13
	cmp ebx,29
	je checkgrid12
	cmp ebx,28
	je checkgrid11
	cmp ebx,27
	je checkgrid10
	cmp ebx,26
	je checkgrid9
	cmp ebx,25
	je checkgrid8
	cmp ebx,24
	je checkgrid7
	cmp ebx,23
	je checkgrid6
	cmp ebx,22
	je checkgrid5
	cmp ebx,21
	je checkgrid4
	cmp ebx,20
	je checkgrid3
	cmp ebx,19
	je checkgrid2
	jmp return11a
leftaa:
	cmp ecx,0
	jle return11a
	sub eax,1
	cmp ebx,43
	je checkgrid26
	cmp ebx,42
	je checkgrid25
	cmp ebx,41
	je checkgrid24
	cmp ebx,40
	je checkgrid23
	cmp ebx,39
	je checkgrid22
	cmp ebx,38
	je checkgrid21
	cmp ebx,37
	je checkgrid20
	cmp ebx,36
	je checkgrid19
	cmp ebx,35
	je checkgrid18
	cmp ebx,34
	je checkgrid17
	cmp ebx,33
	je checkgrid16
	cmp ebx,32
	je checkgrid15
	cmp ebx,31
	je checkgrid14
	cmp ebx,30
	je checkgrid13
	cmp ebx,29
	je checkgrid12
	cmp ebx,28
	je checkgrid11
	cmp ebx,27
	je checkgrid10
	cmp ebx,26
	je checkgrid9
	cmp ebx,25
	je checkgrid8
	cmp ebx,24
	je checkgrid7
	cmp ebx,23
	je checkgrid6
	cmp ebx,22
	je checkgrid5
	cmp ebx,21
	je checkgrid4
	cmp ebx,20
	je checkgrid3
	cmp ebx,19
	je checkgrid2
	jmp return11a
checkgrid26:
	cmp level,1
	jne l2checkgrid26
	cmp	grid01maze26[eax],' '
	je validUpOn
	cmp	grid01maze26[eax],'.'
	jne return11a
	mov grid01maze26[eax],' '
	add score,5
	add DodgeScore,5
	jmp validupon
	l2checkgrid26:
		cmp level,2
		jne l3checkgrid26		
		cmp	grid02maze26[eax],' '
		je validUpOn
		cmp	grid02maze26[eax],'.'
		jne return11a
		mov grid02maze26[eax],' '
		add score,10
		add DodgeScore,10
		jmp validupon
		l3checkgrid26:
			cmp	grid03maze26[eax],' '
			je validUpOn
			cmp	grid03maze26[eax],'.'
			jne return11a
			mov grid03maze26[eax],' '
			add score,15
			add DodgeScore,15
			jmp validupon
checkgrid25:
    cmp level,1
	jne l2checkgrid25
	cmp	grid01maze25[eax],' '
	je validUpOn
	cmp	grid01maze25[eax],'.'
	jne return11a
	mov grid01maze25[eax],' '
	add score,5
	add DodgeScore,5
	jmp validupon
	l2checkgrid25:
		cmp level,2
		jne l3checkgrid25
		cmp	grid02maze25[eax],' '
		je validUpOn
		cmp	grid02maze25[eax],'.'
		jne return11a
		mov grid02maze25[eax],' '
		add score,10
		add DodgeScore,10
		jmp validupon
		l3checkgrid25:
			cmp	grid03maze25[eax],' '
			je validUpOn
			cmp	grid03maze25[eax],'.'
			jne return11a
			mov grid03maze25[eax],' '
			add score,15
			add DodgeScore,15
			jmp validupon
checkgrid24:
    cmp level,1
	jne l2checkgrid24
	cmp	grid01maze24[eax],' '
	je validUpOn
	cmp	grid01maze24[eax],'.'
	jne return11a
	mov grid01maze24[eax],' '
	add score,5
	add DodgeScore,5
	jmp validupon
	l2checkgrid24:
		cmp	level,2
		jne l3checkgrid24
		cmp	grid02maze24[eax],' '
		je validUpOn
		cmp	grid02maze24[eax],'.'
		jne return11a
		mov grid02maze24[eax],' '
		add score,10
		add DodgeScore,10
		jmp validupon
		l3checkgrid24:
			cmp	grid03maze24[eax],' '
			je validUpOn
			cmp	grid03maze24[eax],'.'
			jne return11a
			mov grid03maze24[eax],' '
			add score,15
			add DodgeScore,15
			jmp validupon
checkgrid23:
	cmp level,1
	jne l2checkgrid23
	cmp	grid01maze23[eax],' '
	je validUpOn
	cmp	grid01maze23[eax],'.'
	jne return11a
	mov grid01maze23[eax],' '
	add score,5
	add DodgeScore,5
	jmp validupon
	l2checkgrid23:
		cmp	level,2
		jne l3checkgrid23
		cmp	grid02maze23[eax],' '
		je validUpOn
		cmp	grid02maze23[eax],'.'
		jne return11a
		mov grid02maze23[eax],' '
		add score,10
		add DodgeScore,10
		jmp validupon
		l3checkgrid23:
			cmp	grid03maze23[eax],' '
			je validUpOn
			cmp	grid03maze23[eax],'.'
			jne return11a
			mov grid03maze23[eax],' '
			add score,15
			add DodgeScore,15
			jmp validupon
checkgrid22:
	cmp level,1
	jne l2checkgrid22
	cmp	grid01maze22[eax],' '
	je validUpOn
	cmp	grid01maze22[eax],'.'
	jne return11a
	mov grid01maze22[eax],' '
	add score,5
	add DodgeScore,5
	jmp validupon
	l2checkgrid22:
		cmp	level,2
		jne l3checkgrid22
		cmp	grid02maze22[eax],' '
		je validUpOn
		cmp	grid02maze22[eax],'.'
		jne return11a
		mov grid02maze22[eax],' '
		add score,10
		add DodgeScore,10
		jmp validupon
		l3checkgrid22:
			cmp	grid03maze22[eax],' '
			je validUpOn
			cmp	grid03maze22[eax],'.'
			jne return11a
			mov grid03maze22[eax],' '
			add score,15
			add DodgeScore,15
			jmp validupon
checkgrid21:
	cmp level,1
	jne l2checkgrid21
	cmp	grid01maze21[eax],' '
	je validUpOn
	cmp	grid01maze21[eax],'.'
	jne return11a
	mov grid01maze21[eax],' '
	add score,5
	add DodgeScore,5
	jmp validupon
	l2checkgrid21:
		cmp	level,2
		jne l3checkgrid21
		cmp	grid02maze21[eax],' '
		je validUpOn
		cmp	grid02maze21[eax],'.'
		jne return11a
		mov grid02maze21[eax],' '
		add score,10
		add DodgeScore,10
		jmp validupon
		l3checkgrid21:
			cmp	grid03maze21[eax],' '
			je validUpOn
			cmp	grid03maze21[eax],'.'
			jne return11a
			mov grid03maze21[eax],' '
			add score,15
			add DodgeScore,15
			jmp validupon
checkgrid20:
    cmp level,1
	jne l2checkgrid20
	cmp	grid01maze20[eax],' '
	je validUpOn
	cmp	grid01maze20[eax],'.'
	jne return11a
	mov grid01maze20[eax],' '
	add score,5
	add DodgeScore,5
	jmp validupon
	l2checkgrid20:
		cmp	level,2
		jne l3checkgrid20
		cmp	grid02maze20[eax],' '
		je validUpOn
		cmp	grid02maze20[eax],'.'
		jne return11a
		mov grid02maze20[eax],' '
		add score,10
		add DodgeScore,10
		jmp validupon
		l3checkgrid20:
			cmp	grid03maze20[eax],' '
			je validUpOn
			cmp	grid03maze20[eax],'.'
			jne return11a
			mov grid03maze20[eax],' '
			add score,15
			add DodgeScore,15
			jmp validupon
checkgrid19:
	cmp level,1
	jne l2checkgrid19
	cmp	grid01maze19[eax],' '
	je validUpOn
	cmp	grid01maze19[eax],'.'
	jne return11a
	mov grid01maze19[eax],' '
	add score,5
	add DodgeScore,5
	jmp validupon
	l2checkgrid19:
		cmp level,2
		jne l3checkgrid19
		cmp	grid02maze19[eax],' '
		je validUpOn
		cmp	grid02maze19[eax],'.'
		jne return11a
		mov grid02maze19[eax],' '
		add score,10
		add DodgeScore,10
		jmp validupon
		l3checkgrid19:
			cmp	grid03maze19[eax],' '
			je validUpOn
			cmp	grid03maze19[eax],'.'
			jne return11a
			mov grid03maze19[eax],' '
			add score,15
			add DodgeScore,15
			jmp validupon
checkgrid18:
	cmp level,1
	jne l2checkgrid18
	cmp	grid01maze18[eax],' '
	je validUpOn
	cmp	grid01maze18[eax],'.'
	jne return11a
	mov grid01maze18[eax],' '
	add score,5
	add DodgeScore,5
	jmp validupon
	l2checkgrid18:
	cmp level,2
	jne l3checkgrid18
		cmp	grid02maze18[eax],' '
		je validUpOn
		cmp	grid02maze18[eax],'.'
		jne return11a
		mov grid02maze18[eax],' '
		add score,10
		add DodgeScore,10
		jmp validupon
		l3checkgrid18:
			cmp	grid03maze18[eax],' '
			je validUpOn
			cmp	grid03maze18[eax],'.'
			jne return11a
			mov grid03maze18[eax],' '
			add score,15
			add DodgeScore,15
			jmp validupon
checkgrid17:
	cmp level,1
	jne l2checkgrid17
	cmp	grid01maze17[eax],' '
	je validUpOn
	cmp	grid01maze17[eax],'.'
	jne return11a
	mov grid01maze17[eax],' '
	add score,5
	add DodgeScore,5
	jmp validupon
	l2checkgrid17:
		cmp	level,2
		jne l3checkgrid17
		cmp	grid02maze17[eax],' '
		je validUpOn
		cmp	grid02maze17[eax],'.'
		jne return11a
		mov grid02maze17[eax],' '
		add score,10
		add DodgeScore,10
		jmp validupon
		l3checkgrid17:
			cmp	grid03maze17[eax],' '
			je validUpOn
			cmp	grid03maze17[eax],'.'
			jne return11a
			mov grid03maze17[eax],' '
			add score,15
			add DodgeScore,15
			jmp validupon
checkgrid16:
	cmp level,1
	jne l2checkgrid16
	cmp	grid01maze16[eax],' '
	je validUpOn
	cmp	grid01maze16[eax],'.'
	jne return11a
	mov grid01maze16[eax],' '
	add score,5
	add DodgeScore,5
	jmp validupon
	l2checkgrid16:
		cmp	level,2
		jne l3checkgrid16
		cmp	grid02maze16[eax],' '
		je validUpOn
		cmp	grid02maze16[eax],'.'
		jne return11a
		mov grid02maze16[eax],' '
		add score,10
		add DodgeScore,10
		jmp validupon
		l3checkgrid16:
			cmp	grid03maze16[eax],' '
			je validUpOn
			cmp	grid03maze16[eax],'.'
			jne return11a
			mov grid03maze16[eax],' '
			add score,15
			add DodgeScore,15
			jmp validupon
checkgrid15:
	cmp level,1
	jne l2checkgrid15
	cmp	grid01maze15[eax],' '
	je validUpOn
	cmp	grid01maze15[eax],'.'
	jne return11a
	mov grid01maze15[eax],' '
	add score,5
	add DodgeScore,5
	jmp validupon
	l2checkgrid15:
		cmp	level,2
		jne l3checkgrid15
		cmp	grid02maze15[eax],' '
		je validUpOn
		cmp	grid02maze15[eax],'.'
		jne return11a
		mov grid02maze15[eax],' '
		add score,10
		add DodgeScore,10
		jmp validupon
		l3checkgrid15:
			cmp	grid03maze15[eax],' '
			je validUpOn
			cmp	grid03maze15[eax],'.'
			jne return11a
			mov grid03maze15[eax],' '
			add score,15
			add DodgeScore,15
			jmp validupon
checkgrid14:
	cmp level,1
	jne l2checkgrid14
	cmp	grid01maze14[eax],' '
	je validUpOn
	cmp	grid01maze14[eax],'.'
	jne return11a
	mov grid01maze14[eax],' '
	add score,5
	add DodgeScore,5
	jmp validupon
	l2checkgrid14:
		cmp	level,2
		jne l3checkgrid14
		cmp	grid02maze14[eax],' '
		je validUpOn
		cmp	grid02maze14[eax],'.'
		jne return11a
		mov grid02maze14[eax],' '
		add score,10
		add DodgeScore,10
		jmp validupon
		l3checkgrid14:
			cmp	grid03maze14[eax],' '
			je validUpOn
			cmp	grid03maze14[eax],'.'
			jne return11a
			mov grid03maze14[eax],' '
			add score,15
			add DodgeScore,15
			jmp validupon
checkgrid13:
	cmp level,1
	jne l2checkgrid13
	cmp	grid01maze13[eax],' '
	je validUpOn
	cmp	grid01maze13[eax],'.'
	jne return11a
	mov grid01maze13[eax],' '
	add score,5
	add DodgeScore,5
	jmp validupon
	l2checkgrid13:
		cmp	level,2
		jne l3checkgrid13
		cmp	grid02maze13[eax],' '
		je validUpOn
		cmp	grid02maze13[eax],'.'
		jne return11a
		mov grid02maze13[eax],' '
		add score,10
		add DodgeScore,10
		jmp validupon
		l3checkgrid13:
			cmp	grid03maze13[eax],' '
			je validUpOn
			cmp	grid03maze13[eax],'.'
			jne return11a
			mov grid03maze13[eax],' '
			add score,15
			add DodgeScore,15
			jmp validupon
checkgrid12:
	cmp level,1
	jne l2checkgrid12
	cmp	grid01maze12[eax],' '
	je validUpOn
	cmp	grid01maze12[eax],'.'
	jne return11a
	mov grid01maze12[eax],' '
	add score,5
	add DodgeScore,5
	jmp validupon
	l2checkgrid12:
		cmp	level,2
		jne l3checkgrid12
		cmp	grid02maze12[eax],' '
		je validUpOn
		cmp	grid02maze12[eax],'.'
		jne return11a
		mov grid02maze12[eax],' '
		add score,10
		add DodgeScore,10
		jmp validupon
		l3checkgrid12:
			cmp	grid03maze12[eax],' '
			je validUpOn
			cmp	grid03maze12[eax],'.'
			jne return11a
			mov grid03maze12[eax],' '
			add score,15
			add DodgeScore,15
			jmp validupon
checkgrid11:
	cmp level,1
	jne l2checkgrid11
	cmp	grid01maze11[eax],' '
	je validUpOn
	cmp	grid01maze11[eax],'.'
	jne return11a
	mov grid01maze11[eax],' '
	add score,5
	add DodgeScore,5
	jmp validupon
	l2checkgrid11:
		cmp	level,2
		jne l3checkgrid11
		cmp	grid02maze11[eax],' '
		je validUpOn
		cmp	grid02maze11[eax],'.'
		jne return11a
		mov grid02maze11[eax],' '
		add score,10
		add DodgeScore,10
		jmp validupon
		l3checkgrid11:
			cmp	grid03maze11[eax],' '
			je validUpOn
			cmp	grid03maze11[eax],'.'
			jne return11a
			mov grid03maze11[eax],' '
			add score,15
			add DodgeScore,15
			jmp validupon
checkgrid10:
	cmp level,1
	jne l2checkgrid10
	cmp	grid01maze10[eax],' '
	je validUpOn
	cmp	grid01maze10[eax],'.'
	jne return11a
	mov grid01maze10[eax],' '
	add score,5
	add DodgeScore,5
	jmp validupon
	l2checkgrid10:
		cmp	level,2
		jne l3checkgrid10
		cmp	grid02maze10[eax],' '
		je validUpOn
		cmp	grid02maze10[eax],'.'
		jne return11a
		mov grid02maze10[eax],' '
		add score,10
		add DodgeScore,10
		jmp validupon
		l3checkgrid10:
			cmp	grid03maze10[eax],' '
			je validUpOn
			cmp	grid03maze10[eax],'.'
			jne return11a
			mov grid03maze10[eax],' '
			add score,15
			add DodgeScore,15
			jmp validupon
checkgrid9:
	cmp level,1
	jne l2checkgrid9
	cmp	grid01maze09[eax],' '
	je validUpOn
	cmp	grid01maze09[eax],'.'
	jne return11a
	mov grid01maze09[eax],' '
	add score,5
	add DodgeScore,5
	jmp validupon
	l2checkgrid9:
		cmp	level,2
		jne l3checkgrid9
		cmp	grid02maze09[eax],' '
		je validUpOn
		cmp	grid02maze09[eax],'.'
		jne return11a
		mov grid02maze09[eax],' '
		add score,10
		add DodgeScore,10
		jmp validupon
		l3checkgrid9:
			cmp	grid03maze09[eax],' '
			je validUpOn
			cmp	grid03maze09[eax],'.'
			jne return11a
			mov grid03maze09[eax],' '
			add score,15
			add DodgeScore,15
			jmp validupon
checkgrid8:
	cmp level,1
	jne l2checkgrid8
	cmp	grid01maze08[eax],' '
	je validUpOn
	cmp	grid01maze08[eax],'.'
	jne return11a
	mov grid01maze08[eax],' '
	add score,5
	add DodgeScore,5
	jmp validupon
	l2checkgrid8:
		cmp	level,2
		jne l3checkgrid8
		cmp	grid02maze08[eax],' '
		je validUpOn
		cmp	grid02maze08[eax],'.'
		jne return11a
		mov grid02maze08[eax],' '
		add score,10
		add DodgeScore,10
		jmp validupon
		l3checkgrid8:
			cmp	grid03maze08[eax],' '
			je validUpOn
			cmp	grid03maze08[eax],'.'
			jne return11a
			mov grid03maze08[eax],' '
			add score,15
			add DodgeScore,15
			jmp validupon
checkgrid7:
	cmp level,1
	jne l2checkgrid7
	cmp	grid01maze07[eax],' '
	je validUpOn
	cmp	grid01maze07[eax],'.'
	jne return11a
	mov grid01maze07[eax],' '
	add score,5
	add DodgeScore,5
	jmp validupon
	l2checkgrid7:
		cmp	level,2
		jne l3checkgrid7
		cmp	grid02maze07[eax],' '
		je validUpOn
		cmp	grid02maze07[eax],'.'
		jne return11a
		mov grid02maze07[eax],' '
		add score,10
		add DodgeScore,10
		jmp validupon
		l3checkgrid7:
			cmp	grid03maze07[eax],' '
			je validUpOn
			cmp	grid03maze07[eax],'.'
			jne return11a
			mov grid03maze07[eax],' '
			add score,15
			add DodgeScore,15
			jmp validupon
checkgrid6:
	cmp level,1
	jne l2checkgrid6
	cmp	grid01maze06[eax],' '
	je validUpOn
	cmp	grid01maze06[eax],'.'
	jne return11a
	mov grid01maze06[eax],' '
	add score,5
	add DodgeScore,5
	jmp validupon
	l2checkgrid6:
		cmp	level,2
		jne l3checkgrid6
		cmp	grid02maze06[eax],' '
		je validUpOn
		cmp	grid02maze06[eax],'.'
		jne return11a
		mov grid02maze06[eax],' '
		add score,10
		add DodgeScore,10
		jmp validupon
		l3checkgrid6:
			cmp	grid03maze06[eax],' '
			je validUpOn
			cmp	grid03maze06[eax],'.'
			jne return11a
			mov grid03maze06[eax],' '
			add score,15
			add DodgeScore,15
			jmp validupon
checkgrid5:
	cmp level,1
	jne l2checkgrid5
	cmp	grid01maze05[eax],' '
	je validUpOn
	cmp	grid01maze05[eax],'.'
	jne return11a
	mov grid01maze05[eax],' '
	add score,5
	add DodgeScore,5
	jmp validupon
	l2checkgrid5:
		cmp	level,2
		jne l3checkgrid5
		cmp	grid02maze05[eax],' '
		je validUpOn
		cmp	grid02maze05[eax],'.'
		jne return11a
		mov grid02maze05[eax],' '
		add score,10
		add DodgeScore,10
		jmp validupon
		l3checkgrid5:
			cmp	grid03maze05[eax],' '
			je validUpOn
			cmp	grid03maze05[eax],'.'
			jne return11a
			mov grid03maze05[eax],' '
			add score,15
			add DodgeScore,15
			jmp validupon
checkgrid4:
	cmp level,1
	jne l2checkgrid4
	cmp	grid01maze04[eax],' '
	je validUpOn
	cmp	grid01maze04[eax],'.'
	jne return11a
	mov grid01maze04[eax],' '
	add score,5
	add DodgeScore,5
	jmp validupon
	l2checkgrid4:
		cmp	level,2
		jne l3checkgrid4
		cmp	grid02maze04[eax],' '
		je validUpOn
		cmp	grid02maze04[eax],'.'
		jne return11a
		mov grid02maze04[eax],' '
		add score,10
		add DodgeScore,10
		jmp validupon
		l3checkgrid4:
			cmp	grid03maze04[eax],' '
			je validUpOn
			cmp	grid03maze04[eax],'.'
			jne return11a
			mov grid03maze04[eax],' '
			add score,15
			add DodgeScore,15
			jmp validupon
checkgrid3:
	cmp level,1
	jne l2checkgrid3
	cmp	grid01maze03[eax],' '
	je validUpOn
	cmp	grid01maze03[eax],'.'
	jne return11a
	mov grid01maze03[eax],' '
	add score,5
	add DodgeScore,5
	jmp validupon
	l2checkgrid3:
		cmp	level,2
		jne l3checkgrid3
		cmp	grid02maze03[eax],' '
		je validUpOn
		cmp	grid02maze03[eax],'.'
		jne return11a
		mov grid02maze03[eax],' '
		add score,10
		add DodgeScore,10
		jmp validupon
		l3checkgrid3:
			cmp	grid03maze03[eax],' '
			je validUpOn
			cmp	grid03maze03[eax],'.'
			jne return11a
			mov grid03maze03[eax],' '
			add score,15
			add DodgeScore,15
			jmp validupon
checkgrid2:
	cmp level,1
	jne l2checkgrid2
	cmp	grid01maze02[eax],' '
	je validUpOn
	cmp	grid01maze02[eax],'.'
	jne return11a
	mov grid01maze02[eax],' '
	add score,5
	add DodgeScore,5
	jmp validupon
	l2checkgrid2:
		cmp	level,2
		jne l3checkgrid2
		cmp	grid02maze02[eax],' '
		je validUpOn
		cmp	grid02maze02[eax],'.'
		jne return11a
		mov grid02maze02[eax],' '
		add score,10
		add DodgeScore,10
		jmp validupon
		l3checkgrid2:
			cmp	grid03maze02[eax],' '
			je validUpOn
			cmp	grid03maze02[eax],'.'
			jne return11a
			mov grid03maze02[eax],' '
			add score,15
			add DodgeScore,15
			jmp validupon
validupon:
	mov validup,1
	jmp return11a
return11a:
	popad
	ret
CheckValidMovement ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                          ;;
;;                   CheckValidMovementG                     ;;
;;                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CheckValidMovementG PROC
	pushad
	movzx eax,xPosG
	sub eax,26
	mov ecx,eax
	movzx ebx,yPosG
	cmp updownleftrightG,1
	je downaaG
	cmp updownleftrightG,2
	je upaaG
	cmp updownleftrightG,3
	je rightaaG
	cmp updownleftrightG,4
	je leftaaG
upaaG:
	cmp ebx,44
	je checkgrid26
	cmp ebx,43
	je checkgrid25
	cmp ebx,42
	je checkgrid24
	cmp ebx,41
	je checkgrid23
	cmp ebx,40
	je checkgrid22
	cmp ebx,39
	je checkgrid21
	cmp ebx,38
	je checkgrid20
	cmp ebx,37
	je checkgrid19
	cmp ebx,36
	je checkgrid18
	cmp ebx,35
	je checkgrid17
	cmp ebx,34
	je checkgrid16
	cmp ebx,33
	je checkgrid15
	cmp ebx,32
	je checkgrid14
	cmp ebx,31
	je checkgrid13
	cmp ebx,30
	je checkgrid12
	cmp ebx,29
	je checkgrid11
	cmp ebx,28
	je checkgrid10
	cmp ebx,27
	je checkgrid9
	cmp ebx,26
	je checkgrid8
	cmp ebx,25
	je checkgrid7
	cmp ebx,24
	je checkgrid6
	cmp ebx,23
	je checkgrid5
	cmp ebx,22
	je checkgrid4
	cmp ebx,21
	je checkgrid3
	cmp ebx,20
	je checkgrid2
	jmp return12a
downaaG:
	cmp ebx,19
	je checkgrid3
	cmp ebx,20
	je checkgrid4
	cmp ebx,21
	je checkgrid5
	cmp ebx,22
	je checkgrid6
	cmp ebx,23
	je checkgrid7
	cmp ebx,24
	je checkgrid8
	cmp ebx,25
	je checkgrid9
	cmp ebx,26
	je checkgrid10
	cmp ebx,27
	je checkgrid11
	cmp ebx,28
	je checkgrid12
	cmp ebx,29
	je checkgrid13
	cmp ebx,30
	je checkgrid14
	cmp ebx,31
	je checkgrid15
	cmp ebx,32
	je checkgrid16
	cmp ebx,33
	je checkgrid17
	cmp ebx,34
	je checkgrid18
	cmp ebx,35
	je checkgrid19
	cmp ebx,36
	je checkgrid20
	cmp ebx,37
	je checkgrid21
	cmp ebx,38
	je checkgrid22
	cmp ebx,39
	je checkgrid23
	cmp ebx,40
	je checkgrid24
	cmp ebx,41
	je checkgrid25
	cmp ebx,42
	je checkgrid26
	jmp return12a
rightaaG:
	cmp ecx,119
	jge return12a
	add eax,1
	cmp ebx,43
	je checkgrid26
	cmp ebx,42
	je checkgrid25
	cmp ebx,41
	je checkgrid24
	cmp ebx,40
	je checkgrid23
	cmp ebx,39
	je checkgrid22
	cmp ebx,38
	je checkgrid21
	cmp ebx,37
	je checkgrid20
	cmp ebx,36
	je checkgrid19
	cmp ebx,35
	je checkgrid18
	cmp ebx,34
	je checkgrid17
	cmp ebx,33
	je checkgrid16
	cmp ebx,32
	je checkgrid15
	cmp ebx,31
	je checkgrid14
	cmp ebx,30
	je checkgrid13
	cmp ebx,29
	je checkgrid12
	cmp ebx,28
	je checkgrid11
	cmp ebx,27
	je checkgrid10
	cmp ebx,26
	je checkgrid9
	cmp ebx,25
	je checkgrid8
	cmp ebx,24
	je checkgrid7
	cmp ebx,23
	je checkgrid6
	cmp ebx,22
	je checkgrid5
	cmp ebx,21
	je checkgrid4
	cmp ebx,20
	je checkgrid3
	cmp ebx,19
	je checkgrid2
	jmp return12a
leftaaG:
	cmp ecx,0
	jle return12a
	sub eax,1
	cmp ebx,43
	je checkgrid26
	cmp ebx,42
	je checkgrid25
	cmp ebx,41
	je checkgrid24
	cmp ebx,40
	je checkgrid23
	cmp ebx,39
	je checkgrid22
	cmp ebx,38
	je checkgrid21
	cmp ebx,37
	je checkgrid20
	cmp ebx,36
	je checkgrid19
	cmp ebx,35
	je checkgrid18
	cmp ebx,34
	je checkgrid17
	cmp ebx,33
	je checkgrid16
	cmp ebx,32
	je checkgrid15
	cmp ebx,31
	je checkgrid14
	cmp ebx,30
	je checkgrid13
	cmp ebx,29
	je checkgrid12
	cmp ebx,28
	je checkgrid11
	cmp ebx,27
	je checkgrid10
	cmp ebx,26
	je checkgrid9
	cmp ebx,25
	je checkgrid8
	cmp ebx,24
	je checkgrid7
	cmp ebx,23
	je checkgrid6
	cmp ebx,22
	je checkgrid5
	cmp ebx,21
	je checkgrid4
	cmp ebx,20
	je checkgrid3
	cmp ebx,19
	je checkgrid2
	jmp return12a
checkgrid26:
	cmp level,1
	jne l2checkgrid26
	cmp	grid01maze26[eax],' '
	je validuponG
	cmp	grid01maze26[eax],'.'
	jne return12a
	
	
	jmp validuponG
	l2checkgrid26:
		cmp level,2
		jne l3checkgrid26		
		cmp	grid02maze26[eax],' '
		je validuponG
		cmp	grid02maze26[eax],'.'
		jne return12a
		
		
		jmp validuponG
		l3checkgrid26:
			cmp	grid03maze26[eax],' '
			je validuponG
			cmp	grid03maze26[eax],'.'
			jne return12a
			
			
			jmp validuponG
checkgrid25:
    cmp level,1
	jne l2checkgrid25
	cmp	grid01maze25[eax],' '
	je validuponG
	cmp	grid01maze25[eax],'.'
	jne return12a
	
	
	jmp validuponG
	l2checkgrid25:
		cmp level,2
		jne l3checkgrid25
		cmp	grid02maze25[eax],' '
		je validuponG
		cmp	grid02maze25[eax],'.'
		jne return12a
		jmp validuponG
		l3checkgrid25:
			cmp	grid03maze25[eax],' '
			je validuponG
			cmp	grid03maze25[eax],'.'
			jne return12a
			jmp validuponG
checkgrid24:
    cmp level,1
	jne l2checkgrid24
	cmp	grid01maze24[eax],' '
	je validuponG
	cmp	grid01maze24[eax],'.'
	jne return12a
	jmp validuponG
	l2checkgrid24:
		cmp	level,2
		jne l3checkgrid24
		cmp	grid02maze24[eax],' '
		je validuponG
		cmp	grid02maze24[eax],'.'
		jne return12a
		jmp validuponG
		l3checkgrid24:
			cmp	grid03maze24[eax],' '
			je validuponG
			cmp	grid03maze24[eax],'.'
			jne return12a
			jmp validuponG
checkgrid23:
	cmp level,1
	jne l2checkgrid23
	cmp	grid01maze23[eax],' '
	je validuponG
	cmp	grid01maze23[eax],'.'
	jne return12a
	
	
	jmp validuponG
	l2checkgrid23:
		cmp	level,2
		jne l3checkgrid23
		cmp	grid02maze23[eax],' '
		je validuponG
		cmp	grid02maze23[eax],'.'
		jne return12a
		
		
		jmp validuponG
		l3checkgrid23:
			cmp	grid03maze23[eax],' '
			je validuponG
			cmp	grid03maze23[eax],'.'
			jne return12a
			
			
			jmp validuponG
checkgrid22:
	cmp level,1
	jne l2checkgrid22
	cmp	grid01maze22[eax],' '
	je validuponG
	cmp	grid01maze22[eax],'.'
	jne return12a
	
	
	jmp validuponG
	l2checkgrid22:
		cmp	level,2
		jne l3checkgrid22
		cmp	grid02maze22[eax],' '
		je validuponG
		cmp	grid02maze22[eax],'.'
		jne return12a
		
		
		jmp validuponG
		l3checkgrid22:
			cmp	grid03maze22[eax],' '
			je validuponG
			cmp	grid03maze22[eax],'.'
			jne return12a
			
			
			jmp validuponG
checkgrid21:
	cmp level,1
	jne l2checkgrid21
	cmp	grid01maze21[eax],' '
	je validuponG
	cmp	grid01maze21[eax],'.'
	jne return12a
	
	
	jmp validuponG
	l2checkgrid21:
		cmp	level,2
		jne l3checkgrid21
		cmp	grid02maze21[eax],' '
		je validuponG
		cmp	grid02maze21[eax],'.'
		jne return12a
		
		
		jmp validuponG
		l3checkgrid21:
			cmp	grid03maze21[eax],' '
			je validuponG
			cmp	grid03maze21[eax],'.'
			jne return12a
			
			
			jmp validuponG
checkgrid20:
    cmp level,1
	jne l2checkgrid20
	cmp	grid01maze20[eax],' '
	je validuponG
	cmp	grid01maze20[eax],'.'
	jne return12a
	
	
	jmp validuponG
	l2checkgrid20:
		cmp	level,2
		jne l3checkgrid20
		cmp	grid02maze20[eax],' '
		je validuponG
		cmp	grid02maze20[eax],'.'
		jne return12a
		
		
		jmp validuponG
		l3checkgrid20:
			cmp	grid03maze20[eax],' '
			je validuponG
			cmp	grid03maze20[eax],'.'
			jne return12a
			
			
			jmp validuponG
checkgrid19:
	cmp level,1
	jne l2checkgrid19
	cmp	grid01maze19[eax],' '
	je validuponG
	cmp	grid01maze19[eax],'.'
	jne return12a
	
	
	jmp validuponG
	l2checkgrid19:
		cmp level,2
		jne l3checkgrid19
		cmp	grid02maze19[eax],' '
		je validuponG
		cmp	grid02maze19[eax],'.'
		jne return12a
		
		
		jmp validuponG
		l3checkgrid19:
			cmp	grid03maze19[eax],' '
			je validuponG
			cmp	grid03maze19[eax],'.'
			jne return12a
			
			
			jmp validuponG
checkgrid18:
	cmp level,1
	jne l2checkgrid18
	cmp	grid01maze18[eax],' '
	je validuponG
	cmp	grid01maze18[eax],'.'
	jne return12a
	
	jmp validuponG
	l2checkgrid18:
	cmp level,2
	jne l3checkgrid18
		cmp	grid02maze18[eax],' '
		je validuponG
		cmp	grid02maze18[eax],'.'
		jne return12a
		
		
		jmp validuponG
		l3checkgrid18:
			cmp	grid03maze18[eax],' '
			je validuponG
			cmp	grid03maze18[eax],'.'
			jne return12a
			
			
			jmp validuponG
checkgrid17:
	cmp level,1
	jne l2checkgrid17
	cmp	grid01maze17[eax],' '
	je validuponG
	cmp	grid01maze17[eax],'.'
	jne return12a
	
	
	jmp validuponG
	l2checkgrid17:
		cmp	level,2
		jne l3checkgrid17
		cmp	grid02maze17[eax],' '
		je validuponG
		cmp	grid02maze17[eax],'.'
		jne return12a
		
		
		jmp validuponG
		l3checkgrid17:
			cmp	grid03maze17[eax],' '
			je validuponG
			cmp	grid03maze17[eax],'.'
			jne return12a
			
			
			jmp validuponG
checkgrid16:
	cmp level,1
	jne l2checkgrid16
	cmp	grid01maze16[eax],' '
	je validuponG
	cmp	grid01maze16[eax],'.'
	jne return12a
	
	
	jmp validuponG
	l2checkgrid16:
		cmp	level,2
		jne l3checkgrid16
		cmp	grid02maze16[eax],' '
		je validuponG
		cmp	grid02maze16[eax],'.'
		jne return12a
		
		
		jmp validuponG
		l3checkgrid16:
			cmp	grid03maze16[eax],' '
			je validuponG
			cmp	grid03maze16[eax],'.'
			jne return12a
			
			
			jmp validuponG
checkgrid15:
	cmp level,1
	jne l2checkgrid15
	cmp	grid01maze15[eax],' '
	je validuponG
	cmp	grid01maze15[eax],'.'
	jne return12a
	
	
	jmp validuponG
	l2checkgrid15:
		cmp	level,2
		jne l3checkgrid15
		cmp	grid02maze15[eax],' '
		je validuponG
		cmp	grid02maze15[eax],'.'
		jne return12a
		
		
		jmp validuponG
		l3checkgrid15:
			cmp	grid03maze15[eax],' '
			je validuponG
			cmp	grid03maze15[eax],'.'
			jne return12a
			
			
			jmp validuponG
checkgrid14:
	cmp level,1
	jne l2checkgrid14
	cmp	grid01maze14[eax],' '
	je validuponG
	cmp	grid01maze14[eax],'.'
	jne return12a
	
	
	jmp validuponG
	l2checkgrid14:
		cmp	level,2
		jne l3checkgrid14
		cmp	grid02maze14[eax],' '
		je validuponG
		cmp	grid02maze14[eax],'.'
		jne return12a
		
		
		jmp validuponG
		l3checkgrid14:
			cmp	grid03maze14[eax],' '
			je validuponG
			cmp	grid03maze14[eax],'.'
			jne return12a
			
			
			jmp validuponG
checkgrid13:
	cmp level,1
	jne l2checkgrid13
	cmp	grid01maze13[eax],' '
	je validuponG
	cmp	grid01maze13[eax],'.'
	jne return12a
	
	
	jmp validuponG
	l2checkgrid13:
		cmp	level,2
		jne l3checkgrid13
		cmp	grid02maze13[eax],' '
		je validuponG
		cmp	grid02maze13[eax],'.'
		jne return12a
		
		
		jmp validuponG
		l3checkgrid13:
			cmp	grid03maze13[eax],' '
			je validuponG
			cmp	grid03maze13[eax],'.'
			jne return12a
			
			
			jmp validuponG
checkgrid12:
	cmp level,1
	jne l2checkgrid12
	cmp	grid01maze12[eax],' '
	je validuponG
	cmp	grid01maze12[eax],'.'
	jne return12a
	
	
	jmp validuponG
	l2checkgrid12:
		cmp	level,2
		jne l3checkgrid12
		cmp	grid02maze12[eax],' '
		je validuponG
		cmp	grid02maze12[eax],'.'
		jne return12a
		
		
		jmp validuponG
		l3checkgrid12:
			cmp	grid03maze12[eax],' '
			je validuponG
			cmp	grid03maze12[eax],'.'
			jne return12a
			
			
			jmp validuponG
checkgrid11:
	cmp level,1
	jne l2checkgrid11
	cmp	grid01maze11[eax],' '
	je validuponG
	cmp	grid01maze11[eax],'.'
	jne return12a
	
	
	jmp validuponG
	l2checkgrid11:
		cmp	level,2
		jne l3checkgrid11
		cmp	grid02maze11[eax],' '
		je validuponG
		cmp	grid02maze11[eax],'.'
		jne return12a
		
		
		jmp validuponG
		l3checkgrid11:
			cmp	grid03maze11[eax],' '
			je validuponG
			cmp	grid03maze11[eax],'.'
			jne return12a
			
			
			jmp validuponG
checkgrid10:
	cmp level,1
	jne l2checkgrid10
	cmp	grid01maze10[eax],' '
	je validuponG
	cmp	grid01maze10[eax],'.'
	jne return12a
	
	
	jmp validuponG
	l2checkgrid10:
		cmp	level,2
		jne l3checkgrid10
		cmp	grid02maze10[eax],' '
		je validuponG
		cmp	grid02maze10[eax],'.'
		jne return12a
		
		
		jmp validuponG
		l3checkgrid10:
			cmp	grid03maze10[eax],' '
			je validuponG
			cmp	grid03maze10[eax],'.'
			jne return12a
			
			
			jmp validuponG
checkgrid9:
	cmp level,1
	jne l2checkgrid9
	cmp	grid01maze09[eax],' '
	je validuponG
	cmp	grid01maze09[eax],'.'
	jne return12a
	
	
	jmp validuponG
	l2checkgrid9:
		cmp	level,2
		jne l3checkgrid9
		cmp	grid02maze09[eax],' '
		je validuponG
		cmp	grid02maze09[eax],'.'
		jne return12a
		
		
		jmp validuponG
		l3checkgrid9:
			cmp	grid03maze09[eax],' '
			je validuponG
			cmp	grid03maze09[eax],'.'
			jne return12a
			
			
			jmp validuponG
checkgrid8:
	cmp level,1
	jne l2checkgrid8
	cmp	grid01maze08[eax],' '
	je validuponG
	cmp	grid01maze08[eax],'.'
	jne return12a
	
	
	jmp validuponG
	l2checkgrid8:
		cmp	level,2
		jne l3checkgrid8
		cmp	grid02maze08[eax],' '
		je validuponG
		cmp	grid02maze08[eax],'.'
		jne return12a
		
		
		jmp validuponG
		l3checkgrid8:
			cmp	grid03maze08[eax],' '
			je validuponG
			cmp	grid03maze08[eax],'.'
			jne return12a
			
			
			jmp validuponG
checkgrid7:
	cmp level,1
	jne l2checkgrid7
	cmp	grid01maze07[eax],' '
	je validuponG
	cmp	grid01maze07[eax],'.'
	jne return12a
	
	
	jmp validuponG
	l2checkgrid7:
		cmp	level,2
		jne l3checkgrid7
		cmp	grid02maze07[eax],' '
		je validuponG
		cmp	grid02maze07[eax],'.'
		jne return12a
		
		
		jmp validuponG
		l3checkgrid7:
			cmp	grid03maze07[eax],' '
			je validuponG
			cmp	grid03maze07[eax],'.'
			jne return12a
			
			
			jmp validuponG
checkgrid6:
	cmp level,1
	jne l2checkgrid6
	cmp	grid01maze06[eax],' '
	je validuponG
	cmp	grid01maze06[eax],'.'
	jne return12a
	
	
	jmp validuponG
	l2checkgrid6:
		cmp	level,2
		jne l3checkgrid6
		cmp	grid02maze06[eax],' '
		je validuponG
		cmp	grid02maze06[eax],'.'
		jne return12a
		
		
		jmp validuponG
		l3checkgrid6:
			cmp	grid03maze06[eax],' '
			je validuponG
			cmp	grid03maze06[eax],'.'
			jne return12a
			
			
			jmp validuponG
checkgrid5:
	cmp level,1
	jne l2checkgrid5
	cmp	grid01maze05[eax],' '
	je validuponG
	cmp	grid01maze05[eax],'.'
	jne return12a
	
	
	jmp validuponG
	l2checkgrid5:
		cmp	level,2
		jne l3checkgrid5
		cmp	grid02maze05[eax],' '
		je validuponG
		cmp	grid02maze05[eax],'.'
		jne return12a
		
		
		jmp validuponG
		l3checkgrid5:
			cmp	grid03maze05[eax],' '
			je validuponG
			cmp	grid03maze05[eax],'.'
			jne return12a
			
			
			jmp validuponG
checkgrid4:
	cmp level,1
	jne l2checkgrid4
	cmp	grid01maze04[eax],' '
	je validuponG
	cmp	grid01maze04[eax],'.'
	jne return12a
	
	
	jmp validuponG
	l2checkgrid4:
		cmp	level,2
		jne l3checkgrid4
		cmp	grid02maze04[eax],' '
		je validuponG
		cmp	grid02maze04[eax],'.'
		jne return12a
		
		
		jmp validuponG
		l3checkgrid4:
			cmp	grid03maze04[eax],' '
			je validuponG
			cmp	grid03maze04[eax],'.'
			jne return12a
			
			
			jmp validuponG
checkgrid3:
	cmp level,1
	jne l2checkgrid3
	cmp	grid01maze03[eax],' '
	je validuponG
	cmp	grid01maze03[eax],'.'
	jne return12a
	
	
	jmp validuponG
	l2checkgrid3:
		cmp	level,2
		jne l3checkgrid3
		cmp	grid02maze03[eax],' '
		je validuponG
		cmp	grid02maze03[eax],'.'
		jne return12a
		
		
		jmp validuponG
		l3checkgrid3:
			cmp	grid03maze03[eax],' '
			je validuponG
			cmp	grid03maze03[eax],'.'
			jne return12a
			
			
			jmp validuponG
checkgrid2:
	cmp level,1
	jne l2checkgrid2
	cmp	grid01maze02[eax],' '
	je validuponG
	cmp	grid01maze02[eax],'.'
	jne return12a
	
	
	jmp validuponG
	l2checkgrid2:
		cmp	level,2
		jne l3checkgrid2
		cmp	grid02maze02[eax],' '
		je validuponG
		cmp	grid02maze02[eax],'.'
		jne return12a
		
		
		jmp validuponG
		l3checkgrid2:
			cmp	grid03maze02[eax],' '
			je validuponG
			cmp	grid03maze02[eax],'.'
			jne return12a
			jmp validuponG
validuponG:
	mov validupG,1
	jmp return12a
return12a:
	popad
	ret
CheckValidMovementG ENDP


CheckPosition PROC
	pushad
	movzx eax,xPosG
	sub eax,26
	movzx ebx,yPosG
	cmp ebx,43
	je checkgrid26
	cmp ebx,42
	je checkgrid25
	cmp ebx,41
	je checkgrid24
	cmp ebx,40
	je checkgrid23
	cmp ebx,39
	je checkgrid22
	cmp ebx,38
	je checkgrid21
	cmp ebx,37
	je checkgrid20
	cmp ebx,36
	je checkgrid19
	cmp ebx,35
	je checkgrid18
	cmp ebx,34
	je checkgrid17
	cmp ebx,33
	je checkgrid16
	cmp ebx,32
	je checkgrid15
	cmp ebx,31
	je checkgrid14
	cmp ebx,30
	je checkgrid13
	cmp ebx,29
	je checkgrid12
	cmp ebx,28
	je checkgrid11
	cmp ebx,27
	je checkgrid10
	cmp ebx,26
	je checkgrid9
	cmp ebx,25
	je checkgrid8
	cmp ebx,24
	je checkgrid7
	cmp ebx,23
	je checkgrid6
	cmp ebx,22
	je checkgrid5
	cmp ebx,21
	je checkgrid4
	cmp ebx,20
	je checkgrid3
	cmp ebx,19
	je checkgrid2
	jmp return12a
checkgrid26:
	cmp level,1
	jne l2checkgrid26
	cmp	grid01maze26[eax],'.'
	jne return12a	
	jmp PositionDotOn
	l2checkgrid26:
		cmp level,2
		jne l3checkgrid26
		cmp	grid02maze26[eax],'.'
		jne return12a
		jmp PositionDotOn
		l3checkgrid26:
			cmp	grid03maze26[eax],'.'
			jne return12a
			jmp PositionDotOn
checkgrid25:
    cmp level,1
	jne l2checkgrid25
	cmp	grid01maze25[eax],'.'
	jne return12a
	jmp PositionDotOn
	l2checkgrid25:
		cmp level,2
		jne l3checkgrid25
		cmp	grid02maze25[eax],'.'
		jne return12a
		jmp PositionDotOn
		l3checkgrid25:
			cmp	grid03maze25[eax],'.'
			jne return12a
			jmp PositionDotOn
checkgrid24:
    cmp level,1
	jne l2checkgrid24
	cmp	grid01maze24[eax],'.'
	jne return12a
	jmp PositionDotOn
	l2checkgrid24:
		cmp	level,2
		jne l3checkgrid24
		cmp	grid02maze24[eax],'.'
		jne return12a
		jmp PositionDotOn
		l3checkgrid24:
			cmp	grid03maze24[eax],'.'
			jne return12a
			jmp PositionDotOn
checkgrid23:
	cmp level,1
	jne l2checkgrid23
	cmp	grid01maze23[eax],'.'
	jne return12a
	jmp PositionDotOn
	l2checkgrid23:
		cmp	level,2
		jne l3checkgrid23
		cmp	grid02maze23[eax],'.'
		jne return12a
		jmp PositionDotOn
		l3checkgrid23:
			cmp	grid03maze23[eax],'.'
			jne return12a
			jmp PositionDotOn
checkgrid22:
	cmp level,1
	jne l2checkgrid22
	cmp	grid01maze22[eax],'.'
	jne return12a
	jmp PositionDotOn
	l2checkgrid22:
		cmp	level,2
		jne l3checkgrid22
		cmp	grid02maze22[eax],'.'
		jne return12a
		jmp PositionDotOn
		l3checkgrid22:
			cmp	grid03maze22[eax],'.'
			jne return12a
			jmp PositionDotOn
checkgrid21:
	cmp level,1
	jne l2checkgrid21
	cmp	grid01maze21[eax],'.'
	jne return12a
	jmp PositionDotOn
	l2checkgrid21:
		cmp	level,2
		jne l3checkgrid21
		cmp	grid02maze21[eax],'.'
		jne return12a
		jmp PositionDotOn
		l3checkgrid21:
			cmp	grid03maze21[eax],'.'
			jne return12a
			jmp PositionDotOn
checkgrid20:
    cmp level,1
	jne l2checkgrid20
	cmp	grid01maze20[eax],'.'
	jne return12a
	jmp PositionDotOn
	l2checkgrid20:
		cmp	level,2
		jne l3checkgrid20
		cmp	grid02maze20[eax],'.'
		jne return12a
		jmp PositionDotOn
		l3checkgrid20:
			cmp	grid03maze20[eax],'.'
			jne return12a
			jmp PositionDotOn
checkgrid19:
	cmp level,1
	jne l2checkgrid19
	cmp	grid01maze19[eax],'.'
	jne return12a
	jmp PositionDotOn
	l2checkgrid19:
		cmp level,2
		jne l3checkgrid19
		cmp	grid02maze19[eax],'.'
		jne return12a
		jmp PositionDotOn
		l3checkgrid19:
			cmp	grid03maze19[eax],'.'
			jne return12a
			jmp PositionDotOn
checkgrid18:
	cmp level,1
	jne l2checkgrid18
	cmp	grid01maze18[eax],'.'
	jne return12a
	jmp PositionDotOn
	l2checkgrid18:
	cmp level,2
	jne l3checkgrid18
		cmp	grid02maze18[eax],'.'
		jne return12a
		jmp PositionDotOn
		l3checkgrid18:
			cmp	grid03maze18[eax],'.'
			jne return12a
			jmp PositionDotOn
checkgrid17:
	cmp level,1
	jne l2checkgrid17
	cmp	grid01maze17[eax],'.'
	jne return12a
	jmp PositionDotOn
	l2checkgrid17:
		cmp	level,2
		jne l3checkgrid17
		cmp	grid02maze17[eax],'.'
		jne return12a
		jmp PositionDotOn
		l3checkgrid17:
			cmp	grid03maze17[eax],'.'
			jne return12a
			jmp PositionDotOn
checkgrid16:
	cmp level,1
	jne l2checkgrid16
	cmp	grid01maze16[eax],'.'
	jne return12a
	jmp PositionDotOn
	l2checkgrid16:
		cmp	level,2
		jne l3checkgrid16
		cmp	grid02maze16[eax],'.'
		jne return12a
		jmp PositionDotOn
		l3checkgrid16:
			cmp	grid03maze16[eax],'.'
			jne return12a
			jmp PositionDotOn
checkgrid15:
	cmp level,1
	jne l2checkgrid15
	cmp	grid01maze15[eax],'.'
	jne return12a
	jmp PositionDotOn
	l2checkgrid15:
		cmp	level,2
		jne l3checkgrid15
		cmp	grid02maze15[eax],'.'
		jne return12a
		jmp PositionDotOn
		l3checkgrid15:
			cmp	grid03maze15[eax],'.'
			jne return12a
			jmp PositionDotOn
checkgrid14:
	cmp level,1
	jne l2checkgrid14
	cmp	grid01maze14[eax],'.'
	jne return12a
	jmp PositionDotOn
	l2checkgrid14:
		cmp	level,2
		jne l3checkgrid14
		cmp	grid02maze14[eax],'.'
		jne return12a
		jmp PositionDotOn
		l3checkgrid14:
			cmp	grid03maze14[eax],'.'
			jne return12a
			jmp PositionDotOn
checkgrid13:
	cmp level,1
	jne l2checkgrid13
	cmp	grid01maze13[eax],'.'
	jne return12a
	jmp PositionDotOn
	l2checkgrid13:
		cmp	level,2
		jne l3checkgrid13
		cmp	grid02maze13[eax],'.'
		jne return12a
		jmp PositionDotOn
		l3checkgrid13:
			cmp	grid03maze13[eax],'.'
			jne return12a
			jmp PositionDotOn
checkgrid12:
	cmp level,1
	jne l2checkgrid12
	cmp	grid01maze12[eax],'.'
	jne return12a
	jmp PositionDotOn
	l2checkgrid12:
		cmp	level,2
		jne l3checkgrid12
		cmp	grid02maze12[eax],'.'
		jne return12a
		jmp PositionDotOn
		l3checkgrid12:
			cmp	grid03maze12[eax],'.'
			jne return12a
			jmp PositionDotOn
checkgrid11:
	cmp level,1
	jne l2checkgrid11
	cmp	grid01maze11[eax],'.'
	jne return12a
	jmp PositionDotOn
	l2checkgrid11:
		cmp	level,2
		jne l3checkgrid11
		cmp	grid02maze11[eax],'.'
		jne return12a
		jmp PositionDotOn
		l3checkgrid11:
			cmp	grid03maze11[eax],'.'
			jne return12a
			jmp PositionDotOn
checkgrid10:
	cmp level,1
	jne l2checkgrid10
	cmp	grid01maze10[eax],'.'
	jne return12a
	jmp PositionDotOn
	l2checkgrid10:
		cmp	level,2
		jne l3checkgrid10
		cmp	grid02maze10[eax],'.'
		jne return12a
		jmp PositionDotOn
		l3checkgrid10:
			cmp	grid03maze10[eax],'.'
			jne return12a
			jmp PositionDotOn
checkgrid9:
	cmp level,1
	jne l2checkgrid9
	cmp	grid01maze09[eax],'.'
	jne return12a
	jmp PositionDotOn
	l2checkgrid9:
		cmp	level,2
		jne l3checkgrid9
		cmp	grid02maze09[eax],'.'
		jne return12a
		jmp PositionDotOn
		l3checkgrid9:
			cmp	grid03maze09[eax],'.'
			jne return12a
			jmp PositionDotOn
checkgrid8:
	cmp level,1
	jne l2checkgrid8
	cmp	grid01maze08[eax],'.'
	jne return12a
	jmp PositionDotOn
	l2checkgrid8:
		cmp	level,2
		jne l3checkgrid8
		cmp	grid02maze08[eax],'.'
		jne return12a
		jmp PositionDotOn
		l3checkgrid8:
			cmp	grid03maze08[eax],'.'
			jne return12a
			jmp PositionDotOn
checkgrid7:
	cmp level,1
	jne l2checkgrid7
	cmp	grid01maze07[eax],'.'
	jne return12a
	jmp PositionDotOn
	l2checkgrid7:
		cmp	level,2
		jne l3checkgrid7
		cmp	grid02maze07[eax],'.'
		jne return12a
		jmp PositionDotOn
		l3checkgrid7:
			cmp	grid03maze07[eax],'.'
			jne return12a
			jmp PositionDotOn
checkgrid6:
	cmp level,1
	jne l2checkgrid6
	cmp	grid01maze06[eax],'.'
	jne return12a
	jmp PositionDotOn
	l2checkgrid6:
		cmp	level,2
		jne l3checkgrid6
		cmp	grid02maze06[eax],'.'
		jne return12a
		jmp PositionDotOn
		l3checkgrid6:
			cmp	grid03maze06[eax],'.'
			jne return12a
			jmp PositionDotOn
checkgrid5:
	cmp level,1
	jne l2checkgrid5
	cmp	grid01maze05[eax],'.'
	jne return12a
	jmp PositionDotOn
	l2checkgrid5:
		cmp	level,2
		jne l3checkgrid5
		cmp	grid02maze05[eax],'.'
		jne return12a
		jmp PositionDotOn
		l3checkgrid5:
			cmp	grid03maze05[eax],'.'
			jne return12a
			jmp PositionDotOn
checkgrid4:
	cmp level,1
	jne l2checkgrid4
	cmp	grid01maze04[eax],'.'
	jne return12a
	jmp PositionDotOn
	l2checkgrid4:
		cmp	level,2
		jne l3checkgrid4
		cmp	grid02maze04[eax],'.'
		jne return12a
		jmp PositionDotOn
		l3checkgrid4:
			cmp	grid03maze04[eax],'.'
			jne return12a
			jmp PositionDotOn
checkgrid3:
	cmp level,1
	jne l2checkgrid3
	cmp	grid01maze03[eax],'.'
	jne return12a
	jmp PositionDotOn
	l2checkgrid3:
		cmp	level,2
		jne l3checkgrid3
		cmp	grid02maze03[eax],'.'
		jne return12a
		jmp PositionDotOn
		l3checkgrid3:
			cmp	grid03maze03[eax],'.'
			jne return12a
			jmp PositionDotOn
checkgrid2:
	cmp level,1
	jne l2checkgrid2
	cmp	grid01maze02[eax],'.'
	jne return12a	
	jmp PositionDotOn
	l2checkgrid2:
		cmp	level,2
		jne l3checkgrid2
		cmp	grid02maze02[eax],'.'
		jne return12a
		jmp PositionDotOn
		l3checkgrid2:
			cmp	grid03maze02[eax],'.'
			jne return12a
			jmp PositionDotOn
PositionDotOn:
	mov ghostDot,1
	jmp return12a
return12a:
	popad
	ret
CheckPosition ENDP

NumbToStr PROC uses ebx,x:DWORD,bbffff:DWORD

    mov     ecx,bbffff
    mov     eax,x
    mov     ebx,10
    add     ecx,ebx             ; ecx = buffer + max size of string
@@:
    xor     edx,edx
    div     ebx
    add     edx,48              ; convert the digit to ASCII
    mov     BYTE PTR [ecx],dl   ; store the character in the buffer
    dec     ecx                 ; decrement ecx pointing the buffer
    test    eax,eax             ; check if the quotient is 0
    jnz     @b

    inc     ecx
    mov     eax,ecx             ; eax points the string in the buffer
    ret

NumbToStr ENDP


END main