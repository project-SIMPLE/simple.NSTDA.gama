/**
* Name: mainGAMAforesttrails2
* Based on the internal empty template. 
* Author: lilti
* Tags: 
*/

// เพิ่มระยะห่างต้นไม้ + ลดจำนวนต้นไม้
// เอเลี่ยนรอบ 2
// สัปดาห์หน้าทำ เอเลี่ยนให้เสร็จ

// 14Nov2024
// ให้ผู้เล่นเข้า zone tutorial ก่อน แล้วถ้าผู้เล่นเล่นเสร็จแล้ว พี่เติ้ลจะส่ง playerID ของคนที่เสร็จแล้วมาให้ done!
// ถ้าส่งมาครบแล้วปุ่ม start ถึงจะกดได้ แล้ววาร์ปทุกคนไปที่ zone แรก done!
// เล่นจบแล้ววาร์ปไป tutorial done!

// 28Nov2024
// ทำกราฟใหม่
// แก้ tutorial ให้เห็นชัดขึ้น
// เปลี่ยนชื่อ Tree1 Tree2... ให้เป็นชื่อต้นไม้
// ทำให้ใสจำนวนเมล็ดที่ต้องเก็บในแต่ละรอบได้
// ทำของคิตให้เป็น action มีกราฟทิ้งไว้


model mainGAMAforesttrails

import 'species.gaml'

