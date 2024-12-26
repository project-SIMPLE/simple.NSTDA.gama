/**
* Name: NewModel1
* Based on the internal empty template. 
* Author: lilti
* Tags: 
*/


model NewModel1

global{
	shape_file Trail_shape_file <- shape_file("../includes/Trail.shp");
	geometry shape <- (envelope(Trail_shape_file));
	
	geometry usable_area;
	geometry usable_area_for_tree;
	geometry my_overlap;
	
	
	map<string, int> map_player_id <- ["Player_101"::1, "Player_102"::2, "Player_103"::3, "Player_104"::4, "Player_105"::5, "Player_106"::6];
	list<rgb> player_colors <- [#blue, #red, #green, #yellow, #black, #white];
	init{
		
		write map_player_id;
		write "" + "Player_106" + " is team " + map_player_id["Player_106"];
		write " has color " + player_colors[map_player_id["Player_106"]-1];
			
		create road from: Trail_shape_file;
		
		usable_area <- union(road collect each.geom_visu) inter world.shape ;
		usable_area_for_tree <- usable_area - 3;
		
		create my_circle{
			location <- any_location_in(usable_area_for_tree);
		}
		
		ask my_circle{
			my_overlap <- usable_area_for_tree inter self.shape ;
//			create road from:my_overlap{
//				buffer_size <- 0.0;
//				color <- #red;
//			}
		}
		save usable_area to:"../includes/export/usable_area.shp" format:"shp";
		save usable_area_for_tree to:"../includes/export/usable_area_for_tree.shp" format:"shp";
	}
	
}

species road{
	rgb color <- #grey;
	float buffer_size <- 15.0;
	geometry geom_visu <- shape + buffer_size;
	aspect default {
		draw geom_visu color: color ;	
	}
}

species my_circle{
	rgb color <- #blue;
	geometry shape <- circle(100#m);
	aspect default {
		draw shape color: color ;	
	}
}

experiment init_exp type: gui {	
	output{
		display "Main" type: 3d background: rgb(50,50,50){
			camera 'default' locked:false distance:550 ;
			species my_circle;
			species road ;
			
		}
	}
}