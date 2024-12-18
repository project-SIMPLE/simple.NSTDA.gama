/**
* Name: optimizeGAMAtrails
* Based on the internal empty template. 
* Author: lilti
* Tags: 
*/

model optimizeGAMAtrails

import "optimize_species.gaml"

// สี player สี road
// ทำ แสดงผลการเล่น tutorial ว่าคนไหนเสร็จหรือยังไม่เสร็จ
// ทำส่วนที่บอกว่าแว่นไหนคือ team ไหน

global{
	// Parameter
	int n_team <- 6;
	int stop_time <- 180; //second
	list<rgb> player_colors <-[#green, #blue, #yellow, #orange, #lime, #purple];
	
	// Variable
	shape_file Trail_shape_file <- shape_file("../includes/Trail.shp");
	csv_file my_csv_file <- csv_file("../includes/pheno_tz_16Dec2024.csv");
	
	geometry shape <- (envelope(Trail_shape_file));
	float width <- shape.width;
	float height <- shape.height;
	
	list<list<int>> fruiting_stage <- list_with(12, list_with(6, 0));
	list<list<int>> n_tree <- list_with(12, list_with(6, 0));
	list<list<int>> alien_tree <- list_with(12, list_with(6, 0));
	list<list<int>> seeds <- list_with(n_team, list_with(length(n_tree), 0));
	list<list<int>> alien_seeds <- list_with(n_team, list_with(length(n_tree), 0));
	list<int> sum_total_seeds <- list_with(n_team, 0);
	
	int init_time <- 0;
	int time_now <- 0;
	int count_start <- 0 ;
	int current_time <- 1 ;
	int max_time <- stop_time * 6;
	bool it_start <- false;
	bool can_start <- true ;
	rgb color_state1 <- rgb(117, 148, 69);
	rgb color_state2 <- rgb(133, 134, 66);
	rgb color_state3 <- rgb(165, 105, 60);
	rgb color_state4 <- rgb(198, 76, 54);
	int upper_bound;
	int max_total_seed;
	
	bool alien_experimant <- false;
	
	geometry usable_area;
	geometry usable_area_for_tree;
	geometry my_overlap_for_tree;
	list<geometry> road_midpoint;

	list<int> map_zone <- list<int>([0::0, 1::2, 2::4, 3::5, 4::3, 5::1 ]);
	
	list<tree> tree_list <- [];
	list<string> player_id_list <- [];
	
	list<string> player_id_finish_tutorial_list <- [];
	bool tutorial_finish <- false;
	
	map<string, int> map_player_id ;
	
	init{
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
			
			ask zone{do die;}
			loop j from:0 to:length(n_tree[0])-1{
				create zone {
					location <- road_midpoint[map_zone[j]].location;
				}
			}
			
			int count_create_tree <- 0;
			
			loop i from:0 to:length(n_tree)-1{
				loop j from:0 to:length(n_tree[i])-1{
					if n_tree[i][j] > 0{
						loop cnt from:1 to:n_tree[i][j]{
							create tree{
								tree_type <- i+1 ;
								tree_zone <- j+1;
								if count_create_tree > 0{
									ask tree[count_create_tree-1] {
										usable_area_for_tree <- usable_area_for_tree - self.shape;
										usable_area <- usable_area + self.shape;
									}
								}
								
								if (usable_area_for_tree = nil) {
									is_ok <- false;
								} 
								
								else {		
									my_overlap_for_tree <- usable_area_for_tree inter zone[j].shape ;	
									location <- any_location_in(my_overlap_for_tree);
									count_create_tree <- count_create_tree + 1;
								}
							}
						}						
						if (not is_ok) {
							write 'Geometry not enough';
							break;
						}
					}
				}
			}
		}
		
		save usable_area to:"../includes/export/usable_area.shp" format:"shp";
		save usable_area_for_tree to:"../includes/export/usable_area_for_tree.shp" format:"shp";
		save union(road_midpoint) to:"../includes/export/road_midpoint.shp" format:"shp";
		
		ask tree {
			list_of_state1 <- list<int>(assign_list_of_state(1, tree_type));
			list_of_state2 <- list<int>(assign_list_of_state(2, tree_type));
			list_of_state3 <- list<int>(assign_list_of_state(3, tree_type));
			list_of_state4 <- list<int>(assign_list_of_state(4, tree_type));
		}
	}
		
	reflex update_time_and_bound when: it_start and tutorial_finish{
		if (gama.machine_time div 1000) - init_time = 1{
			init_time <- gama.machine_time div 1000;
			time_now <- time_now + 1;
		}
		current_time <- int((time_now - 0.01) div stop_time) + 1;
		
		loop i from:0 to:(length(sum_total_seeds)-1){
			sum_total_seeds[i] <- int(sum(seeds[i])) + int(sum(alien_seeds[i]));
		}
		max_total_seed <- int(max(sum_total_seeds));
		
		loop i from:0 to:(n_team-1){
			loop j from:0 to:((length(n_tree))-1){ 
				int temp <- int(seeds[i][j] + alien_seeds[i][j]);
				if temp > upper_bound{
					upper_bound <- temp;
				}
						
			}	
		}
	}
	
	action save_total_seeds_to_csv;
	
	reflex do_resume when: it_start and can_start{

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
	
	reflex do_pause when: (time_now >= stop_time*count_start) and (cycle != 0) and not can_start{
		ask sign{
			icon <- play;
		}
		
		it_start <- false;
		can_start <- true ;
		do pause_game;
	}
	
	action pause_game;
	
	action growth_up {
		loop i from:0 to:length(n_tree)-1{
			if alien_tree[i][count_start-1] = 1{
				write "Alien at i= " + i + " j= " + (count_start-1) + " num= "+ n_tree[i][count_start-1] + " num0.2= " + int(n_tree[i][count_start-1]*0.2);
			}
			
			if fruiting_stage[i][count_start-1] = 1{
				tree_list <- tree where ((each.tree_type = i+1) and (each.tree_zone = count_start));

				if alien_experimant and alien_tree[i][count_start-1] = 1{
					loop j from:0 to: int(n_tree[i][count_start-1]*0.4)-1{
						ask tree_list[j]{
							write self;
							color <- #red;
							it_alien <- true;
						}
					}
				}
				
				ask tree_list{
					it_state <- 4 ;
					if not it_alien{
						self.color <- color_state4 ;
					}
				}				
			}
		}
		if count_start >= 2{
			tree_list <- tree where (each.tree_zone = count_start-1);
			ask tree_list{
				it_state <- 1 ;
				if not it_alien{
					self.color <- rgb(43, 150, 0);	
				}
			}
		}
	}
}

experiment init_exp type: gui {
	list tree_name <- ['Qu','Sa','Ma','Ph','De','Di','Os','Ph','Ca','Gm'];
	
	float seed <- 0.5;
	
	output{
		layout vertical([horizontal([0::1, 1::1])::1, 2::1]) 
		toolbars: false tabs: false parameters: false consoles: false navigator: false controls: false tray: false ;
		display "Main" type: 3d background: rgb(50,50,50){
			camera 'default' locked:false distance:550 ;
//			species zone refresh: false;
			species road refresh: false;
			species island refresh: false;
			species tree;
			species sign;
			
			event #mouse_down {
				if ((#user_location distance_to sign[0]) < 25) {
					write 'click start!!!';
					ask world {
						if time_now<max_time{
							do resume;
							it_start <- true;
//							tutorial_finish <- true;
						}
					}
				}
			}

			graphics Strings {
				draw "Current Period: "+ count_start at:{width/3, -45} font:font("Times", 20, #bold+#italic) ; 
				if tutorial_finish{
					if time_now<max_time{
						draw "Remaining time: "+ ((stop_time*count_start - time_now) div 60) + " minutes " + ((stop_time*count_start - time_now) mod 60) + " seconds" at:{width/3, -20} font:font("Times", 20, #bold+#italic) ;
					}
					else{
						draw "Finish!" at:{width/3, -20} font:font("Times", 20, #bold+#italic) ;
					}
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
					data "Team" + (i+1) value:int(sum_total_seeds[i])
					color:player_colors[i];
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
						if (j>0 and j<9) or (j>9){
							write temp;
							data "T"+ (i+1) + tree_name[temp-1] value: int(seeds[i][j] + alien_seeds[i][j]) 
							color:player_colors[i]; 
							temp <- temp + 1;
						}
						
					}
				}
			}
		}	
	}
}

