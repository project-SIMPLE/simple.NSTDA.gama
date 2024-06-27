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
	int n_tree_type1 <- 100;
	int n_tree_type2 <- 100;
	int n_tree_type3 <- 100;
	int n_tree_type4 <- 100;
	int n_tree_type5 <- 100;
	int n_tree_type6 <- 100;
	int n_tree_type7 <- 100;
	int n_tree_type8 <- 100;
	int n_tree_type9 <- 100;
	int n_tree_type10 <- 100;
	int n_tree_type11 <- 100;
	int n_tree_type12 <- 100;
	int collect_seeds_distance <- 5;
	int month_duration <- 5000;
	
	int size <- 3 ;
	
	// Variable
	int total_seeds <- 0;
	int total_big_tree_seeds <- 0;
	int total_medium_tree_seeds <- 0;
	int total_small_tree_seeds <- 0;
	
	list<string> month_list <- ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"];
	string current_month <- "1" update: month_list[(cycle div month_duration) mod 12];
	int past_month <- 0;
//	int current_day <- 0 update: int(((cycle-(past_month*month_duration))/month_duration)*30);
	int current_day <- 0 update: int((cycle/month_duration)*30);
	
	reflex write{
//		write current_month;
//		write ((cycle+((int(current_month)-1)*month_duration)));
		write current_day;
	}
