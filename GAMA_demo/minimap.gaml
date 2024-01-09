/**
* Name: minimap
* Based on the internal empty template. 
* Author: lilti
* Tags: 
*/


model minimap

global{
	int map_size <- 50;
	int grid_size <- map_size; 
	geometry shape <- square(map_size); 
	
	int initial_n_of_big_tree <- 5; 
	int initial_n_of_medium_tree <- 7; 
	int initial_n_of_small_tree <- 10; 
	int initial_n_of_seed <- 10; 
	
	int cut_tree_distance <- 3;
	int havest_seed_distance <- 3;
	int number_of_cut_trees <- 0;
	int number_of_harvested_seed <- 0;
	
	list inventory <- [];
	
	init{
		create big_tree number:(initial_n_of_big_tree);
		create medium_tree number:(initial_n_of_medium_tree);
		create small_tree number:(initial_n_of_small_tree);
		create seed_type1 number:(initial_n_of_seed);
		create player;
	}
}

grid my_grid width:grid_size height:grid_size neighbors:8{
	rgb color <- rgb(173, 158, 130);
}

species player{
	aspect default{
		draw circle(2#m) color:#red border:#black;
	}
}

species seed_type1{
	aspect default{
		draw circle(1#m) color:#yellow border:#black;
	}
}

species big_tree{
	bool on_fire <- false;
	aspect default{
		draw circle(3#m) color:on_fire? #black:rgb(24, 105, 21);
	}
}

species medium_tree{
	bool on_fire <- false;
	aspect default{
		draw circle(2#m) color:on_fire? #black:rgb(97, 135, 47);
	}
}

species small_tree{
	bool on_fire <- false;
	aspect default{
		draw circle(1#m) color:on_fire? #black:rgb(135, 135, 47);
	}
}


experiment MainExperiment type: gui {

    action player_move_up{
    	//write player + "move up";
    	write "player move up";
		ask player {
    		location <- point({self.location.x, self.location.y - 1, self.location.z});
    	}
    }
    action player_move_down{
    	//write player + "move down";
    	write "player move down";
    	ask player {
    		location <- point({self.location.x, self.location.y + 1, self.location.z});
    	}
    }
    action player_move_left{
    	//write player + "move left";
    	write "player move left";
    	ask player {
    		location <- point({self.location.x - 1, self.location.y, self.location.z});
    	}
    }
    action player_move_right{
    	//write player + "move right";
    	write "player move right";
    	ask player {
    		location <- point({self.location.x + 1, self.location.y, self.location.z});
    	}
    }
    action harvest_seed{
    	ask player{
    		int limit_harvest_per_action <- 0;
    		ask seed_type1 at_distance havest_seed_distance {
    			if limit_harvest_per_action < 1{
    				number_of_harvested_seed <- number_of_harvested_seed + 1;
    				limit_harvest_per_action <- limit_harvest_per_action+1;
    				add self to:inventory;
    				//write player + "harvest" + self;
    				write "player harvest" + self;
	    			do die;
    			}
	    	}
    	}
    }
    action cut_trees{
    	ask player{
    		int limit_cut_per_action <- 0;
    		ask big_tree at_distance cut_tree_distance {
	    		if limit_cut_per_action < 1 and not on_fire{
		    		number_of_cut_trees <- number_of_cut_trees + 1;
		    		limit_cut_per_action <- limit_cut_per_action+1;
		    		//write player + "cut" + self;
		    		write "player cut" + self;
		    		do die;
	    		}
	    	}
	    	ask medium_tree at_distance cut_tree_distance {
	    		if limit_cut_per_action < 1 and not on_fire{
		    		number_of_cut_trees <- number_of_cut_trees + 1;
		    		limit_cut_per_action <- limit_cut_per_action+1;
		    		//write player + "cut" + self;
		    		write "player cut" + self;
		    		do die;
	    		}
	    	}
	    	ask small_tree at_distance cut_tree_distance {
	    		if limit_cut_per_action < 1 and not on_fire{
		    		number_of_cut_trees <- number_of_cut_trees + 1;
		    		limit_cut_per_action <- limit_cut_per_action+1;
		    		//write player + "cut" + self;
		    		write "player cut" + self;
		    		do die;
	    		}
	    	}
    	}
    }
    
    output {
        display Main_map type: 2d{
            grid my_grid;
            
            species small_tree;
			species medium_tree;
			species big_tree;
			species seed_type1;
			species player;
			
            event #arrow_up action: player_move_up;
            event #arrow_down action: player_move_down;
            event #arrow_left action: player_move_left;
            event #arrow_right action: player_move_right;
            event 'v' action: harvest_seed;
            event 'c' action: cut_trees;
        }
        
        monitor "Number of cut tree" value: (number_of_cut_trees);
        monitor "Number of harvested seed " value: (number_of_harvested_seed);
    }
}
