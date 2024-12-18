/**
* Name: NewModel
* Based on the internal empty template. 
* Author: pchwx
* Tags: 
*/

// ถ้า overlap กันให้ต้นที่เล็กกว่าตาย
// ทำเป็น multi-player 6 graph (6 teams) n_team
// read matrix 

model GROWTH_Model

global{
	
	int map_size <- 100;
	geometry shape <- square(map_size #m);
	
	int n_type ;
	list<int> n_tree <- [];
	
	int n_simulation <- 20;
	
	float init_height <- 50.0 #cm;
	float init_RCD <- 2.0 #cm ;
	
	float init_time <- 0.0;
	int num_of_survive_tree <- 0;
	int num_of_dead_tree <- 0;
	float survi_rate_y5 <- 0.99;
	
	list RCD_growth_rate <- [];
	list Height_growth_rate <- [];
	list Max_Height <- [];
	list Max_DBH <- [];
	list survi_rate_y1 <- [];
	list survi_rate_y2 <- [];
	list survi_rate_y3 <- [];
	
	list<tree> list_survive_tree <- [];
	list<tree> list_deathtree <- [];
	
	list<tree> survi_tree_sort_height;
	
	list<list> avg_height_list <- [[],[],[],[],[],[],[],[],[],[]];
	list<list> avg_RCD_list <- [[],[],[],[],[],[],[],[],[],[]];
	list<int> count_tree_survi <- [0,0,0,0,0,0,0,0,0,0];
	list<int> finaldeath_tree <- [0,0,0,0,0,0,0,0,0,0];
	list<rgb> color_list <- [#red, #blue, #green, #teal, #cyan, #magenta, #orange, #purple, #pink, #brown, 
								#lime, #crimson, #indigo, #gray, #coral];
								
	int player_ID <- 1;
	
	// Import Tree Data
	file my_csv_file <- csv_file( "../includes/RGR_GAMA_tree_cm copy.csv");
	
	// read seed data
	file seeds_file <- csv_file( "../result/total_seeds.csv");
	file alien_seeds_file <- csv_file( "../result/total_alien_seeds.csv");
	
	
	init{
		
		matrix seed_data <- matrix(seeds_file);
		matrix alien_seed_data <- matrix(alien_seeds_file);
		n_type <- seed_data.columns - 1; 
		
//		avg_height_list <- [[],[],[],[],[],[],[],[],[],[]];
//		avg_RCD_list <- [[],[],[],[],[],[],[],[],[],[]];
//		write avg_height_list;
//		avg_height_list <- list_with(n_type, []);
//		avg_RCD_list <- list_with(n_type, []);
//		write avg_height_list;

		write 'player ID' + player_ID;
		loop i from: 1 to: seed_data.columns -1 {
			add int(seed_data[i,player_ID-1])*10 to:n_tree;
		}
//		write n_tree;
//		write seed_data.columns;
//		write seed_data.rows;		

		matrix data <- matrix(my_csv_file);

		loop i from: 4 to: data.columns -1{
			loop j from: 0 to: data.rows-1{
				if i = 4{
					add int(data[i,j]) to:Max_DBH;
				}
				if i = 5{
					add int(data[i,j]) to:Max_Height;

				}
				if i = 6{
					add float(data[i,j]) to:survi_rate_y1;
//					add 1 to:survi_rate_y1;
				}
				if i = 7{
					add float(data[i,j]) to:survi_rate_y2;
						
				} 
				if i = 8{
					add float(data[i,j]) to:survi_rate_y3;
				
				} 
				if i = 9{
					add float(data[i,j]) to:Height_growth_rate;
			
				} 
				if i = 10{
					add float(data[i,j]) to:RCD_growth_rate;	
				
				} 
			}
		}
		
		loop i from:1 to:n_type{
			create tree number:n_tree[i-1]{
//			create tree number:100{
				tree_type <- i;
			}
		}

		
		ask tree {
			add self to: list_survive_tree;
//			write list_survive_tree;
//			write n_tree;
			
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
//				write height;
//				write RCD;
				
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
//			write height;
		}
//	write count_tree_survi;
//	write finaldeath_tree;
		
//		survi_tree_sort_height <- reverse(tree sort_by (each.RCD) inter list_survive_tree);
////		write survi_tree_sort_height;
//		ask survi_tree_sort_height{
////			write RCD;
////			write "I'm " + self;
//			ask list_survive_tree at_distance float(RCD#cm + 500#cm){
////				write "I'm overlapping " + self;
//				if self.RCD < myself.RCD{
//					if flip(0.01){
//						remove self from: list_survive_tree;
//						add self to: list_deathtree;
//						self.death <- true;
////						write "I'm die" + self;
//					}
//				}
//			}
//		}
	}

	reflex cal_avg{
		loop j from:1 to:n_type{
			float sum_height <- 0.0;
			float sum_RCD <- 0.0;
			int count <- 0;
			ask tree{
				if tree_type = j and self in list_survive_tree{
					sum_height <- sum_height + height;
					sum_RCD <- sum_RCD + RCD;
					count <- count + 1;
				}			
			}
			if count > 0{
//				avg_tree_list[j-1] <- sum/count; 	
				add with_precision(sum_height/count, 2)to: avg_height_list[j-1] ;
				add with_precision(sum_RCD/count, 2)to: avg_RCD_list[j-1];
			}
		}
//		write avg_tree_list; 
	}
	
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
//				write "sur1" + flip(1 - float(survi_rate_y1[tree_type - 1]));
//				write "sur1 " + (1 - float(survi_rate_y1[tree_type - 1])) +  flip(1 - float(survi_rate_y1[tree_type - 1]));
			}
		}
		if cycle < 5{
			if flip(1 - float(survi_rate_y2[tree_type - 1])){
				remove self from: list_survive_tree;
				add self to: list_deathtree;
				death <- true;
//				write "sur2 " + (1 - float(survi_rate_y2[tree_type - 1])) + flip(1 - float(survi_rate_y2[tree_type - 1]));
//				write "sur2" + flip(1 - float(survi_rate_y2[tree_type - 1]));
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
//		draw cylinder(RCD#cm, height#cm) color:death ? #grey : color_list[tree_type - 1];
		draw cylinder(RCD#cm, height#cm) color:color_list[tree_type - 1];
	}
}


experiment graph_growth_tree{
	
	output {
		display Height  type: 2d { 
			chart 'Tree Height' type: series background: #white style: exploded {
				loop k from: 1 to: n_type{
					data 'Tree Type'+k value: avg_height_list[k-1] color:color_list[k-1] marker_size: 1 ;
				}
			}
		}
		display RCD type:2d{
			chart 'Tree RCD' type: series background: #white style: exploded{
				loop k from: 1 to:n_type{
					data 'Tree Type'+k value: avg_RCD_list[k-1] color:color_list[k - 1] marker_size: 1 ;
				}
			}
		}
		display survive_and_death_tree type:2d{
			chart 'Number of survive tree and death tree' type: histogram 
			x_serie_labels: ["Type1","Type2","Type3","Type4","Type5","Type6","Type7","Type8","Type9","Type10","Type11","Type12","Type13","Type14","Type15"]
//			y_range:[0,n_type * n_tree]
//			series_label_position: xaxis
			y_label:'Number of Tree'
			{
				loop k from: 1 to:n_type{
//					write k;
					data "S"+k value:count_tree_survi[k-1] color:#blue;
					data "D"+k value:finaldeath_tree[k-1] color:#red; 
				}
			}
		}
	}
}

