/**
* Name: optimizeGAMAtrails
* Based on the internal empty template. 
* Author: lilti
* Tags: 
*/

model optimizeGAMAtrails

import "optimize_species.gaml"

// ทำให้ start ด้วย mid ให้ได้
// ทำเอเลี่ยนใหม่ done!

//1. เปลี่ยนสีผู้เล่นตาม สีแว่น กับ ลดขนาดพัด done!
//2. เช็คการเรียก model ต้นเบอร์ 7. Dios ใน period ที่ 5 done!
//3.  ทำกราฟแท่งให้มีระยะห่างระหว่าง team & fix ไม่ให้กราฟเลื่อน done!
//4. ปุ่ม start ตรง tutorial จะกดซ้ำไม่ได้ done!
//5. จะบอกให้ครูรู้ว่า ให้ start game ได้ถ้าคนเล่น tutorial เสร๋จแล้ว done!

global{
	// Parameter
	int n_team <- 6;
	int stop_time <- 10; //second
	
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
	bool it_end_game <- false;
	
	map<string, int> map_player_id <- ["Player_101"::1, "Player_102"::2, "Player_103"::3, "Player_104"::4, "Player_105"::5, "Player_106"::6];
			
	list<bool> who_connect <- [false,false,false,false,false,false];							
	list<bool> who_finish_tutorial <- [false,false,false,false,false,false];
	list<bool> player_walk_in_zone <- [false,false,false,false,false,false];
										
	list<rgb> player_colors <- [#blue, #red, #green, #yellow, #black, rgb(223,219,195)];
	
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
		write "do_resume";
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
			
//		if user_confirm("Confirmation","Do you want to start?"){
//			ask sign{
//				icon <- stop;
//			}
//			
//			if tutorial_finish{
//				count_start <- count_start + 1 ;
//				init_time <- gama.machine_time div 1000;
//				do growth_up;
//			}
//			
//			can_start <- false ;
//			do resume;
//			do resume_game;
//		}
//		else{
//			it_start <- false;
//			do pause;
//		}
		
		
	}
	action resume_game;
	
	reflex do_pause when: (time_now >= stop_time*count_start) and (cycle != 0) and not can_start and tutorial_finish{
		write "do_pause";
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
				}				
			}
		}
		if count_start >= 2{
			tree_list <- tree where (each.tree_zone = count_start-1);
			ask tree_list{
				it_state <- 1 ;
				self.color <- rgb(43, 150, 0);	
//				if not it_alien{
//					self.color <- rgb(43, 150, 0);	
//				}
			}
		}
	}
}

