0 rem t=14469 : rem if you want the sprite to start at the upper left corner
1 deffna(b)=1+abs(t-int(t/b)*b-b/2):?"{clear}":s=832:v=s*64:h=255
2 forx=.to19:pokes+(x*3),128:pokes+(x*3)+2,1:ifx<3thenpokes+x,h:poke892+x,h
3 next:pokev+21,1:pokev+23,1:pokev+29,1:pokev+39,14:pokeh*8,13
4 a=s+(fna(36)*3)+x/8:pokez,m:m=peek(a):pokea,2^(7-xand7)orm:z=a:t=t+1
5 x=fna(42):w=23+fna(546):pokev+1,49+fna(318):pokev+16,abs(w>h):pokev,wandh:goto4

!- Thx to Robin from 8 bit show and tell for the ocillator function in line 1
!- https://www.youtube.com/watch?v=jhQgHW2VI0o
!- Sprite bouncer in sprite v6 by Eyvind Ebsen, 286 bytes.
!- The first pokez,m in line 4, will poke 0,0
!- - this seems to be ok, saw it elsewhere
!-
!- bug? pixel Y axis goes in the frame line (21)
!- yes, was fna(38) line 4, changed to fna(36) - fixed
!-
!- sprite bounce not aligned correctly - fixed
