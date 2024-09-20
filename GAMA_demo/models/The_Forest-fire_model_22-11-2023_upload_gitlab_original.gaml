/**
* Name: TheForestfiremodel
* Based on the internal empty template. 
* Author: lilti
* Tags: 
* Note: forest-fire model modified from https://scipython.com/blog/the-forest-fire-model/
*/

model TheForestfiremodel

global{
	bool main_model <- true;
	
	// Parameter Input
	int paintbrush_size <- 15;	//grid size per click when player make firebreak		//user input
	int map_size <- 200; //map size in #m
	int sub_map_size <- 50;
	
	float f <- 0.0; //prob of lighting strike
	float prob_on_fire <- 0.075; //prob of catching fire
	
	int initial_n_evacuation_point <- 50; //num of points for animals heading to when alerted 
	int initial_n_gibbon <- 500; //num of gibbons in map
	int initial_n_baby_deer <- 500; //num of deers in map
	int initial_n_of_big_tree <- 1000; //num of big-sized trees
	int initial_n_of_medium_tree <- 1000; //num of medium-sized trees
	int initial_n_of_small_tree <- 1000; //num of small-sized trees
	int initial_n_of_seed <- 10; //num of seed
	int initial_point_of_fire <- 1; //num of grid to catch fire when game starts
	
	int limit_block_of_firebreak <- 3000; //limit grid size for making firebreak 
	
	int perception_distance <- 5; //distance in #m between animals & fire before getting alerted 
	float gibbon_speed <- 1.0; //gibbon's moving speed in #m/s
	float baby_deer_speed <- 1.0; //deer's moving speed in #m/s 
	
	int max_fire_spread <- 1 ; //grid
	
	int cut_tree_distance <- 3;
	int havest_seed_distance <- 3;
	
	int distance_accept_onfire_in_firebreak <- 10;
	
	int percent_of_tree_in_submap <- 10;
	
	// Fixed parameter
	rgb firebreak_color <- rgb(107, 106, 106); // firebreak color
	int grid_size <- map_size; //now drawing a grid in same size as map size in #m
	geometry shape <- square(map_size); //make a squre map
	geometry sub_shape <- square(sub_map_size); //make a squre map
	
	int count_exit <- 0; //for counting survials who can reach evacuation point
	int count_die <- 0; //for counting the dead who got fired
	int count_point_of_fire <- 0;
	int count_block_of_firebreak <- 0;
	
	list fire_spread <- [0];
	int border_grid <- -1;
	
	list keep_index_list <- [];
	list keep_location_list <- [];
	
	int number_of_cut_trees <- 0;
	int number_of_harvested_seed <- 0;
	int number_of_burnt_area <- 0;
	int number_of_burnt_trees <- 0;
	int number_of_big_trees_in_fire_break <- 0;
	int number_of_medium_trees_in_fire_break <- 0;
	int number_of_small_trees_in_fire_break <- 0;
	
	bool can_enter <- true;
	
	list big_tree_in_firebreak <- [];
	list medium_tree_in_firebreak <- [];
	list small_tree_in_firebreak <- [];
	
	int initial_n_of_big_tree_on_sub_map <- 0;
	int initial_n_of_medium_tree_on_sub_map <- 0;
	int initial_n_of_small_tree_on_sub_map <- 0; 
	int firebreak_remaining <- 0;
	int big_tree_remaining_on_sub_map <- 0;
	int medium_tree_remaining_on_sub_map <- 0;
	int small_tree_remaining_on_sub_map <- 0;
	
	list inventory <- [];
	
	int n_big_tree_sub_map_onfire <- 1;
	int n_medium_tree_sub_map_onfire <- 1;
	int n_small_tree_sub_map_onfire <- 1;
	
	reflex create_fire_spreadList when: cycle=0{
		loop i from:1 to:max_fire_spread{
			add -i to:fire_spread;
			add i to:fire_spread;
		}
		border_grid <- max(fire_spread) + 1;
	}
	
	// catch fire
	reflex catch_fire when: count_point_of_fire < initial_point_of_fire and cycle < 1 and main_model{
		ask my_grid[rnd(0, grid_size), int(rnd((3*grid_size/4), grid_size))]{
    		if color != firebreak_color{
				color <- #red;
				count_point_of_fire <- count_point_of_fire+1;
			}
    	}
	}	
	
    //each zone has different tree density
    init{
    	if main_model{	    	
	    	//create big tree
			//area 1 a lot of big trees
			create big_tree number:(0.85*initial_n_of_big_tree){
				location <- {rnd(0, map_size), rnd(0, (map_size/3))};
			}
			//area 2 some big trees
			create big_tree number:(0.1*initial_n_of_big_tree){
				location <- {rnd(0, map_size), rnd((map_size/3), (2*map_size/3))};
			}
			//area 3 few big trees
			create big_tree number:(0.05*initial_n_of_big_tree){
				location <- {rnd(0, map_size), rnd((2*map_size/3), map_size)};
			}
			
			//create medium tree
			//area 2 a lot of medium trees 
			create medium_tree number:(0.9*initial_n_of_medium_tree){
				location <- {rnd(0, map_size), rnd((map_size/3), (2*map_size/3))};
			}
			//area 1 few medium trees
			create medium_tree number:(0.05*initial_n_of_medium_tree){
				location <- {rnd(0, map_size), rnd(0, (map_size/3))};
			}
			//area 3 few medium trees
			create medium_tree number:(0.05*initial_n_of_medium_tree){
				location <- {rnd(0, map_size), rnd((2*map_size/3), map_size)};
			}
			
			//create small tree
			//area 3 a lot of small trees
			create small_tree number:(0.85*initial_n_of_small_tree){
				location <- {rnd(0, map_size), rnd((2*map_size/3), map_size)};
			}
			//area 1 few small trees
			create small_tree number:(0.05*initial_n_of_small_tree){
				location <- {rnd(0, map_size), rnd(0, (map_size/3))};
			}
			//area 2 some small trees
			create small_tree number:(0.1*initial_n_of_small_tree){
				location <- {rnd(0, map_size), rnd((map_size/3), (2*map_size/3))};
			}
			
			//randomly create evacuation point at each eage of map
			create evacuation_point number:initial_n_evacuation_point{
				int side <- rnd(1,4);
				if side = 1{
					location <- {rnd(0, map_size), 0};
				}
				else if side = 2{
					location <- {map_size, rnd(0, map_size)};
				}
				else if side = 3{
					location <- {rnd(0, map_size), map_size};
				}
				else if side = 4{
					location <- {0, rnd(0, map_size)};
				}
			}
			
			//create gibbon
			create inhabitant_gibbon number: initial_n_gibbon{
				safety_point <- any(evacuation_point);
			}
			
			//create baby deer
			create inhabitant_baby_deer number: initial_n_baby_deer{
				safety_point <- any(evacuation_point);
			}
		}
    }
    
    //making a list of grid is catching fire
    reflex update when:count_point_of_fire > 0 and main_model{
    	list on_fire_list <- [];
    	loop ix from:border_grid-1 to: grid_size - border_grid{
    		loop iy from:border_grid-1 to: grid_size - border_grid{
    			ask my_grid[ix, iy]{
    				if color = #red{
    					add [ix, iy] to:on_fire_list;
    				}
    			}
    		}
		}
		number_of_burnt_area <- length(on_fire_list);
		
		loop index_in_on_fire_list from:0 to: length(on_fire_list)-1{
			int ix <- int(on_fire_list[index_in_on_fire_list][0]);
			int iy <- int(on_fire_list[index_in_on_fire_list][1]);
			loop n from:1 to:rnd(1,8){
				bool can_on_fire <- flip(prob_on_fire); //checking if grid neighbors catching fire 
				if can_on_fire{
					list<int> dx <- 1 among(fire_spread);
					list<int> dy <- 1 among(fire_spread);
					bool prob <- flip(1-0.573); // different chance of getting fired of diagonal grid
					
					if ((abs(dx[0]) != abs(dy[0])) and prob){
						break;
					}
					
					ask my_grid[ix + dx[0], iy + dy[0]]{
						/*if color = firebreak_color or color = #red{
							break;
						}*/
						if color = #red{
							break;
						}
						
						bool big_tree_in_distance <- false;
						bool medium_tree_in_distance <- false;
						bool small_tree_in_distance <- false;
						if color = firebreak_color{
							ask big_tree {
								if (self in big_tree_in_firebreak) and (myself distance_to self <= distance_accept_onfire_in_firebreak){
									//write big_tree_in_firebreak;
									//write self ;
									//write on_fire;
									
									if not on_fire{
										big_tree_in_distance <- true;
										break;	
									}
								}
							}
							ask medium_tree {
								if (self in medium_tree_in_firebreak) and (myself distance_to self <= distance_accept_onfire_in_firebreak){
									if not on_fire{
										medium_tree_in_distance <- true;
										break;	
									}
								}
							}
							ask small_tree {
								if (self in small_tree_in_firebreak) and (myself distance_to self <= distance_accept_onfire_in_firebreak){
									if not on_fire{
										small_tree_in_distance <- true;
										break;	
									}
								}
							}
							if not big_tree_in_distance and not medium_tree_in_distance and not small_tree_in_distance{
								break;
							}
							else{
								if firebreak_remaining >= 0{
									firebreak_remaining <- firebreak_remaining - 1;
								}
							}
						}
						
						
						color <- #red; //grid is red when catching fire
						ask big_tree overlapping self{
							do count_burnt_trees;
							on_fire <- true; //tree is burnt when the center overlapps burning grid
						}
						ask medium_tree overlapping self{
							do count_burnt_trees;
							on_fire <- true;
						}
						ask small_tree overlapping self{
							do count_burnt_trees;
							on_fire <- true;
						}
						ask inhabitant_gibbon at_distance perception_distance{
							is_alerted <- true; //animals in perception_distance from burning grid get alerted 
						}
						ask inhabitant_baby_deer at_distance perception_distance{
							is_alerted <- true;
						}
					}
				}
			}
			ask my_grid[ix, iy]{
				ask inhabitant_gibbon overlapping self{
					do it_die; //animals overlaps burning grid is dead
					do die;
				}
				ask inhabitant_baby_deer overlapping self{
					do it_die;
					do die;
				}
			}
		}
	}
	//create ligthing strike
	reflex ligthing when: flip(f) and main_model{
		ask my_grid[rnd(0,grid_size-1),rnd(0,grid_size-1)]{
			if color != #red{
				color <- #red;
			}
		}
	}
	//Stopping criteria when all animals dead
	reflex stop_simu when: empty(inhabitant_gibbon) and empty(inhabitant_baby_deer) and main_model{
		do pause;
	}
	//Stopping criteria when player lose
	reflex player_lose when: firebreak_remaining < 0 {
		ask TheForestfiremodel_model[1]{
			ask player{
				write "You lose...";
				do die;	
			}
		}
	}
	reflex on_fire_tree_on_sup_map when: not can_enter{
		bool can_on_fire_big_tree <- false;
		bool can_on_fire_medium_tree <- false;
		bool can_on_fire_small_tree <- false;
		int count_on_fire_big_tree_in_firebreak <- 0;
		int count_on_fire_medium_tree_in_firebreak <- 0;
		int count_on_fire_small_tree_in_firebreak <- 0;
		
		
		ask big_tree {
			if self in big_tree_in_firebreak and on_fire{
				count_on_fire_big_tree_in_firebreak <- count_on_fire_big_tree_in_firebreak + 1;
			}
		}
		ask medium_tree {
			if self in medium_tree_in_firebreak and on_fire{
				count_on_fire_medium_tree_in_firebreak <- count_on_fire_medium_tree_in_firebreak + 1;
			}
		}
		ask small_tree {
			if self in small_tree_in_firebreak and on_fire{
				count_on_fire_small_tree_in_firebreak <- count_on_fire_small_tree_in_firebreak + 1;
			}
		}
		
		if initial_n_of_big_tree_on_sub_map > 0 {
			if count_on_fire_big_tree_in_firebreak - n_big_tree_sub_map_onfire*ceil(number_of_big_trees_in_fire_break/initial_n_of_big_tree_on_sub_map) >= 0{
				ask TheForestfiremodel_model[1]{
					ask big_tree{
						if not on_fire{
							on_fire <- true;
							break;
						}
					}
				}
				n_big_tree_sub_map_onfire <- n_big_tree_sub_map_onfire + 1;
			}			
		}
		
		if initial_n_of_medium_tree_on_sub_map > 0 {
			if count_on_fire_medium_tree_in_firebreak - n_medium_tree_sub_map_onfire*ceil(number_of_medium_trees_in_fire_break/initial_n_of_medium_tree_on_sub_map) >= 0{
				ask TheForestfiremodel_model[1]{
					ask medium_tree{
						if not on_fire{
							on_fire <- true;
							break;
						}
					}
				}
				n_medium_tree_sub_map_onfire <- n_medium_tree_sub_map_onfire + 1;
			}
		}
		
		if initial_n_of_small_tree_on_sub_map > 0 {
			if count_on_fire_small_tree_in_firebreak - n_big_tree_sub_map_onfire*ceil(number_of_small_trees_in_fire_break/initial_n_of_small_tree_on_sub_map) >= 0{
				ask TheForestfiremodel_model[1]{
					ask small_tree{
						if not on_fire{
							//write count_on_fire_small_tree_in_firebreak;
							on_fire <- true;
							break;
						}
					}
				}
				n_big_tree_sub_map_onfire <- n_big_tree_sub_map_onfire + 1;
			}
		}
	}
}

