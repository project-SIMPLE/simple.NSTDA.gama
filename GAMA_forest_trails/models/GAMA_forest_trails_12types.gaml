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
	int n_tree_type1 <- 50;
	int n_tree_type2 <- 50;
	int n_tree_type3 <- 50;
	int n_tree_type4 <- 50;
	int n_tree_type5 <- 50;
	int n_tree_type6 <- 50;
	int n_tree_type7 <- 50;
	int n_tree_type8 <- 50;
	int n_tree_type9 <- 50;
	int n_tree_type10 <- 50;
	int n_tree_type11 <- 50;
	int n_tree_type12 <- 100;
	int collect_seeds_distance <- 5;
	
	// Variable
	int total_seeds <- 0;
	int total_big_tree_seeds <- 0;
	int total_medium_tree_seeds <- 0;
	int total_small_tree_seeds <- 0;
	
	list red_tree_type1_list <- [];
	list red_tree_type2_list <- [];
	list red_tree_type3_list <- [];
	list red_tree_type4_list <- [];
	list red_tree_type5_list <- [];
	list red_tree_type6_list <- [];
	list red_tree_type7_list <- [];
	list red_tree_type8_list <- [];
	list red_tree_type9_list <- [];
	list red_tree_type10_list <- [];
	list red_tree_type11_list <- [];
	list red_tree_type12_list <- [];
	
	float max_radius <- 200.0; //250.0
	float x_river <- 0.0 ;//300.0; //0.0
	float y_river <- 442.0 ;//375.0; //442.0
	
	init {
		list tree_loc_list <- (list(-10,-9,-8,-7,-6,-5,5,6,7,8,9,10));
		float x_max <- sqrt((max_radius^2)/2);
		write(x_max);
		
		create river{
			location <- {x_river, y_river, 0.0};
		}
		
		create road from: roads_shape_file ;
		road_network <- as_edge_graph(road);
		
		create player{
			location <- any_location_in(any(road));
		}
		
		create tree_type1 number:n_tree_type1{
			point at_location;
			point target_location;
			at_location <- any_location_in(any(road));
			target_location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
			location <- target_location;
		}
		
		create tree_type2 number:n_tree_type2{
			point at_location;
			point target_location;
			at_location <- any_location_in(any(road));
			target_location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
			location <- target_location;
		}
		
		create tree_type3 number:n_tree_type3{
			point at_location;
			point target_location;
			at_location <- any_location_in(any(road));
			target_location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
			location <- target_location;
		}
		
		create tree_type4 number:n_tree_type4{
			point at_location;
			point target_location;
			at_location <- any_location_in(any(road));
			target_location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
			location <- target_location;
		}
		
		create tree_type5 number:n_tree_type5{
			point at_location;
			point target_location;
			at_location <- any_location_in(any(road));
			target_location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
			location <- target_location;
		}
		
		create tree_type6 number:n_tree_type6{
			point at_location;
			point target_location;
			at_location <- any_location_in(any(road));
			target_location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
			location <- target_location;
		}
		
		create tree_type7 number:n_tree_type7{
			point at_location;
			point target_location;
			at_location <- any_location_in(any(road));
			target_location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
			location <- target_location;
		}
		
		create tree_type8 number:n_tree_type8{
			point at_location;
			point target_location;
			at_location <- any_location_in(any(road));
			target_location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
			location <- target_location;
		}
		
		create tree_type9 number:n_tree_type9{
			point at_location;
			point target_location;
			at_location <- any_location_in(any(road));
			target_location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
			location <- target_location;
		}
		
		create tree_type10 number:n_tree_type10{
			point at_location;
			point target_location;
			at_location <- any_location_in(any(road));
			target_location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
			location <- target_location;
		}
		
		create tree_type11 number:n_tree_type11{
			point at_location;
			point target_location;
			at_location <- any_location_in(any(road));
			target_location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
			location <- target_location;
		}
		
		create tree_type12 number:n_tree_type12{
			point at_location;
			point target_location;
			bool false_position <- true;
//			at_location <- any_location_in(road[0]);
//			loop while: (at_location.x > 160 or at_location.y < 250){
//				at_location <- any_location_in(any(road));
//			}
//			target_location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};		
//			location <- target_location;
			loop while: false_position{
				at_location <- any_location_in(any(road)) ;
				float distance <- sqrt(((x_river - at_location.x)^2) + ((y_river - at_location.y)^2));
//				write(distance);
				loop while: distance > max_radius{
					at_location <- any_location_in(any(road)) ;
					distance <- sqrt(((x_river - at_location.x)^2) + ((y_river - at_location.y)^2));
				}
				float p_x_y <- 1 - (distance/max_radius) ;
				write(p_x_y) ;
				bool create_or_not <- flip(p_x_y);
				write(create_or_not) ;
				if create_or_not{
					write("pass!");
					false_position <- false;
					target_location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};		
					location <- target_location;	
				}
			}
		}
	}
	
	reflex created_red_tree when: cycle=0{
		loop i from:1 to:int(0.1*n_tree_type1){
			ask any(tree_type1){
				it_red <- true;
				initial_seed <- rnd(5,10);
				add self to: red_tree_type1_list;
			}
		}
		
		loop i from:1 to:int(0.1*n_tree_type2){
			ask any(tree_type2){
				it_red <- true;
				initial_seed <- rnd(5,10);
				add self to: red_tree_type2_list;
			}
		}
		
		loop i from:1 to:int(0.1*n_tree_type3){
			ask any(tree_type3){
				it_red <- true;
				initial_seed <- rnd(5,10);
				add self to: red_tree_type3_list;
			}
		}
		
		loop i from:1 to:int(0.1*n_tree_type4){
			ask any(tree_type4){
				it_red <- true;
				initial_seed <- rnd(5,10);
				add self to: red_tree_type4_list;
			}
		}
		
		loop i from:1 to:int(0.1*n_tree_type5){
			ask any(tree_type5){
				it_red <- true;
				initial_seed <- rnd(5,10);
				add self to: red_tree_type5_list;
			}
		}
		
		loop i from:1 to:int(0.1*n_tree_type6){
			ask any(tree_type6){
				it_red <- true;
				initial_seed <- rnd(5,10);
				add self to: red_tree_type6_list;
			}
		}
		
		loop i from:1 to:int(0.1*n_tree_type7){
			ask any(tree_type7){
				it_red <- true;
				initial_seed <- rnd(5,10);
				add self to: red_tree_type7_list;
			}
		}
		
		loop i from:1 to:int(0.1*n_tree_type8){
			ask any(tree_type8){
				it_red <- true;
				initial_seed <- rnd(5,10);
				add self to: red_tree_type8_list;
			}
		}
		
		loop i from:1 to:int(0.1*n_tree_type9){
			ask any(tree_type9){
				it_red <- true;
				initial_seed <- rnd(5,10);
				add self to: red_tree_type9_list;
			}
		}
		
		loop i from:1 to:int(0.1*n_tree_type10){
			ask any(tree_type10){
				it_red <- true;
				initial_seed <- rnd(5,10);
				add self to: red_tree_type10_list;
			}
		}
		
		loop i from:1 to:int(0.1*n_tree_type11){
			ask any(tree_type11){
				it_red <- true;
				initial_seed <- rnd(5,10);
				add self to: red_tree_type11_list;
			}
		}
		
		loop i from:1 to:int(0.1*n_tree_type12){
			ask any(tree_type12){
				it_red <- true;
				initial_seed <- rnd(5,10);
				add self to: red_tree_type12_list;
			}
		}
		
		write "Tree_type1" + red_tree_type1_list;
		write "Tree_type2" + red_tree_type2_list;
		write "Tree_type3" + red_tree_type3_list;
		write "Tree_type4" + red_tree_type4_list;
		write "Tree_type5" + red_tree_type5_list;
		write "Tree_type6" + red_tree_type6_list;
		write "Tree_type7" + red_tree_type7_list;
		write "Tree_type8" + red_tree_type8_list;
		write "Tree_type9" + red_tree_type9_list;
		write "Tree_type10" + red_tree_type10_list;
		write "Tree_type11" + red_tree_type11_list;
		write "Tree_type12" + red_tree_type12_list;
	}
}

