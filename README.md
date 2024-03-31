# Snake
This was created for an Uni project in Assembly.  
  This is not an typical snake game because you spawn with 10 length.  
  Also eating a star doesn't generate a new one there are already 25 stars to collect.  
  There are 3 types of stars:  
  Red - Removes 200 delay  
  Blue - Removes 400 delay  
  Green - Removes 600 delay  
  All of these remove delay which means snake moves faster.  
  There's a function that every 2 minutes also removes delay.  
  You can use from F1-F8 keys to change snake's color.  
  Game ends when you collect all stars.  
  There is no collision for snake so it can't die.  
  PRNG is there for generating stars but it's pretty bad implemented.  

  How to run it?  
  
  Download the MS-DOS emulator 
  Source: https://www.dosbox.com/download.php?main=1  
  Install it, and then you have to find dosbox.conf file and mount ur folder for example for me it was:  
  mount G: G:\ASM  
  Then you can download Snake.ASM and put it here.  
  To run it you have to use 3 commands to run it:  
  1. TASM Snake.ASM  
  2. TLINK Snake.obj  
  3. Snake.exe  



  

  