grid my_grid width:grid_size height:grid_size neighbors:8{
	rgb color <- rgb(173, 158, 130);
}

grid my_new_grid width:grid_size height:grid_size neighbors:8{
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
	action count_burnt_trees{
		number_of_burnt_trees <- number_of_burnt_trees + 1;
	}
	action count_big_tree_in_fire_break{
		number_of_big_trees_in_fire_break <- number_of_big_trees_in_fire_break + 1;
		//do die;
	}
}

species medium_tree{
	bool on_fire <- false;
	aspect default{
		draw circle(2#m) color:on_fire? #black:rgb(97, 135, 47);
	}
	action count_burnt_trees{
		number_of_burnt_trees <- number_of_burnt_trees + 1;
	}
	action count_medium_tree_in_fire_break{
		number_of_medium_trees_in_fire_break <- number_of_medium_trees_in_fire_break + 1;
		//do die;
	}
}

species small_tree{
	bool on_fire <- false;
	aspect default{
		draw circle(1#m) color:on_fire? #black:rgb(135, 135, 47);
	}
	action count_burnt_trees{
		number_of_burnt_trees <- number_of_burnt_trees + 1;
	}
	action count_small_tree_in_fire_break{
		number_of_small_trees_in_fire_break <- number_of_small_trees_in_fire_break + 1;
		//do die;
	}
}

species evacuation_point{
	action evacuate_inhabitant{
		count_exit <- count_exit + 1;
	}
	 
	aspect default{
		draw circle(2#m) color:#yellow border:#black;
	}
}

species inhabitant_gibbon skills:[moving]{
	bool is_alerted <- false;
	evacuation_point safety_point;
	
	aspect default{
		draw circle(1#m) color: is_alerted ? rgb(255, 149, 10) : #blue;
	}
	reflex evacuate when:is_alerted{
		do goto target: safety_point speed:gibbon_speed;
		if(self.location distance_to safety_point.location <2#m){
			ask safety_point{do evacuate_inhabitant();}
			do die;
		}
	}
	action it_die{
		count_die <- count_die + 1;
	}
}

species inhabitant_baby_deer skills:[moving]{
	bool is_alerted <- false;
	evacuation_point safety_point;
	
	aspect default{
		draw square(2#m) color: is_alerted ? rgb(255, 149, 10) : #purple;
	}
	reflex evacuate when:is_alerted{
		do goto target: safety_point speed:baby_deer_speed;
		if(self.location distance_to safety_point.location <2#m){
			ask safety_point{do evacuate_inhabitant();}
			do die;
		}
	}
	action it_die{
		count_die <- count_die + 1;
	}
}

experiment MainExperiment type: gui {
	action firebreak{
		if main_model{
			if count_block_of_firebreak < limit_block_of_firebreak and can_enter = true {
		 		point loc <- #user_location;
	
				loop n1 from:0 to:paintbrush_size/2{
		    		loop n2 from:0 to:paintbrush_size/2{
		    			int x1 <- int(loc.x)+n1;
		    			int x2 <- int(loc.x)-n1;
		    			int y1 <- int(loc.y)+n2;
		    			int y2 <- int(loc.y)-n2;
		    			
		    			if x1 > grid_size-1 or x1 < 0 or x2 > grid_size-1 or x2 < 0 or
		    			 y1 > grid_size-1 or y1 < (grid_size/2) or y2 > grid_size-1 or y2 < (grid_size/2) or
		    			 count_block_of_firebreak >= limit_block_of_firebreak{
		    				break;
		    			}
		    			
						ask my_grid[x1, y1]{
							if color != #red and color != firebreak_color{
								color <- firebreak_color;
								count_block_of_firebreak <- count_block_of_firebreak+1;
								add [x1, y1] to:keep_index_list;
								add location to:keep_location_list;
								
								ask big_tree overlapping self{
									if not (self in big_tree_in_firebreak){
										add self to:big_tree_in_firebreak;
										do count_big_tree_in_fire_break;
									}
								}
								ask medium_tree overlapping self{
									if not (self in medium_tree_in_firebreak){
										add self to:medium_tree_in_firebreak;
										do count_medium_tree_in_fire_break;
									}
								}
								ask small_tree overlapping self{
									if not (self in small_tree_in_firebreak){
										add self to:small_tree_in_firebreak;
										do count_small_tree_in_fire_break;
									}
								}
							}
			    		}
			    		ask my_grid[x2, y2]{
				    		if color != #red and color != firebreak_color{
								color <- firebreak_color;
								count_block_of_firebreak <- count_block_of_firebreak+1;
								add [x2, y2] to:keep_index_list;
								add location to:keep_location_list;
								
								ask big_tree overlapping self{
									if not (self in big_tree_in_firebreak){
										add self to:big_tree_in_firebreak;
										do count_big_tree_in_fire_break;
									}
								}
								ask medium_tree overlapping self{
									if not (self in medium_tree_in_firebreak){
										add self to:medium_tree_in_firebreak;
										do count_medium_tree_in_fire_break;
									}
								}
								ask small_tree overlapping self{
									if not (self in small_tree_in_firebreak){
										add self to:small_tree_in_firebreak;
										do count_small_tree_in_fire_break;
									}
								}
							}
			    		}
			    		ask my_grid[x1, y2]{
				    		if color != #red and color != firebreak_color{
								color <- firebreak_color;
								count_block_of_firebreak <- count_block_of_firebreak+1;
								add [x1, y2] to:keep_index_list;
								add location to:keep_location_list;
								
								ask big_tree overlapping self{
									if not (self in big_tree_in_firebreak){
										add self to:big_tree_in_firebreak;
										do count_big_tree_in_fire_break;
									}
								}
								ask medium_tree overlapping self{
									if not (self in medium_tree_in_firebreak){
										add self to:medium_tree_in_firebreak;
										do count_medium_tree_in_fire_break;
									}
								}
								ask small_tree overlapping self{
									if not (self in small_tree_in_firebreak){
										add self to:small_tree_in_firebreak;
										do count_small_tree_in_fire_break;
									}
								}
							}
			    		}
			    		ask my_grid[x2, y1]{
				    		if color != #red and color != firebreak_color{
								color <- firebreak_color;
								count_block_of_firebreak <- count_block_of_firebreak+1;
								add [x2, y1] to:keep_index_list;
								add location to:keep_location_list;
								
								ask big_tree overlapping self{
									if not (self in big_tree_in_firebreak){
										add self to:big_tree_in_firebreak;
										do count_big_tree_in_fire_break;
									}
								}
								ask medium_tree overlapping self{
									if not (self in medium_tree_in_firebreak){
										add self to:medium_tree_in_firebreak;
										do count_medium_tree_in_fire_break;
									}
								}
								ask small_tree overlapping self{
									if not (self in small_tree_in_firebreak){
										add self to:small_tree_in_firebreak;
										do count_small_tree_in_fire_break;
									}
								}
							}
			    		}	
		    		}
		    	}	
		 	}
		 	firebreak_remaining <- int(ceil(count_block_of_firebreak*(0.7)));
		}
    }
    action player_move_up{
    	write "player move up";
		ask player {
    		location <- point({self.location.x, self.location.y - 1, self.location.z});
    	}
    }
    action player_move_down{
    	write "player move down";
    	ask player {
    		location <- point({self.location.x, self.location.y + 1, self.location.z});
    	}
    }
    action player_move_left{
    	write "player move left";
    	ask player {
    		location <- point({self.location.x - 1, self.location.y, self.location.z});
    	}
    }
    action player_move_right{
    	write "player move right";
    	ask player {
    		location <- point({self.location.x + 1, self.location.y, self.location.z});
    	}
    }
    action harvest_seed{
    	if not main_model{
	    	ask player{
	    		int limit_harvest_per_action <- 0;
	    		ask seed_type1 at_distance havest_seed_distance {
	    			if limit_harvest_per_action < 1{
	    				number_of_harvested_seed <- number_of_harvested_seed + 1;
	    				limit_harvest_per_action <- limit_harvest_per_action+1;
	    				add self to:inventory;
	    				write "player harvest" + self;
		    			do die;
	    			}
		    	}
	    	}
    	}
    }
    action cut_trees{
    	if not main_model{
	    	ask player{
	    		int limit_cut_per_action <- 0;
	    		ask big_tree at_distance cut_tree_distance {
		    		if limit_cut_per_action < 1 and not on_fire{
			    		number_of_cut_trees <- number_of_cut_trees + 1;
			    		limit_cut_per_action <- limit_cut_per_action+1;
			    		write "player cut" + self;
			    		
			    		ask TheForestfiremodel_model[0]{
			    			list big_tree_not_on_fire <- [];
			    			ask big_tree {
			    				if self in big_tree_in_firebreak and not on_fire{
			    					add self to:big_tree_not_on_fire;
			    				}
			    			}
			    			list big_tree_do_die <- int(number_of_big_trees_in_fire_break/initial_n_of_big_tree_on_sub_map) 
			    										among(big_tree_not_on_fire);
							ask container(big_tree_do_die){
								do die;
							}
							remove big_tree_do_die from: big_tree_in_firebreak;
							
							big_tree_remaining_on_sub_map <- big_tree_remaining_on_sub_map - 1;
							if big_tree_remaining_on_sub_map = 0{
								ask container(big_tree_not_on_fire){
									do die;
								}
							}
			    		}
			    		do die;
		    		}
		    	}
		    	ask medium_tree at_distance cut_tree_distance {
		    		if limit_cut_per_action < 1 and not on_fire{
			    		number_of_cut_trees <- number_of_cut_trees + 1;
			    		limit_cut_per_action <- limit_cut_per_action+1;
			    		write "player cut" + self;
			    		
			    		ask TheForestfiremodel_model[0]{
			    			list medium_tree_not_on_fire <- [];
			    			ask medium_tree {
			    				if self in medium_tree_in_firebreak and not on_fire{
			    					add self to:medium_tree_not_on_fire;
			    				}
			    			}
			    			list medium_tree_do_die <- int(number_of_medium_trees_in_fire_break/initial_n_of_medium_tree_on_sub_map) 
			    										among(medium_tree_not_on_fire);
							ask container(medium_tree_do_die){
								do die;
							}
							remove medium_tree_do_die from: medium_tree_in_firebreak;
							
							medium_tree_remaining_on_sub_map <- medium_tree_remaining_on_sub_map - 1;
							if medium_tree_remaining_on_sub_map = 0{
								ask container(medium_tree_not_on_fire){
									do die;
								}
							}
			    		}
			    		do die;
		    		}
		    	}
		    	ask small_tree at_distance cut_tree_distance {
		    		if limit_cut_per_action < 1 and not on_fire{
			    		number_of_cut_trees <- number_of_cut_trees + 1;
			    		limit_cut_per_action <- limit_cut_per_action+1;
			    		write "player cut" + self;
			    		
			    		ask TheForestfiremodel_model[0]{
			    			list small_tree_not_on_fire <- [];
			    			ask small_tree {
			    				if self in small_tree_in_firebreak and not on_fire{
			    					add self to:small_tree_not_on_fire;
			    				}
			    			}
			    			list small_tree_do_die <- int(number_of_small_trees_in_fire_break/initial_n_of_small_tree_on_sub_map) 
			    										among(small_tree_not_on_fire);
							ask container(small_tree_do_die){
								do die;
							}
							remove small_tree_do_die from: small_tree_in_firebreak;
							
							small_tree_remaining_on_sub_map <- small_tree_remaining_on_sub_map - 1;
							if small_tree_remaining_on_sub_map = 0{
								ask container(small_tree_not_on_fire){
									do die;
								}
							}
			    		}
			    		do die;
		    		}
		    	}
	    	}
    	}
    }
    
    action jump_to_sub_map{
    	can_enter <- false;
    	initial_n_of_big_tree_on_sub_map <- int(ceil(number_of_big_trees_in_fire_break*(percent_of_tree_in_submap/100)));
    	initial_n_of_medium_tree_on_sub_map <- int(ceil(number_of_medium_trees_in_fire_break*(percent_of_tree_in_submap/100)));
    	initial_n_of_small_tree_on_sub_map <- int(ceil(number_of_small_trees_in_fire_break*(percent_of_tree_in_submap/100)));
    	
    	create simulation with:[shape::sub_shape, 
    		main_model::false, 
    		big_tree_in_firebreak::big_tree_in_firebreak,
    		medium_tree_in_firebreak::medium_tree_in_firebreak,
    		small_tree_in_firebreak::small_tree_in_firebreak,
    		initial_n_of_big_tree_on_sub_map::initial_n_of_big_tree_on_sub_map,
    		initial_n_of_medium_tree_on_sub_map::initial_n_of_medium_tree_on_sub_map,
    		initial_n_of_small_tree_on_sub_map::initial_n_of_small_tree_on_sub_map,
    		number_of_big_trees_in_fire_break::number_of_big_trees_in_fire_break,
    		number_of_medium_trees_in_fire_break::number_of_medium_trees_in_fire_break,
    		number_of_small_trees_in_fire_break::number_of_small_trees_in_fire_break,
    		big_tree_remaining_on_sub_map::initial_n_of_big_tree_on_sub_map,
    		medium_tree_remaining_on_sub_map::initial_n_of_medium_tree_on_sub_map,
    		small_tree_remaining_on_sub_map::initial_n_of_small_tree_on_sub_map
    	];
    	ask TheForestfiremodel_model[1]{
    		create seed_type1 number:initial_n_of_seed;
    		create player;
    		create big_tree number:int(initial_n_of_big_tree_on_sub_map);
    		create medium_tree number:int(initial_n_of_medium_tree_on_sub_map);
    		create small_tree number:int(initial_n_of_small_tree_on_sub_map);
    	}
    }
    
    output {
        display Main_map type: 2d{
            grid my_grid;
            
            species small_tree;
			species medium_tree;
			species big_tree;
			species evacuation_point;
			species inhabitant_gibbon;
			species inhabitant_baby_deer;
			species seed_type1;
			species player;
			
			event #mouse_drag action: firebreak ; 			 
			event #enter action: jump_to_sub_map ;
            event #arrow_up action: player_move_up;
            event #arrow_down action: player_move_down;
            event #arrow_left action: player_move_left;
            event #arrow_right action: player_move_right;
            event 'v' action: harvest_seed;
            event 'c' action: cut_trees;
        }
        monitor "Number of cut tree" value: (number_of_cut_trees);
        monitor "Number of harvested seed " value: (number_of_harvested_seed);
        monitor "Number of burnt area" value: (number_of_burnt_area);
        monitor "Number of burnt trees" value: (number_of_burnt_trees);
        monitor "Number of survival animals" value: (count_exit);
        monitor "Number of dead animals" value: (count_die);
        monitor "Number of block firebreak" value: (count_block_of_firebreak);
        monitor "HP of block firebreak remaining" value: (firebreak_remaining);
        monitor "Number of big tree in firebreak" value: (number_of_big_trees_in_fire_break);
        monitor "Number of medium tree in firebreak" value: (number_of_medium_trees_in_fire_break);
        monitor "Number of small tree in firebreak" value: (number_of_small_trees_in_fire_break);
    }
}