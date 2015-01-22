// Thickness of the material you are cutting the module from.  This adjusts the notch width.
material_thickness = 5;

// Adjust the notches to account for swarf.  on the hacman laser this is 0.15mm
swarf = 0;

// AMB specifies the drop per module at 63mm, but this can generate modules of any drop.
drop_per_module = 63;

// AMB modules are 480mm long
module_length = 480;


module endplate()
{
	difference()
	{
		square([400+swarf, 120+swarf], center=true);
		translate ([0,drop_per_module/2,0])
		{
			circle(r=30/2);
			for(x=[-150, -100, 100, 150])
				translate([x,0]) circle(r=8/2);
		}
	}
}

module endplate_holes()
{
	difference()
	{
		endplate();
		for(x=[-192, 192])
			for(y=[-50,0,50])
				translate ([x,y]) circle(r=4/2);
	}
}

module endplate_box()
{
	difference()
	{
		endplate();
		for (x=[(material_thickness/2)-200-0.5,200-(material_thickness/2)+0.5])
			translate([x,0])
				square([material_thickness-swarf+1, 40-swarf], center=true);
		}
}

module endplate_box_up()
{
	difference()
	{
		endplate_box();
		for (x=[-100,0,100])
			translate([x,(material_thickness/2)-60-1])
				square([40-swarf, material_thickness-swarf+1], center=true);
	}
}

module endplate_box_down()
{
	difference()
	{
		endplate_box();
		for (x=[-100,0,100])
			translate([x,60-(material_thickness/2)+1])
				square([40-swarf, material_thickness-swarf+1], center=true);
	}
}

module baseplate()
{
	union()
	{
		square([400-material_thickness-material_thickness+swarf, module_length-material_thickness-material_thickness+swarf], center=true);
		for (x=[-100,0,100])
			for (y=[(material_thickness/2)-(module_length/2), (module_length/2)-(material_thickness/2)])
				translate([x,y])
					square([40-swarf, material_thickness-swarf], center=true);
		for (x=[(material_thickness/2)-(400/2), (400/2)-(material_thickness/2)])
			for (y=[-200,-100,0,100,200])
				translate([x,y])
					square([material_thickness-swarf, 40-swarf], center=true);
	}
}

module sideplate()
{
	union ()
	{
		difference()
		{
			square([120+swarf, module_length-material_thickness-material_thickness+swarf], center=true);
			for (y=[-200,-100,0,100,200])
				translate([60-(material_thickness/2)+1,y])
					square([material_thickness-swarf+1, 40-swarf], center=true);
			hull()
			{
				translate([-60,0]) square([1, module_length-material_thickness-material_thickness], center=true);
				for (y=[-(module_length-150)/2, (module_length-150)/2])
					translate([0,y])
						circle(r=40, center=true);
			}
		}
		for (y=[(material_thickness/2)-(module_length/2), (module_length/2)-(material_thickness/2)])
			translate([0,y])
				square([40-swarf, material_thickness-swarf], center=true);
	}
}

module amb_box_2d()
{
	translate([280, 0]) rotate([0,0,180]) sideplate();
	translate([0, 320]) endplate_box_up();
	baseplate();
	translate([0, -320]) endplate_box_down();
	translate([-280,0]) sideplate();
}

module amb_box_3d()
{
	color("red") linear_extrude(height=material_thickness) baseplate();

	color("blue")	translate([0, (module_length/2), 60]) rotate([90,0,0]) linear_extrude(height=material_thickness) endplate_box_up();
	color("blue")	translate([0, -(module_length/2), 60]) rotate([-90,0,0]) linear_extrude(height=material_thickness) endplate_box_down();

	color("green")	translate([-200, 0, 60]) rotate([0,90,0])  linear_extrude(height=material_thickness) sideplate();
	color("green")	translate([200, 0, 60]) rotate([0,-90,0]) mirror([1,0,0]) linear_extrude(height=material_thickness) sideplate();
}

amb_box_2d();
