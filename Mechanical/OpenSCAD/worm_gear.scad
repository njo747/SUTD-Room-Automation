use <involute_gears.scad>

function unitVector(v) = v/sqrt(v[0]*v[0]+v[1]*v[1]+v[2]*v[2]);
function barycenter(v1,v2,r) = (v1*r+v2*(1-r));

module slice(i,stepsPerTurn,minorRadius,pitch,ThreadDepth,ThreadRatio=0.5,ThreadPosition=0.5,ThreadAngle=20)
{
	function XY(n) = minorRadius*[cos(360*n/stepsPerTurn),sin(360*n/stepsPerTurn),0];
	function Z(n) = [0,0,pitch*n/stepsPerTurn];	
	function V(n) = XY(n)+Z(n);
		
	ABot = V(i); ATop = V(i+stepsPerTurn); BBot = V(i+1); BTop = V(i+1+stepsPerTurn);

	uva  = unitVector(ATop-ABot)*ThreadDepth/2*tan(ThreadAngle);
	uvb  = unitVector(BTop-BBot)*ThreadDepth/2*tan(ThreadAngle);
	uvat = unitVector(XY(i+stepsPerTurn))*ThreadDepth;
	uvbt = unitVector(XY(i+1+stepsPerTurn))*ThreadDepth;

	tptr = ThreadPosition+ThreadRatio/2; tmtr = ThreadPosition-ThreadRatio/2;
	
	polyPoints=[
		Z(i), Z(i+stepsPerTurn), // AShaftBot, AShaftTop
		ATop,
		barycenter(ATop,ABot,tptr)+uva,
		barycenter(ATop,ABot,tptr)-uva+uvat,
		barycenter(ATop,ABot,ThreadPosition),
		barycenter(ATop,ABot,tmtr)+uva+uvat,
		barycenter(ATop,ABot,tmtr)-uva,
		ABot, BTop,
		barycenter(BTop,BBot,tptr)+uvb,
		barycenter(BTop,BBot,tptr)-uvb+uvbt,
		barycenter(BTop,BBot,ThreadPosition),
		barycenter(BTop,BBot,tmtr)+uvb+uvbt,
		barycenter(BTop,BBot,tmtr)-uvb,
		BBot,
		Z(i+1), Z(i+1+stepsPerTurn) // BShaftBot, BShaftTop
	];

	polyTriangles=[
		[3,2,10],[2,9,10],[4,3,10],[10,11,4],[6,4,11],[11,13,6],
		[7,6,13],[13,14,7],[8,7,14],[14,15,8],[0,8,15],[1,9,2],
		[3,4,5],[5,4,6],[5,6,7],[11,10,12],[11,12,13],[12,14,13],
		[0,1, 5],[1,2,3],[1,3,5],[0,5,7],[0,7,8], 		 //A side of shaft
		[1,0,12],[1,10,9],[1,12,10],[0,14,12],[0,15,14], //B side of shaft
	];
	polyhedron(polyPoints,polyTriangles);
}

module worm_gear(
	length=45,				// axial length of the threaded rod
	pitch=10,				// axial distance from crest to crest
	pitchRadius=10,			// radial distance from center to mid-profile
	threadHeightToPitch=0.5,// ratio between the height of the profile and the pitch
	profileRatio=0.5,		// ratio between the lengths of the raised part of the profile and the pitch
	threadAngle=30,			// angle between the two faces of the thread
	clearance=0.1,			// radial clearance, normalized to thread height
	backlash=0.1,			// axial clearance, normalized to pitch
	stepsPerTurn=24)		// number of slices to create per turn,
{
	minorRadius = pitchRadius-(0.5+clearance)*pitch*threadHeightToPitch;
	threadHeight = pitch*threadHeightToPitch*(1+clearance);
	profileR = profileRatio*(1-backlash);
	threadPosition = ( profileR + threadHeightToPitch*(1+clearance)*tan(threadAngle) )/2;
	
	numTurns = floor(8*length/pitch-6)/8;

	difference()
	{
		for(i=[0:stepsPerTurn*numTurns]) slice(i,stepsPerTurn,minorRadius,pitch,threadHeight,profileR,threadPosition,threadAngle);
		translate([0,0,length-0.01]) cylinder(h=5,r=pitchRadius);
	}
	cylinder(h=length,r=0.999*pitchRadius-(0.5+clearance)*pitch*threadHeightToPitch,$fn=stepsPerTurn);
}

num_teeth = 10;
circular_pitch = 360;
pitch = 2*3.1415*circular_pitch/360;

translate([-10,5+num_teeth*circular_pitch/360,5]) rotate([0,90,0])
	worm_gear(20,pitch,5,stepsPerTurn=50);

rotate([0,0,16])
	gear(num_teeth,circular_pitch,gear_thickness=10,rim_thickness=10,pressure_angle=20,clearance=0,backlash=0.1,twist=-2);
