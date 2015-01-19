module endplate()
{
	difference()
	{
		square([400, 120], center=true);
		translate ([0,63/2,0])
		{
			circle(r=30/2);
			for(x=[-150, -100, 100, 150])
				translate([x,0]) circle(r=8/2);
		}
		for(x=[-192, 192])
			for(y=[-50,0,50])
				translate ([x,y]) circle(r=4/2); 
	}
}

module box(length=500)
{
	translate([0,5-(length/2),0]) rotate([90,0,0])linear_extrude(height=5) endplate();
	translate([0,(length/2),0]) rotate([0,180,0]) rotate([90,0,0])linear_extrude(height=5) endplate();
	translate([0,0,-60]) cube([400, length, 6], center=true);
}

endplate();
