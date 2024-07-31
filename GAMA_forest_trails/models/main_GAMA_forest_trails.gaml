/**
* Name: test_shapefile
* Based on the internal empty template. 
* Author: lilti
* Tags: 
*/

model GAMA_forest_trails

import "species.gaml"

global {	
	//	shape_file roads_shape_file <- shape_file("../includes/Trail_4_5.shp");
	shape_file roads_shape_file <- shape_file("../includes/cir.shp");
	shape_file border_shape_file <- shape_file("../includes/rec.shp");
	geometry bg_in <- geometry(shape_file("../includes/incir.shp"));
	geometry bg_out <- geometry(shape_file("../includes/outcir.shp"));
	geometry free_space <- bg_out - bg_in ;
	geometry shape <- envelope(border_shape_file);
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
	int n_tree_type12 <- 50;
	int n_tree_type13 <- 50;
	int n_tree_type14 <- 50;
	int n_tree_type15 <- 50;
	int n_tree_type16 <- 50;
	int n_tree_type17 <- 50;
	int n_tree_type18 <- 50;
	int collect_seeds_distance <- 5;
	int stop_time <- 10; //second
	int stop_every_n_turn <- 2; //turn
	
	// Variable
	list total_seeds_team1 <- [0,0,0,0,0,0,0,0,0,0,0,0];
	list total_seeds_team2 <- [0,0,0,0,0,0,0,0,0,0,0,0];
	list total_seeds_team3 <- [0,0,0,0,0,0,0,0,0,0,0,0];
	list total_seeds_team4 <- [0,0,0,0,0,0,0,0,0,0,0,0];
	list total_seeds_team5 <- [0,0,0,0,0,0,0,0,0,0,0,0];
	list total_seeds_team6 <- [0,0,0,0,0,0,0,0,0,0,0,0];
	list total_alien_seeds_team1 <- [0,0,0,0,0,0,0,0,0,0,0,0];
	list total_alien_seeds_team2 <- [0,0,0,0,0,0,0,0,0,0,0,0];
	list total_alien_seeds_team3 <- [0,0,0,0,0,0,0,0,0,0,0,0];
	list total_alien_seeds_team4 <- [0,0,0,0,0,0,0,0,0,0,0,0];
	list total_alien_seeds_team5 <- [0,0,0,0,0,0,0,0,0,0,0,0];
	list total_alien_seeds_team6 <- [0,0,0,0,0,0,0,0,0,0,0,0];
	list sum_total_seeds_team <- [0,0,0,0,0,0];
	
	list alien_tree <- [];
	
	list tree_loc_list <- (list(-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8));
	float x_max <- sqrt((max_radius^2)/2);
		
	float width <- shape.width;
	float height <- shape.height;
	
	float x_river <- 0.0 ;
	float y_river <-  260.0 ; //442.0
	
	int init_time <- 0;
	int time_now <- 0;
	int count_start <- 0 ;
	bool can_start <- true ;
	
	int current_time <- 1 ;
	float current_day <- 0.0 ;
	int max_day <- 84;
	int max_time <- stop_time * 6;
	
	rgb color_state1 <- rgb(117, 148, 69);
	rgb color_state2 <- rgb(133, 134, 66);
	rgb color_state3 <- rgb(165, 105, 60);
	rgb color_state4 <- rgb(198, 76, 54);
	
	int upper_bound;
	int max_total_seed;
	
	reflex update_time_and_bound{
		if (gama.machine_time div 1000) - init_time = 1{
			init_time <- gama.machine_time div 1000;
			time_now <- time_now + 1;
		}
		current_time <- int((time_now-0.1) div (stop_time / stop_every_n_turn))+1;
		current_day <- (time_now / (stop_time / stop_every_n_turn)) * 7;
		
		write "Time now: " + time_now + " Current turn: " + current_time + " Current day: " + int(current_day);
		
		upper_bound <- max(max(total_seeds_team1), max(total_seeds_team2), max(total_seeds_team3),
			max(total_seeds_team4), max(total_seeds_team5), max(total_seeds_team6));
			
		sum_total_seeds_team[0] <- sum(total_seeds_team1)+ sum(total_alien_seeds_team1);
		sum_total_seeds_team[1] <- sum(total_seeds_team2)+ sum(total_alien_seeds_team2);
		sum_total_seeds_team[2] <- sum(total_seeds_team3)+ sum(total_alien_seeds_team3);
		sum_total_seeds_team[3] <- sum(total_seeds_team4)+ sum(total_alien_seeds_team4);
		sum_total_seeds_team[4] <- sum(total_seeds_team5)+ sum(total_alien_seeds_team5);
		sum_total_seeds_team[5] <- sum(total_seeds_team6)+ sum(total_alien_seeds_team6);
		max_total_seed <- max(sum_total_seeds_team);
//		write(max_total_seed);
	}
	
	reflex write{
		if flip(0.1){
			do collect(rnd(1,6),rnd(1,12),rnd(1,10), true);
		}
		if flip(0.1){
			do collect(rnd(1,6),rnd(1,12),rnd(1,10), false);
		}
	}
	
	reflex restart when:current_day=max_day{
		time_now <- 0;
		count_start <- 0 ;
	}
	
	reflex do_resume when: (not paused) and can_start{
		if user_confirm("Confirmation","Do you want to confirm?"){
			ask sign{
				icon <- stop;
				write "change to stop icon.";
			}
			count_start <- count_start + 1 ;
			init_time <- gama.machine_time div 1000;
			can_start <- false ;
		}
		else{
			do pause;
		}
	}
	
	reflex do_pause when: (time_now >= stop_time*count_start) and (cycle != 0) {
		ask sign{
			icon <- play;
			write "change to start icon.";
		}
		can_start <- true ;
		do pause;
	}
	
	
	init {
		create bg from: list(free_space);
		
		create sign{
			location <- {width/3 - 35, -45, 0};
		}
		
//		write(x_max);
		
		create river{
			location <- {x_river, y_river, 0.0};
		}
		
		create road from: roads_shape_file ;

		loop i from:1 to:6{
			create player{
				team <- i;
				location <- any_location_in(any(road));
			}
		}
		
		create tree number:n_tree_type1{
			tree_type <- 1;
			list_of_month_state1 <- [1, 2, 3, 10, 11, 12];
			list_of_month_state2 <- [4, 5];
			list_of_month_state3 <- [6, 7];
			list_of_month_state4 <- [8, 9];
			shape <- circle(3+size#m);
			
			point at_location <- any_location_in(any(road));
			location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
		}
		
		create tree number:n_tree_type2{
			tree_type <- 2;
			list_of_month_state1 <- [1, 2, 3, 11, 12];
			list_of_month_state2 <- [4];
			list_of_month_state3 <- [5, 6, 7, 8];
			list_of_month_state4 <- [9, 10];
			shape <- triangle(7+size#m);
			
			point at_location <- any_location_in(any(road));
			location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
		}
		
		create tree number:n_tree_type3{
			tree_type <- 3;
			list_of_month_state1 <- [1, 2, 3, 4, 5, 6];
			list_of_month_state2 <- [7, 8];
			list_of_month_state3 <- [9, 10];
			list_of_month_state4 <- [11, 12];
			shape <- square(5+size#m);
			
			point at_location <- any_location_in(any(road));
			location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
		}
		
		create tree number:n_tree_type4{
			tree_type <- 4;
			list_of_month_state1 <- [1, 8, 9, 10, 11, 12];
			list_of_month_state2 <- [2, 3];
			list_of_month_state3 <- [4, 5];
			list_of_month_state4 <- [6, 7];
			shape <- hexagon(7+size#m);
	
			point at_location <- any_location_in(any(road));
			location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
		}
		
		create tree number:n_tree_type5{
			tree_type <- 5;
			list_of_month_state1 <- [6, 7, 8, 9, 10];
			list_of_month_state2 <- [11, 12];
			list_of_month_state3 <- [1, 2];
			list_of_month_state4 <- [3, 4, 5];
			shape <- hexagon(7+size#m);
			
			point at_location <- any_location_in(any(road));
			location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
		}
		
		create tree number:n_tree_type6{
			tree_type <- 6;
			list_of_month_state1 <- [4, 5, 6, 7, 8];
			list_of_month_state2 <- [9, 10];
			list_of_month_state3 <- [11, 12];
			list_of_month_state4 <- [1, 2, 3];
			shape <- circle(3+size#m);
			
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
					location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};			
				}
			}
		}
		
		create tree number:n_tree_type7{
			tree_type <- 7;
			list_of_month_state1 <- [1, 2, 3, 10, 11, 12];
			list_of_month_state2 <- [4, 5];
			list_of_month_state3 <- [6, 7];
			list_of_month_state4 <- [8, 9];
			shape <- circle(3+size#m);
			
			point at_location <- any_location_in(any(road));
			location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
		}
		
		create tree number:n_tree_type8{
			tree_type <- 8;
			list_of_month_state1 <- [1, 2, 3, 11, 12];
			list_of_month_state2 <- [4];
			list_of_month_state3 <- [5, 6, 7, 8];
			list_of_month_state4 <- [9, 10];
			shape <- triangle(7+size#m);
			
			point at_location <- any_location_in(any(road));
			location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
		}
		
		create tree number:n_tree_type9{
			tree_type <- 9;
			list_of_month_state1 <- [1, 2, 3, 4, 5, 6];
			list_of_month_state2 <- [7, 8];
			list_of_month_state3 <- [9, 10];
			list_of_month_state4 <- [11, 12];
			shape <- square(5+size#m);
			
			point at_location <- any_location_in(any(road));
			location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
		}
		
		create tree number:n_tree_type10{
			tree_type <- 10;
			list_of_month_state1 <- [1, 8, 9, 10, 11, 12];
			list_of_month_state2 <- [2, 3];
			list_of_month_state3 <- [4, 5];
			list_of_month_state4 <- [6, 7];
			shape <- hexagon(7+size#m);
			
			point at_location <- any_location_in(any(road));
			location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
		}
		
		create tree number:n_tree_type11{
			tree_type <- 11;
			list_of_month_state1 <- [6, 7, 8, 9, 10];
			list_of_month_state2 <- [11, 12];
			list_of_month_state3 <- [1, 2];
			list_of_month_state4 <- [3, 4, 5];
			shape <- hexagon(7+size#m);
			
			point at_location <- any_location_in(any(road));
			location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
		}
		
		create tree number:n_tree_type12{
			tree_type <- 12;
			list_of_month_state1 <- [4, 5, 6, 7, 8];
			list_of_month_state2 <- [9, 10];
			list_of_month_state3 <- [11, 12];
			list_of_month_state4 <- [1, 2, 3];
			shape <- circle(3+size#m);
			
			point at_location <- any_location_in(any(road));
			location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
		}
		
	}
	
	reflex growth_up{ 
		ask tree{
			if not it_alien{
				switch current_time {
					match_one list_of_month_state1{
						self.color <- color_state1 ;
						initial_seed <- 0;
						can_collect <- false ;
					}
					match_one list_of_month_state2{
						self.color <- color_state2 ;
						initial_seed <- 0;
						can_collect <- false ;
					}
					match_one list_of_month_state3{
						self.color <- color_state3 ;
						initial_seed <- 0;
						can_collect <- false ;
					}
					match_one list_of_month_state4{
						self.color <- color_state4 ;
						initial_seed <- rnd(1,10);
						can_collect <- true ;
					}
				}	
			}
			else{
				switch current_time {
					match_one list_of_month_state1{
						initial_seed <- 0;
						can_collect <- false ;
					}
					match_one list_of_month_state2{
						initial_seed <- 0;
						can_collect <- false ;
					}
					match_one list_of_month_state3{
						initial_seed <- 0;
						can_collect <- false ;
					}
					match_one list_of_month_state4{
						initial_seed <- rnd(1,10);
						can_collect <- true ;
					}
				}	
			}
		}
	}
		
	action collect(int team, int id, int n, bool alien){
		switch team{
			match 1 {
				if not alien{
					switch id {
						match 1 {
							total_seeds_team1[0] <- total_seeds_team1[0] + n ;
							write "Total seeds type1: " + total_seeds_team1[0];
						}
						match 2 {
							total_seeds_team1[1] <- total_seeds_team1[1] + n ;
							write "Total seeds type2: " + total_seeds_team1[1];
						}
						match 3 {
							total_seeds_team1[2] <- total_seeds_team1[2] + n ;
							write "Total seeds type3: " + total_seeds_team1[2];
						}
						match 4 {
							total_seeds_team1[3] <- total_seeds_team1[3] + n ;
							write "Total seeds type4: " + total_seeds_team1[3];
						}
						match 5 {
							total_seeds_team1[4] <- total_seeds_team1[4] + n ;
							write "Total seeds type5: " + total_seeds_team1[4];
						}
						match 6 {
							total_seeds_team1[5] <- total_seeds_team1[5] + n ;
							write "Total seeds type6: " + total_seeds_team1[5];
						}
						match 7 {
							total_seeds_team1[6] <- total_seeds_team1[6] + n ;
							write "Total seeds type7: " + total_seeds_team1[6];
						}
						match 8 {
							total_seeds_team1[7] <- total_seeds_team1[7] + n ;
							write "Total seeds type8: " + total_seeds_team1[7];
						}
						match 9 {
							total_seeds_team1[8] <- total_seeds_team1[8] + n ;
							write "Total seeds type9: " + total_seeds_team1[8];
						}
						match 10 {
							total_seeds_team1[9] <- total_seeds_team1[9] + n ;
							write "Total seeds type10: " + total_seeds_team1[9];
						}
						match 11 {
							total_seeds_team1[10] <- total_seeds_team1[10] + n ;
							write "Total seeds type11: " + total_seeds_team1[10];
						}
						match 12 {
							total_seeds_team1[11] <- total_seeds_team1[11] + n ;
							write "Total seeds type12: " + total_seeds_team1[11];
						}
					}
				}
				else {
					switch id {
						match 1 {
							total_alien_seeds_team1[0] <- total_alien_seeds_team1[0] + n ;
							write "Total alien seeds type1: " + total_alien_seeds_team1[0];
						}
						match 2 {
							total_alien_seeds_team1[1] <- total_alien_seeds_team1[1] + n ;
							write "Total alien seeds type2: " + total_alien_seeds_team1[1];
						}
						match 3 {
							total_alien_seeds_team1[2] <- total_alien_seeds_team1[2] + n ;
							write "Total alien seeds type3: " + total_alien_seeds_team1[2];
						}
						match 4 {
							total_alien_seeds_team1[3] <- total_alien_seeds_team1[3] + n ;
							write "Total alien seeds type4: " + total_alien_seeds_team1[3];
						}
						match 5 {
							total_alien_seeds_team1[4] <- total_alien_seeds_team1[4] + n ;
							write "Total alien seeds type5: " + total_alien_seeds_team1[4];
						}
						match 6 {
							total_alien_seeds_team1[5] <- total_alien_seeds_team1[5] + n ;
							write "Total alien seeds type6: " + total_alien_seeds_team1[5];
						}
						match 7 {
							total_alien_seeds_team1[6] <- total_alien_seeds_team1[6] + n ;
							write "Total alien seeds type7: " + total_alien_seeds_team1[6];
						}
						match 8 {
							total_alien_seeds_team1[7] <- total_alien_seeds_team1[7] + n ;
							write "Total alien seeds type8: " + total_alien_seeds_team1[7];
						}
						match 9 {
							total_alien_seeds_team1[8] <- total_alien_seeds_team1[8] + n ;
							write "Total alien seeds type9: " + total_alien_seeds_team1[8];
						}
						match 10 {
							total_alien_seeds_team1[9] <- total_alien_seeds_team1[9] + n ;
							write "Total alien seeds type10: " + total_alien_seeds_team1[9];
						}
						match 11 {
							total_alien_seeds_team1[10] <- total_alien_seeds_team1[10] + n ;
							write "Total alien seeds type11: " + total_alien_seeds_team1[10];
						}
						match 12 {
							total_alien_seeds_team1[11] <- total_alien_seeds_team1[11] + n ;
							write "Total alien seeds type12: " + total_alien_seeds_team1[11];
						}
					}
				}
			}
			match 2 {
				if not alien{
					switch id {
						match 1 {
							total_seeds_team2[0] <- total_seeds_team2[0] + n ;
							write "Total seeds type1: " + total_seeds_team2[0];
						}
						match 2 {
							total_seeds_team2[1] <- total_seeds_team2[1] + n ;
							write "Total seeds type2: " + total_seeds_team2[1];
						}
						match 3 {
							total_seeds_team2[2] <- total_seeds_team2[2] + n ;
							write "Total seeds type3: " + total_seeds_team2[2];
						}
						match 4 {
							total_seeds_team2[3] <- total_seeds_team2[3] + n ;
							write "Total seeds type4: " + total_seeds_team2[3];
						}
						match 5 {
							total_seeds_team2[4] <- total_seeds_team2[4] + n ;
							write "Total seeds type5: " + total_seeds_team2[4];
						}
						match 6 {
							total_seeds_team2[5] <- total_seeds_team2[5] + n ;
							write "Total seeds type6: " + total_seeds_team2[5];
						}
						match 7 {
							total_seeds_team2[6] <- total_seeds_team2[6] + n ;
							write "Total seeds type7: " + total_seeds_team2[6];
						}
						match 8 {
							total_seeds_team2[7] <- total_seeds_team2[7] + n ;
							write "Total seeds type8: " + total_seeds_team2[7];
						}
						match 9 {
							total_seeds_team2[8] <- total_seeds_team2[8] + n ;
							write "Total seeds type9: " + total_seeds_team2[8];
						}
						match 10 {
							total_seeds_team2[9] <- total_seeds_team2[9] + n ;
							write "Total seeds type10: " + total_seeds_team2[9];
						}
						match 11 {
							total_seeds_team2[10] <- total_seeds_team2[10] + n ;
							write "Total seeds type11: " + total_seeds_team2[10];
						}
						match 12 {
							total_seeds_team2[11] <- total_seeds_team2[11] + n ;
							write "Total seeds type12: " + total_seeds_team2[11];
						}
					}
				}
				else {
					switch id {
						match 1 {
							total_alien_seeds_team2[0] <- total_alien_seeds_team2[0] + n ;
							write "Total alien seeds type1: " + total_alien_seeds_team2[0];
						}
						match 2 {
							total_alien_seeds_team2[1] <- total_alien_seeds_team2[1] + n ;
							write "Total alien seeds type2: " + total_alien_seeds_team2[1];
						}
						match 3 {
							total_alien_seeds_team2[2] <- total_alien_seeds_team2[2] + n ;
							write "Total alien seeds type3: " + total_alien_seeds_team2[2];
						}
						match 4 {
							total_alien_seeds_team2[3] <- total_alien_seeds_team2[3] + n ;
							write "Total alien seeds type4: " + total_alien_seeds_team2[3];
						}
						match 5 {
							total_alien_seeds_team2[4] <- total_alien_seeds_team2[4] + n ;
							write "Total alien seeds type5: " + total_alien_seeds_team2[4];
						}
						match 6 {
							total_alien_seeds_team2[5] <- total_alien_seeds_team2[5] + n ;
							write "Total alien seeds type6: " + total_alien_seeds_team2[5];
						}
						match 7 {
							total_alien_seeds_team2[6] <- total_alien_seeds_team2[6] + n ;
							write "Total alien seeds type7: " + total_alien_seeds_team2[6];
						}
						match 8 {
							total_alien_seeds_team2[7] <- total_alien_seeds_team2[7] + n ;
							write "Total alien seeds type8: " + total_alien_seeds_team2[7];
						}
						match 9 {
							total_alien_seeds_team2[8] <- total_alien_seeds_team2[8] + n ;
							write "Total alien seeds type9: " + total_alien_seeds_team2[8];
						}
						match 10 {
							total_alien_seeds_team2[9] <- total_alien_seeds_team2[9] + n ;
							write "Total alien seeds type10: " + total_alien_seeds_team2[9];
						}
						match 11 {
							total_alien_seeds_team2[10] <- total_alien_seeds_team2[10] + n ;
							write "Total alien seeds type11: " + total_alien_seeds_team2[10];
						}
						match 12 {
							total_alien_seeds_team2[11] <- total_alien_seeds_team2[11] + n ;
							write "Total alien seeds type12: " + total_alien_seeds_team2[11];
						}
					}
				}
			}
			match 3 {
				if not alien{
					switch id {
						match 1 {
							total_seeds_team3[0] <- total_seeds_team3[0] + n ;
							write "Total seeds type1: " + total_seeds_team3[0];
						}
						match 2 {
							total_seeds_team3[1] <- total_seeds_team3[1] + n ;
							write "Total seeds type2: " + total_seeds_team3[1];
						}
						match 3 {
							total_seeds_team3[2] <- total_seeds_team3[2] + n ;
							write "Total seeds type3: " + total_seeds_team3[2];
						}
						match 4 {
							total_seeds_team3[3] <- total_seeds_team3[3] + n ;
							write "Total seeds type4: " + total_seeds_team3[3];
						}
						match 5 {
							total_seeds_team3[4] <- total_seeds_team3[4] + n ;
							write "Total seeds type5: " + total_seeds_team3[4];
						}
						match 6 {
							total_seeds_team3[5] <- total_seeds_team3[5] + n ;
							write "Total seeds type6: " + total_seeds_team3[5];
						}
						match 7 {
							total_seeds_team3[6] <- total_seeds_team3[6] + n ;
							write "Total seeds type7: " + total_seeds_team3[6];
						}
						match 8 {
							total_seeds_team3[7] <- total_seeds_team3[7] + n ;
							write "Total seeds type8: " + total_seeds_team3[7];
						}
						match 9 {
							total_seeds_team3[8] <- total_seeds_team3[8] + n ;
							write "Total seeds type9: " + total_seeds_team3[8];
						}
						match 10 {
							total_seeds_team3[9] <- total_seeds_team3[9] + n ;
							write "Total seeds type10: " + total_seeds_team3[9];
						}
						match 11 {
							total_seeds_team3[10] <- total_seeds_team3[10] + n ;
							write "Total seeds type11: " + total_seeds_team3[10];
						}
						match 12 {
							total_seeds_team3[11] <- total_seeds_team3[11] + n ;
							write "Total seeds type12: " + total_seeds_team3[11];
						}
					}
				}
				else {
					switch id {
						match 1 {
							total_alien_seeds_team3[0] <- total_alien_seeds_team3[0] + n ;
							write "Total alien seeds type1: " + total_alien_seeds_team3[0];
						}
						match 2 {
							total_alien_seeds_team3[1] <- total_alien_seeds_team3[1] + n ;
							write "Total alien seeds type2: " + total_alien_seeds_team3[1];
						}
						match 3 {
							total_alien_seeds_team3[2] <- total_alien_seeds_team3[2] + n ;
							write "Total alien seeds type3: " + total_alien_seeds_team3[2];
						}
						match 4 {
							total_alien_seeds_team3[3] <- total_alien_seeds_team3[3] + n ;
							write "Total alien seeds type4: " + total_alien_seeds_team3[3];
						}
						match 5 {
							total_alien_seeds_team3[4] <- total_alien_seeds_team3[4] + n ;
							write "Total alien seeds type5: " + total_alien_seeds_team3[4];
						}
						match 6 {
							total_alien_seeds_team3[5] <- total_alien_seeds_team3[5] + n ;
							write "Total alien seeds type6: " + total_alien_seeds_team3[5];
						}
						match 7 {
							total_alien_seeds_team3[6] <- total_alien_seeds_team3[6] + n ;
							write "Total alien seeds type7: " + total_alien_seeds_team3[6];
						}
						match 8 {
							total_alien_seeds_team3[7] <- total_alien_seeds_team3[7] + n ;
							write "Total alien seeds type8: " + total_alien_seeds_team3[7];
						}
						match 9 {
							total_alien_seeds_team3[8] <- total_alien_seeds_team3[8] + n ;
							write "Total alien seeds type9: " + total_alien_seeds_team3[8];
						}
						match 10 {
							total_alien_seeds_team3[9] <- total_alien_seeds_team3[9] + n ;
							write "Total alien seeds type10: " + total_alien_seeds_team3[9];
						}
						match 11 {
							total_alien_seeds_team3[10] <- total_alien_seeds_team3[10] + n ;
							write "Total alien seeds type11: " + total_alien_seeds_team3[10];
						}
						match 12 {
							total_alien_seeds_team3[11] <- total_alien_seeds_team3[11] + n ;
							write "Total alien seeds type12: " + total_alien_seeds_team3[11];
						}
					}
				}
			}
			match 4 {
				if not alien{
					switch id {
						match 1 {
							total_seeds_team4[0] <- total_seeds_team4[0] + n ;
							write "Total seeds type1: " + total_seeds_team4[0];
						}
						match 2 {
							total_seeds_team4[1] <- total_seeds_team4[1] + n ;
							write "Total seeds type2: " + total_seeds_team4[1];
						}
						match 3 {
							total_seeds_team4[2] <- total_seeds_team4[2] + n ;
							write "Total seeds type3: " + total_seeds_team4[2];
						}
						match 4 {
							total_seeds_team4[3] <- total_seeds_team4[3] + n ;
							write "Total seeds type4: " + total_seeds_team4[3];
						}
						match 5 {
							total_seeds_team4[4] <- total_seeds_team4[4] + n ;
							write "Total seeds type5: " + total_seeds_team4[4];
						}
						match 6 {
							total_seeds_team4[5] <- total_seeds_team4[5] + n ;
							write "Total seeds type6: " + total_seeds_team4[5];
						}
						match 7 {
							total_seeds_team4[6] <- total_seeds_team4[6] + n ;
							write "Total seeds type7: " + total_seeds_team4[6];
						}
						match 8 {
							total_seeds_team4[7] <- total_seeds_team4[7] + n ;
							write "Total seeds type8: " + total_seeds_team4[7];
						}
						match 9 {
							total_seeds_team4[8] <- total_seeds_team4[8] + n ;
							write "Total seeds type9: " + total_seeds_team4[8];
						}
						match 10 {
							total_seeds_team4[9] <- total_seeds_team4[9] + n ;
							write "Total seeds type10: " + total_seeds_team4[9];
						}
						match 11 {
							total_seeds_team4[10] <- total_seeds_team4[10] + n ;
							write "Total seeds type11: " + total_seeds_team4[10];
						}
						match 12 {
							total_seeds_team4[11] <- total_seeds_team4[11] + n ;
							write "Total seeds type12: " + total_seeds_team4[11];
						}
					}
				}
				else {
					switch id {
						match 1 {
							total_alien_seeds_team4[0] <- total_alien_seeds_team4[0] + n ;
							write "Total alien seeds type1: " + total_alien_seeds_team4[0];
						}
						match 2 {
							total_alien_seeds_team4[1] <- total_alien_seeds_team4[1] + n ;
							write "Total alien seeds type2: " + total_alien_seeds_team4[1];
						}
						match 3 {
							total_alien_seeds_team4[2] <- total_alien_seeds_team4[2] + n ;
							write "Total alien seeds type3: " + total_alien_seeds_team4[2];
						}
						match 4 {
							total_alien_seeds_team4[3] <- total_alien_seeds_team4[3] + n ;
							write "Total alien seeds type4: " + total_alien_seeds_team4[3];
						}
						match 5 {
							total_alien_seeds_team4[4] <- total_alien_seeds_team4[4] + n ;
							write "Total alien seeds type5: " + total_alien_seeds_team4[4];
						}
						match 6 {
							total_alien_seeds_team4[5] <- total_alien_seeds_team4[5] + n ;
							write "Total alien seeds type6: " + total_alien_seeds_team4[5];
						}
						match 7 {
							total_alien_seeds_team4[6] <- total_alien_seeds_team4[6] + n ;
							write "Total alien seeds type7: " + total_alien_seeds_team4[6];
						}
						match 8 {
							total_alien_seeds_team4[7] <- total_alien_seeds_team4[7] + n ;
							write "Total alien seeds type8: " + total_alien_seeds_team4[7];
						}
						match 9 {
							total_alien_seeds_team4[8] <- total_alien_seeds_team4[8] + n ;
							write "Total alien seeds type9: " + total_alien_seeds_team4[8];
						}
						match 10 {
							total_alien_seeds_team4[9] <- total_alien_seeds_team4[9] + n ;
							write "Total alien seeds type10: " + total_alien_seeds_team4[9];
						}
						match 11 {
							total_alien_seeds_team4[10] <- total_alien_seeds_team4[10] + n ;
							write "Total alien seeds type11: " + total_alien_seeds_team4[10];
						}
						match 12 {
							total_alien_seeds_team4[11] <- total_alien_seeds_team4[11] + n ;
							write "Total alien seeds type12: " + total_alien_seeds_team4[11];
						}
					}
				}
			}
			match 5 {
				if not alien{
					switch id {
						match 1 {
							total_seeds_team5[0] <- total_seeds_team5[0] + n ;
							write "Total seeds type1: " + total_seeds_team5[0];
						}
						match 2 {
							total_seeds_team5[1] <- total_seeds_team5[1] + n ;
							write "Total seeds type2: " + total_seeds_team5[1];
						}
						match 3 {
							total_seeds_team5[2] <- total_seeds_team5[2] + n ;
							write "Total seeds type3: " + total_seeds_team5[2];
						}
						match 4 {
							total_seeds_team5[3] <- total_seeds_team5[3] + n ;
							write "Total seeds type4: " + total_seeds_team5[3];
						}
						match 5 {
							total_seeds_team5[4] <- total_seeds_team5[4] + n ;
							write "Total seeds type5: " + total_seeds_team5[4];
						}
						match 6 {
							total_seeds_team5[5] <- total_seeds_team5[5] + n ;
							write "Total seeds type6: " + total_seeds_team5[5];
						}
						match 7 {
							total_seeds_team5[6] <- total_seeds_team5[6] + n ;
							write "Total seeds type7: " + total_seeds_team5[6];
						}
						match 8 {
							total_seeds_team5[7] <- total_seeds_team5[7] + n ;
							write "Total seeds type8: " + total_seeds_team5[7];
						}
						match 9 {
							total_seeds_team5[8] <- total_seeds_team5[8] + n ;
							write "Total seeds type9: " + total_seeds_team5[8];
						}
						match 10 {
							total_seeds_team5[9] <- total_seeds_team5[9] + n ;
							write "Total seeds type10: " + total_seeds_team5[9];
						}
						match 11 {
							total_seeds_team5[10] <- total_seeds_team5[10] + n ;
							write "Total seeds type11: " + total_seeds_team5[10];
						}
						match 12 {
							total_seeds_team5[11] <- total_seeds_team5[11] + n ;
							write "Total seeds type12: " + total_seeds_team5[11];
						}
					}
				}
				else {
					switch id {
						match 1 {
							total_alien_seeds_team5[0] <- total_alien_seeds_team5[0] + n ;
							write "Total alien seeds type1: " + total_alien_seeds_team5[0];
						}
						match 2 {
							total_alien_seeds_team5[1] <- total_alien_seeds_team5[1] + n ;
							write "Total alien seeds type2: " + total_alien_seeds_team5[1];
						}
						match 3 {
							total_alien_seeds_team5[2] <- total_alien_seeds_team5[2] + n ;
							write "Total alien seeds type3: " + total_alien_seeds_team5[2];
						}
						match 4 {
							total_alien_seeds_team5[3] <- total_alien_seeds_team5[3] + n ;
							write "Total alien seeds type4: " + total_alien_seeds_team5[3];
						}
						match 5 {
							total_alien_seeds_team5[4] <- total_alien_seeds_team5[4] + n ;
							write "Total alien seeds type5: " + total_alien_seeds_team5[4];
						}
						match 6 {
							total_alien_seeds_team5[5] <- total_alien_seeds_team5[5] + n ;
							write "Total alien seeds type6: " + total_alien_seeds_team5[5];
						}
						match 7 {
							total_alien_seeds_team5[6] <- total_alien_seeds_team5[6] + n ;
							write "Total alien seeds type7: " + total_alien_seeds_team5[6];
						}
						match 8 {
							total_alien_seeds_team5[7] <- total_alien_seeds_team5[7] + n ;
							write "Total alien seeds type8: " + total_alien_seeds_team5[7];
						}
						match 9 {
							total_alien_seeds_team5[8] <- total_alien_seeds_team5[8] + n ;
							write "Total alien seeds type9: " + total_alien_seeds_team5[8];
						}
						match 10 {
							total_alien_seeds_team5[9] <- total_alien_seeds_team5[9] + n ;
							write "Total alien seeds type10: " + total_alien_seeds_team5[9];
						}
						match 11 {
							total_alien_seeds_team5[10] <- total_alien_seeds_team5[10] + n ;
							write "Total alien seeds type11: " + total_alien_seeds_team5[10];
						}
						match 12 {
							total_alien_seeds_team5[11] <- total_alien_seeds_team5[11] + n ;
							write "Total alien seeds type12: " + total_alien_seeds_team5[11];
						}
					}
				}
			}
			match 6 {
				if not alien{
					switch id {
						match 1 {
							total_seeds_team6[0] <- total_seeds_team6[0] + n ;
							write "Total seeds type1: " + total_seeds_team6[0];
						}
						match 2 {
							total_seeds_team6[1] <- total_seeds_team6[1] + n ;
							write "Total seeds type2: " + total_seeds_team6[1];
						}
						match 3 {
							total_seeds_team6[2] <- total_seeds_team6[2] + n ;
							write "Total seeds type3: " + total_seeds_team6[2];
						}
						match 4 {
							total_seeds_team6[3] <- total_seeds_team6[3] + n ;
							write "Total seeds type4: " + total_seeds_team6[3];
						}
						match 5 {
							total_seeds_team6[4] <- total_seeds_team6[4] + n ;
							write "Total seeds type5: " + total_seeds_team6[4];
						}
						match 6 {
							total_seeds_team6[5] <- total_seeds_team6[5] + n ;
							write "Total seeds type6: " + total_seeds_team6[5];
						}
						match 7 {
							total_seeds_team6[6] <- total_seeds_team6[6] + n ;
							write "Total seeds type7: " + total_seeds_team6[6];
						}
						match 8 {
							total_seeds_team6[7] <- total_seeds_team6[7] + n ;
							write "Total seeds type8: " + total_seeds_team6[7];
						}
						match 9 {
							total_seeds_team6[8] <- total_seeds_team6[8] + n ;
							write "Total seeds type9: " + total_seeds_team6[8];
						}
						match 10 {
							total_seeds_team6[9] <- total_seeds_team6[9] + n ;
							write "Total seeds type10: " + total_seeds_team6[9];
						}
						match 11 {
							total_seeds_team6[10] <- total_seeds_team6[10] + n ;
							write "Total seeds type11: " + total_seeds_team6[10];
						}
						match 12 {
							total_seeds_team6[11] <- total_seeds_team6[11] + n ;
							write "Total seeds type12: " + total_seeds_team6[11];
						}
					}
				}
				else {
					switch id {
						match 1 {
							total_alien_seeds_team6[0] <- total_alien_seeds_team6[0] + n ;
							write "Total alien seeds type1: " + total_alien_seeds_team6[0];
						}
						match 2 {
							total_alien_seeds_team6[1] <- total_alien_seeds_team6[1] + n ;
							write "Total alien seeds type2: " + total_alien_seeds_team6[1];
						}
						match 3 {
							total_alien_seeds_team6[2] <- total_alien_seeds_team6[2] + n ;
							write "Total alien seeds type3: " + total_alien_seeds_team6[2];
						}
						match 4 {
							total_alien_seeds_team6[3] <- total_alien_seeds_team6[3] + n ;
							write "Total alien seeds type4: " + total_alien_seeds_team6[3];
						}
						match 5 {
							total_alien_seeds_team6[4] <- total_alien_seeds_team6[4] + n ;
							write "Total alien seeds type5: " + total_alien_seeds_team6[4];
						}
						match 6 {
							total_alien_seeds_team6[5] <- total_alien_seeds_team6[5] + n ;
							write "Total alien seeds type6: " + total_alien_seeds_team6[5];
						}
						match 7 {
							total_alien_seeds_team6[6] <- total_alien_seeds_team6[6] + n ;
							write "Total alien seeds type7: " + total_alien_seeds_team6[6];
						}
						match 8 {
							total_alien_seeds_team6[7] <- total_alien_seeds_team6[7] + n ;
							write "Total alien seeds type8: " + total_alien_seeds_team6[7];
						}
						match 9 {
							total_alien_seeds_team6[8] <- total_alien_seeds_team6[8] + n ;
							write "Total alien seeds type9: " + total_alien_seeds_team6[8];
						}
						match 10 {
							total_alien_seeds_team6[9] <- total_alien_seeds_team6[9] + n ;
							write "Total alien seeds type10: " + total_alien_seeds_team6[9];
						}
						match 11 {
							total_alien_seeds_team6[10] <- total_alien_seeds_team6[10] + n ;
							write "Total alien seeds type11: " + total_alien_seeds_team6[10];
						}
						match 12 {
							total_alien_seeds_team6[11] <- total_alien_seeds_team6[11] + n ;
							write "Total alien seeds type12: " + total_alien_seeds_team6[11];
						}
					}
				}
			}
		}
	} 
}

experiment First type: gui {
	
	action move_player{
		point cursor_location <- #user_location;
		if (not paused) and (geometry(cursor_location) overlaps free_space){
			ask player[0] {
	    		location <- cursor_location;
	    	}
		}
	}
	
	output{
//		layout horizontal([0::1500, vertical([horizontal([2::1000, 3::1000, 4::1000])::1250, horizontal([5::1000, 6::1000, 7::1000])::1250])::2500])
		layout horizontal([vertical([0::4, 1::3])::1500, vertical([horizontal([2::1000, 3::1000, 4::1000])::1250, horizontal([5::1000, 6::1000, 7::1000])::1250])::2500])
	
		tabs: false consoles: false toolbars: false;
		display "Main" type: 3d background: rgb(50,50,50){
			camera 'default' locked:true distance:850 ; //, vertical([5::1000, 6::1000, 7::1000]))::2500
			
			species bg refresh: false;
//			species river refresh: false;
//			species road refresh: false;
			species tree;
			species player;
			species sign;
			event #mouse_down {
				if ((#user_location distance_to sign[0]) < 25) {
					ask world {
//						do toggle;
						do resume;
					}
				}
			}
			
			event #mouse_drag action: move_player ; 

			graphics Strings {
				draw "Current turn: "+ current_time at:{width/3, -45} font:font("Times", 20, #bold+#italic) ; 
				draw "Time: "+ ((max_time - time_now) div 60) + " minute " + ((max_time - time_now) mod 60) + " second" at:{width/3, -20} font:font("Times", 20, #bold+#italic) ;
			}
		}
		display "Total seeds" type: 2d {
			chart "Total seeds" type:histogram reverse_axes:true
			y_range:[0, 10 + max_total_seed]
			x_serie_labels: [""]
			style:"3d"
			series_label_position: xaxis
			{
				data "team1" value:sum_total_seeds_team[0]
				color:#red;
				data "team2" value:sum_total_seeds_team[1]
				color:#red;
				data "team3" value:sum_total_seeds_team[2]
				color:#red;
				data "team4" value:sum_total_seeds_team[3]
				color:#red;
				data "team5" value:sum_total_seeds_team[4]
				color:#red;
				data "team6" value:sum_total_seeds_team[5]
				color:#red;
			}
		}

		display "Summary Team1" type: 2d { 			
		chart "Team1" type:histogram 			
		y_range:[0, 10 + upper_bound] 			
		x_serie_labels: ["species"] 			
		style:"3d" 			
		series_label_position: xaxis { 				
			data "T1" value:total_seeds_team1[0] 				
			color:#green; 				
			data "T2" value:total_seeds_team1[1] 				
			color:#green; 				
			data "T3" value:total_seeds_team1[2] 				
			color:#green; 				
			data "T4" value:total_seeds_team1[3] 				
			color:#green; 				
			data "T5" value:total_seeds_team1[4] 				
			color:#green; 				
			data "T6" value:total_seeds_team1[5] 				
			color:#green; 				
			data "T7" value:total_seeds_team1[6] 				
			color:#green; 				
			data "T8" value:total_seeds_team1[7] 				
			color:#green; 				
			data "T9" value:total_seeds_team1[8] 				
			color:#green; 				
			data "T10" value:total_seeds_team1[9] 				
			color:#green; 				
			data "T11" value:total_seeds_team1[10] 				
			color:#green; 				
			data "T12" value:total_seeds_team1[11] 				
			color:#green; 			
			} 		
		}
		
		display "Summary Team2" type: 2d { 			
		chart "Team2" type:histogram 			
		y_range:[0, 10 + upper_bound] 					
		x_serie_labels: ["species"] 			
		style:"3d" 			
		series_label_position: xaxis { 				
			data "T1" value:total_seeds_team2[0] 				
			color:#blue; 				
			data "T2" value:total_seeds_team2[1] 				
			color:#blue; 				
			data "T3" value:total_seeds_team2[2] 				
			color:#blue; 				
			data "T4" value:total_seeds_team2[3] 				
			color:#blue; 				
			data "T5" value:total_seeds_team2[4] 				
			color:#blue; 				
			data "T6" value:total_seeds_team2[5] 				
			color:#blue; 				
			data "T7" value:total_seeds_team2[6] 				
			color:#blue; 				
			data "T8" value:total_seeds_team2[7] 				
			color:#blue; 				
			data "T9" value:total_seeds_team2[8] 				
			color:#blue; 				
			data "T10" value:total_seeds_team2[9] 				
			color:#blue; 				
			data "T11" value:total_seeds_team2[10] 				
			color:#blue; 				
			data "T12" value:total_seeds_team2[11] 				
			color:#blue; 			
			} 		
		}
		
		display "Summary Team3" type: 2d { 			
		chart "Team3" type:histogram 			
		y_range:[0, 10 + upper_bound] 					
		x_serie_labels: ["species"] 			
		style:"3d" 			
		series_label_position: xaxis { 				
			data "T1" value:total_seeds_team3[0] 				
			color:#yellow; 				
			data "T2" value:total_seeds_team3[1] 				
			color:#yellow; 				
			data "T3" value:total_seeds_team3[2] 				
			color:#yellow; 				
			data "T4" value:total_seeds_team3[3] 				
			color:#yellow; 				
			data "T5" value:total_seeds_team3[4] 				
			color:#yellow; 				
			data "T6" value:total_seeds_team3[5] 				
			color:#yellow; 				
			data "T7" value:total_seeds_team3[6] 				
			color:#yellow; 				
			data "T8" value:total_seeds_team3[7] 				
			color:#yellow; 				
			data "T9" value:total_seeds_team3[8] 				
			color:#yellow; 				
			data "T10" value:total_seeds_team3[9] 				
			color:#yellow; 				
			data "T11" value:total_seeds_team3[10] 				
			color:#yellow; 				
			data "T12" value:total_seeds_team3[11] 				
			color:#yellow; 			
			} 		
		}
		
		display "Summary Team4" type: 2d { 			
		chart "Team4" type:histogram 			
		y_range:[0, 10 + upper_bound] 		 			
		x_serie_labels: ["species"] 			
		style:"3d" 			
		series_label_position: xaxis { 				
			data "T1" value:total_seeds_team4[0] 				
			color:#orange; 				
			data "T2" value:total_seeds_team4[1] 				
			color:#orange; 				
			data "T3" value:total_seeds_team4[2] 				
			color:#orange; 				
			data "T4" value:total_seeds_team4[3] 				
			color:#orange; 				
			data "T5" value:total_seeds_team4[4] 				
			color:#orange; 				
			data "T6" value:total_seeds_team4[5] 				
			color:#orange; 				
			data "T7" value:total_seeds_team4[6] 				
			color:#orange; 				
			data "T8" value:total_seeds_team4[7] 				
			color:#orange; 				
			data "T9" value:total_seeds_team4[8] 				
			color:#orange; 				
			data "T10" value:total_seeds_team4[9] 				
			color:#orange; 				
			data "T11" value:total_seeds_team4[10] 				
			color:#orange; 				
			data "T12" value:total_seeds_team4[11] 				
			color:#orange; 			
			} 		
		}
		
		display "Summary Team5" type: 2d { 			
		chart "Team5" type:histogram 			
		y_range:[0, 10 + upper_bound] 				
		x_serie_labels: ["species"]		
		style:"3d" 			
		series_label_position: xaxis { 				
			data "T1" value:total_seeds_team5[0] 				
			color:#lime; 				
			data "T2" value:total_seeds_team5[1] 				
			color:#lime; 				
			data "T3" value:total_seeds_team5[2] 				
			color:#lime; 				
			data "T4" value:total_seeds_team5[3] 				
			color:#lime; 				
			data "T5" value:total_seeds_team5[4] 				
			color:#lime; 				
			data "T6" value:total_seeds_team5[5] 				
			color:#lime; 				
			data "T7" value:total_seeds_team5[6] 				
			color:#lime; 				
			data "T8" value:total_seeds_team5[7] 				
			color:#lime; 				
			data "T9" value:total_seeds_team5[8] 				
			color:#lime; 				
			data "T10" value:total_seeds_team5[9] 				
			color:#lime; 				
			data "T11" value:total_seeds_team5[10] 				
			color:#lime; 				
			data "T12" value:total_seeds_team5[11] 				
			color:#lime; 			
			} 		
		}
		
		display "Summary Team6" type: 2d { 			
		chart "Team6" type:histogram 			
		y_range:[0, 10 + upper_bound] 					
		x_serie_labels: ["species"] 			
		style:"3d" 			
		series_label_position: xaxis { 				
			data "T1" value:total_seeds_team6[0] 				
			color:#purple; 				
			data "T2" value:total_seeds_team6[1] 				
			color:#purple; 				
			data "T3" value:total_seeds_team6[2] 				
			color:#purple; 				
			data "T4" value:total_seeds_team6[3] 				
			color:#purple; 				
			data "T5" value:total_seeds_team6[4] 				
			color:#purple; 				
			data "T6" value:total_seeds_team6[5] 				
			color:#purple; 				
			data "T7" value:total_seeds_team6[6] 				
			color:#purple; 				
			data "T8" value:total_seeds_team6[7] 				
			color:#purple; 				
			data "T9" value:total_seeds_team6[8] 				
			color:#purple; 				
			data "T10" value:total_seeds_team6[9] 				
			color:#purple; 				
			data "T11" value:total_seeds_team6[10] 				
			color:#purple; 				
			data "T12" value:total_seeds_team6[11] 				
			color:#purple; 			
			} 		
		}
	}
}


experiment Second type: gui {
	
	action move_player{
		point cursor_location <- #user_location;
		if (not paused) and (geometry(cursor_location) overlaps free_space){
			ask player[0] {
	    		location <- cursor_location;
	    	}
		}
	}
		
	reflex add_alien when:cycle=0{
		ask tree{
			switch tree_type{
				match_one [2,4,6,8,10,12]{
					if flip(0.3){
						it_alien <- true;
						self.color <- #purple;
						add self to: alien_tree;
					}
				}
			}
		}
//		write alien_tree;
	}
	
	output{
//		layout horizontal([0::1500, vertical([horizontal([2::1000, 3::1000, 4::1000])::1250, horizontal([5::1000, 6::1000, 7::1000])::1250])::2500])
		layout horizontal([vertical([0::4, 1::3])::1500, vertical([horizontal([2::1000, 3::1000, 4::1000])::1250, horizontal([5::1000, 6::1000, 7::1000])::1250])::2500])
	
		tabs: false consoles: false toolbars: false;
		display "Main" type: 3d background: rgb(50,50,50){
			camera 'default' locked:true distance:850 ; //, vertical([5::1000, 6::1000, 7::1000]))::2500
			
			species bg refresh: false;
//			species river refresh: false;
//			species road refresh: false;
			species tree;
			species player;
			species sign;
			event #mouse_down {
				if ((#user_location distance_to sign[0]) < 25) {
					ask world {
//						do toggle;
						do resume;
					}
				}
			}
			
			event #mouse_drag action: move_player ; 

			graphics Strings {
				draw "Current turn: "+ current_time at:{width/3, -45} font:font("Times", 20, #bold+#italic) ; 
				draw "Time: "+ ((max_time - time_now) div 60) + " minute " + ((max_time - time_now) mod 60) + " second" at:{width/3, -20} font:font("Times", 20, #bold+#italic) ;
			}
		}
		display "Total seeds" type: 2d {
			chart "Total seeds" type:histogram reverse_axes:true
			y_range:[0, 10 + max_total_seed]
			x_serie_labels: [""]
			style:"3d"
			series_label_position: xaxis
			{
				data "team1" value:sum_total_seeds_team[0]
				color:#red;
				data "team2" value:sum_total_seeds_team[1]
				color:#red;
				data "team3" value:sum_total_seeds_team[2]
				color:#red;
				data "team4" value:sum_total_seeds_team[3]
				color:#red;
				data "team5" value:sum_total_seeds_team[4]
				color:#red;
				data "team6" value:sum_total_seeds_team[5]
				color:#red;
			}
		}

		display "Summary Team1" type: 2d { 			
		chart "Team1" type:histogram 			
		y_range:[0, 10 + upper_bound] 			
		x_serie_labels: ["species"] 			
		style:"3d" 			
		series_label_position: xaxis { 				
			data "T1" value:total_seeds_team1[0]+total_alien_seeds_team1[0] 				
			color:#green; 			
			data "T2" value:total_seeds_team1[1]+total_alien_seeds_team1[1] 				
			color:#green; 				
			data "T3" value:total_seeds_team1[2]+total_alien_seeds_team1[2] 				
			color:#green; 				
			data "T4" value:total_seeds_team1[3]+total_alien_seeds_team1[3] 				
			color:#green; 				
			data "T5" value:total_seeds_team1[4]+total_alien_seeds_team1[4] 				
			color:#green; 				
			data "T6" value:total_seeds_team1[5]+total_alien_seeds_team1[5] 				
			color:#green; 				
			data "T7" value:total_seeds_team1[6]+total_alien_seeds_team1[6] 				
			color:#green; 				
			data "T8" value:total_seeds_team1[7]+total_alien_seeds_team1[7] 				
			color:#green; 				
			data "T9" value:total_seeds_team1[8]+total_alien_seeds_team1[8] 				
			color:#green; 				
			data "T10" value:total_seeds_team1[9]+total_alien_seeds_team1[9] 				
			color:#green; 				
			data "T11" value:total_seeds_team1[10]+total_alien_seeds_team1[10] 				
			color:#green; 				
			data "T12" value:total_seeds_team1[11]+total_alien_seeds_team1[11] 				
			color:#green; 			
			} 		
		}
		
		display "Summary Team2" type: 2d { 			
		chart "Team2" type:histogram 			
		y_range:[0, 10 + upper_bound] 					
		x_serie_labels: ["species"] 			
		style:"3d" 			
		series_label_position: xaxis { 				
			data "T1" value:total_seeds_team2[0]+total_alien_seeds_team2[0] 				
			color:#blue; 				
			data "T2" value:total_seeds_team2[1]+total_alien_seeds_team2[1] 				
			color:#blue; 				
			data "T3" value:total_seeds_team2[2]+total_alien_seeds_team2[2] 				
			color:#blue; 				
			data "T4" value:total_seeds_team2[3]+total_alien_seeds_team2[3] 				
			color:#blue; 				
			data "T5" value:total_seeds_team2[4]+total_alien_seeds_team2[4] 				
			color:#blue; 				
			data "T6" value:total_seeds_team2[5]+total_alien_seeds_team2[5] 				
			color:#blue; 				
			data "T7" value:total_seeds_team2[6]+total_alien_seeds_team2[6] 				
			color:#blue; 				
			data "T8" value:total_seeds_team2[7]+total_alien_seeds_team2[7] 				
			color:#blue; 				
			data "T9" value:total_seeds_team2[8]+total_alien_seeds_team2[8] 				
			color:#blue; 				
			data "T10" value:total_seeds_team2[9]+total_alien_seeds_team2[9] 				
			color:#blue; 				
			data "T11" value:total_seeds_team2[10]+total_alien_seeds_team2[10] 				
			color:#blue; 				
			data "T12" value:total_seeds_team2[11]+total_alien_seeds_team2[11] 				
			color:#blue; 			
			} 		
		}
		
		display "Summary Team3" type: 2d { 			
		chart "Team3" type:histogram 			
		y_range:[0, 10 + upper_bound] 					
		x_serie_labels: ["species"] 			
		style:"3d" 			
		series_label_position: xaxis { 				
			data "T1" value:total_seeds_team3[0]+total_alien_seeds_team3[0] 				
			color:#yellow; 				
			data "T2" value:total_seeds_team3[1]+total_alien_seeds_team3[1] 				
			color:#yellow; 				
			data "T3" value:total_seeds_team3[2]+total_alien_seeds_team3[2] 				
			color:#yellow; 				
			data "T4" value:total_seeds_team3[3]+total_alien_seeds_team3[3] 				
			color:#yellow; 				
			data "T5" value:total_seeds_team3[4]+total_alien_seeds_team3[4] 				
			color:#yellow; 				
			data "T6" value:total_seeds_team3[5]+total_alien_seeds_team3[5] 				
			color:#yellow; 				
			data "T7" value:total_seeds_team3[6]+total_alien_seeds_team3[6] 				
			color:#yellow; 				
			data "T8" value:total_seeds_team3[7]+total_alien_seeds_team3[7] 				
			color:#yellow; 				
			data "T9" value:total_seeds_team3[8]+total_alien_seeds_team3[8] 				
			color:#yellow; 				
			data "T10" value:total_seeds_team3[9]+total_alien_seeds_team3[9] 				
			color:#yellow; 				
			data "T11" value:total_seeds_team3[10]+total_alien_seeds_team3[10] 				
			color:#yellow; 				
			data "T12" value:total_seeds_team3[11]+total_alien_seeds_team3[11] 				
			color:#yellow; 			
			} 		
		}
		
		display "Summary Team4" type: 2d { 			
		chart "Team4" type:histogram 			
		y_range:[0, 10 + upper_bound] 		 			
		x_serie_labels: ["species"] 			
		style:"3d" 			
		series_label_position: xaxis { 				
			data "T1" value:total_seeds_team4[0]+total_alien_seeds_team4[0] 				
			color:#orange; 				
			data "T2" value:total_seeds_team4[1]+total_alien_seeds_team4[1]  				
			color:#orange; 				
			data "T3" value:total_seeds_team4[2]+total_alien_seeds_team4[2]  				
			color:#orange; 				
			data "T4" value:total_seeds_team4[3]+total_alien_seeds_team4[3]  				
			color:#orange; 				
			data "T5" value:total_seeds_team4[4]+total_alien_seeds_team4[4]  				
			color:#orange; 				
			data "T6" value:total_seeds_team4[5]+total_alien_seeds_team4[5]  				
			color:#orange; 				
			data "T7" value:total_seeds_team4[6]+total_alien_seeds_team4[6]  				
			color:#orange; 				
			data "T8" value:total_seeds_team4[7]+total_alien_seeds_team4[7]  				
			color:#orange; 				
			data "T9" value:total_seeds_team4[8]+total_alien_seeds_team4[8]  				
			color:#orange; 				
			data "T10" value:total_seeds_team4[9]+total_alien_seeds_team4[9]  				
			color:#orange; 				
			data "T11" value:total_seeds_team4[10]+total_alien_seeds_team4[10]  				
			color:#orange; 				
			data "T12" value:total_seeds_team4[11]+total_alien_seeds_team4[11]  				
			color:#orange; 			
			} 		
		}
		
		display "Summary Team5" type: 2d { 			
		chart "Team5" type:histogram 			
		y_range:[0, 10 + upper_bound] 				
		x_serie_labels: ["species"]		
		style:"3d" 			
		series_label_position: xaxis { 				
			data "T1" value:total_seeds_team5[0]+total_alien_seeds_team5[0]  				
			color:#lime; 				
			data "T2" value:total_seeds_team5[1]+total_alien_seeds_team5[1]  				
			color:#lime; 				
			data "T3" value:total_seeds_team5[2]+total_alien_seeds_team5[2]  				
			color:#lime; 				
			data "T4" value:total_seeds_team5[3]+total_alien_seeds_team5[3]  				
			color:#lime; 				
			data "T5" value:total_seeds_team5[4]+total_alien_seeds_team5[4]  				
			color:#lime; 				
			data "T6" value:total_seeds_team5[5]+total_alien_seeds_team5[5]  				
			color:#lime; 				
			data "T7" value:total_seeds_team5[6]+total_alien_seeds_team5[6]  				
			color:#lime; 				
			data "T8" value:total_seeds_team5[7]+total_alien_seeds_team5[7]  				
			color:#lime; 				
			data "T9" value:total_seeds_team5[8]+total_alien_seeds_team5[8]  				
			color:#lime; 				
			data "T10" value:total_seeds_team5[9]+total_alien_seeds_team5[9]  				
			color:#lime; 				
			data "T11" value:total_seeds_team5[10]+total_alien_seeds_team5[10]  				
			color:#lime; 				
			data "T12" value:total_seeds_team5[11]+total_alien_seeds_team5[11]  				
			color:#lime; 			
			} 		
		}
		
		display "Summary Team6" type: 2d { 			
		chart "Team6" type:histogram 			
		y_range:[0, 10 + upper_bound] 					
		x_serie_labels: ["species"] 			
		style:"3d" 			
		series_label_position: xaxis { 				
			data "T1" value:total_seeds_team6[0]+total_alien_seeds_team6[0]  				
			color:#purple; 				
			data "T2" value:total_seeds_team6[1]+total_alien_seeds_team6[1] 				
			color:#purple; 				
			data "T3" value:total_seeds_team6[2]+total_alien_seeds_team6[2] 				
			color:#purple; 				
			data "T4" value:total_seeds_team6[3]+total_alien_seeds_team6[3] 				
			color:#purple; 				
			data "T5" value:total_seeds_team6[4]+total_alien_seeds_team6[4] 				
			color:#purple; 				
			data "T6" value:total_seeds_team6[5]+total_alien_seeds_team6[5] 				
			color:#purple; 				
			data "T7" value:total_seeds_team6[6]+total_alien_seeds_team6[6] 				
			color:#purple; 				
			data "T8" value:total_seeds_team6[7]+total_alien_seeds_team6[7] 				
			color:#purple; 				
			data "T9" value:total_seeds_team6[8]+total_alien_seeds_team6[8] 				
			color:#purple; 				
			data "T10" value:total_seeds_team6[9]+total_alien_seeds_team6[9] 				
			color:#purple; 				
			data "T11" value:total_seeds_team6[10]+total_alien_seeds_team6[10] 				
			color:#purple; 				
			data "T12" value:total_seeds_team6[11]+total_alien_seeds_team6[11] 				
			color:#purple; 			
			} 		
		}
	}
}