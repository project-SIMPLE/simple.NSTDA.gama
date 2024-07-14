/**
* Name: test_shapefile
* Based on the internal empty template. 
* Author: lilti
* Tags: 
*/

// 3/7/2024
// เล่น 10 นาที เปลี่ยนเดือนเป็นสัปดาห์แทน 10min/2week done!
// ฟังก์ชั่นปิด player

// 9/7/2024
// player เดินบนถนนเท่านั้น
// แยก species ไว้อีก file
// สร้างวงกลมข้างในกับข้างนอกห้าม player เดิน (มีพื้นที่จำกัดการเดิน) อิงจาก continuous move model เป็น agent bg

model GAMA_forest_trails

global {
	
	action collect(string text, int n){
		write text + " " + n;
		if text = "type1"{
			total_seeds_tree_type1 <- total_seeds_tree_type1 + n ;
			write "Total seeds type1: " + total_seeds_tree_type1;
		}
		else if text = "type2"{
			total_seeds_tree_type2 <- total_seeds_tree_type2 + n ;
			write "Total seeds type2: " + total_seeds_tree_type2;
		}
		else if text = "type3"{
			total_seeds_tree_type3 <- total_seeds_tree_type3 + n ;
			write "Total seeds type3: " + total_seeds_tree_type3;
		}
		else if text = "type4"{
			total_seeds_tree_type4 <- total_seeds_tree_type4 + n ;
			write "Total seeds type4: " + total_seeds_tree_type4;
		}
		else if text = "type5"{
			total_seeds_tree_type5 <- total_seeds_tree_type5 + n ;
			write "Total seeds type5: " + total_seeds_tree_type5;
		}
		else if text = "type6"{
			total_seeds_tree_type6 <- total_seeds_tree_type6 + n ;
			write "Total seeds type6: " + total_seeds_tree_type6;
		}		
	}
	
//	shape_file roads_shape_file <- shape_file("../includes/Trail_4_5.shp");
	shape_file roads_shape_file <- shape_file("../includes/cir.shp");
	shape_file border_shape_file <- shape_file("../includes/rec.shp");
	geometry shape <- envelope(border_shape_file);
	graph road_network;
	
	image_file play <- image_file("../images/play.png");
	image_file stop <- image_file("../images/stop.png");
	
	// Parameter
	int n_tree_type1 <- 100;
	int n_tree_type2 <- 100;
	int n_tree_type3 <- 100;
	int n_tree_type4 <- 100;
	int n_tree_type5 <- 100;
	int n_tree_type6 <- 100;
	int n_tree_type7 <- 100;
	int n_tree_type8 <- 100;
	int n_tree_type9 <- 100;
	int n_tree_type10 <- 100;
	int n_tree_type11 <- 100;
	int n_tree_type12 <- 100;
	int collect_seeds_distance <- 5;
	int stop_time <- 10; //second
	int stop_every_n_week <- 2; //week
	int n_teams <- 1;
	
	int size <- 3 ;
	
	float max_radius <- 200.0;
	float x_river <- 0.0 ;
	float y_river <-  260.0 ; //442.0
	
	// Variable
	int total_seeds_tree_type1 <- 0;
	int total_seeds_tree_type2 <- 0;
	int total_seeds_tree_type3 <- 0;
	int total_seeds_tree_type4 <- 0;
	int total_seeds_tree_type5 <- 0;
	int total_seeds_tree_type6 <- 0;
	int total_seeds_tree_type7 <- 0;
	int total_seeds_tree_type8 <- 0;
	int total_seeds_tree_type9 <- 0;
	int total_seeds_tree_type10 <- 0;
	int total_seeds_tree_type11 <- 0;
	int total_seeds_tree_type12 <- 0;
	int total_big_tree_seeds <- 0;
	int total_medium_tree_seeds <- 0;
	int total_small_tree_seeds <- 0;
	float width <- shape.width;
	float height <- shape.height;
	int init_time <- 0;
	int time_now <- 0;
	int count_start <- 0 ;
	
	int current_time <- 1 ;
	int past_month <- 0;
	float current_day <- 0.0 ;
	
	rgb color_state1 <- rgb(117, 148, 69);
	rgb color_state2 <- rgb(133, 134, 66);
	rgb color_state3 <- rgb(165, 105, 60);
	rgb color_state4 <- rgb(198, 76, 54);
	
	reflex update_time{
		if (machine_time div 1000) - init_time = 1{
			init_time <- machine_time div 1000;
			time_now <- time_now + 1;
		}
		current_time <- int(time_now div (stop_time / stop_every_n_week))+1;
		current_day <- (time_now / (stop_time / stop_every_n_week)) * 7;
		
		write "Time now: " + time_now + " Current week: " + current_time + " Current day: " + int(current_day);
	}
	reflex write{
//		write length(time_list);
//		write current_month;
//		write ((cycle+((int(current_month)-1)*month_duration)));
//		write current_day;
//		write machine_time div 1000;
//		write(machine_time/86400)+24106+(7/24);
//		write init_time;
//		write "Time now: " + int((machine_time div 1000) - init_time) ;
		ask tree_type6{
			if color = #red{
				write self;
			}
		}
	}
	
	reflex restart when:current_day=84{
		time_now <- 0;
		count_start <- 0 ;
	}
	
	reflex do_pause when: (time_now >= stop_time*count_start ) and (cycle != 0) {
		do pause;
		ask sign{
			icon <- play;
		}
	}
	
	action toggle {
		if paused {
			ask sign{
				icon <- stop;
				write "change to stop icon.";
			}
			count_start <- count_start + 1 ;
			do resume;
			init_time <- machine_time div 1000;
		} 
//		else {
//			ask sign{
//				icon <- play;
//				write "change to start icon.";
//			}
//			do pause;
//		}

	}
	
	init {
		create sign{
			location <- {width/3 - 35, -45, 0};
		}
		
		list tree_loc_list <- (list(-10,-9,-8,-7,-6,-5,5,6,7,8,9,10));
		float x_max <- sqrt((max_radius^2)/2);
//		write(x_max);
		
		create river{
			location <- {x_river, y_river, 0.0};
		}
		
		create road from: roads_shape_file ;

		create player{
			location <- any_location_in(any(road));
		}
		
		create tree_type1 number:n_tree_type1{
			point at_location <- any_location_in(any(road));
			point target_location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
			location <- target_location;
		}
		
		create tree_type2 number:n_tree_type2{
			point at_location <- any_location_in(any(road));
			point target_location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
			location <- target_location;
		}
		
		create tree_type3 number:n_tree_type3{
			point at_location <- any_location_in(any(road));
			point target_location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
			location <- target_location;
		}
		
		create tree_type4 number:n_tree_type4{
			point at_location <- any_location_in(any(road));
			point target_location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
			location <- target_location;
		}
		
		create tree_type5 number:n_tree_type5{
			point at_location <- any_location_in(any(road));
			point target_location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};
			location <- target_location;
		}
		
		create tree_type6 number:n_tree_type6{
			bool false_position <- true;

			loop while: false_position{
				point at_location <- any_location_in(any(road));
				float distance <- sqrt(((x_river - at_location.x)^2) + ((y_river - at_location.y)^2));

				loop while: distance > max_radius{
					at_location <- any_location_in(any(road)) ;
					distance <- sqrt(((x_river - at_location.x)^2) + ((y_river - at_location.y)^2));
				}
				float p_x_y <- 1 - (distance/max_radius) ;
//				write(p_x_y) ;
				bool create_or_not <- flip(p_x_y);
//				write(create_or_not) ;
				if create_or_not{
//					write("pass!");
					false_position <- false;
					point target_location <- {at_location.x + tree_loc_list[rnd_choice(tree_loc_list)],at_location.y + tree_loc_list[rnd_choice(tree_loc_list)],at_location.z};		
					location <- target_location;	
				}
			}
		}
	}
	
	reflex growth_up{
		ask tree_type1{
			if current_time in list_of_month_state1{
				self.color <- color_state1 ; //rgb(43, 150, 0) ;
				initial_seed <- 0;
				can_collect <- false ;
			}
			else if current_time in list_of_month_state2{
				self.color <- color_state2 ; //rgb(255, 89, 149) ;
				initial_seed <- 0;
				can_collect <- false ;
			}
			else if current_time in list_of_month_state3{
				self.color <- color_state3 ; //rgb(229, 250, 0) ;
				initial_seed <- 0;
				can_collect <- false ;
			}
			else if current_time in list_of_month_state4{
				self.color <- color_state4 ; //rgb(250, 0, 0) ;
				initial_seed <- rnd(1,10);
				can_collect <- true ;
			}
		}
		
		ask tree_type2{
			if current_time in list_of_month_state1{
				self.color <- color_state1 ; //rgb(43, 150, 0) ;
				initial_seed <- 0;
				can_collect <- false ;
			}
			else if current_time in list_of_month_state2{
				self.color <- color_state2 ; //rgb(255, 89, 149) ;
				initial_seed <- 0;
				can_collect <- false ;
			}
			else if current_time in list_of_month_state3{
				self.color <- color_state3 ; //rgb(229, 250, 0) ;
				initial_seed <- 0;
				can_collect <- false ;
			}
			else if current_time in list_of_month_state4{
				self.color <- color_state4 ; //rgb(250, 0, 0) ;
				initial_seed <- rnd(1,10);
				can_collect <- true ;
			}
		}
		
		ask tree_type3{
			if current_time in list_of_month_state1{
				self.color <- color_state1 ; //rgb(43, 150, 0) ;
				initial_seed <- 0;
				can_collect <- false ;
			}
			else if current_time in list_of_month_state2{
				self.color <- color_state2 ; //rgb(255, 89, 149) ;
				initial_seed <- 0;
				can_collect <- false ;
			}
			else if current_time in list_of_month_state3{
				self.color <- color_state3 ; //rgb(229, 250, 0) ;
				initial_seed <- 0;
				can_collect <- false ;
			}
			else if current_time in list_of_month_state4{
				self.color <- color_state4 ; //rgb(250, 0, 0) ;
				initial_seed <- rnd(1,10);
				can_collect <- true ;
			}
		}
		
		ask tree_type4{
			if current_time in list_of_month_state1{
				self.color <- color_state1 ; //rgb(43, 150, 0) ;
				initial_seed <- 0;
				can_collect <- false ;
			}
			else if current_time in list_of_month_state2{
				self.color <- color_state2 ; //rgb(255, 89, 149) ;
				initial_seed <- 0;
				can_collect <- false ;
			}
			else if current_time in list_of_month_state3{
				self.color <- color_state3 ; //rgb(229, 250, 0) ;
				initial_seed <- 0;
				can_collect <- false ;
			}
			else if current_time in list_of_month_state4{
				self.color <- color_state4 ; //rgb(250, 0, 0) ;
				initial_seed <- rnd(1,10);
				can_collect <- true ;
			}
		}
		
		ask tree_type5{
			if current_time in list_of_month_state1{
				self.color <- color_state1 ; //rgb(43, 150, 0) ;
				initial_seed <- 0;
				can_collect <- false ;
			}
			else if current_time in list_of_month_state2{
				self.color <- color_state2 ; //rgb(255, 89, 149) ;
				initial_seed <- 0;
				can_collect <- false ;
			}
			else if current_time in list_of_month_state3{
				self.color <- color_state3 ; //rgb(229, 250, 0) ;
				initial_seed <- 0;
				can_collect <- false ;
			}
			else if current_time in list_of_month_state4{
				self.color <- color_state4 ; //rgb(250, 0, 0) ;
				initial_seed <- rnd(1,10);
				can_collect <- true ;
			}
		}
		
		ask tree_type6{
			if current_time in list_of_month_state1{
				self.color <- color_state1 ; //rgb(43, 150, 0) ;
				initial_seed <- 0;
				can_collect <- false ;
			}
			else if current_time in list_of_month_state2{
				self.color <- color_state2 ; //rgb(255, 89, 149) ;
				initial_seed <- 0;
				can_collect <- false ;
			}
			else if current_time in list_of_month_state3{
				self.color <- color_state3 ; //rgb(229, 250, 0) ;
				initial_seed <- 0;
				can_collect <- false ;
			}
			else if current_time in list_of_month_state4{
				self.color <- color_state4 ; //rgb(250, 0, 0) ;
				initial_seed <- rnd(1,10);
				can_collect <- true ;
			}
		}
	}
}


