$fn=50;

// takes forever to render so I replaced them with the rendered STLs
//use <screw_thread.scad>
use <involute_gears.scad>
use <worm_gear.scad>

gear_cp = 360;

module quadring() for(i=[1,3,5,7]) rotate([0,0,i*45]) children();

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

module knob_final()
{
	difference()
	{
		cylinder(r=25,h=2.5);
		cylinder(r=16.5,h=10,center=true);
		translate([0,21.5,0]) cylinder(r=1.5,h=6,center=true);
		for(i=[1,3,5,7]) rotate([0,0,i*45]) translate([20,0,0]) cylinder(r=1,h=10,center=true);
	}
}

module knob_delay_case(height=16)
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
			translate([0,-40,1]) cube([60,40,2],center=true);
			quadring() translate([29,0,0]) cylinder(r=4.5,h=height);
		}
		translate([0,0,1]) cylinder(r=25.5,h=height);
		cylinder(r=23.5,h=5,center=true);
		translate([0,-42,0]) cylinder(r=7,h=6,center=true);
		quadring() translate([0,29,0])
		{
			cylinder(r=1.5,h=height*3,center=true);
			cylinder(r=3.5,h=height*2-5,$fn=6,center=true);
		}
	}
}

module knob_delay_case_cap()
{
	linear_extrude(1) difference()
	{
		union()
		{
			circle(r=28);
			quadring() translate([29,0,0]) circle(r=4.5);
		}
		circle(r=22.5);
		quadring() translate([0,29,0]) circle(r=1.5);
	}
}

module gear1(thickness=3)
{
	difference()
	{
		union()
		{
			gear(24,gear_cp,gear_thickness=thickness,rim_thickness=thickness,hub_thickness=0);
			translate([0,0,thickness]) cylinder(r=23,h=1);
		}
		cylinder(r=16.5,h=thickness*3,center=true);
		quadring() translate([20,0,0]) cylinder(r=1,h=thickness*3,center=true);
	}
}

module gear2(thickness=3)
{
	difference()
	{
		gear(18,gear_cp,gear_thickness=thickness,rim_thickness=thickness,hub_thickness=0);
		cylinder(r=5,h=thickness*3,$fn=6,center=true);
	}
}

module worm_spur()
{	
	gear(10,gear_cp,rim_thickness=10,pressure_angle=20,clearance=0,backlash=0.1,twist=-2);
	cylinder(r=6.5,h=4,center=true);
	cylinder(r=5,h=10,$fn=6,center=true);
}

module motor_worm()
{
	difference()
	{
		union()
		{
			translate([0,0,0.8]) worm_gear(20,2*3.1415,5,stepsPerTurn=15);
			cylinder(r=5,h=1,$fn=100);
		}
		cylinder(r=1,h=70,center=true,$fn=100);
	}
}

//translate([0,30,7.5]) rotate([0,180,0]) // for printing cap

// exploded view because it is pretty
/*
translate([0,0,52]) knob_delay_case_cap();
% translate([0,0,3.05]) knob_delay_case();
translate([0,0,33]) difference(){ knob_hub(height=10); cube([0.5,100,50],center=true); }
translate([0,0,45]) knob_wheel();
translate([0,0,26]) knob_delay();
translate([0,0,20]) knob_final();
gear1();
translate([0,-42,0]) gear2();
translate([0,-42,5]){ worm_spur(); translate([15,-10,7.5]) rotate([-90,0,0]) motor_worm(); }
*/

knob_delay_case();
gear2();

//door_cap_frame();

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