species tree_type1{
	bool it_red <- false;
	int initial_seed <- 0;
	rgb color <- #red;
	aspect default{
		draw circle(5#m) color:it_red? color:rgb(24, 105, 21);
	}
}

species tree_type2{
	bool it_red <- false;
	int initial_seed <- 0;
	rgb color <- #red;
	aspect default{
		draw square(5#m) color:it_red? color:rgb(97, 135, 47);
	}
}

species tree_type3{
	bool it_red <- false;
	int initial_seed <- 0;
	rgb color <- #red;
	aspect default{
		draw triangle(5#m) color:it_red? color:rgb(135, 135, 47);
	}
}

species tree_type4{
	bool it_red <- false;
	int initial_seed <- 0;
	rgb color <- #red;
	aspect default{
		draw circle(5#m) color:it_red? color:rgb(161, 255, 189);
	}
}

species tree_type5{
	bool it_red <- false;
	int initial_seed <- 0;
	rgb color <- #red;
	aspect default{
		draw square(5#m) color:it_red? color:rgb(82, 255, 133);
	}
}

species tree_type6{
	bool it_red <- false;
	int initial_seed <- 0;
	rgb color <- #red;
	aspect default{
		draw triangle(5#m) color:it_red? color:rgb(0, 255, 75);
	}
}

species tree_type7{
	bool it_red <- false;
	int initial_seed <- 0;
	rgb color <- #red;
	aspect default{
		draw circle(5#m) color:it_red? color:rgb(242, 255, 168);
	}
}

species tree_type8{
	bool it_red <- false;
	int initial_seed <- 0;
	rgb color <- #red;
	aspect default{
		draw square(5#m) color:it_red? color:rgb(230, 255, 87);
	}
}

species tree_type9{
	bool it_red <- false;
	int initial_seed <- 0;
	rgb color <- #red;
	aspect default{
		draw triangle(5#m) color:it_red? color:rgb(217, 255, 0);
	}
}

species tree_type10{
	bool it_red <- false;
	int initial_seed <- 0;
	rgb color <- #red;
	aspect default{
		draw circle(5#m) color:it_red? color:rgb(255, 222, 150);
	}
}

species tree_type11{
	bool it_red <- false;
	int initial_seed <- 0;
	rgb color <- #red;
	aspect default{
		draw square(5#m) color:it_red? color:rgb(255, 201, 82);
	}
}

species tree_type12{
	bool it_red <- false;
	int initial_seed <- 0;
	rgb color <- #red;
	aspect default{
		draw triangle(10#m) color:it_red? color:#blue;
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

species river{
	aspect default {
		draw circle(max_radius#m) color:rgb(138, 178, 242);
		draw circle(5#m) color:#red;
	}
}

experiment forest type: gui {
	

	
	action move_player{
		ask player {
    		location <- #user_location;
    	}
	}
	action collect_seeds{
    	ask player{
//    		write self;
    		int limit_harvest_per_action <- 0;
//    		ask small_tree at_distance collect_seeds_distance{
//    			if limit_harvest_per_action < 1{
//    				if self in red_small_tree_list and color = #red{
//    					color <- #black;
////		    			write self;
////	    				write color;
////						write initial_seed;
//						total_seeds <- total_seeds + initial_seed;
//	    				total_small_tree_seeds <- total_small_tree_seeds + initial_seed;
//	    				limit_harvest_per_action <- limit_harvest_per_action + 1;
//	    				write "Player collect " + initial_seed + " seeds from small tree. | Total: " + total_seeds;
//    				}	
//				}
//	    	}
//	    	ask medium_tree at_distance collect_seeds_distance{
//    			if limit_harvest_per_action < 1{
//    				if self in red_medium_tree_list and color = #red{
//    					color <- #black;
////		    			write self;
////	    				write color;
////						write initial_seed;
//						total_seeds <- total_seeds + initial_seed;
//	    				total_medium_tree_seeds <- total_medium_tree_seeds + initial_seed;
//	    				limit_harvest_per_action <- limit_harvest_per_action + 1;
//	    				write "Player collect " + initial_seed + " seeds from medium tree. | Total: " + total_seeds;
//    				}	
//				}
//	    	}
//	    	ask big_tree at_distance collect_seeds_distance{
//    			if limit_harvest_per_action < 1{
//    				if self in red_big_tree_list and color = #red{
//    					color <- #black;
////		    			write self;
////	    				write color;
////						write initial_seed;
//						total_seeds <- total_seeds + initial_seed;
//	    				total_big_tree_seeds <- total_big_tree_seeds + initial_seed;
//	    				limit_harvest_per_action <- limit_harvest_per_action + 1;
//	    				write "Player collect " + initial_seed + " seeds from big tree. | Total: " + total_seeds;
//    				}	
//				}
//	    	}
    	}
    }
	output{
//		layout #split;
		display "Main" type: 3d background: rgb(50,50,50){
			camera 'default' locked:true; //location: {445,750,750} 
			
			species river;
			species road;
			species tree_type1;
			species tree_type2;
			species tree_type3;
			species tree_type4;
			species tree_type5;
			species tree_type6;
			species tree_type7;
			species tree_type8;
			species tree_type9;
			species tree_type10;
			species tree_type11;
			species tree_type12;
			species player;
			
			event #mouse_drag action: move_player ; 
			event 'c' action: collect_seeds;
		}
		display "Summary" type: 2d {
			chart "Number of seeds collected" type:histogram
			y_range:[0, 10+total_seeds]
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
//				data "Total" value:total_seeds
//				style:stack
//				color:#red;
			}
		}
		monitor "Number of seeds" value:total_seeds;
	}
}