global{
	
	shape_file Trail_shape_file <- shape_file("../includes/Trail.shp");
	csv_file my_csv_file <- csv_file("../includes/pheno_tz_7Nov2024.csv");

	geometry usable_area;
	geometry usable_area_for_tree;
	
	geometry spawn_point;
	list<geometry> road_midpoint ;
	geometry shape <- (envelope(Trail_shape_file));
	
	float width <- shape.width;
	float height <- shape.height;
	
	// Parameter
	int n_team <- 2;
//	list n_tree <- [50,50,50,50,50,50,50,50,50,50,50,50];
//	list n_tree <- [50,50,50];
	list<list<int>> fruiting_stage <- list_with(12, list_with(6, 0));
	list<list<int>> n_tree <- list_with(12, list_with(6, 0));
	list<list<int>> alien_tree <- list_with(12, list_with(6, 0));
	int stop_time <- 60; //second
	
	// Variable
	int n_turn <- 6;
	int n_month_by_turn <- 1;
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
	bool alien_experimant <- false;
	list<tree> tree_list <- [];
	
	list<int> map_zone <- list<int>([0::0, 1::2, 2::4, 3::5, 4::3, 5::1 ]);
	
	list<string> player_id_list <- [];
	
	list<string> player_id_finish_tutorial_list <- [];
	bool tutorial_finish <- false;
	bool move_player_when_game_finish <- true;
	
	map<string, int> map_player_id ;
	
	init{
//		write envelope(Trail_shape_file);
		create road from: Trail_shape_file;
		
		matrix data <- matrix(my_csv_file);

		loop i from: 2 to: data.columns -1{
			loop j from: 0 to: data.rows -1{
				if i = 2{
					container(fruiting_stage[j div 6])[j mod 6] <- int(data[i,j]);
				}
				else if i = 3{
					container(n_tree[j div 6])[j mod 6] <- int(data[i,j]);
				}
				else if i = 4{
					container(alien_tree[j div 6])[j mod 6] <- int(data[i,j]);
				}
			}	
		}
		
		loop j from:0 to:length(n_tree)-1{
			write "fruiting_stage type" + (j+1) + " is \t" + fruiting_stage[j];
			write "n_tree type" + (j+1) + " is \t\t\t" + n_tree[j];
			write "alien_tree type" + (j+1) + " is \t\t" + alien_tree[j];
			write " ";
		}
		
		create sign{
			location <- {width/3 - 35, -45, 0};
		}
		
		create island{
			location <- {width/2 - 20, height/2 - 20, 0};
		}
		
		bool still_do <- true;
		loop while: still_do {
			still_do <- false;
			bool is_ok <- true;
			ask tree {do die;}
			usable_area <- union(road collect each.geom_visu) inter world.shape ;
			usable_area_for_tree <- usable_area - 3 ;

			road_midpoint <- split_geometry(usable_area_for_tree, {width/3, height/2});
//			write road_midpoint;
//			write length(road_midpoint);
			
//			create road from:road_midpoint;
//			
//			ask road[3]{
//				color2 <- #red;
//			}
//			ask road[4]{
//				color2 <- #blue;
//			}
//			ask road[5]{
//				color2 <- #green;
//			}
//			ask road[6]{
//				color2 <- #yellow;
//			}
//			ask road[7]{
//				color2 <- #lime;
//			}
//			ask road[8]{
//				color2 <- #purple;
//			}
//			
//			ask road[2]{
//				do die;
//			}
//			
//			ask road[1]{
//				do die;
//			}
//			
//			ask road[0]{
//				do die;
//			}
			
			
			int count_create_tree <- 0;
			
			loop i from:0 to:length(n_tree)-1{
				loop j from:0 to:length(n_tree[i])-1{
					if n_tree[i][j] > 0{
						create tree number:n_tree[i][j]{
							tree_type <- i+1;
							
//							if j = 0{
//								color <- #red;
//							}
//							if j = 1{
//								color <- #blue;
//							}
//							if j = 2{
//								color <- #green;
//							}
//							if j = 3{
//								color <- #yellow;
//							}
//							if j = 4{
//								color <- #lime;
//							}
//							if j = 5{
//								color <- #purple;
//							}
							
							if count_create_tree > 0{
								ask tree[count_create_tree-1] {
									usable_area_for_tree <- usable_area_for_tree - self.shape;
									usable_area <- usable_area + self.shape;
									save usable_area_for_tree to:"../includes/export/usable_area_for_tree.shp" format:"shp";
								}
							}
							
							if (usable_area_for_tree = nil) {
								is_ok <- false;
							} 
							
							else {
//								location <- (point(usable_area_for_tree closest_points_with(road_midpoint[j])));
//								write point(usable_area_for_tree closest_points_with(road_midpoint[j]));

//								geometry spawn_point <- one_of(usable_area_for_tree overlapping road_midpoint);
//								location <- any_location_in(spawn_point);
//								location <- any_location_in(usable_area_for_tree) when distance_between(location, road_midpoint[j].location) > 70;
								
//								spawn_point <- one_of(road_midpoint);
//								location <- any_location_in(one_of(road_midpoint));
								
								location <- any_location_in(usable_area_for_tree);
								loop while: location distance_to road_midpoint[map_zone[j]].location > 100{
//									write "Again!" + count_create_tree + " norm: " + location distance_to road_midpoint[j].location;
									location <- any_location_in(usable_area_for_tree);
								}

//								write my_grid(location);
//								loop while: my_grid(location) != my_grid[j] {
//									write "Again!" + count_create_tree;
//									location <- any_location_in(usable_area_for_tree);
//								}
								
								count_create_tree <- count_create_tree + 1;
							}
						}
						
						if (not is_ok) {
							break;
						}
					}
				}
			}
			
//			ask my_grid[0]{
//				color <- #red;
//			}
			
		}
		save usable_area to:"../includes/export/usable_area.shp" format:"shp";
		save usable_area_for_tree to:"../includes/export/usable_area_for_tree.shp" format:"shp";
		save union(road_midpoint) to:"../includes/export/road_midpoint.shp" format:"shp";
		
		ask tree {
			list_of_state1 <- assign_list_of_state(1, tree_type);
			list_of_state2 <- assign_list_of_state(2, tree_type);
			list_of_state3 <- assign_list_of_state(3, tree_type);
			list_of_state4 <- assign_list_of_state(4, tree_type);
		}
		
//		create player2 number:1{
//			team <- 1 ;
//			location <- any_location_in(usable_area - 1.5) + {0, 0, 3};
//		}
	}
	
	reflex test{

	}
	
	reflex update_time_and_bound when: (not paused) and tutorial_finish{
		if (gama.machine_time div 1000) - init_time = 1{
			init_time <- gama.machine_time div 1000;
			time_now <- time_now + 1;
		}
		current_time <- int((time_now - 0.01) div (stop_time / n_month_by_turn)) + 1;
//		write "Time: " + time_now + " s, Turn: " + count_start + " Month: " + current_time ;
		
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
	}
	
//	reflex end_game when:time_now>=max_time{
//		time_now <- max_time;
////		count_start <- 0 ;
//		can_start <- false;
//		do save_total_seeds_to_csv;
//	}
	
	action save_total_seeds_to_csv;
	
	reflex do_resume when: (not paused) and can_start{
//		write "alien_experimant" + alien_experimant;
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
		if tutorial_finish{
			count_start <- count_start + 1 ;
			init_time <- gama.machine_time div 1000;
			can_start <- false ;
			do growth_up;
		}
		
		do resume_game;
	}
	action resume_game;
	
	reflex do_pause when: (time_now >= stop_time*count_start) and (cycle != 0) and tutorial_finish{
		ask sign{
			icon <- play;
//			write "change to start icon.";
		}
		can_start <- true ;
		
		do pause;
		do pause_game;
	}
	
	action pause_game;
	
//	reflex growth_up when: tutorial_finish and count_start>0{
	action growth_up {
		loop i from:0 to:length(n_tree)-1{
			write count_start;
			if alien_tree[i][count_start-1] = 1{
				write "Alien at i= " + i + " j= " + (count_start-1) + " num= "+ n_tree[i][count_start-1] + " num0.2= " + int(n_tree[i][count_start-1]*0.2);
			}
			
			if fruiting_stage[i][count_start-1] = 1{
//				write count_start;
//				list<tree> tree_list <- tree where (each.tree_type = i+1);
				tree_list <- tree where ((each.tree_type = i+1) and (each.location distance_to road_midpoint[map_zone[count_start-1]].location < 100));
//					write tree_list;

				if alien_experimant and alien_tree[i][count_start-1] = 1{
					loop j from:0 to: int(n_tree[i][count_start-1]*0.4)-1{
						ask tree_list[j]{
							write self;
							color <- #purple;
							it_alien <- true;
						}
					}
				}
				
				ask tree_list{
					it_state <- 4 ;
					if not it_alien{
						self.color <- color_state4 ;
					}
//					write self;
//					switch current_time {
//						match_one list_of_state1{
//							if not it_alien{
//								self.color <- color_state1 ;	
//							}
//							it_state <- 1 ;
//						}
//						match_one list_of_state2{
//							if not it_alien{
//								self.color <- color_state2 ;
//							}
//							it_state <- 2 ;
//						}
//						match_one list_of_state3{
//							if not it_alien{
//								self.color <- color_state3 ;
//							}
//							it_state <- 3 ;
//						}
//						match_one list_of_state4{
//							if not it_alien{
//								self.color <- color_state4 ;
//							}
//							it_state <- 4 ;
//						}
//					}
				}				
			}
			else if fruiting_stage[i][count_start-1] = 0{
				tree_list <- tree where ((each.tree_type = i+1) and (each.location distance_to road_midpoint[map_zone[count_start-1]].location < 100));
				ask tree_list{
					it_state <- 1 ;
					if not it_alien{
						self.color <- color_state1 ;	
					}
//					switch current_time {
//						match_one list_of_state1{
//							if not it_alien{
//								self.color <- color_state1 ;	
//							}
//							it_state <- 1 ;
//						}
//						match_one list_of_state2{
//							if not it_alien{
//								self.color <- color_state2 ;
//							}
//							it_state <- 2 ;
//						}
//						match_one list_of_state3{
//							if not it_alien{
//								self.color <- color_state3 ;
//							}
//							it_state <- 3 ;
//						}
//						match_one list_of_state4{
//							if not it_alien{
//								self.color <- color_state4 ;
//							}
//							it_state <- 4 ;
//						}
//					}
				}
			}
		}
//		
//		ask tree{			
//			switch current_time {
//				match_one list_of_state1{
//					if not it_alien{
//						self.color <- color_state1 ;	
//					}
//					it_state <- 1 ;
//				}
//				match_one list_of_state2{
//					if not it_alien{
//						self.color <- color_state2 ;
//					}
//					it_state <- 2 ;
//				}
//				match_one list_of_state3{
//					if not it_alien{
//						self.color <- color_state3 ;
//					}
//					it_state <- 3 ;
//				}
//				match_one list_of_state4{
//					if not it_alien{
//						self.color <- color_state4 ;
//					}
//					it_state <- 4 ;
//				}
//			}	
//		}
	}
}

experiment init_exp type: gui {
	list<rgb> player_colors <-[#green, #blue, #yellow, #orange, #lime, #purple];
	float seed <- 0.5;
	
	output{
		layout vertical([horizontal([0::1, 1::1])::1, 2::1]) ;//tabs:false consoles:false toolbars:false;
		display "Main" type: 3d background: rgb(50,50,50){
			camera 'default' locked:false distance:550 ;
//			grid my_grid border: #darkgreen;
			species road refresh: false;
			species island refresh: false;
			species tree;
//			species player2;
			species sign;
			
			event #mouse_down {
				if ((#user_location distance_to sign[0]) < 25) {
					ask world {
						do resume;
					}
				}
			}

			graphics Strings {
				draw "Current turn: "+ count_start at:{width/3, -45} font:font("Times", 20, #bold+#italic) ; 
				if tutorial_finish{
					draw "Remaining time: "+ ((stop_time*count_start - time_now) div 60) + " minutes " + ((stop_time*count_start - time_now) mod 60) + " seconds" at:{width/3, -20} font:font("Times", 20, #bold+#italic) ;
				}
				else{
					draw "Tutorial" at:{width/3, -20} font:font("Times", 20, #bold+#italic) ;
				}
				
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