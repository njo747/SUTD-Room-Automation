module thread(or,lt,st,lf,rs)
{
	sf = [[1,0,3],[1,3,6],[6,3,8],[1,6,4],[0,1,2],[1,4,2],[2,4,5],
		  [5,4,6],[5,6,7],[7,6,8],[7,8,3],[0,2,3],[3,2,7],[7,2,5]];
	ir = or - st/2*cos(lf)/sin(lf); pf = 2*PI*or; sn = floor(pf/rs);
	lfxy = 360/sn; ttn = round(lt/st+1); zt = st/sn;
	
	for(i=[0:ttn-1]){ ist = i*st; for(j=[0:sn-1])
	{
		istjzt=ist+j*zt; jlfxy=j*lfxy;
		cj=cos(jlfxy); cja=cos(jlfxy+lfxy);
		sj=sin(jlfxy); sja=sin(jlfxy+lfxy);
		pt = [
			[0,0,ist-st],
			[ir*cj, ir*sj, istjzt-st],
			[ir*cja,ir*sja,istjzt+zt-st],
			[0,0,ist],
			[or*cj, or*sj, istjzt-st/2],
			[or*cja,or*sja,istjzt+zt-st/2],
			[ir*cj, ir*sj, istjzt],
			[ir*cja,ir*sja,istjzt+zt],
			[0,0,ist+st]
		];
		polyhedron(points=pt,faces=sf);
	}}
}

/*
or - outer radius
lt - length
st - step size
lf - thread angle
rs - resolution
*/

thread(28,5,3,45,1);