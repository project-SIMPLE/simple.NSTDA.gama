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
	
	float max_radius <- 200.0;
}


species sign {
	image_file icon <- play;
	aspect default {
		draw icon size: {50, 50};
	}
}
	

species player_info{
	int team <- 0;
}

species tree{
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
	geometry shape <- circle(5#m);
//	action initialize(geometry area) {
//		shape <- circle(3+size#m);
//		location <- any_location_in(area);
//	}
	
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
			match_one [13,14]{
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
			match_one [15,16]{
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
			match_one [17,18]{
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
			match_one [19,20]{
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
			match_one [21,22]{
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
			match_one [23,24]{
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

species river{
	aspect default {
		draw circle(max_radius#m) color:rgb(138, 178, 242);
		draw circle(5#m) color:#red;
	}
}

species road{
	rgb color <- #grey;
	float buffer_size <- 10.0;
	geometry geom_visu <- shape + buffer_size;
	aspect default {
		draw geom_visu color: color ;	
//		draw square(10) color:#white;
	}
	reflex write when:cycle=0{
		write location;
	}
}

species island{
	rgb color <- #grey;
	geometry shape <- square(40);
//	aspect default {
//		draw square(40) color: color ;
//	}
}

//species offroad{
//	rgb color <- #blue;
////	float buffer_size <- 0.0;
////	geometry geom_visu <- shape + buffer_size;
//	aspect default {
////		draw geom_visu color: #blue ;	
//		draw shape color: color ;	
//	}
//}