//	reflex change_month when: current_day=30{
//		current_day <- 1;
//		past_month <- past_month + 1;
//	}

	reflex show_month{
//		draw "Current Month:" + current_month;
	}
	
	float max_radius <- 200.0;
	float x_river <- 0.0 ;
	float y_river <- 442.0 ;
	
	init {
		list tree_loc_list <- (list(-10,-9,-8,-7,-6,-5,5,6,7,8,9,10));
		float x_max <- sqrt((max_radius^2)/2);
//		write(x_max);
		
		create river{
			location <- {x_river, y_river, 0.0};
		}
		
		create road from: roads_shape_file ;
		
		create player{
			location <- any_location_in(any(road));
		}
		
		create tree_type1 number:n_tree_type1{
			point at_location <- any_location_in(any(road));
			point target_location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
			location <- target_location;
		}
		
		create tree_type2 number:n_tree_type2{
			point at_location <- any_location_in(any(road));
			point target_location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
			location <- target_location;
		}
		
		create tree_type3 number:n_tree_type3{
			point at_location <- any_location_in(any(road));
			point target_location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
			location <- target_location;
		}
		
		create tree_type4 number:n_tree_type4{
			point at_location <- any_location_in(any(road));
			point target_location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
			location <- target_location;
		}
		
		create tree_type5 number:n_tree_type5{
			point at_location <- any_location_in(any(road));
			point target_location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
			location <- target_location;
		}
		
		create tree_type6 number:n_tree_type6{
			bool false_position <- true;

			loop while: false_position{
				point at_location <- any_location_in(any(road));
				float distance <- sqrt(((x_river - at_location.x)^2) + ((y_river - at_location.y)^2));

				loop while: distance > max_radius{
					at_location <- any_location_in(any(road)) ;
					distance <- sqrt(((x_river - at_location.x)^2) + ((y_river - at_location.y)^2));
				}
				float p_x_y <- 1 - (distance/max_radius) ;
//				write(p_x_y) ;
				bool create_or_not <- flip(p_x_y);
//				write(create_or_not) ;
				if create_or_not{
//					write("pass!");
					false_position <- false;
					point target_location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};		
					location <- target_location;	
				}
			}
		}
	}
	
	reflex growth_up{
		ask tree_type1{
			if current_month in list_of_month_state1{
				self.color <- rgb(117, 148, 69) ; //rgb(43, 150, 0) ; 
				can_collect <- false ;
			}
			else if current_month in list_of_month_state2{
				self.color <- rgb(133, 134, 66) ; //rgb(255, 89, 149) ;
				can_collect <- false ;
			}
			else if current_month in list_of_month_state3{
				self.color <- rgb(165, 105, 60) ; //rgb(229, 250, 0) ;
				can_collect <- false ;
			}
			else if current_month in list_of_month_state4{
				self.color <- rgb(198, 76, 54) ; //rgb(250, 0, 0) ;
				initial_seed <- rnd(1,10);
				can_collect <- true ;
			}
		}
		
		ask tree_type2{
			if current_month in list_of_month_state1{
				self.color <- rgb(117, 148, 69) ; //rgb(43, 150, 0) ; 
				can_collect <- false ;
			}
			else if current_month in list_of_month_state2{
				self.color <- rgb(133, 134, 66) ; //rgb(255, 89, 149) ;
				can_collect <- false ;
			}
			else if current_month in list_of_month_state3{
				self.color <- rgb(165, 105, 60) ; //rgb(229, 250, 0) ;
				can_collect <- false ;
			}
			else if current_month in list_of_month_state4{
				self.color <- rgb(198, 76, 54) ; //rgb(250, 0, 0) ;
				initial_seed <- rnd(1,10);
				can_collect <- true ;
			}
		}
		
		ask tree_type3{
			if current_month in list_of_month_state1{
				self.color <- rgb(117, 148, 69) ; //rgb(43, 150, 0) ; 
				can_collect <- false ;
			}
			else if current_month in list_of_month_state2{
				self.color <- rgb(133, 134, 66) ; //rgb(255, 89, 149) ;
				can_collect <- false ;
			}
			else if current_month in list_of_month_state3{
				self.color <- rgb(165, 105, 60) ; //rgb(229, 250, 0) ;
				can_collect <- false ;
			}
			else if current_month in list_of_month_state4{
				self.color <- rgb(198, 76, 54) ; //rgb(250, 0, 0) ;
				initial_seed <- rnd(1,10);
				can_collect <- true ;
			}
		}
		
		ask tree_type4{
			if current_month in list_of_month_state1{
				self.color <- rgb(117, 148, 69) ; //rgb(43, 150, 0) ; 
				can_collect <- false ;
			}
			else if current_month in list_of_month_state2{
				self.color <- rgb(133, 134, 66) ; //rgb(255, 89, 149) ;
				can_collect <- false ;
			}
			else if current_month in list_of_month_state3{
				self.color <- rgb(165, 105, 60) ; //rgb(229, 250, 0) ;
				can_collect <- false ;
			}
			else if current_month in list_of_month_state4{
				self.color <- rgb(198, 76, 54) ; //rgb(250, 0, 0) ;
				initial_seed <- rnd(1,10);
				can_collect <- true ;
			}
		}
		
		ask tree_type5{
			if current_month in list_of_month_state1{
				self.color <- rgb(117, 148, 69) ; //rgb(43, 150, 0) ; 
				can_collect <- false ;
			}
			else if current_month in list_of_month_state2{
				self.color <- rgb(133, 134, 66) ; //rgb(255, 89, 149) ;
				can_collect <- false ;
			}
			else if current_month in list_of_month_state3{
				self.color <- rgb(165, 105, 60) ; //rgb(229, 250, 0) ;
				can_collect <- false ;
			}
			else if current_month in list_of_month_state4{
				self.color <- rgb(198, 76, 54) ; //rgb(250, 0, 0) ;
				initial_seed <- rnd(1,10);
				can_collect <- true ;
			}
		}
		
		ask tree_type6{
			if current_month in list_of_month_state1{
				self.color <- rgb(117, 148, 69) ; //rgb(43, 150, 0) ; 
				can_collect <- false ;
			}
			else if current_month in list_of_month_state2{
				self.color <- rgb(133, 134, 66) ; //rgb(255, 89, 149) ;
				can_collect <- false ;
			}
			else if current_month in list_of_month_state3{
				self.color <- rgb(165, 105, 60) ; //rgb(229, 250, 0) ;
				can_collect <- false ;
			}
			else if current_month in list_of_month_state4{
				self.color <- rgb(198, 76, 54) ; //rgb(250, 0, 0) ;
				initial_seed <- rnd(1,10);
				can_collect <- true ;
			}
		}
	}
	
	reflex do_pause when: (cycle mod (3*month_duration) = 0) and (cycle != 0) {
		do pause;
	}
	
	action do_start{
		do resume;
	}
}