species sign skills: [moving]{
	image_file icon <- play;
	aspect default {
		draw icon size: {50, 50};
	}
}
	
species tree_type1{
	bool can_collect ;
	int initial_seed <- 0;
	rgb color <- rgb(43, 150, 0);
	list list_of_month_state1 <- [1, 2, 3, 10, 11, 12];
	list list_of_month_state2 <- [4, 5];
	list list_of_month_state3 <- [6, 7];
	list list_of_month_state4 <- [8, 9];
	aspect default{
//		draw sphere(3+size#m) color:color;
		draw circle(3+size#m) color:color;
	}
}

species tree_type2{
	bool can_collect ;
	int initial_seed <- 0;
	rgb color <- rgb(43, 150, 0);
	list list_of_month_state1 <- [1, 2, 3, 11, 12];
	list list_of_month_state2 <- [4];
	list list_of_month_state3 <- [5, 6, 7, 8];
	list list_of_month_state4 <- [9, 10];
	aspect default{
//		draw cylinder(3+size#m, 3+size#m) color:color;
		draw triangle(7+size#m) color:color;
	}
}

species tree_type3{
	bool can_collect ;
	int initial_seed <- 0;
	rgb color <- rgb(43, 150, 0);
	list list_of_month_state1 <- [1, 2, 3, 4, 5, 6];
	list list_of_month_state2 <- [7, 8];
	list list_of_month_state3 <- [9, 10];
	list list_of_month_state4 <- [11, 12];
	aspect default{
//		draw cube(4+size#m) color:color;
		draw square(5+size#m) color:color;
	}
}

species tree_type4{
	bool can_collect ;
	int initial_seed <- 0;
	rgb color <- rgb(43, 150, 0);
	list list_of_month_state1 <- [1, 8, 9, 10, 11, 12];
	list list_of_month_state2 <- [2, 3];
	list list_of_month_state3 <- [4, 5];
	list list_of_month_state4 <- [6, 7];
	aspect default{
//		draw pyramid(5+size#m) color:color;
		draw hexagon(7+size#m) color:color;
	}
}

species tree_type5{
	bool can_collect ;
	int initial_seed <- 0;
	rgb color <- rgb(43, 150, 0);
	list list_of_month_state1 <- [6, 7, 8, 9, 10];
	list list_of_month_state2 <- [11, 12];
	list list_of_month_state3 <- [1, 2];
	list list_of_month_state4 <- [3, 4, 5];
	aspect default{
//		draw teapot(3+size#m) color:color;
		draw hexagon(7+size#m) color:color;
	}
}

species tree_type6{
	bool can_collect ;
	int initial_seed <- 0;
	rgb color <- rgb(43, 150, 0);
	list list_of_month_state1 <- [4, 5, 6, 7, 8];
	list list_of_month_state2 <- [9, 10];
	list list_of_month_state3 <- [11, 12];
	list list_of_month_state4 <- [1, 2, 3];
	aspect default{
//		draw cone3D(3+size#m, 5+size#m) color:color;
		draw circle(3+size#m) color:color;
	}
}

species road skills: [road_skill] {
	aspect default {
		draw shape + 10#m color: #white depth:1;
//		draw shape color: #white ;
	}
}

species player{
	aspect default {
		draw circle(10#m) color: #purple border:#black;
	}
}

species river{
	aspect default {
		draw circle(max_radius#m) color:rgb(138, 178, 242);
		draw circle(5#m) color:#red;
	}
}

species bg{

}

experiment forest type: gui {
	
	action move_player{
		if not paused{
			ask player {
	    		location <- #user_location;
	    	}
		}
	}
	
	output{
		layout vertical([1::1250,0::5000]) tabs: false consoles: false toolbars: true;
		display "Main" type: 3d background: rgb(50,50,50){
			camera 'default' locked:true distance:800 ;
			
			species river refresh: false;
//			species road refresh: false;
			species tree_type1;
			species tree_type2;
			species tree_type3;
			species tree_type4;
			species tree_type5;
			species tree_type6;
			species player;
			species sign;
			event #mouse_down {
				if ((#user_location distance_to sign[0]) < 25) {
					ask world {
						do toggle;
					}
				}
				
			}
			
			event #mouse_drag action: move_player ; 

			graphics Strings {
				draw "Current week: "+ current_time at:{width/3, -45} font:font("Times", 20, #bold+#italic) ; 
				draw "Time: "+ (time_now div 60) + " minute " + (time_now mod 60) + " second" at:{width/3, -25} font:font("Times", 20, #bold+#italic) ;
			}
		}
		display "Month" type: 2d {
			chart "Progress" type:histogram reverse_axes:true
			y_range:[1, 84]
			x_serie_labels: [""]
			style:"3d"
			series_label_position: xaxis
			{
				data "Days" value:current_day
				color:#green;
//				data "Months" value:int(current_month)
//				color:#yellow;
			}
		}

//		display "Summary" type: 2d {
//			chart "Number of seeds collected" type:histogram
//			y_range:[0, 10+total_seeds]
//			x_serie_labels: ["Collected from"]
//			style:"3d"
//			series_label_position: xaxis
//			{
//				data "Small tree" value:total_small_tree_seeds
//				color:#yellow;
//				data "Medium tree" value:total_medium_tree_seeds
//				color:#green;
//				data "Big tree" value:total_big_tree_seeds
//				color:#blue;
//			}
//		}
//		monitor "Number of seeds" value:total_seeds;
//		monitor "Month" value:int(current_month);
	}
}

