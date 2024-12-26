/**
* Name: growthModel5sep2024
* Based on the internal empty template. 
* Author: pchwx
* Tags: 
*/


model growthModel

global{
	float init_height <- 1.0;
	float init_time <- 0.0;
	
	list<float> height_RGR <- [0.1993, 0.3524, 0.6645, 0.2242, 0.7543, 0.9576, 0.523, 0.8155, 0.3248, 0.50, 0.6093, 1.2531, 0.50, 0.55, 0.6761];
	list<float> RCD_RGR <- [0.2359, 0.7104, 1.0165, 1.5151, 1.2295, 1.4364, 0.6839, 1.2202, 0.9653, 1.0, 1.0601, 1.9072, 1.0, 0.6265, 1.3713];
	list<float> servi_rate <- [0.2667, 0.34, 0.3556, 0.9444, 0.5569, 0.6377, 0.5464, 0.4167, 0.4271, 0.5, 0.4954, 0.2509, 0.5, 0.49, 0.5917];
	list<float> max_height_list <- [30, 25, 35, 30, 25, 30, 10, 5, 5, 15, 15, 10, 12, 8, 20];
	
	list list_survive_tree <- [];
	list list_deadtree <- [];
	int num_of_survive_tree <- 0;
	int num_of_dead_tree <- 0;
	int n_type <- 15;
	int n_tree <- 1;
	
	
	init{
		loop i from:1 to:n_type{
			create tree number:n_tree{
				tree_type <- i;
			}
		}
		
		ask tree {
			add self to: list_survive_tree;
		}
	}
	
	reflex stop_simulation when: cycle >= 19{
			do pause;
		}
}

species tree{
	int tree_type ;
	float height <- 0.0;
	float RCD <- 0.0;
	
	// survival
	action survival_tree{
		
		if flip(1 - (servi_rate[tree_type - 1])){		
//		if flip(0.001){
			remove self from: list_survive_tree;
			
			add self to: list_deadtree;

		}
	}
	
	
	 
	// Logistic Growth Model
	float logist_growth (float max_height, float growth_rate){
		growth_rate <- growth_rate + rnd (-0.1, 0.1) * growth_rate;
		

		float height_logist <- (init_height * max_height) / 
								(init_height + (max_height - init_height) * exp (-(( growth_rate ) * (cycle - init_time) ))) ;
//								write height_logist;
//								write growth_rate;
		return height_logist;
	}
		
		
	reflex tree_growth {
		
		if self in list_survive_tree{
			float previous_height <- height;
			float previous_RCD <- RCD;
			
			height <- logist_growth(max_height_list[tree_type - 1], height_RGR[tree_type-1]);
				
			RCD <- logist_growth(150.0, RCD_RGR[tree_type-1]);
				
				
			if height < previous_height  {
				height <- previous_height;
			}
			if RCD < previous_RCD{
				RCD <- previous_RCD;
				}	
		}
	do survival_tree;
	num_of_survive_tree <- length(list_survive_tree);
	num_of_dead_tree <- length(tree) - num_of_survive_tree;
	
	}
	
	
}

experiment growth{
	list<rgb> color_list <- [#red, #blue, #green, #yellow, #cyan, #magenta, #orange, #purple, #pink, #brown, #lime, #turquoise, #indigo, #gold, #coral];
	output {
		display height  type: 2d  { 
			chart 'Tree Height' type: series background: #white style: exploded {
				loop i from: 0 to:(length(tree)-1){
					data 'height'+i value: tree[i].height color:color_list[tree[i].tree_type - 1] marker_size: 1 ;
				}

			}
		}
		display RCD type:2d{
			chart 'Tree RCD' type: series background: #white style: exploded{
				loop i from: 0 to:(length(tree)-1){
					data 'RCD'+i value: tree[i].RCD color:color_list[tree[i].tree_type - 1] marker_size: 1 ;
				}
			}
		}
		display numoftree type:2d{
			chart 'Number of survive tree and dead tree' type: histogram 
//			x_label:'Survive Tree','Dead Tree'
			y_range:[0,n_type * n_tree]
			y_label:'Number of Tree'
			x_serie_labels: ["Survive Tree","Dead Tree"]
			{
				data "Survive Tree" value:num_of_survive_tree color:#blue;
				data "Dead Tree" value:num_of_dead_tree color:#red;
			}
		}
	}
}
