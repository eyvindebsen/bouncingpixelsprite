1 dEfna(b)=aB(t-int(t/b)*b-b/2):v=53269:z=255:pOv+8,1:pOz*8,13:pOv,1:?"{clear}{blue}{reverse on}@{reverse off}@a
2 fOx=0to62:pO832+x,(x<3orx>59)*-zorpE(4^5+x-int(x/3)*3):nE:pOv+18,14:pOv+2,1
3 x=fna(544)+24:pOv-5,-(x>z):pOv-21,xaNz:pOv-20,fna(316)+50:x=fna(42)+1
4 pOl,o:l=835+fna(36)*3+x/8:o=pE(l):pOl,oor2^(7-xaN7):t=t+1:gO3
!-
!- Version 9 - 268 bytes. 
!- This is the combined improvements from Robin (8-bit show and tell) and me.
!- https://www.youtube.com/@8_Bit
!- https://www.youtube.com/watch?v=zwTA7xi0QD0
!-
!- Improvements:
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
