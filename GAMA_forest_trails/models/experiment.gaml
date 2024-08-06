/**
* Name: experiment
* Based on the internal empty template. 
* Author: lilti
* Tags: 
*/


model myexperiment

import 'main_GAMA_forest_trails.gaml'

experiment First type: gui {
	list<rgb> player_colors <-[#green,#blue,#yellow,#orange,#lime,#purple];
	
	action move_player{
		point cursor_location <- #user_location;
//		write geometry(cursor_location);
//		write geometry(road);
		if (geometry(cursor_location) overlaps geometry(road)){ //(not paused) and (geometry(cursor_location) overlaps shape)
//			write true;
			ask player[0] {
	    		location <- cursor_location;
	    	}
		}
	}
	
	output{
//		layout horizontal([vertical([0::4, 1::3])::1500, vertical([horizontal([2::1000, 3::1000, 4::1000])::1250, horizontal([5::1000, 6::1000, 7::1000])::1250])::2500])
//		tabs: false consoles: true toolbars: false;
//		layout horizontal([vertical([0::4, 1::3])::1500, vertical([horizontal([2::1000, 3::1000, 4::1000])::1250, horizontal([5::1000, 6::1000, 7::1000])::1250])::2500])
		
		layout vertical([horizontal([0::1, 1::1])::1, 2::1]) tabs: false consoles: false toolbars: false;
		display "Main" type: 3d background: rgb(50,50,50){
			camera 'default' locked:true distance:550 ; //, vertical([5::1000, 6::1000, 7::1000]))::2500 //distance:850
			
			species road refresh: false;
			species tree;
			species player;
			species sign;
			event #mouse_down {
				if ((#user_location distance_to sign[0]) < 25) {
					ask world {
						do resume;
					}
				}
			}
			
			event #mouse_drag action: move_player ; 

			graphics Strings {
				draw "Current turn: "+ count_start at:{width/3, -45} font:font("Times", 20, #bold+#italic) ; 
				draw "Remaining time: "+ ((stop_time*count_start - time_now) div 60) + " minutes " + ((stop_time*count_start - time_now) mod 60) + " seconds" at:{width/3, -20} font:font("Times", 20, #bold+#italic) ;
			}
		}
		
		display "Total seeds" type: 2d {
			chart "Total seeds" type:histogram reverse_axes:true
			y_range:[0, 20 + max_total_seed]
			x_serie_labels: [""]
			style:"3d"
			series_label_position: xaxis
			{
				loop i from:0 to:(length(sum_total_seeds)-1){
					data "team" + (i+1) value:int(sum_total_seeds[i])
					color:#red;
				}
			}
		}
		
		//loop i from:1 to:n_team {
		display "Summary" type: 2d { 			
			chart "Summary" type:histogram 			
			y_range:[0, 10 + upper_bound] 			
			x_serie_labels: ["species"] 			
			style:"3d" 			
			series_label_position: xaxis {
				loop i from:0 to:(n_player-1){
					int temp <- 1 ;
					loop j from:0 to:((length(n_tree)*2)-1) step:2{ 
//						data "Team"+ j + "Tree" + i value:(empty(seeds) ? 0 : seeds[i][j]) color:player_colors[i]; 
						data "T"+ (i+1) + "Tree" + temp value: int(seeds[i][j] + alien_seeds[i][j]) +  int(seeds[i][j+1] + alien_seeds[i][j+1]) 
						color:player_colors[i]; 
						temp <- temp + 1;
					}
					data ""+(i+1) value:0;
				}
			}
		}	
	}
}

