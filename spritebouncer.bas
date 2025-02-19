0 rem sprite bouncer in sprite
1 y=abs(t-int(t/38)*38-19):x=abs(t-int(t/42)*42-21)
4 print x,y:t=t+1:goto1
5 print"{clear}":v=128:forx=.to7:b(x)=v:v=v/2:next:v=53248
10 pokev+21,1:pokev+39,14:poke2040,13:rem enable sprite 1
20 rem pokev,24:pokev+1,50:rem set position
22 pokev+23,1:pokev+29,1:rem expand in x y
25 rem forx=.to62:poke832+x,0:next:rem clear sprite
26 z=832:forx=1to20:pokez+(x*3),128:pokez+(x*3)+2,1:pokez+(x*3)+1,0:next:forx=.to2:pokez+x,255:poke892+x,255:next
35 x=1:y=1:dx=1:dy=1:o=255:bx=24:by=50:cx=1:cy=1
38 rem x=1+int(rnd(pi)*19):y=1+int(rnd(pi)*16):rem set random pos
40 a=832+int(y*3+(x/8))
45 pokez,o:rem delete the old
50 o=peek(a):pokea,b(xand7)oro:z=a
60 x=x+dx:y=y+dy:printx
65 ifx>21orx<2thendx=-dx
68 ify>18ory<2thendy=-dy
84 bx=bx+cx:by=by+cy:rem now move the sprite
87 ifbx<24orbx>295thencx=-cx
88 ifby<51orby>207thency=-cy
89 ifbx>255thenpokev+16,1:pokev,bx-255:goto92:rem x>255
90 pokev+16,0:pokev,bx
92 pokev+1,by:goto40