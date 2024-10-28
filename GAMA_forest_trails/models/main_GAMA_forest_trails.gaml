/**
* Name: mainGAMAforesttrails2
* Based on the internal empty template. 
* Author: lilti
* Tags: 
*/

model mainGAMAforesttrails2

import 'species.gaml'

// quest3 ก่อนจะได้ดูว่าเป็นที่ model หรือ unity done!
// ทำแมพพี่ตั้ม done!
// multiplayer done!
// ปรับ function ให้รับ unity ได้
// output csv treespeice team จน เมล็ด done!

// goal : link เมล็ดให้ได้

//---------------------------------------------------------------------------------------------------------
// ให้ invi wall อ้อมต้นไม้ได้ done!
// turn สุดท้ายให้แสดง turn 6 คงไว้
// รูปพี่ตั้มมาใส่ บน gama
// เปลี่ยนหัวตาราง

global{
	
	shape_file Trail_shape_file <- shape_file("../includes/Trail.shp");
//	shape_file offtrail_shape_file <- shape_file("../includes/export/offtrail.shp");

	geometry usable_area;
	geometry usable_area_for_tree;
	geometry shape <- (envelope(Trail_shape_file));
	
	float width <- shape.width;
	float height <- shape.height;
	
	// Parameter
	int n_team <- 1;
	list n_tree <- [50,50,50,50,50,50,50,50,50,50,50,50];
	int stop_time <- 60; //second
	
	// Variable
	int n_turn <- 6;
	int n_month_by_turn <- 2;
	list<list<int>> seeds <- list_with(n_team, list_with(length(n_tree), 0));
	list<list<int>> alien_seeds <- list_with(n_team, list_with(length(n_tree), 0));
	list<int> sum_total_seeds <- list_with(n_team, 0);
	int init_time <- 0;
	int time_now <- 0;
	int count_start <- 0 ;
	bool can_start <- true ;
	int current_time <- 1 ;
	float current_day <- 0.0 ;
	int max_time <- stop_time * n_turn;
	rgb color_state1 <- rgb(117, 148, 69);
	rgb color_state2 <- rgb(133, 134, 66);
	rgb color_state3 <- rgb(165, 105, 60);
	rgb color_state4 <- rgb(198, 76, 54);
	int upper_bound;
	int max_total_seed;
	
	float x_river <- 0.0 ;
	float y_river <-  260.0 ;
	
	list<string> player_id_list <- [];
	list<string> tree_id_list <- [];
//	geometry offTrail;
	
	map<string, int> map_player_id ;
//	map<string, int> map_tree_id ;
	
	init{
//		write map_player_id;
//		write player_id_list; 

//		write seeds;
//		write alien_seeds;
		
//		create road from: split_lines(Trail_shape_file);
		create road from: Trail_shape_file;
		create island{
			location <- {width/2, height/2, 0};
		}
//		save island to:"../includes/export/island.shp" format:"shp";
		
//		save road to:"../includes/export/trail.shp" format:"shp";
//		write length(road);
		
//		ask road[0]{
//			color <- #yellow;
//		}
//		ask road[1]{
//			color <- #lime;
//		}
//		ask road[2]{
//			color <- #red;
//		}
		
//		offTrail<- world.shape - (road collect (each.shape.contour+5.0));
//		save offTrail to:"../includes/export/offtrail.shp" format:"shp";
//		create offroad from: offtrail_shape_file;
//		write length(offroad);
		
		
		create sign{
			location <- {width/3 - 35, -45, 0};
		}
		bool still_do <- true;
		loop while: still_do {
			still_do <- false;
			bool is_ok <- true;
			tree_id_list <- [];
			ask tree {do die;}
			usable_area <- union(road collect each.geom_visu) inter world.shape ;
			usable_area_for_tree <- usable_area - 3 ;
			int count_create_tree <- 0;
			loop i from:0 to:(length(n_tree)-1){		
				loop j from:1 to:(n_tree[i] div 2){
					create tree{
						tree_type <- 2*i+1;
						
	//					do initialize(usable_area);
						if count_create_tree > 0{
							ask tree[count_create_tree-1] {
								usable_area_for_tree <- usable_area_for_tree - self.shape;
								usable_area <- usable_area + self.shape;
							}
						}
						if (usable_area_for_tree = nil) {
							is_ok <- false;
						} else {
							location <- any_location_in(usable_area_for_tree);
		//					location <- any_location_in(usable_area);
		//					add "tree"+ (length(tree)-1)::i to:map_tree_id;
							add "tree"+ (length(tree)-1) to:tree_id_list;
							count_create_tree <- count_create_tree + 1;
						}
					}
					if (not is_ok) {
						break;
					}
					
				}
				loop j from:1 to:(n_tree[i] - (n_tree[i] div 2)){
					create tree{
						tree_type <- 2*i+2;
						
	//					do initialize(usable_area);
						ask tree[count_create_tree-1] {
							usable_area_for_tree <- usable_area_for_tree - self.shape;
							usable_area <- usable_area + self.shape;
						}
						if (usable_area_for_tree = nil) {
							is_ok <- false;
						} else {
							
							location <- any_location_in(usable_area_for_tree);
		//					location <- any_location_in(usable_area);
		//					add "tree"+ (length(tree)-1)::i to:map_tree_id;
							add "tree"+ (length(tree)-1) to:tree_id_list;
							count_create_tree <- count_create_tree + 1;
						}
						
					}
					if (not is_ok) {
						break;
					}
				}
				if (not is_ok) {
					still_do <- true;
					break;
				}
			}
		}
		save usable_area_for_tree to:"../includes/export/usable_area_for_tree.shp" format:"shp";
		
		ask tree {
			list_of_state1 <- assign_list_of_state(1, tree_type);
			list_of_state2 <- assign_list_of_state(2, tree_type);
			list_of_state3 <- assign_list_of_state(3, tree_type);
			list_of_state4 <- assign_list_of_state(4, tree_type);
		}
	}
	
	reflex test{
//		write map_player_id;
//		write player_id_list; 
//		write map_player_id[player_id_list[0]];
//		write map_tree_id;
//		write tree_id_list;

//		write unity_player.name ;
//		ask unity_player{
//			write name;
//		}
//		write player_id_list;
//		ask unity_linker{
//			loop p over: unity_player {
//				write p;
//			}
//		}
//		write unity_player as list;
	}
	
	reflex update_time_and_bound{
		if (gama.machine_time div 1000) - init_time = 1{
			init_time <- gama.machine_time div 1000;
			time_now <- time_now + 1;
		}
		current_time <- int((time_now - 0.01) div (stop_time / n_month_by_turn)) + 1;
//		write "Time: " + time_now + " s, Turn: " + count_start + " Month: " + current_time ;
//		ask unity_linker{
//			do send_message players: unity_player as list mes: ["start":: !can_start, "remaining_time":: (stop_time*count_start - time_now)];
//		}

		loop i from:0 to:(length(sum_total_seeds)-1){
			sum_total_seeds[i] <- int(sum(seeds[i])) + int(sum(alien_seeds[i]));
		}
		
		loop i from:0 to:(n_team-1){
			loop j from:0 to:((length(n_tree))-1){ 
				int temp <- int(seeds[i][j] + alien_seeds[i][j]);
				if temp > upper_bound{
					upper_bound <- temp;
				}
						
			}	
		}
		
		max_total_seed <- int(max(sum_total_seeds));
//		write length(unity_player);
	}
	
	reflex restart when:time_now=max_time{
		time_now <- 0;
		count_start <- 0 ;
		do save_total_seeds_to_csv;
	}
	
	action save_total_seeds_to_csv;
	
	
	
	
	reflex do_resume when: (not paused) and can_start{
//		if user_confirm("Confirmation","Do you want to start?"){
//			ask sign{
//				icon <- stop;
////				write "change to stop icon.";
//			}
//			count_start <- count_start + 1 ;
//			init_time <- gama.machine_time div 1000;
//			can_start <- false ;
//		}
//		else{
//			do pause;
//		}

		ask sign{
			icon <- stop;
		}
		count_start <- count_start + 1 ;
		init_time <- gama.machine_time div 1000;
		can_start <- false ;
		
		do resume_game;
	}
	action resume_game;
	
	reflex do_pause when: (time_now >= stop_time*count_start) and (cycle != 0) {
		ask sign{
			icon <- play;
//			write "change to start icon.";
		}
		can_start <- true ;
		do pause;

		do pause_game;
	}
	
	action pause_game;
	
	reflex growth_up{ 
		ask tree{
			switch current_time {
				match_one list_of_state1{
					if not it_alien{
						self.color <- color_state1 ;	
					}
//					initial_seed <- 0;
					can_collect <- false ;
					it_state <- 1 ;
				}
				match_one list_of_state2{
					if not it_alien{
						self.color <- color_state2 ;
					}
//					initial_seed <- 0;
					can_collect <- false ;
					it_state <- 2 ;
				}
				match_one list_of_state3{
					if not it_alien{
						self.color <- color_state3 ;
					}
//					initial_seed <- 0;
					can_collect <- false ;
					it_state <- 3 ;
				}
				match_one list_of_state4{
					if not it_alien{
						self.color <- color_state4 ;
					}
//					initial_seed <- rnd(1,10);
					can_collect <- true ;
					it_state <- 4 ;
				}
			}	
		}
	}
}

