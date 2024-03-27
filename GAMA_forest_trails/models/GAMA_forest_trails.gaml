/**
* Name: test_shapefile
* Based on the internal empty template. 
* Author: lilti
* Tags: 
*/

model GAMA_forest_trails

global {
	shape_file roads_shape_file <- shape_file("../includes/Trail_4_5.shp");
	geometry shape <- envelope(roads_shape_file);
	graph road_network;
	
	// Parameter
	int n_big_tree <- 100;
	int n_medium_tree <- 150;
	int n_small_tree <- 200;
	int collect_seeds_distance <- 5;
	
	// Variable
	int total_seeds <- 0;
	int total_big_tree_seeds <- 0;
	int total_medium_tree_seeds <- 0;
	int total_small_tree_seeds <- 0;
	
	list red_big_tree_list <- [];
	list red_medium_tree_list <- [];
	list red_small_tree_list <- [];
	
	init {
		list tree_loc_list <- (list(-10,-9,-8,-7,-6,-5,-4,-3,-2,2,3,4,5,6,7,8,9,10));
//		write tree_loc_list[rnd_choice(tree_loc_list)];
		
		create road from: roads_shape_file ;
		road_network <- as_edge_graph(road);
//		write road_network.vertices[0];
//		write roads_shape_file;
//		write road_network.edges;
		
		create player{
			location <- any_location_in(any(road));
		}
		
//		ask road{
//			write self;
//			if bool(player overlapping self){
//				write "True";
//			}
//		}
		
		create big_tree number:n_big_tree{
			point at_location;
			point target_location;
			at_location <- any_location_in(any(road));
			target_location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
			location <- target_location;
//			location <- any_location_in(any(road));
		}
		create medium_tree number:n_medium_tree{
			point at_location;
			point target_location;
			at_location <- any_location_in(any(road));
			target_location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
			location <- target_location;
		}
		create small_tree number:n_small_tree{
			point at_location;
			point target_location;
			at_location <- any_location_in(any(road));
			target_location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};		
			location <- target_location;
		}
	}
	reflex created_red_tree when: cycle=0{
		loop i from:1 to:int(0.1*n_big_tree){
			ask any(big_tree){
//				write self;
				it_red <- true;
				initial_seed <- rnd(5,10);
//				write initial_seed;
				add self to: red_big_tree_list;
			}
		}
		loop i from:1 to:int(0.1*n_medium_tree){
			ask any(medium_tree){
//				write self;
				it_red <- true;
				initial_seed <- rnd(10,20);
//				write initial_seed;
				add self to: red_medium_tree_list;
			}
		}
		loop i from:1 to:int(0.1*n_small_tree){
			ask any(small_tree){
//				write self;
				it_red <- true;
				initial_seed <- rnd(1,5);
//				write initial_seed;
				add self to: red_small_tree_list;
			}
		}
		write "Red big tree" + red_big_tree_list;
		write "Red medium tree" + red_medium_tree_list;
		write "Red small tree" + red_small_tree_list;
	}
}

species big_tree{
	bool it_red <- false;
	int initial_seed <- 0;
	rgb color <- #red;
	aspect default{
		draw circle(5#m) color:it_red? color:rgb(24, 105, 21);
	}
}

species medium_tree{
	bool it_red <- false;
	int initial_seed <- 0;
	rgb color <- #red;
	aspect default{
		draw square(5#m) color:it_red? color:rgb(97, 135, 47);
	}
}

species small_tree{
	bool it_red <- false;
	int initial_seed <- 0;
	rgb color <- #red;
	aspect default{
		draw triangle(5#m) color:it_red? color:rgb(135, 135, 47);
	}
}

species road skills: [road_skill] {
	aspect default {
		draw shape color: #white width:5;
	}
}

species player{
	aspect default {
		draw circle(10#m) color: #purple border:#black;
	}
}

experiment forrest type: gui {
	action move_player{
		ask player {
    		location <- #user_location;
    	}
	}
	action collect_seeds{
    	ask player{
//    		write self;
    		int limit_harvest_per_action <- 0;
    		ask small_tree at_distance collect_seeds_distance{
    			if limit_harvest_per_action < 1{
    				if self in red_small_tree_list{
    					color <- #black;
//		    			write self;
//	    				write color;
//						write initial_seed;
						total_seeds <- total_seeds + initial_seed;
	    				total_small_tree_seeds <- total_small_tree_seeds + initial_seed;
	    				limit_harvest_per_action <- limit_harvest_per_action + 1;
	    				write "Player collect " + initial_seed + " seeds from small tree. | Total: " + total_seeds;
    				}	
				}
	    	}
	    	ask medium_tree at_distance collect_seeds_distance{
    			if limit_harvest_per_action < 1{
    				if self in red_medium_tree_list{
    					color <- #black;
//		    			write self;
//	    				write color;
//						write initial_seed;
						total_seeds <- total_seeds + initial_seed;
	    				total_medium_tree_seeds <- total_medium_tree_seeds + initial_seed;
	    				limit_harvest_per_action <- limit_harvest_per_action + 1;
	    				write "Player collect " + initial_seed + " seeds from medium tree. | Total: " + total_seeds;
    				}	
				}
	    	}
	    	ask big_tree at_distance collect_seeds_distance{
    			if limit_harvest_per_action < 1{
    				if self in red_big_tree_list{
    					color <- #black;
//		    			write self;
//	    				write color;
//						write initial_seed;
						total_seeds <- total_seeds + initial_seed;
	    				total_big_tree_seeds <- total_big_tree_seeds + initial_seed;
	    				limit_harvest_per_action <- limit_harvest_per_action + 1;
	    				write "Player collect " + initial_seed + " seeds from big tree. | Total: " + total_seeds;
    				}	
				}
	    	}
    	}
    }
	output synchronized: true {
		display "Main" type: 3d background: rgb(50,50,50){
			camera 'default' locked:true; //location: {445,750,750} 
			
			species road;
			species big_tree;
			species medium_tree;
			species small_tree;
			species player;
			
			event #mouse_drag action: move_player ; 
			event 'c' action: collect_seeds;
		}
		display "Summary" type: 2d {
			chart "Number of seeds collected" type:histogram
			x_serie_labels: ["Collected from"]
			style:"3d"
			series_label_position: xaxis
			{
				data "Small tree" value:total_small_tree_seeds
//				style:stack
				color:#yellow;
				data "Medium tree" value:total_medium_tree_seeds
//				style:stack
				color:#green;
				data "Big tree" value:total_big_tree_seeds
//				style:stack
				color:#blue;
//				marker_shape:marker_circle ;
				data "Total" value:total_seeds
//				style:stack
				color:#red;
			}
		} 
	}
}

