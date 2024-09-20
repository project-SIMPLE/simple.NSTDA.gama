/**
* Name: NewModel
* Based on the internal empty template. 
* Author: pchwx
* Tags: 
*/

// update 29 Aug 2024 

model growthModel

global{
	
	float mort_rate <- 0.1;
	float init_tree_height <- 1.0;
	int time_step <- 0;
	
	// for plot
	list<float> for_plot_linear <- [];
	list<float> for_plot_expo <- [];
	list<float> for_plot_lo <- [];
	
	reflex update_height{
		
		ask tree{
//			do survival_tree;
//			write linear_growth(10.0,10.0);
//			heigth[0] <- linear_growth(0.1);
//			heigth[1] <- expo_growth(0.1);
			heigth[2] <- logistic_g(20.0, 0.2);
			
			write heigth;
		}
//		add tree[0].heigth[0] to: for_plot_linear; 
//		add tree[0].heigth[1] to: for_plot_expo; 
		add tree[0].heigth[2] to: for_plot_lo; 
//		write length(tree);
//		write for_plot_linear;
	}
	
	init{
		create tree number:10{
//			heigth[0] <- init_tree_height;
//			heigth[1] <- init_tree_height;
			heigth[2] <- init_tree_height;
		}
	}
}

species tree{
	list<float> heigth <- [0,0,0];
	
	// linear growth model
//	float linear_growth (float growth_rate){
//		float height_linear <- init_tree_height + (growth_rate * time_step);
//		return height_linear;
//	}
	
	
	// exponential growth model
//	float expo_growth (float growth_rate){
//		float height_expo <- init_tree_height * (exp(growth_rate * cycle));
//		return height_expo;
//	}
	
	float logistic_g (float max_height, float growth_rate){
		float height_logistic_g <- max_height / (1 + ((max_height - init_tree_height / init_tree_height) * exp(-growth_rate * cycle)));
		write max_height;
		write 1 + ((max_height - init_tree_height / init_tree_height) * exp(-growth_rate * cycle));
//		write exp(-growth_rate * time_step);
		return height_logistic_g;
	}	
	
	// survival
	action survival_tree{
		if flip(mort_rate){
			do die;
		}
	}
	
}


experiment growth{
	output {
		display height  type: 2d  { 
			chart 'Tree Height' type: series background: #white style: exploded {
//				data 'Linear' value: for_plot_linear color: rgb(46,204,113) marker_size: 2;
//				data 'Expo' value: for_plot_expo color: rgb(231,76,60) marker_size: 2;
				data 'lo' value: for_plot_lo color: rgb(231,76,60) marker_size: 2;
				
			}
		}
	}
}