experiment growth_tree_sim{
	init {
		loop i from:2 to:6{
			create simulation with:[player_ID:i];
		}
	}
	
	
	output{
//		layout #split toolbars: false tabs: false parameters: false consoles: false navigator: false controls: true tray: false;
		display 'Tree' type:3d{
			species tree aspect: base;
		}
	}
}

experiment full_sim{
	output{
		layout #split toolbars: false tabs: false parameters: false consoles: true navigator: false controls: true tray: false;
		
		display 'Tree' type:3d{
			species tree aspect: base;
			camera #default location: {15,15,15} ;
		}
		
		display Height  type: 2d { 
			chart 'Tree Height' type: series background: #white style: exploded {
				loop k from: 1 to: n_type{
					data 'Tree Type'+k value: avg_height_list[k-1] color:color_list[k-1] marker_size: 1 ;
				}
			}
		}
		display RCD type:2d{
			chart 'Tree RCD' type: series background: #white style: exploded{
				loop k from: 1 to:n_type{
					data 'Tree Type'+k value: avg_RCD_list[k-1] color:color_list[k - 1] marker_size: 1 ;
				}
			}
		}
		display survive_and_death_tree type:2d{
			chart 'Number of survive tree and death tree' type: histogram 
			x_serie_labels: ["Type1","Type2","Type3","Type4","Type5","Type6","Type7","Type8","Type9","Type10","Type11","Type12","Type13","Type14","Type15"]
//			y_range:[0,n_type * n_tree]
//			series_label_position: xaxis
			y_label:'Number of Tree'
			{
				loop k from: 1 to:n_type{
//					write k;
					data "S"+k value:count_tree_survi[k-1] color:#blue;
					data "D"+k value:finaldeath_tree[k-1] color:#red; 
				}
			}
		}
	}
}