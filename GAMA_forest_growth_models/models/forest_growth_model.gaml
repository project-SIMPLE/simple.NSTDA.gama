/**
* Name: newgrowthModel
* Based on the internal empty template. 
* Author: pchwx
* Tags: 
*/


model growthModel

global{
	
	int map_size <- 100;
	geometry shape <- square(map_size #m);
	int n_simulation <- 20;
	int player_ID <- 1;
	
	int n_type;
	list<int> n_tree <- [];
	float init_height <- 50.0 #cm;
	float init_RCD <- 2.0 #cm;
	float init_time <- 0.0;
	int num_of_oldtree <- 2859; //2859
	
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
	
	list<tree> survi_tree_sort_height;
	
	list<list> avg_height_list <- [[],[],[],[],[],[],[],[],[],[]];
	list<list> avg_RCD_list <- [[],[],[],[],[],[],[],[],[],[]];
	list<int> count_tree_survi <- [0,0,0,0,0,0,0,0,0,0];
	list<int> finaldeath_tree <- [0,0,0,0,0,0,0,0,0,0];
	
	list<rgb> color_list <- [#red, #blue, #green, #teal, #cyan, #magenta, #orange, #purple, #pink, #brown, 
								#lime, #crimson, #indigo, #gray, #coral];
								
	rgb color_oldtree <- rgb(163, 191, 172);
	
	// Read Tree Data
	file my_csv_file <- csv_file( "../includes/GAMA_RGR_16-12-24.csv");
	
	// Read seed data
	file seeds_file <- csv_file( "../result/total_seeds.csv");
	file alien_seeds_file <- csv_file( "../result/total_alien_seeds.csv");
	
	init{
		
		matrix seed_data <- matrix(seeds_file);
		matrix alien_seed_data <- matrix(alien_seeds_file);
		n_type <- seed_data.columns - 1; 
		
		// seed data
		write 'player ID' + player_ID;
		
		loop i from: 1 to: seed_data.columns -1 {
			add int(seed_data[i,player_ID-1])*10 to:n_tree;
		}
		
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
		
		loop i from:1 to: n_type{
			add int((n_tree[i-1] * germination_rate[i-1] ) / 100) to:initial_treeid;
		}
		
		write initial_treeid;
		
		loop i from:1 to: n_type{
			create tree number: initial_treeid[i-1]{
				tree_type <- i;
			}
		}
			
		
		create old_tree number: num_of_oldtree{
			height_oldtree <- rnd(500.0 , 3500.0);
			RCD_oldtree <- rnd(16.0, 100.0);
		}
		
		ask tree{
			add self to: list_survive_tree;
		}
	}
	
	reflex inc_height_RCD {
		count_tree_survi <- [0,0,0,0,0,0,0,0,0,0];
		finaldeath_tree <- [0,0,0,0,0,0,0,0,0,0];
		
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
		}
	}

//	reflex cal_avg{
//		loop j from:1 to:n_type{
//			float sum_height <- 0.0;
//			float sum_RCD <- 0.0;
//			int count <- 0;
//			ask tree{
//				if tree_type = j and self in list_survive_tree{
//					sum_height <- sum_height + height;
//					sum_RCD <- sum_RCD + RCD;
//					count <- count + 1;
//				}			
//			}
//			if count > 0{
////				avg_tree_list[j-1] <- sum/count; 	
//				add with_precision(sum_height/count, 2)to: avg_height_list[j-1] ;
//				add with_precision(sum_RCD/count, 2)to: avg_RCD_list[j-1];
//			}
//		}
//	}
	
	
	reflex stop_simulation when: cycle >= n_simulation{
			do pause;
	}
	
}

species tree{
	int tree_type;
	float height <- 50.0 #cm;
	float RCD <- 2.0 #cm;
	bool death <- false;
	
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
		}
	}
	if cycle < 5{
		if flip(1 - float(survi_rate_y2[tree_type - 1])){
			remove self from: list_survive_tree;
			add self to: list_deathtree;
			death <- true;
		}
	}
	if cycle >= 5 {
		if flip(1 - survi_rate_y5){
			remove self from: list_survive_tree;
			add self to: list_deathtree;
			death <- true;
		}
	}
}
	
	aspect base {
		draw cylinder(RCD#cm, height#cm) color:death ? #black : color_list[tree_type - 1];
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

experiment visualize_tree_growth{
	
	init{
		loop i from:2 to:6{
			create simulation with:[player_ID:i];
		}
	}
	
	output{
//		layout #split toolbars: false tabs: false parameters: false consoles: false navigator: false controls: true tray: false;
		display 'Tree' type:3d{
			species tree aspect: base;
			species old_tree aspect: base;
		}
	}
}


