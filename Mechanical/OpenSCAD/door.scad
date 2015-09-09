$fn=100;

// takes forever to render so I replaced them with the rendered STLs
// If you want the library, go to http://www.thingiverse.com/thing:3575
// The file I used is here: http://www.thingiverse.com/download:10581
// uncomment the line below and the 2 bevel_gear() lines later
//use <parametric_involute_gear_v5.0.scad>
use <publicDomainGearV1.1.scad>

//use <screw_thread.scad>
use <servo.scad>

module door_cap_frame(padding=5)
{
	cap_r = 27.5; // radius of cap
	cap_d = 80; // distance between caps
	
	frame_w = (cap_r+padding)*2;
	frame = [cap_d+frame_w,frame_w];
	
	translate([-cap_d/2,0,0]) difference()
	{
		linear_extrude(3) difference()
		{
			square(frame,center=true);
			for(i=[-1,1]) translate([i*cap_d/2,0,0]) circle(r=cap_r);
			translate([-(cap_d+frame_w/2)/2,0,0]) square([frame_w/2,frame_w],center=true);
		}
	}	
}

module knob_hub(radius=20, height=20, shell=false)
{
	clr = 3;
	tab = [12,3,4.5];
	knob_r = 15.5;
	
	if ( shell )
	{
		cylinder(r=radius+0.75,h=height,$fn=6);
	}
	else
	{
		difference()
		{
			union()
			{
				translate([0,0,clr]) cylinder(r=radius,h=height-clr,$fn=6);
				cylinder(r=sqrt(3)*radius/2,h=clr);
			}
			cylinder(r=knob_r,h=height*3,center=true);
		}
		for(i=(tab[1]/2+sqrt(knob_r*knob_r-(tab[0]*tab[0])/4))*[-1,1])
			translate([0,i,tab[2]/2]) cube(tab,center=true);
	}
}

module knob_wheel()
{
	difference()
	{
		cylinder(r=25,h=5);
		translate([0,0,-0.1]) knob_hub(height=15,shell=true);
		translate([0,21.5,0]) cylinder(r=1.55,h=15,center=true);
	}
}

module knob_delay()
{
	translate([22.5,0,2.5]) cube([3,3,5],center=true);
	difference()
	{
		cylinder(r=25,h=5); cylinder(r=24,h=15,center=true);
	}
}

module knob_delay_case(height=14)
{
	difference()
	{
		union()
		{
			cylinder(r=27,h=height);
			linear_extrude(2) hull()
			{
				square([60,55],center=true);
				for(i=[-1,1]) translate([25*i,27.5,0]) circle(r=5);
			}
			translate([0,0,9.5]) difference()
			{
				import("screw_thread.stl",convexity=3);
				translate([0,0,4.55]) cylinder(r=30,h=5);
			}
		}
		translate([0,0,1]) cylinder(r=25.5,h=height);
		cylinder(r=23.5,h=5,center=true);
	}
}

module knob_delay_case_cap()
{
	difference()
	{
		cylinder(r=29,h=7.5);
		import("screw_thread.stl",convexity=3);
		cylinder(r=27.5,h=25,center=true);
	}
	translate([0,0,6.5]) difference()
	{
		cylinder(r=29,h=1);
		cylinder(r=22.5,h=3,center=true);
	}
}

* translate([0,-8,2.5]) difference()
{
	intersection()
	{
		translate([0,15,0]) cube([30,30,5],center=true);
		cylinder(r=28.5,h=15,center=true);
	}
//	translate([0,0,3]) cylinder(r=27.5,h=10,center=true);
//	translate([0,8,0]) cylinder(r=16.5,h=20,center=true);
	translate([0,8,0]) cylinder(r=10,h=20,center=true);
	translate([0,-11,0]) cube([20,40,10],center=true);
}
rotate([0,0,60]) translate([-33,0,-1.5])
{
	gear(6,10,4,0);
	cylinder(r=6,h=5);
}
% translate([0,0,-1.6]) difference()
{
	union()
	{
		gear(6,24,3,3);
		translate([0,0,2]) cylinder(r=23,h=1,center=true);
	}
	cylinder(r=16.5,h=10,center=true);
	for(i=[1,3,5,7]) rotate([0,0,i*45]) translate([20,0,0]) cylinder(r=1,h=10,center=true);
}

* translate([0,0,-10]) difference()
{
	cylinder(r=25,h=2.5);
	cylinder(r=16.5,h=10,center=true);
	translate([0,21.5,0]) cylinder(r=1.5,h=6,center=true);
	for(i=[1,3,5,7]) rotate([0,0,i*45]) translate([20,0,0]) cylinder(r=1,h=10,center=true);
}

//door_cap_frame();
knob_delay_case();
//translate([0,30,7.5]) rotate([0,180,0]) knob_delay_case_cap();

//knob_wheel();
//knob_delay();

//difference(){ knob_hub(height=10); cube([0.5,100,50],center=true); }