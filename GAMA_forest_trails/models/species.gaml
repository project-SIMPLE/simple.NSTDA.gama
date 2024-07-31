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
	list list_of_month_state1 <- [];
	list list_of_month_state2 <- [];
	list list_of_month_state3 <- [];
	list list_of_month_state4 <- [];
}

species player_info{
	int team <- 0;
}

species tree parent:tree_info{
	aspect default{
		draw shape color:color;
	}
}

species player parent:player_info{
	aspect default {
		draw circle(10#m) color: #blue border:#black;
		draw ("Team" + team) font:font("Times", 18, #bold); 
	}
}

species road skills: [road_skill] {
	aspect default {
		draw shape + 1#m color: #white depth:1;
//		draw shape color: #white ;
	}
}

species river{
	aspect default {
		draw circle(max_radius#m) color:rgb(138, 178, 242);
		draw circle(5#m) color:#red;
	}
}

species bg{
	aspect default {
		draw shape color: #grey ;	
	}
}