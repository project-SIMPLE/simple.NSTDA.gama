/**
* Name: mainGAMAforesttrails2
* Based on the internal empty template. 
* Author: lilti
* Tags: 
*/


model mainGAMAforesttrails2

import 'species.gaml'

global{
//	shape_file roads_shape_file <- shape_file("../includes/cir.shp");
//	shape_file border_shape_file <- shape_file("../includes/rec.shp");
//	geometry bg_in <- geometry(shape_file("../includes/incir.shp"));
//	geometry bg_out <- geometry(shape_file("../includes/outcir.shp"));
//	geometry free_space <- bg_out - bg_in;
//	geometry shape <- envelope(border_shape_file);

	shape_file free_space <- shape_file("../includes/trail_buffer.shp");
	geometry shape <- geometry(free_space);
	
	float width <- shape.width;
	float height <- shape.height;
	
	// Parameter
	int n_player <- 4;
	list n_tree <- [50,50,50];
	int collect_seeds_distance <- 5;
	int stop_time <- 10; //second
	int stop_every_n_turn <- 2; //turn
	
	// Variable
	list<list<int>> seeds <- [];
	list<list<int>> alien_seeds <- [];
	list<int> sum_total_seeds <- [];
	int init_time <- 0;
	int time_now <- 0;
	int count_start <- 0 ;
	bool can_start <- true ;
	int current_time <- 1 ;
	float current_day <- 0.0 ;
	int max_time <- stop_time * n_player;
	rgb color_state1 <- rgb(117, 148, 69);
	rgb color_state2 <- rgb(133, 134, 66);
	rgb color_state3 <- rgb(165, 105, 60);
	rgb color_state4 <- rgb(198, 76, 54);
	int upper_bound;
	int max_total_seed;
	
	float x_river <- 0.0 ;
	float y_river <-  260.0 ;
	
	init{		
//		write shape;
		seeds <- list_with(n_player, list_with(length(n_tree) * 2, 0));
		alien_seeds <- list_with(n_player, list_with(length(n_tree) * 2, 0));
		sum_total_seeds <- list_with(n_player, 0);

//		write seeds;
//		write seeds[0][0];
//		write container(seeds[0]);
//		write container(seeds[0])[0];
//		container(seeds[0])[0] <- 10;
//		write seeds[0][0];
//		write alien_seeds;
//		write sum_total_seeds;
//		save matrix(seeds) to: "test.csv" format:"csv" rewrite: true;
		
		create road from: free_space;
//		create bg from: list(bg_in);
		
		create sign{
			location <- {width/3 - 35, -45, 0};
		}
		
		loop i from:1 to:n_player{
			create player{
				team <- i;
				location <- any_location_in(any(road));
			}
		}
		
		int temp <- 0 ;
		loop i from:1 to:(length(n_tree) * 2) step:2{			
			create tree number:n_tree[temp]{
				tree_type <- i;
				shape <- circle(3+size#m);
				
				location <- any_location_in(any(road));
			}
			create tree number:n_tree[temp]{
				tree_type <- i+1;
				shape <- circle(3+size#m);
				
				location <- any_location_in(any(road));
			}
			temp <- temp + 1;
		}
		
		ask tree {
			list_of_state1 <- assign_list_of_state(1, tree_type);
			list_of_state2 <- assign_list_of_state(2, tree_type);
			list_of_state3 <- assign_list_of_state(3, tree_type);
			list_of_state4 <- assign_list_of_state(4, tree_type);
//			write self.location;
		}
	}
	
	reflex update_time_and_bound{
		if (gama.machine_time div 1000) - init_time = 1{
			init_time <- gama.machine_time div 1000;
			time_now <- time_now + 1;
		}
		current_time <- int((time_now-0.1) div (stop_time / stop_every_n_turn)) + 1;
		
		write "Time: " + time_now + " s, Turn: " + current_time ;

		loop i from:0 to:(length(sum_total_seeds)-1){
//			write sum(seeds[i]);
//			write sum(alien_seeds[i]);
//			write int(sum(seeds[i])) + int(sum(alien_seeds[i]));
			sum_total_seeds[i] <- int(sum(seeds[i])) + int(sum(alien_seeds[i]));
		}
		
		loop i from:0 to:(n_player-1){
			loop j from:0 to:((length(n_tree)*2)-1) step:2{ 
				int temp <- int(seeds[i][j] + alien_seeds[i][j]) +  int(seeds[i][j+1] + alien_seeds[i][j+1]);
				if temp > upper_bound{
					upper_bound <- temp;
				}
						
			}				
		}
		
		max_total_seed <- int(max(sum_total_seeds));
//		write(max_total_seed);
	}
	
	reflex restart when:current_time=max_time{
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
	
	reflex growth_up{ 
		ask tree{
			switch current_time {
				match_one list_of_state1{
					if not it_alien{
						self.color <- color_state1 ;	
					}
					initial_seed <- 0;
					can_collect <- false ;
					it_state <- 1 ;
				}
				match_one list_of_state2{
					if not it_alien{
						self.color <- color_state2 ;
					}
					initial_seed <- 0;
					can_collect <- false ;
					it_state <- 2 ;
				}
				match_one list_of_state3{
					if not it_alien{
						self.color <- color_state3 ;
					}
					initial_seed <- 0;
					can_collect <- false ;
					it_state <- 3 ;
				}
				match_one list_of_state4{
					if not it_alien{
						self.color <- color_state4 ;
					}
					initial_seed <- rnd(1,10);
					can_collect <- true ;
					it_state <- 4 ;
				}
			}	
		}
	}
	
	action collect(int team, int type, int n, bool alien){
		if alien{
//			write int(int(container(alien_seeds[team])[type]) + n);
			int temp <- int(container(alien_seeds[team-1])[type-1]);
			container(alien_seeds[team-1])[type-1] <- int(temp + n);	
		}
		else{
//			container(seeds[team])[type] <- int(int(container(seeds[team])[type]) + n);
			int temp <- int(container(seeds[team-1])[type-1]);
			container(seeds[team-1])[type-1] <- int(temp + n);
		}
	}
	
	reflex random{
		if flip(0.1){
			do collect(rnd(1,n_player),rnd(1,length(n_tree)*2),rnd(1,10), true);
		}
		if flip(0.1){
			do collect(rnd(1,n_player),rnd(1,length(n_tree)*2),rnd(1,10), false);
		}
	}
}


