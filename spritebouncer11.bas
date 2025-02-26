1 dEfna(b)=aB(t-int(t/b)*b-b/2):v=53269:pOv+8,1:pO2040,16:pOv,1:?"{clear}{blue}{reverse on}{191}{191}{191}";
2 fOx=0to18:?"@{reverse off}@a{reverse on}{191}{191}{191}{left*3}";:nE:pOv+18,14:pOv+2,1
3 x=fna(544)+24:pOv-5,-(x>255):pOv-21,xaN255:pOv-20,fna(316)+50:x=fna(42)+1
4 pOl,o:l=1027+fna(36)*3+x/8:o=pE(l):pOl,oor2^(7-xaN7):t=t+1:gO3
!-
!- Version 11 - 246 bytes. 
!- This is the combined improvements from Robin Harbron (8-bit show and tell),
!- Peter Tirsek & Eyvind Ebsen.
!- https://www.youtube.com/@8_Bit
!- https://www.youtube.com/watch?v=zwTA7xi0QD0
!-
!- v11 improvements:
!- 
!-  We have entered the 1 block-size program now! :D
!- 
!-  Peter Tirsek sugggested another great improvement.
!-  Why not print the entire sprite data to screen
!-  and move the sprite pointer there? haha ofcourse! Awesome!
!-  Sprite pointer 16=(16*64)=address 1024, start of screen memory.
!-  So the end of line 1, and line 2 
!-  looks like this now (printing the sprite data)
!-
!-  end of line 1 ... ?"{clear}{blue}{reverse on}{191}{191}{191}";
!-  2 fOx=0to18:?"@{reverse off}@a{reverse on}";:nE:?"{191}{191}{191}"...
!- 
!-  Now we are down to 248 bytes! :)
!-  ({191} can be typed on the original hardware using CBM-B)
!- 
!-  One little improvement here is to go 3 left with the cursor,
!-  after the printing, so you dont need to print after the loop:
!-
!-  fOx=0to18:?"@{reverse off}@a{reverse on}{191}{191}{191}{left*3}";:nE
!- 
!-  This saves 1 more byte. 247 bytes now.
!-
!-  Robin suggested the end quote trick (remove end quote), in the end of line 2:
!-  Move the print to the end of the line, and skip then end quote (")
!-
!-  ?"{191}{191}{191}
!- 
!-  This would save the same byte as adding the 3cursor lefts trick.
!- 
!-  Another optimization Robin came up was to remove the "Z=255",
!-  and just use the typed constant, this saves 1 more byte.
!-  Weird? ":z=255" will take 6 bytes, we now have to poke the full2040,16
!-  costing 1 byte. But instead of using Z, we use 255, spending 2 more bytes
!-  on each, costing another 4 bytes. And there's the save. Sweet!
!-
!-  246 bytes now!
!- 
!-  Huge Thanks to Peter Tirsek for getting us into the 1-block era ;)
!-
!-
!- v10 Improvements: 265 bytes
!-
!-  Instead of doing the mod function during the sprite creation,
!-  why not keep printing the sequence ahead and just peek.
!-  Will print too many sequences, but who cares, its hidden! :)
!-
!-  This will get rid of the "pE(4^5+x-int(x/3)*3)" (mod function), in line 2
!-  and replace it with "pE(1064+x)"
!- 
!-  Where did the peek(4^5+ go? Since i had to keep the print in line 1 without an
!-  ending quote, the line shifts down, so have to peek at 1064, wasting a byte.
!-  So if i wanted to keep the 4^5 thing, that would cost 2 bytes in line 1,
!-  while im only saving 1 byte in line 2.
!-  All in all, 3 bytes saved.
!-  
!-  
!- v9 Improvements: 268 bytes
!-   print the data (128,0,1) on screen; cost less than a poke
!-   peek from 1024, or why not 4^5(1024), saves 1 more byte.
!- 
!- Robin pointed out that you can skip the last "
!- in the print, line 1, saving 1 more byte - works fine.
!-
!- PAL & NTSC safe :)
!-
!- Moved Robins pokev,1 from line 3, to line 1 since there is room now.
!- A little speedboost.
