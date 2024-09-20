/**
* Name: mainGAMAforesttrails2
* Based on the internal empty template. 
* Author: lilti
* Tags: 
*/

model mainGAMAforesttrails2

import 'species.gaml'

// ทำให้คนเดินไม่ได้เมื่อเวลาหมด ส่งเป็นคำเอาให้จับคำเอาเอง เช่น play0/play1 
// ทำข้อความตอน start ด้วย GAMA ต้องบอกว่าเริ่มเล่นได้แล้ว
// รับ จน. เมล็ด ให้รับ player ID, tree ID, n แล้วลองไปทำอะไรกับต้นไม้ต้นหนึ่ง แล้วให้ปุ่มนั้นส่ง message กลับมาว่า player คือใคร จน. เมล็ดเท่าใด ต้นไม้ต้นไหน
// ดัก ID player สร้าง list ของ player
// list รายการว่า มีอะไรที่ใช้ได้บ้าง เช่น send_message ดู receive_message ที่รับ player ID
// เน้นเก็บเมล็ดก่อน


// ลง apk ผ่าน terminal
// ลอง multiplayer 
// ทำกราฟ
// screen record

global{
	shape_file Trail_shape_file <- shape_file("../includes/Trail.shp");
	geometry usable_area;
	geometry shape <- envelope(Trail_shape_file);
	
	float width <- shape.width;
	float height <- shape.height;
	
	// Parameter
	int n_team <- 4;
	list n_tree <- [50,50,50];
	int collect_seeds_distance <- 5;
	int stop_time <- 20; //second
	
	// Variable
	int n_turn <- 6;
	int n_month_by_turn <- 2;
	list<list<int>> seeds <- [];
	list<list<int>> alien_seeds <- [];
	list<int> sum_total_seeds <- [];
	int init_time <- 0;
	int time_now <- 0;
	int count_start <- 0 ;
	bool can_start <- true ;
	int current_time <- 1 ;
	float current_day <- 0.0 ;
	int max_time <- stop_time * n_turn;
	rgb color_state1 <- rgb(117, 148, 69);
	rgb color_state2 <- rgb(133, 134, 66);
	rgb color_state3 <- rgb(165, 105, 60);
	rgb color_state4 <- rgb(198, 76, 54);
	int upper_bound;
	int max_total_seed;
	
	float x_river <- 0.0 ;
	float y_river <-  260.0 ;
	
	list<string> player_name_list <- [];

	init{
		write player_name_list; 
		seeds <- list_with(n_team, list_with(length(n_tree) * 2, 0));
		alien_seeds <- list_with(n_team, list_with(length(n_tree) * 2, 0));
		sum_total_seeds <- list_with(n_team, 0);
		
		create road from: split_lines(Trail_shape_file);
		usable_area <-  union(road collect each.geom_visu);
		
		create sign{
			location <- {width/3 - 35, -45, 0};
		}
		
		int temp <- 0 ;
		loop i from:1 to:(length(n_tree) * 2) step:2{			
			create tree number:(n_tree[temp] div 2){
				tree_type <- i;
				do initialize(usable_area);
			}
			create tree number:(n_tree[temp] div 2){
				tree_type <- i+1;
				do initialize(usable_area);
			}
			temp <- temp + 1;
		}
		
		ask tree {
			list_of_state1 <- assign_list_of_state(1, tree_type);
			list_of_state2 <- assign_list_of_state(2, tree_type);
			list_of_state3 <- assign_list_of_state(3, tree_type);
			list_of_state4 <- assign_list_of_state(4, tree_type);
		}
	}
	
	reflex test{
//		write unity_player.name ;
//		ask unity_player{
//			write name;
//		}
//		write player_name_list;
//		ask unity_linker{
//			loop p over: unity_player {
//				write p;
//			}
//		}
//		write unity_player as list;
	}
	
	reflex update_time_and_bound{
		if (gama.machine_time div 1000) - init_time = 1{
			init_time <- gama.machine_time div 1000;
			time_now <- time_now + 1;
		}
		current_time <- int((time_now-0.1) div (stop_time / n_month_by_turn)) + 1;
//		write "Time: " + time_now + " s, Turn: " + count_start + " Month: " + current_time ;
		ask unity_linker{
			do send_message players: unity_player as list mes: ["start":: !can_start, "remaining_time":: (stop_time*count_start - time_now)];
		}

		loop i from:0 to:(length(sum_total_seeds)-1){
			sum_total_seeds[i] <- int(sum(seeds[i])) + int(sum(alien_seeds[i]));
		}
		
		loop i from:0 to:(n_team-1){
			loop j from:0 to:((length(n_tree)*2)-1) step:2{ 
				int temp <- int(seeds[i][j] + alien_seeds[i][j]) +  int(seeds[i][j+1] + alien_seeds[i][j+1]);
				if temp > upper_bound{
					upper_bound <- temp;
				}
						
			}	
		}
		
		max_total_seed <- int(max(sum_total_seeds));

	}
	
	reflex restart when:time_now=max_time{
		time_now <- 0;
		count_start <- 0 ;
	}
	
	reflex do_resume when: (not paused) and can_start{
//		if user_confirm("Confirmation","Do you want to start?"){
//			ask sign{
//				icon <- stop;
////				write "change to stop icon.";
//			}
//			count_start <- count_start + 1 ;
//			init_time <- gama.machine_time div 1000;
//			can_start <- false ;
//		}
//		else{
//			do pause;
//		}

		ask sign{
			icon <- stop;
		}
		count_start <- count_start + 1 ;
		init_time <- gama.machine_time div 1000;
		can_start <- false ;
		
		ask unity_linker {
			loop p over: unity_player {
				do enable_player_movement(
					player:p,
					enable:true
				);
			}
		}	
	}
	
	reflex do_pause when: (time_now >= stop_time*count_start) and (cycle != 0) {
		ask sign{
			icon <- play;
//			write "change to start icon.";
		}
		can_start <- true ;
		do pause;

		ask unity_linker {
			loop p over: unity_player {
				do enable_player_movement(
					player:p,
					enable:false
				);
			}
		}	
	}
	
	reflex growth_up{ 
		ask tree{
			switch current_time {
				match_one list_of_state1{
					if not it_alien{
						self.color <- color_state1 ;	
					}
					initial_seed <- 0;
					can_collect <- false ;
					it_state <- 1 ;
				}
				match_one list_of_state2{
					if not it_alien{
						self.color <- color_state2 ;
					}
					initial_seed <- 0;
					can_collect <- false ;
					it_state <- 2 ;
				}
				match_one list_of_state3{
					if not it_alien{
						self.color <- color_state3 ;
					}
					initial_seed <- 0;
					can_collect <- false ;
					it_state <- 3 ;
				}
				match_one list_of_state4{
					if not it_alien{
						self.color <- color_state4 ;
					}
					initial_seed <- rnd(1,10);
					can_collect <- true ;
					it_state <- 4 ;
				}
			}	
		}
	}
	
	
	
//	action collect(int team, int type, int n, bool alien){
//		if alien{
//			int temp <- int(container(alien_seeds[team-1])[type-1]);
//			container(alien_seeds[team-1])[type-1] <- int(temp + n);	
//		}
//		else{
//			int temp <- int(container(seeds[team-1])[type-1]);
//			container(seeds[team-1])[type-1] <- int(temp + n);
//		}
//	}
	
//	reflex random{
//		if flip(0.1){
//			do collect(rnd(1,n_team),rnd(1,length(n_tree)*2),rnd(1,2), true);
//		}
//		if flip(0.1){
//			do collect(rnd(1,n_team),rnd(1,length(n_tree)*2),rnd(1,2), false);
//		}
//	}
}

