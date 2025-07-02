/**
* Name: optimizespecies
* Based on the internal empty template. 
* Author: lilti
* Tags: 
*/


model optimizespecies

species tree{
	int tree_type <- 0;
	int it_state <- 1;
	rgb color <- rgb(43, 150, 0);
	
	reflex change_color{
		if it_state = 0{
			color <- #black;
		}
		else if it_state = 1{
			color <- rgb(43, 150, 0);
		}
		else if it_state = 2{
			color <- #blue;
		}
		else if it_state = 3{
			color <- #red;
		}
	}
	
	aspect default{
		draw shape color:color;
	}
}

species p1tree parent:tree {
	
}

species p2tree parent:tree {
	
}

species p3tree parent:tree {
	
}

species p4tree parent:tree {
	
}

species p5tree parent:tree {
	
}

species p6tree parent:tree {
	
}


species playerable_area{
	geometry shape <- rectangle(50#m, 40#m);
	rgb color <- #white;
	
	aspect default{
		draw shape color:color border:#black ;
	}
}