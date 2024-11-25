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

//grid my_grid width:3 height:2 use_regular_agents:false{
//	rgb color <- rgb(173, 158, 130);
//	init {
////        write "my column index is:" + grid_x;
////        write "my row index is:" + grid_y;
////        list<point> bugs_inside -> {road inside self};
//    }
//}

species sign {
	image_file icon <- play;
	aspect default {
		draw icon size: {50, 50};
	}
}

species tree{
	int tree_type <- 0;
	bool it_alien <- false;
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
			match_one [1]{
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
			match_one [2]{
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
			match_one [3]{
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
			match_one [4]{
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
			match_one [5]{
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
			match_one [6]{
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
			match_one [7]{
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
			match_one [8]{
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
			match_one [9]{
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
			match_one [10]{
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
			match_one [11]{
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
			match_one [12]{
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

species player2{
	int team <- 0;
	aspect default {
		draw circle(10#m) color: #blue border:#black;
		draw ("Team" + team) font:font("Times", 18, #bold); 
	}
}

species road{
	rgb color <- #grey;
	rgb color2 <- #white;
	float buffer_size <- 15.0;
	geometry geom_visu <- shape + buffer_size;
	aspect default {
		draw geom_visu color: color ;	
//		draw circle(100) color:color2;
	}
//	reflex write when:cycle=0{
//		write location;
//	}
}

species island{
	rgb color <- #grey;
	geometry shape <- square(80);
//	aspect default {
//		draw square(50) color: color ;
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