experiment init_exp type: gui {
	list tree_name <- ['Qu','Sa','Ma','Pho','De','Di','Os','Phy','Ca','Gm'];
	
	float seed <- 0.5;
	
	output{
		layout vertical([horizontal([0::1, 1::1])::1, 2::1]) 
		toolbars: false tabs: false parameters: false consoles: false navigator: false controls: false tray: false ;
		display "Main" type: 3d background: rgb(50,50,50){
//			camera 'default' distance:650 locked:true;
//			camera 'default' location: {385.6838,129.8469,554.5108} target: {385.6838,129.8373,0.0};
//			camera 'default' location: {337.9959,88.8131,554.5108} target: {337.9959,88.8035,0.0};
//			camera 'default' location: {339.1049,127.6289,554.5108} target: {339.1049,127.6193,0.0};
			camera 'default' location: {379.0297,127.6289,554.5108} target: {379.0297,127.6193,0.0};
//			species zone refresh: false;
			species road refresh: false;
			species island refresh: false;
			species tree aspect: for_plot;
			species sign;
			
			event #mouse_down {
				if ((#user_location distance_to sign[0]) < 25) and can_start {
					write 'click start!!!';
					ask world {
						if time_now<max_time{
							do resume;
							it_start <- true;
						}
					}
				}
			}

			graphics Strings {
				draw "Current Period: "+ count_start at:{width/3, -45} font:font("Times", 20, #bold+#italic) ; 
				if tutorial_finish{
					if not it_end_game{
						draw "Remaining time: "+ ((stop_time*count_start - time_now) div 60) + " minutes " + ((stop_time*count_start - time_now) mod 60) + " seconds" at:{width/3, -20} font:font("Times", 20, #bold+#italic) ;
					}
					else{
						draw "Finished!" at:{width/3, -20} font:font("Times", 20, #bold+#italic) ;
					}
				}
				else{
					draw "Tutorial" at:{width/3, -20} font:font("Times", 20, #bold+#italic) ;
				}
				
				loop i from:0 to:length(map_player_id)-1{
					if not who_connect[i]{
						draw "Team" + (i+1) + " - " at:{width+30, 20 + (40*i)} font:font("Times", 20, #bold+#italic) color:#yellow;
					}
					else{
						if not tutorial_finish{
							if who_finish_tutorial[i]{
	
								draw "Team" + (i+1) + " has finished the tutorial!" at:{width+30, 20 + (40*i)} font:font("Times", 20, #bold+#italic) color:#green;
							}
							else{
								draw "Team" + (i+1) + " has not finished the tutorial..." at:{width+30, 20 + (40*i)} font:font("Times", 20, #bold+#italic) color:#red;
							}
						}
						else{
							if not it_end_game{
								if player_walk_in_zone[i]{
									draw "Team" + (i+1) + " is inside zone " + count_start at:{width+30, 20 + (40*i)} font:font("Times", 20, #bold+#italic) color:#green;
								}
								else{
									draw "Team" + (i+1) + " is outside zone " + count_start at:{width+30, 20 + (40*i)} font:font("Times", 20, #bold+#italic) color:#red;
								}
							}
							else{
								draw "Team" + (i+1) + " finished the game" at:{width+30, 20 + (40*i)} font:font("Times", 20, #bold+#italic) ;							
							}
							
						}
					}
				}
			}
		}
		
		display "Total seeds" type: 2d locked:true{
			chart "Total seeds" type:histogram reverse_axes:true
			y_range:[0, 20 + max_total_seed]
			x_serie_labels: [""]
			
			style:"3d"
			series_label_position: xaxis
			{
				loop i from:0 to:(length(sum_total_seeds)-1){
					data "Team" + (i+1) value:int(sum_total_seeds[i])
					color:player_colors[i];
//					legend: string(int(sum_total_seeds[i])) ;
				}
			}
			graphics Strings {
				loop i from:0 to:(length(sum_total_seeds)-1){
					draw "=> " + int(sum_total_seeds[i]) at:{420,65 + 36*i} font:font("Times", 16, #bold+#italic) 
					border:#black color:player_colors[i];
				}
			}
		}
		
		display "Summary" type: 2d locked:true{ 		
			chart "Number of seeds by tree species and by team ID" type:histogram 
			x_serie_labels: ["Species"] 				
			y_range:[0, 10 + upper_bound] 		
			style:"3d" 			  
			series_label_position: xaxis {
				loop i from:0 to:(n_team-1){
					int temp <- 0 ;
					loop j from:0 to:((length(n_tree))-1){
						if not (j=0 or j=9){
							data "T"+ (i+1) + tree_name[temp] value: int(seeds[i][j] + alien_seeds[i][j]) 
//							data "T"+ (i+1) + tree_name[temp] value: 50
							color:player_colors[i] ;
//							legend: string(int(seeds[i][j] + alien_seeds[i][j])) ;
							temp <- temp + 1;
						}
						
					}
					data ""+ (i+1) value:0;
				}
			}
//			graphics Strings {
//				loop i from:0 to:(n_team-1){
//					int temp <- 0 ;
//					loop j from:0 to:((length(n_tree))-1){
//						if not (j=0 or j=9){
//							draw "" + int(seeds[i][j] + alien_seeds[i][j])  at:{100+ 36*i ,100} font:font("Times", 16, #bold+#italic) 
//							border:#black color:player_colors[i];
//							temp <- temp + 1;
//						}
//						
//					}
//					data ""+ (i+1) value:0;
//				}
//			}
		}	
	}
}

