/**
* Name: newgrowthModel
* Based on the internal empty template. 
* Author: pchwx
* Tags: 
*/


model growthModel

global{
	float seed <- 0.0469534499137082 ;
	int map_size <- 100;
	geometry shape <- square(map_size #m);
	int n_simulation <- 21;
	int player_ID <- 1;
	
	int n_type;
	list<int> n_tree <- [];
	float init_height <- 50.0 #cm;
	float init_RCD <- 2.0 #cm;
	float init_time <- 0.0;
	int num_of_oldtree <- 2859; 
	int n_circles <- 10;
	
	int num_of_survive_tree <- 0;
	int num_of_dead_tree <- 0;
	list<tree> list_survive_tree <- [];
	list<tree> list_deathtree <- [];
	
	list RCD_growth_rate <- [];
	list Height_growth_rate <- [];
	list Max_Height <- [];
	list Max_DBH <- [];
	
	list survi_rate_y1 <- [];
	list survi_rate_y2 <- [];
	list survi_rate_y3 <- [];
	float survi_rate_y5 <- 0.99;
	
	list canopy_width <- [];
	list<int> germination_rate <- [];
	list<int> initial_treeid <- [];
	float total_tree;
	
	list<list> avg_height_list ; //<- [[],[],[],[],[],[],[],[],[],[]]
	list<list> avg_RCD_list ;  //[[],[],[],[],[],[],[],[],[],[]]

	list<int> count_tree_survi <- list_with(n_type,0); 
	list<int> finaldeath_tree <- list_with(n_type,0);
	
	list<int> count_tree_in_circles <- [0,0,0,0,0,0,0,0,0,0];
	list<int> count_old_tree_in_circles <- [0,0,0,0,0,0,0,0,0,0];
	
	int alien_germination_rate <- 100;
	float alien_survi_rate <- 1.00;
	
	int type_of_scenario <- 3;	
	
 	list<rgb> color_list <- [#magenta, #green, #tan, #yellow, #pink, #gray, #coral, #gold,#blue , #olive];
//	list<rgb> color_list <- [#red, #blue, #green, #teal, #cyan, #magenta, #orange, #purple, #pink, #brown, 
//								#lime, #crimson, #indigo, #gray, #coral];
								
	map<string, string> map_player_id <- ["Team1"::"Blue", "Team2"::"Red", "Team3"::"Green", "Team4"::"Yellow", "Team5"::"Black", "Team6"::"White"];
	map<string, rgb> map_player_color <- ["Team1"::rgb(66, 72, 255), "Team2"::#red, "Team3"::#green, "Team4"::rgb(255, 196, 0), "Team5"::#black, "Team6"::rgb(156, 152, 142)];
	
	
	rgb color_oldtree <- rgb(163, 191, 172);
	
	list<string> team_id <- [];
	
	geometry use_able_area <- shape - 5;
	int cnt_created_circles <- 0;
	int cnt_created_old_tree <- 0;
	int cnt_created_tree <- 0;
	
	// Read Tree Data
	file my_csv_file <- csv_file( "../includes/GAMA_RGR_07-01-25.csv");
	
	// Read seed data
//	file seeds_file <- csv_file( "../result/total_seeds.csv");
//	file alien_seeds_file <- csv_file( "../result/total_alien_seeds.csv");
	file min_seed_file <- csv_file( "../result/min_collect_seed.csv");

	// Read real seed data from multi-player
	file seeds_file <- csv_file( "../../GAMA_forest_trails/results/22Dec_result/total_seeds.csv");
	file alien_seeds_file <- csv_file( "../../GAMA_forest_trails/results/22Dec_result/total_alien_seeds.csv");


	init{
		
		// tree data
		matrix tree_data <- matrix(my_csv_file);
		
		loop i from: 4  to: tree_data.columns-1{
			loop j from: 1 to:tree_data.rows-1{
				if i = 4{
					add int(tree_data[i,j]) to:Max_DBH;
				}
				if i = 5{
					add int(tree_data[i,j]) to:Max_Height;

				}
				if i = 6{
					add float(tree_data[i,j]) to:survi_rate_y1;
				
				}
				if i = 7{
					add float(tree_data[i,j]) to:survi_rate_y2;
						
				} 
				if i = 8{
					add float(tree_data[i,j]) to:survi_rate_y3;
				
				} 
				if i = 9{
					add float(tree_data[i,j]) to:Height_growth_rate;
			
				} 
				if i = 10{
					add float(tree_data[i,j]) to:RCD_growth_rate;	
				}
				
				if i = 11{
					add float(tree_data[i,j]) to:canopy_width;
				}
				
				if i = 12{
					add int(tree_data[i,j]) to:germination_rate;
				}
			}
		}
		
		
		loop i from: 1 to:n_circles{
				create my_circles {
					if cnt_created_circles > 0{
						ask my_circles[cnt_created_circles - 1]{
							use_able_area <- (use_able_area - (self.shape+7));
						}
					}
					location <- any_location_in(use_able_area);
					cnt_created_circles <- cnt_created_circles + 1;
				}
		}
		
		save use_able_area to: "use_able_area_circle.shp" format:"shp";
		
		matrix seed_data <- matrix(seeds_file);
		matrix alien_seed_data <- matrix(alien_seeds_file);
		matrix minimum_seed <- matrix(min_seed_file);
		
		n_type <- seed_data.columns - 1; 
		
		loop i from: 1 to: n_type {
		   add [] to: avg_height_list;
		   add [] to: avg_RCD_list;
		}
		
		loop i from: 0 to: seed_data.rows - 1{
			add seed_data[0,i] to: team_id;
		}
		
		// seed data
//		write 'player ID' + player_ID;
		
//		write "type_of_scenario is " + type_of_scenario;
		switch type_of_scenario{
			match 1{
				// min collect seed
				loop i from: 1 to:  minimum_seed.columns -1 {
					add int(minimum_seed[i,0])*3 to:n_tree;
				}
			}
			match 2{
				// max collect seed
				loop i from: 1 to:  minimum_seed.columns -1 {
					add int(minimum_seed[i,0])*3*1.3 to:n_tree;
				}
			}
			match 3{
				// multi-player & Check Alien 
				loop i from: 1 to: alien_seed_data.columns-1{
					if int(alien_seed_data[i,player_ID-1]) > 0{
						add int(int(alien_seed_data[i,player_ID-1]) + int(seed_data[i,player_ID-1]))*3 to: n_tree;
						germination_rate[i-1]  <- alien_germination_rate;
						survi_rate_y1[i-1] <- alien_survi_rate;
						survi_rate_y2[i-1] <- alien_survi_rate;
						survi_rate_y3[i-1] <- alien_survi_rate;
					}
					
					else{
						add int(seed_data[i,player_ID-1])*3 to:n_tree;
		
					}
				}
			}
		}

		// germination rate 
		loop i from:1 to: n_type{
			add int((n_tree[i-1] * germination_rate[i-1] ) / 100) to:initial_treeid;
		}
		
//		write initial_treeid;
		
//		int total_initial_treeid <- sum(initial_treeid);
//		write total_initial_treeid;
//		int total_survive_tree <- sum(count_tree_survi);
//		write total_survive_tree;
		
		use_able_area <- shape - 1;
		loop i from:1 to:num_of_oldtree{
			create old_tree {
				height_oldtree <- rnd(500.0 , 3500.0);
				RCD_oldtree <- rnd(16.0, 100.0);
				
				if cnt_created_old_tree > 0{
					ask old_tree[cnt_created_old_tree - 1]{
						use_able_area <- (use_able_area - (self.shape));
					}
				}
				location <- any_location_in(use_able_area);
				cnt_created_old_tree <- cnt_created_old_tree + 1;
			}
		}
		
		
		loop i from:1 to: n_type{
			loop j from:1 to: initial_treeid[i-1]{
				create tree {
					tree_type <- i;
					
					if cnt_created_tree > 0{
						ask tree[cnt_created_tree - 1]{
							use_able_area <- (use_able_area - (self.shape));
						}
					}
					location <- any_location_in(use_able_area);
					cnt_created_tree <- cnt_created_tree + 1;
				}
			}
		}
		
		save use_able_area to: "use_able_area.shp" format:"shp";
		
		ask tree{
			add self to: list_survive_tree;
		}
		
		loop i from: 1 to: alien_seed_data.columns-1{
			if int(alien_seed_data[i,player_ID-1]) > 0{
				list<tree> list_alien_tree <- tree where (each.tree_type = i);
				write "Alien tree is " + list_alien_tree;
				ask list_alien_tree{
					is_alien <- true;
					write "alien is" + self;
				}
			}
		}
	}
	
	reflex inc_height_RCD {
		count_tree_survi <- list_with(n_type,0);
		finaldeath_tree <- list_with(n_type,0);
		
		ask tree{
			if self in list_survive_tree{
				float previous_height <- height;
				float previous_RCD <- RCD;
				
				height <- logist_growth(init_height, float(Max_Height[tree_type - 1] ), float(Height_growth_rate[tree_type-1]) );
				RCD <- logist_growth(init_RCD, float(Max_DBH[tree_type - 1] ), float(RCD_growth_rate[tree_type-1]) );

				
				if height < previous_height  {
					height <- previous_height;
				}
				if RCD < previous_RCD{
					RCD <- previous_RCD;
				}

			}
			do survival_tree;
			
			if self in list_survive_tree{
				count_tree_survi[tree_type-1] <- count_tree_survi[tree_type-1] + 1;
			}
			else{
				finaldeath_tree[tree_type-1] <- finaldeath_tree[tree_type-1] + 1;
			}
//			write sum(count_tree_survi);
		}
	}
	
	reflex stop_simulation when: cycle >= (n_simulation-1) {
		if cycle >= (n_simulation){
			do pause;
		}
		
		else{
	//		write survi_rate_y1;
	//		write survi_rate_y2;
	//		write survi_rate_y3;
			
			loop i from:0 to: length(my_circles)-1{
				int cnt <- 0 ;
				int cnt_oldtree <- 0;
				
				ask list_survive_tree overlapping my_circles[i] {
					cnt <- cnt + 1;
				}
				
				ask old_tree overlapping my_circles[i]{
					cnt_oldtree <- cnt_oldtree + 1;
				}
				
				count_tree_in_circles[i] <- cnt;
				count_old_tree_in_circles[i] <- cnt_oldtree;
				
//				list x <- old_tree where (each.shape overlaps my_circles[i].shape);
//				write "x=" + length(x) ;
			}
			
			
//			write int((( sum(count_old_tree_in_circles) + sum(count_tree_in_circles)) / 10) * 10000 / 78 );
	//		write count_tree_in_circles;
			write count_old_tree_in_circles;
		}
	}
}

species tree{
	int tree_type;
	float height <- 50.0 #cm;
	float RCD <- 10.0 #cm;
	bool death <- false;
	bool is_alien <- false;
	
	// Logistic Growth Model
	float logist_growth (float init_input, float max_height, float growth_rate){
		
		growth_rate <- growth_rate + rnd (-0.1, 0.1) * growth_rate;
		

		float height_logist <- (init_input * max_height) / 
								(init_input + (max_height - init_height) * exp (-(( growth_rate ) * (cycle - init_time) ))) ;
		return height_logist;

	}
	
	action survival_tree{
		if cycle = 1{
			if flip(1 - float(survi_rate_y1[tree_type - 1])){
				remove self from: list_survive_tree;
				add self to: list_deathtree;
				death <- true;
				height <- 50.0 #cm;
				RCD <- 5500.0  #cm;
			}
		}
//		if cycle < 5{
//			if flip(1 - float(survi_rate_y2[tree_type - 1])){
//				remove self from: list_survive_tree;
//				add self to: list_deathtree;
//				death <- true;
//				height <- 50.0  #cm;
//				RCD <- 5500.0  #cm;
//			}
//		}
		if cycle >= 3 {
			if flip(1 - survi_rate_y5){
				remove self from: list_survive_tree;
				add self to: list_deathtree;
				death <- true;
				height <- 50.0  #cm;
				RCD <- 5500.0  #cm;
			}
		}
	}
	
	aspect base {
		
		if is_alien{
			draw cylinder(RCD#cm, height#cm) color:#red;
			
		}
		else if death{
			
			draw cylinder(RCD#cm, height#cm) color:#black;
			
		}
		else{
			draw cylinder(RCD#cm, height#cm) color:color_list[tree_type - 1];
			
		}
		
//		draw cylinder(RCD#cm, height#cm) color:death ? #black : color_list[tree_type - 1];
//		draw cylinder(RCD#cm, height#cm) color:color_list[tree_type - 1];
	}
}

species old_tree{
	float height_oldtree;
	float RCD_oldtree;
	
	aspect base{
		draw cylinder(50#cm, 1#cm) color:color_oldtree;
	}
	
}

species my_circles{
	geometry shape <- circle(5 #m);
	aspect default{
		draw shape;
	}
}


experiment visualize_tree_growth{
	float minimum_cycle_duration <- 0.30;
	
	
	
	init{
		type_of_scenario <- 3;
		if length(team_id) > 1{
			loop i from:2 to:length(team_id){
				create simulation with:[player_ID:i];
			}
		}
		
	}
	
	
	output{
		

		layout vertical([horizontal([0::1, 1::1, 2::1])::1, horizontal([3::1, 4::1, 5::1])::1])
		toolbars: false tabs: false parameters: false consoles: false navigator: false controls: true tray: false;
		
		display 'TEAM' type:3d{
//			camera 'default' location: {100,100,50};
			camera 'default' location: {140.5357,139.5896,86.9179} target: {53.6178,52.6717,0.0};
			overlay position: { 5, 5 } size: { 180 #px, 30 #px } background: rgb(map_player_color[team_id[player_ID-1]]) transparency: 0.2 border: #black rounded: true
        {
//            	draw "survival tree: " + with_precision(sum(count_tree_survi) / sum(initial_treeid),3)
		draw "survival tree: " + sum(count_tree_survi) + " / " + sum(initial_treeid)
            	color: #black font: font("SansSerif", 15, #bold) at: { 10#px, 50#px };
//				draw "Team: " + player_ID color: # white font: font("SansSerif", 20, #bold) at: { 10#px, 20#px };
 				draw "" + team_id[player_ID-1] + " " + string(map_player_id[team_id[player_ID-1]]) color: # white font: font("SansSerif", 20, #bold) at: { 10#px, 20#px };
 				
         
    	draw "RSA: " + int ((( sum(count_old_tree_in_circles) + sum(count_tree_in_circles) ) / 10) * 10000 / 78 )
//    	draw "RSA: " + int ((( sum(count_old_tree_in_circles)   ) / 10) * 10000 / 78 )
        	color: #black font: font("SansSerif", 15, #bold) at: { 10#px, 70#px };
        // 
	    
        }
        	species my_circles aspect: default;
        	species old_tree aspect: base;
			species tree aspect: base;
			
			
		}
	}
}

//experiment mininum_collect_seed parent: visualize_tree_growth{
//	init{
//		type_of_scenario <- 1;
//		loop i from:2 to:6{
////			create simulation with:[player_ID:i];
//		}
//	}
//}
//
//experiment maximum_collect_seed parent: visualize_tree_growth{
//	init{
//		type_of_scenario <- 2;
//		loop i from:2 to:6{
////			create simulation with:[player_ID:i];
//		}
//	}
//}