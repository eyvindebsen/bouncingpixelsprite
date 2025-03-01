1 dEfna(b)=aB(t-int(t/b)*b-b/2):v=53269:?"{clear}{blue}{reverse on}{191}{191}{191}";
2 pOv+18,14:pO2040,16:fOt=.tov:ift<19tH?"@{reverse off}@a{reverse on}{191}{191}{191}{left*3}";:pOv-(t<5)*t*2,1
3 x=fna(544)+24:pOv-5,x/256:pOv-21,xaN255:pOv-20,fna(316)+50:x=fna(42)+1
4 pOl,o:l=1027+fna(36)*3+x/8:o=pE(l):pOl,oor2^(7-xaN7):nE
!-
!- Version 13 - 235 bytes. Now with even more dramatic intro effects! :D
!-
!- This is the combined improvements from Robin Harbron (8-bit show and tell),
!- Peter Tirsek & Eyvind Ebsen.
!- https://www.youtube.com/@8_Bit
!- https://www.youtube.com/watch?v=zwTA7xi0QD0
!-
!-  Version 13 improvements:
!-
!-  Got rid of the 3 pokes,
!-  pOv,1:pOv+2,1:pOv+8,1
!-  need to poke the adresses v+0, v+2, v+8 with 1
!-  So this little weirdo will replace it
!-  pOv-(t<5)*t*2,1
!-  It will poke a few more than needed, but will not harm anything?
!-  It kinda does. It sets the sprite behind the text, so looks weird
!-  when the sprite gets to the top. Another dramatic effect? ;)
!-
!-  Now you see the expansion going on while the sprite is being drawn.
!-  Looks a bit more dramatic to me :D
!-
!-  Saves 4 bytes.
!-
!-
!-
!- Version 12 - 239 bytes. Now with dramatic intro effects!
!-
!- Version 12 improvements:
!-
!- Peter Tirsik came up with a reduction of the statement in line 3.
!-
!- pov-5,-(x>255)  can be written as
!- pov-5,x/256     saves another 3 bytes. Great! :D
!-
!- Was testing to see if the for-loop could run "fovever".
!- Well atleast 53269 frames, stealing the V to save more bytes.
!- Using a nasty "IF", made it work, althou the first 18 frames
!- will show the sprite being drawn. 
!- Which is techinally a free bonus benefit of the initialization
!- to add a cool dramatic intro effect? ;)
!- 
!- In the end its the same result, saving 4 bytes.
!- Hope its not considered a cheat?
!- 
!- Cleaned up the pokes and put them in order.
!- 
!-
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
!-  One little improvement here is to print the ending 3*255
!-  and then go 3 left with the cursor, this will overwrite the 3*255
!-  every loop, but will leave them at the end, after the printing.
!-  So you dont need to print after the loop:
!-
!-  fOx=0to18:?"@{reverse off}@a{reverse on}{191}{191}{191}{left*3}";:nE
!- 
!-  This saves 1 more byte. 247 bytes now.
!-
!-  Robin suggested the end quote trick (remove end quote), in the end of line 2:
!-  Move the print to the end of the line, and skip the end quote (")
!-
!-  ?"{191}{191}{191}
!- 
!-  This would save the same byte as adding the 3cursor lefts trick.
!- 
!-  Another optimization Robin came up with was to remove the "Z=255",
!-  and just use the typed constant, this saves 1 more byte.
!-  Weird? ":z=255" will take 6 bytes, we now have to poke the full2040,16
!-  costing 1 byte. But instead of using Z, we use 255, spending 2 more bytes
!-  on each, costing another 4 bytes. And there's the save. Sweet!
!-
!-  246 bytes now!
!- 
!-  Huge Thanks to Peter Tirsek for getting us into the 1-block era ;)
!-
!- One more thing.
!- Robin and I somehow agreed on measuring the program size this way:
!- (load program)
!- CLR:?-26627-FRE(0)
!- 
!- This will print the size of the program in memory.
!- On disk the program will contain an additional 2 bytes for load address, 
!- and adds 2 trailing zeroes, indicating the end of program. 
!- This adds 4 bytes to the filesize.
!- So technically the program on disk is +4 bytes. These bytes we do not count.
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