experiment First type: gui {
	list<rgb> player_colors <-[#green, #blue, #yellow, #orange, #lime, #purple];
	
	output{
		layout vertical([horizontal([0::1, 1::1])::1, 2::1]);// tabs:false consoles:true toolbars:false;
		display "Main" type: 3d background: rgb(50,50,50){
			camera 'default' locked:false distance:550 ;
//			species offroad refresh: false;
			species road refresh: false;
			species tree;
			species player;
			species sign;
			species island;
			
			
			
			event #mouse_down {
				if ((#user_location distance_to sign[0]) < 25) {
					ask world {
						do resume;
					}
				}
			}

			graphics Strings {
				draw "Current turn: "+ count_start at:{width/3, -45} font:font("Times", 20, #bold+#italic) ; 
				draw "Remaining time: "+ ((stop_time*count_start - time_now) div 60) + " minutes " + ((stop_time*count_start - time_now) mod 60) + " seconds" at:{width/3, -20} font:font("Times", 20, #bold+#italic) ;
			}
		}
		
		display "Total seeds" type: 2d {
			chart "Total seeds" type:histogram reverse_axes:true
			y_range:[0, 20 + max_total_seed]
			x_serie_labels: [""]
			style:"3d"
			series_label_position: xaxis
			{
				loop i from:0 to:(length(sum_total_seeds)-1){
					data "team" + (i+1) value:int(sum_total_seeds[i])
					color:#red;
				}
			}
		}
		
		display "Summary" type: 2d { 			
			chart "Number of seeds by tree species and by team ID" type:histogram 
			x_serie_labels: ["Species"] 				
			y_range:[0, 10 + upper_bound] 		
			style:"3d" 			 
			series_label_position: xaxis {
				loop i from:0 to:(n_team-1){
					int temp <- 1 ;
					loop j from:0 to:((length(n_tree))-1){ 
						data "T"+ (i+1) + "Tree" + temp value: int(seeds[i][j] + alien_seeds[i][j]) 
						color:player_colors[i]; 
						temp <- temp + 1;
					}
					data ""+(i+1) value:0;
				}
			}
		}	
	}
}