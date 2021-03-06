//////////////////////////////////////////////////////////////////////
// Linear Bearings.
//////////////////////////////////////////////////////////////////////

/*
BSD 2-Clause License

Copyright (c) 2017, Revar Desmera
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


include <shapes.scad>
include <metric_screws.scad>


function get_lmXuu_bearing_diam(size) = lookup(size, [
		[  4.0,   8.0],
		[  5.0,  10.0],
		[  6.0,  12.0],
		[  8.0,  15.0],
		[ 10.0,  19.0],
		[ 12.0,  21.0],
		[ 13.0,  23.0],
		[ 16.0,  28.0],
		[ 20.0,  32.0],
		[ 25.0,  40.0],
		[ 30.0,  45.0],
		[ 35.0,  52.0],
		[ 40.0,  60.0],
		[ 50.0,  80.0],
		[ 60.0,  90.0],
		[ 80.0, 120.0],
		[100.0, 150.0]
	]);


function get_lmXuu_bearing_length(size) = lookup(size, [
		[  4.0,  12.0],
		[  5.0,  15.0],
		[  6.0,  19.0],
		[  8.0,  24.0],
		[ 10.0,  29.0],
		[ 12.0,  30.0],
		[ 13.0,  32.0],
		[ 16.0,  37.0],
		[ 20.0,  42.0],
		[ 25.0,  59.0],
		[ 30.0,  64.0],
		[ 35.0,  70.0],
		[ 40.0,  80.0],
		[ 50.0, 100.0],
		[ 60.0, 110.0],
		[ 80.0, 140.0],
		[100.0, 175.0]
	]);


// Creates a model of a clamp to hold a given linear bearing cartridge.
//   d = Diameter of linear bearing. (Default: 15)
//   l = Length of linear bearing. (Default: 24)
//   tab = Clamp tab height. (Default: 7)
//   tabwall = Clamp Tab thickness. (Default: 5)
//   wall = Wall thickness of clamp housing. (Default: 3)
//   gap = Gap in clamp. (Default: 5)
//   screwsize = Size of screw to use to tighten clamp. (Default: 3)
// Example:
//   linear_bearing_housing(d=19, l=29, wall=2, tab=6, screwsize=2.5);
module linear_bearing_housing(d=15,l=24,tab=7,gap=5,wall=3,tabwall=5,screwsize=3)
{
	od = d+2*wall;
	ogap = gap+2*tabwall;
	tabh = tab/2+od/2*sqrt(2)-ogap/2;
	translate([0,0,od/2]) difference() {
		union() {
			rotate([0,0,90])
				teardrop(r=od/2,h=l);
			translate([0,0,tabh])
				cube(size=[l,ogap,tab+0.05], center=true);
			translate([0,0,-od/4])
				cube(size=[l,od,od/2], center=true);
		}
		rotate([0,0,90])
			teardrop(r=d/2,h=l+0.05);
		translate([0,0,(d*sqrt(2)+tab)/2])
			cube(size=[l+0.05,gap,d+tab], center=true);
		translate([0,0,tabh]) {
			translate([0,-ogap/2+2-0.05,0])
				rotate([90,0,0])
					screw(screwsize=screwsize*1.06, screwlen=ogap, headsize=screwsize*2, headlen=10);
			translate([0,ogap/2+0.05,0])
				rotate([90,0,0])
					metric_nut(size=screwsize,hole=false);
		}
	}
}


module lmXuu_housing(size=8,tab=7,gap=5,wall=3,tabwall=5,screwsize=3)
{
	d = get_lmXuu_bearing_diam(size);
	l = get_lmXuu_bearing_length(size);
	linear_bearing_housing(d=d,l=l,tab=tab,gap=gap,wall=wall,tabwall=tabwall,screwsize=screwsize);
}
//lmXuu_housing(size=8);
//lmXuu_housing(size=10);


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
