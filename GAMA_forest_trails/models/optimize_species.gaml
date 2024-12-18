/**
* Name: optimizespecies
* Based on the internal empty template. 
* Author: lilti
* Tags: 
*/


model optimizespecies

global {
	image_file play <- image_file("../images/play.png");
	image_file stop <- image_file("../images/stop.png");
	
}

species sign {
	image_file icon <- play;
	aspect default {
		draw icon size: {50, 50};
	}
}

species tree{
	int tree_type <- 0;
	int tree_zone <- 0;
	bool it_alien <- false;
	rgb color <- rgb(43, 150, 0);
	int it_state ;
	list<int> list_of_state1;
	list<int> list_of_state2;
	list<int> list_of_state3;
	list<int> list_of_state4;
	geometry shape <- circle(5#m);
	
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
					match 4 {
						return [1, 2, 3];
					}	
				}
			}
		}
	}
}

species road{
	rgb color <- #grey;
	float buffer_size <- 15.0;
	geometry geom_visu <- shape + buffer_size;
	aspect default {
		draw geom_visu color: color ;	
	}
}

species island{
	rgb color <- #grey;
	geometry shape <- square(80);
}

species zone{
	rgb color <- rnd_color(255);
	geometry shape <- circle(100#m);
	aspect default {
		draw shape color: color ;	
	}
}