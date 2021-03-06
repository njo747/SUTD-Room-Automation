$fn=100;

module mounts(l,radius,m_dx,m_dy=0)
{
	for(i=[-1,1]) for(j=[-1,1]) translate([i*m_dx/2,j*m_dy/2,0]) cylinder(r=radius,h=l,center=true);
}

module servo(shell=false)
{
	body = [ 42, 20.5, 40 ];
	body_shell = [ 44, 21.5, 40 ];
	
	flange = [ 56, 20.5, 2.5 ];
	fh = 30.0;
	
	m_d = 50.0;
	
	difference()
	{
		cube(flange,center=true);
		if(!shell) mounts(body[2],2.25,m_d,10);
	}
	if(shell) mounts(body[2],2.25,m_d,10);
	
	translate([0,0,body[2]/2-fh]) cube(shell?body_shell:body,center=true);
	
	translate([11,0,body[2]-fh]){ cylinder(r=6,h=1.5); cylinder(r=3,h=5); }
}

module 9g_servo(shell=false)
{
	body = [ 23.28, 12.5, 23.3 ];

	flange = [ 33.28, 12.5, 2.36 ];
	fh = 17.62;
		
	m_d = 27.78;
	
	difference()
	{
		cube(flange,center=true);
		for(i=[-1,1]) translate([i*(1.5+m_d/2),0,0]) cube([3,1,flange[2]*2],center=true);
		if(!shell) mounts(body[2],1,m_d);
	}
	if(shell) mounts(body[2],1,m_d);
	
	translate([0,0,body[2]/2-fh]) cube(body,center=true);
	
	translate([5.82,0,body[2]-fh]){ cylinder(r=6,h=3.75); cylinder(r=2.455,h=6.5); }	
}

module servo_mount()
{
	difference()
	{
		translate([1,0,2]) cube([60,32,4],center=true);
		translate([0,0,6]) servo(true);
	}
	
	translate([30.5,0,10])
	{
		difference()
		{
			cube([4,32,20],center=true);
			for(i=[-1,1]) for(j=[-1.25,-1,-0.75,0.75,1,1.25])
				translate([-3.5,i*8,j+2]) rotate([0,90,0])
				{
					cylinder(r=3.5,h=6,$fn=6,center=true);
					cylinder(r=1.5,h=20,center=true);
				}
		}
		translate([0,0,-6]) intersection()
		{
			rotate([0,45,0]) cube([17.5,32,17.5],true);
			for(i=[-1,1]) translate([-7,i*14,7]) cube([17.5,4,17.5],true);
		}
	}

	for(i=[-1,1]) translate([1,14.5*i,5.5]) cube([60,3,3],center=true);
}

servo_mount();
% translate([0,0,6]) rotate([0,180,0]) servo();
//% 9g_servo();