species tree_type1{
	bool can_collect ;
	int initial_seed <- 0;
	rgb color <- rgb(43, 150, 0);
	list list_of_month_state1 <- ["1", "2", "3", "10", "11", "12"];
	list list_of_month_state2 <- ["4", "5"];
	list list_of_month_state3 <- ["6", "7"];
	list list_of_month_state4 <- ["8", "9"];
	aspect default{
		draw sphere(3+size#m) color:color;
	}
}

species tree_type2{
	bool can_collect ;
	int initial_seed <- 0;
	rgb color <- rgb(43, 150, 0);
	list list_of_month_state1 <- ["1", "2", "3", "11", "12"];
	list list_of_month_state2 <- ["4"];
	list list_of_month_state3 <- ["5", "6", "7", "8"];
	list list_of_month_state4 <- ["9", "10"];
	aspect default{
		draw cylinder(3+size#m, 3+size#m) color:color;
	}
}

species tree_type3{
	bool can_collect ;
	int initial_seed <- 0;
	rgb color <- rgb(43, 150, 0);
	list list_of_month_state1 <- ["1", "2", "3", "4", "5", "6"];
	list list_of_month_state2 <- ["7", "8"];
	list list_of_month_state3 <- ["9", "10"];
	list list_of_month_state4 <- ["11", "12"];
	aspect default{
		draw cube(4+size#m) color:color;
	}
}

species tree_type4{
	bool can_collect ;
	int initial_seed <- 0;
	rgb color <- rgb(43, 150, 0);
	list list_of_month_state1 <- ["1", "8", "9", "10", "11", "12"];
	list list_of_month_state2 <- ["2", "3"];
	list list_of_month_state3 <- ["4", "5"];
	list list_of_month_state4 <- ["6", "7"];
	aspect default{
		draw pyramid(5+size#m) color:color;
	}
}

species tree_type5{
	bool can_collect ;
	int initial_seed <- 0;
	rgb color <- rgb(43, 150, 0);
	list list_of_month_state1 <- ["6", "7", "8", "9", "10"];
	list list_of_month_state2 <- ["11", "12"];
	list list_of_month_state3 <- ["1", "2"];
	list list_of_month_state4 <- ["3", "4", "5"];
	aspect default{
		draw teapot(3+size#m) color:color;
	}
}

species tree_type6{
	bool can_collect ;
	int initial_seed <- 0;
	rgb color <- rgb(43, 150, 0);
	list list_of_month_state1 <- ["4", "5", "6", "7", "8"];
	list list_of_month_state2 <- ["9", "10"];
	list list_of_month_state3 <- ["11", "12"];
	list list_of_month_state4 <- ["1", "2", "3"];
	aspect default{
		draw cone3D(3+size#m, 5+size#m) color:color;
	}
}

species road skills: [road_skill] {
	aspect default {
		draw shape + 1 color: #white depth:1;
	}
}

species player{
	aspect default {
		draw sphere(10#m) color: #purple border:#black;
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
	
	output{
		layout #vertical;
		display "Main" type: 3d background: rgb(50,50,50){
			camera 'default' locked:false;
			
			species river;
			species road;
			species tree_type1;
			species tree_type2;
			species tree_type3;
			species tree_type4;
			species tree_type5;
			species tree_type6;
//			species player;
			
//			event #mouse_drag action: move_player ; 
			event 's' {
				ask world{
					do do_start;
				}
			}
		}
		display "Month" type: 2d {
			chart "Progress" type:histogram reverse_axes:true
			y_range:[1, 360]
			x_serie_labels: [""]
			style:"3d"
			series_label_position: xaxis
			{
				data "Days" value:current_day
				color:#green;
//				data "Months" value:int(current_month)
//				color:#yellow;
			}
		}

//		display "Summary" type: 2d {
//			chart "Number of seeds collected" type:histogram
//			y_range:[0, 10+total_seeds]
//			x_serie_labels: ["Collected from"]
//			style:"3d"
//			series_label_position: xaxis
//			{
//				data "Small tree" value:total_small_tree_seeds
//				color:#yellow;
//				data "Medium tree" value:total_medium_tree_seeds
//				color:#green;
//				data "Big tree" value:total_big_tree_seeds
//				color:#blue;
//			}
//		}
//		monitor "Number of seeds" value:total_seeds;
//		monitor "Month" value:int(current_month);
	}
}

