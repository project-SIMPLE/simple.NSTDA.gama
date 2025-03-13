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
	image_file static_map <- image_file("../images/Ground_V3.jpg");
	image_file reset_image <- image_file("../images/reset.png");
	image_file correct_image <- image_file("../images/correct_icon.png");
	image_file incorrect_image <- image_file("../images/incorrect_icon.png");
	image_file alert_image <- image_file("../images/alert_icon.png");
//	image_file no_signal_image <- image_file("../images/no_signal_icon.png");
	image_file blank_image <- image_file("../images/blank.png");

}

species player_status{
//	image_file status_icon <- no_signal_image;
//	image_file status_icon <- incorrect_image;
	image_file status_icon <- blank_image;
	aspect default {
		draw status_icon size:{30,30};
	}
}

species support {
	image_file img <- static_map;
//	int size_value <- 950;
	aspect default {
//		draw img size:{size_value,size_value/2};
		draw img size:{520,312};
	}
}

species reset {
	image_file img <- reset_image;
	aspect default {
		draw img size:{50,30};
	}
}

species sign {
	image_file icon <- play;
	aspect default {
		draw icon size:{50, 50};
	}
}

species tree{
	int tree_type <- 0;
	int tree_zone <- 0;
	bool it_alien <- false;
	rgb color <- rgb(43, 150, 0);
	int it_state <- 1;
	list<int> list_of_state1;
	list<int> list_of_state2;
	list<int> list_of_state3;
	list<int> list_of_state4;
	geometry shape <- circle(5#m);
	
	aspect default{
		draw shape color:color;
	}
	
	aspect for_plot{
		draw circle(3#m) color:color;
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
	aspect default {
		draw shape color: color border:#green;	
	}
}

species zone{
	rgb color <- rnd_color(255);
	geometry shape <- circle(100#m);
	aspect default {
		draw shape color: color ;	
	}
}

species zone_for_player_warp{
	rgb color ; //<- rnd_color(255);
	geometry shape <- circle(40#m);
	aspect default {
		draw shape color: color;
	}
}