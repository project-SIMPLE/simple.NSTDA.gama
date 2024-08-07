/**
* Name: test_shapefile
* Based on the internal empty template. 
* Author: lilti
* Tags: 
*/

model species_GAMA_forest_trails

global {
	image_file play <- image_file("../images/play.png");
	image_file stop <- image_file("../images/stop.png");
	
	int size <- 3 ;
	float max_radius <- 200.0;
	
}


species sign {
	image_file icon <- play;
	aspect default {
		draw icon size: {50, 50};
	}
}
	
species tree_info{
	int tree_type <- 0;
	bool it_alien <- false;
	bool can_collect ;
	int initial_seed <- 0;
	rgb color <- rgb(43, 150, 0);
	int it_state ;
	list list_of_state1 <- [];
	list list_of_state2 <- [];
	list list_of_state3 <- [];
	list list_of_state4 <- [];
}

species player_info{
	int team <- 0;
}

species tree parent:tree_info{
	
	action initialize(geometry area) {
		shape <- circle(3+size#m);
		location <- any_location_in(area);
	}
	
	aspect default{
		draw shape color:color;
	}
	
	list assign_list_of_state(int state, int type){
		switch type {
			match_one [1,2]{
				switch state {
					match 1 {
						return [3, 4, 9, 10];
					}
					match 2 {
						return [];
					}	
					match 3 {
						return [];
					}	
					match 4 {
						return [1, 2, 5, 6, 7, 8, 11, 12];
					}	
				}
			}
			match_one [3,4]{
				switch state {
					match 1 {
						return [5, 6, 11, 12];
					}
					match 2 {
						return [];
					}	
					match 3 {
						return [];
					}	
					match 4 {
						return [1, 2, 3, 4, 7, 8, 9, 10];
					}	
				}
			}
			match_one [5,6]{
				switch state {
					match 1 {
						return [1, 2, 7, 8];
					}
					match 2 {
						return [];
					}	
					match 3 {
						return [];
					}	
					match 4 {
						return [3, 4, 5, 6, 9, 10, 11, 12];
					}	
				}
			}
			match_one [7,8]{
				switch state {
					match 1 {
						return [1, 8, 9, 10, 11, 12];
					}
					match 2 {
						return [2, 3];
					}	
					match 3 {
						return [4, 5];
					}	
					match 4 {
						return [6, 7];
					}	
				}
			}
			match_one [9,10]{
				switch state {
					match 1 {
						return [6, 7, 8, 9, 10];
					}
					match 2 {
						return [11, 12];
					}	
					match 3 {
						return [1, 2];
					}	
					match 4 {
						return [3, 4, 5];
					}	
				}
			}
			match_one [11,12]{
				switch state {
					match 1 {
						return [4, 5, 6, 7, 8];
					}
					match 2 {
						return [9, 10];
					}	
					match 3 {
						return [11, 12];
					}	
					match 4 {
						return [1, 2, 3];
					}	
				}
			}
		}
	}
}

species player parent:player_info{
	aspect default {
		draw circle(10#m) color: #blue border:#black;
		draw ("Team" + team) font:font("Times", 18, #bold); 
	}
}

//species road skills: [road_skill] {
//	aspect default {
//		draw shape + 1#m color: #white depth:1;
////		draw shape color: #white ;
//	}
//}

species river{
	aspect default {
		draw circle(max_radius#m) color:rgb(138, 178, 242);
		draw circle(5#m) color:#red;
	}
}

species road{
	float buffer_size <- 5.0;
	geometry geom_visu <- shape + buffer_size;
	aspect default {
		draw geom_visu color: #grey ;	
	}
}

species bg{
	aspect default {
		draw shape color: #black ;	
	}
}