experiment First type: gui {
	list<rgb> player_colors <-[#green, #blue, #yellow, #orange, #lime, #purple];
	
	output{
		layout vertical([horizontal([0::1, 1::1])::1, 2::1]) tabs: false consoles: true toolbars: false;
		display "Main" type: 3d background: rgb(50,50,50){
			camera 'default' locked:true distance:550 ;
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
		
		display "Summary" type: 2d { 			
			chart "Number of seeds by tree species and by team ID" type:histogram 
			x_serie_labels: ["Species"] 				
			y_range:[0, 10 + upper_bound] 		
			style:"3d" 			 
			series_label_position: xaxis {
				loop i from:0 to:(n_team-1){
					int temp <- 1 ;
					loop j from:0 to:((length(n_tree)*2)-1) step:2{
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

species unity_linker parent: abstract_unity_linker {
	string player_species <- string(unity_player);
	int num_players <- 2;
	int max_num_players  <- num_players;
	int min_num_players  <- num_players;
//	unity_property up_tree_1;
//	unity_property up_tree_2;
//	unity_property up_tree_3;
	unity_property up_tree_1a;
	unity_property up_tree_1b;
	unity_property up_tree_2a;
	unity_property up_tree_2b;
	unity_property up_tree_3a;
	unity_property up_tree_3b;
	unity_property up_road;

	unity_property up_ghost;
	unity_property up_lg;
	unity_property up_slime;
	unity_property up_turtle;
		
	action collect_seeds(string player_ID, string tree_ID){ 
		write "Player " + player_ID + " collect: " + tree_ID; 
//		if alien{
//			int temp <- int(container(alien_seeds[team-1])[type-1]);
//			container(alien_seeds[team-1])[type-1] <- int(temp + n);	
//		}
//		else{
//			int temp <- int(container(seeds[team-1])[type-1]);
//			container(seeds[team-1])[type-1] <- int(temp + n);
//		}
	}
	
	list<point> init_locations <- define_init_locations();

	list<point> define_init_locations {
		list<point> init_pos;
		loop times: num_players {
			init_pos << any_location_in(usable_area - 1.5) + {0, 0, 5};
		}
		return init_pos;
	}


	init {
		do define_properties;
		player_unity_properties <- [ up_lg,up_turtle, up_slime, up_ghost ];
		do add_background_geometries(road collect (each.geom_visu), up_road);
	}
	action define_properties {
		
		unity_aspect tree_aspect_1a <- prefab_aspect("Prefabs/Visual Prefabs/Nature/PREFABS/Plants/SM_Arbre_001",2.0,0,1.0,0.5, precision);
		up_tree_1a <- geometry_properties("tree_1_a","tree",tree_aspect_1a,#no_interaction,false);
		unity_properties << up_tree_1a;
		
		unity_aspect tree_aspect_1b <- prefab_aspect("Prefabs/Visual Prefabs/Nature/PREFABS/Plants/SM_Arbre_003",2.0,0,1.0,0.5, precision);
		up_tree_1b <- geometry_properties("tree_1_b","tree",tree_aspect_1b,#no_interaction,false);
		unity_properties << up_tree_1b;

		unity_aspect tree_aspect_2a <- prefab_aspect("Prefabs/Visual Prefabs/Nature/PREFABS/Plants/SM_Bananier_005",3.0,0,1.0,0.5, precision);
		up_tree_2a <- geometry_properties("tree_2_a","tree",tree_aspect_2a,#no_interaction,false);
		unity_properties << up_tree_2a;
		
		unity_aspect tree_aspect_2b <- prefab_aspect("Prefabs/Visual Prefabs/Nature/PREFABS/Plants/SM_Bananier_002",3.0,0,1.0,0.5, precision);
		up_tree_2b <- geometry_properties("tree_2_b","tree",tree_aspect_2b,#no_interaction,false);
		unity_properties << up_tree_2b;
		
		unity_aspect tree_aspect_3a <- prefab_aspect("Prefabs/Visual Prefabs/Nature/PREFABS/Plants/SM_ClayPot_001",8.0,0,1.0,0.5, precision);
		up_tree_3a <- geometry_properties("tree_3_a","tree",tree_aspect_3a,#no_interaction,false);
		unity_properties << up_tree_3a;
		
		unity_aspect tree_aspect_3b <- prefab_aspect("Prefabs/Visual Prefabs/Nature/PREFABS/Plants/SM_ClayPotPlant_001",8.0,0,1.0,0.5, precision);
		up_tree_3b <- geometry_properties("tree_3_b","tree",tree_aspect_3b,#no_interaction,false);
		unity_properties << up_tree_3b;
		
		unity_aspect road_aspect <- geometry_aspect(0.5,#gray,precision);
		up_road <- geometry_properties("road","",road_aspect,#no_interaction,false);
		unity_properties << up_road;
		

		unity_aspect ghost_aspect <- prefab_aspect("Prefabs/Visual Prefabs/Character/Ghost",2.0,0.0,-1.0,90.0,precision);
		up_ghost <- geometry_properties("ghost","",ghost_aspect,#collider,false);
		unity_properties << up_ghost; 
		
		unity_aspect slime_aspect <- prefab_aspect("Prefabs/Visual Prefabs/Character/Slime",2.0,0.0,-1.0,90.0,precision);
		up_slime <- geometry_properties("slime","",slime_aspect,new_geometry_interaction(true, false,false,[]),false);
		unity_properties << up_slime; 
		
		unity_aspect lg_aspect <- prefab_aspect("Prefabs/Visual Prefabs/Character/LittleGhost",2.0,0.0,-1.0,90.0,precision);
		up_lg <- geometry_properties("little_ghost","",lg_aspect,new_geometry_interaction(true, false,false,[]),false);
		unity_properties << up_lg; 
		
		unity_aspect turtle_aspect <- prefab_aspect("Prefabs/Visual Prefabs/Character/TurtleShell",2.0,0.0,-1.0,90.0,precision);
		up_turtle <- geometry_properties("turtle","",turtle_aspect,new_geometry_interaction(true, false,false,[]),false);
		unity_properties << up_turtle; 
		

	}
	reflex send_geometries {
		list<tree> t1 <- tree where (each.tree_type <= 2);
		if empty(tree where ((each.tree_type <= 2) and (each.it_state <=3))){
			do add_geometries_to_send(t1,up_tree_1b);
		}
		else{
			do add_geometries_to_send(t1,up_tree_1a);
		}
		
		list<tree> t2 <- tree where (((each.tree_type <= 4) and (each.tree_type > 2)));
		if empty(tree where (((each.tree_type <= 4) and (each.tree_type > 2)) and (each.it_state <=3))){
			do add_geometries_to_send(t2,up_tree_2b);
		}
		else{
			do add_geometries_to_send(t2,up_tree_2a);
		}
		
		list<tree> t3 <- tree where ((each.tree_type > 4));
		if empty(tree where ((each.tree_type > 4) and (each.it_state <=3))){
			do add_geometries_to_send(t3,up_tree_3b);
		}
		else{
			do add_geometries_to_send(t3,up_tree_3a);
		}
	}
	
}

species unity_player parent: abstract_unity_player{
	float player_size <- 20.0;
	rgb color <- #red;
	float cone_distance <- 10.0 * player_size;
	float cone_amplitude <- 90.0;
	float player_rotation <- 90.0;
	bool to_display <- true;
	float z_offset <- 2.0;
	aspect default {
		if to_display {
			if selected {
				 draw circle(player_size) at: location + {0, 0, z_offset} color: rgb(#blue, 0.5);
			}
			draw circle(player_size/2.0) at: location + {0, 0, z_offset} color: color ;
			draw player_perception_cone() color: rgb(color, 0.5);
		}
	}
}

experiment vr_xp parent:First autorun: false type: unity {
	float minimum_cycle_duration <- 0.1;
	string unity_linker_species <- string(unity_linker);
	list<string> displays_to_hide <- ["Main","Total seeds","Summary"];
	float t_ref;

	action create_player(string id) {
		ask unity_linker {
			do create_player(id);
//			write id;
			add id to: player_name_list;
			 
			do build_invisible_walls(
				player: last(unity_player), //player to send the information to
				id: "wall_for_free_area", //id of the walls
				height: 40.0, //height of the walls
				wall_width: 1.0, //width ot the walls
				geoms: [usable_area] + usable_area.holes  //geometries used to defined the walls - the walls will be generated from the countour of these geometries
			);
			
				// change the area on which the player can teleport
			do send_teleport_area(
				player: last(unity_player), //player to send the information to
				id: "Teleport_free_area",//id of the teleportation area
				geoms: to_sub_geometries((usable_area - 1.0) ,[0.5, 0.5]) //geometries used to defined the teleportation area
			);
			
		}
	}

	action remove_player(string id_input) {
		if (not empty(unity_player)) {
			ask first(unity_player where (each.name = id_input)) {
				do die;
			}
		}
	}

	output {
		 display Main_VR parent:Main{
		 	 species unity_player;
			 event #mouse_down{
				 float t <- gama.machine_time;
				 if (t - t_ref) > 500 {
					 ask unity_linker {
						 move_player_event <- true;
					 }
					 t_ref <- t;
				 }
			 }
		 }
	}
}



