model mainGAMAforesttrails_model_VR

import "main_GAMA_forest_trails.gaml"


global {
	action save_total_seeds_to_csv{
		ask unity_player{
			int key_player <- map_player_id[name];
//			write key_player;
			list temp <- [];
			list header <- [];
//			save temp to: "../results/total_seed.csv" format:"csv" rewrite:true;
			add 'Team' + int(key_player + 1) to: temp;
			loop i from:0 to:length(n_tree) - 1{
				add container(seeds[key_player])[i] to: temp;
				add 'Type' + (i+1) to: header;
			}
			write temp;
			if self = unity_player[0]{
//				write 'here!!!';
				save temp to: "../results/total_seed.csv" header:false format:"csv" rewrite:true;
			}
			else{
				save temp to: "../results/total_seed.csv" header:false format:"csv" rewrite:false;
			}
//			save temp to: "../results/total_seed.csv" header:false format:"csv" rewrite:false;
		}
		
	}
	action resume_game {
		if not tutorial_finish{
			ask unity_linker {
				do send_message players: unity_player as list mes: ["Head"::"Tutorial", "Body"::""];
				write "send Tutorial";
				can_start <- false;
			}
			ask unity_player{
				location <- {180, 120, 3};
				ask unity_linker {
					new_player_position[myself.name] <- [myself.location.x *precision,myself.location.y *precision,myself.location.z *precision];
							move_player_event <- true;
				}
			}
		}
		else {
			ask unity_player{
				location <- any_location_in(road_midpoint[map_zone[count_start-1]] - 3) + {0, 0, 3}; //+ {0, 0, 5}
	//			write "move player to: " + location;
				ask unity_linker {
					new_player_position[myself.name] <- [myself.location.x *precision,myself.location.y *precision,myself.location.z *precision];
							move_player_event <- true;
				}
			}
//			ask player2{
//				location <- any_location_in(road_midpoint[map_zone[count_start-1]] - 3) + {0, 0, 3}; //+ {0, 0, 5}
//			}
	
			ask unity_linker {
				do send_message players: unity_player as list mes: ["Head"::"Start", "Body"::""];
				write "send Start";
	//			loop p over: unity_player {
	//				do enable_player_movement(
	//					player:p,
	//					enable:true
	//				);
	//			}
			}
		}
		move_player_when_game_finish <- true;
	}
	action pause_game {
//		ask unity_player{
//			write "now location: " + location;
//		}
		ask unity_linker {
			do send_message players: unity_player as list mes: ["Head"::"Stop", "Body"::""];
			write "send Stop";
//			loop p over: unity_player {
//				do enable_player_movement(
//					player:p,
//					enable:false
//				);
//			}
		}
		
		if move_player_when_game_finish {
//			ask unity_player{
//				location <- {180, 120, 3};
//				ask unity_linker {
//					new_player_position[myself.name] <- [myself.location.x *precision,myself.location.y *precision,myself.location.z *precision];
//							move_player_event <- true;
//						}
//			}
			move_player_when_game_finish <- false;
			
			tutorial_finish <- false;
//			tutorial_finish <- true;
			player_id_finish_tutorial_list <- [];
		}
	}
	
	reflex end_game when:time_now>=max_time{
		time_now <- max_time;
//		count_start <- 0 ;
		can_start <- false;
		do save_total_seeds_to_csv;
		
//		if move_player_when_game_finish {
//			ask unity_player{
//				location <- {180, 120, 3};
//				ask unity_linker {
//					new_player_position[myself.name] <- [myself.location.x *precision,myself.location.y *precision,myself.location.z *precision];
//							move_player_event <- true;
//						}
//			}
//			move_player_when_game_finish <- false;
//		}


	}
}

species unity_linker parent: abstract_unity_linker {
	string player_species <- string(unity_player);
	int num_players <- n_team;
	int max_num_players  <- -1;
	int min_num_players  <- 4;
	unity_property up_tree_1a;
	unity_property up_tree_1b;
	unity_property up_tree_2a;
	unity_property up_tree_2b;
	unity_property up_tree_3a;
	unity_property up_tree_3b;
	unity_property up_tree_4a;
	unity_property up_tree_4b;
	unity_property up_tree_5a;
	unity_property up_tree_5b;
	unity_property up_tree_6a;
	unity_property up_tree_6b;
	unity_property up_tree_7a;
	unity_property up_tree_7b;
	unity_property up_tree_8a;
	unity_property up_tree_8b;
	unity_property up_tree_9a;
	unity_property up_tree_9b;
	unity_property up_tree_10a;
	unity_property up_tree_10b;
	unity_property up_tree_11a;
	unity_property up_tree_11b;
	unity_property up_tree_12a;
	unity_property up_tree_12b;
	unity_property up_road;
	unity_property up_island;

	unity_property up_alien_tree_1;
	unity_property up_alien_tree_2;
	unity_property up_alien_tree_3;
	unity_property up_alien_tree_4;
	unity_property up_alien_tree_5;
	unity_property up_alien_tree_6;
	unity_property up_alien_tree_7;
	unity_property up_alien_tree_8;
	unity_property up_alien_tree_9;
	unity_property up_alien_tree_10;
	unity_property up_alien_tree_11;
	unity_property up_alien_tree_12;
	
	unity_property up_player_jam;
	
	
	action tutorial_finish(string player_ID, string tutorial_status){
		add player_ID to: player_id_finish_tutorial_list;
		write "Player " + player_ID + "finished tutorial.";
//		if length(player_id_finish_tutorial_list) >= length(player_id_list){
		if length(player_id_finish_tutorial_list) >= length(unity_player){
			ask world{
				ask sign{
					self.icon <- play;
				}
				can_start <- true ;
				do pause_game;
				do pause;
			}
			tutorial_finish <- true;
		}
	}
	
	action collect_seeds(string player_ID, string tree_ID){
		write "Player " + player_ID + " collect: " + tree_ID;
		int key_player <- map_player_id[player_ID];
		int key_tree <- int(tree_ID);
		write "TreeID: " + tree_ID;
		write "Key Tree: " + key_tree;
		write "abs Key Tree: " + abs(key_tree);
		
		if key_tree < 0{
			int temp <- int(container(alien_seeds[key_player])[abs(key_tree) - 1]);
			write "Alien before" + container(alien_seeds[key_player])[abs(key_tree) - 1];
			container(alien_seeds[key_player])[abs(key_tree) - 1] <- int(temp + 1);
			write "Alien after" + container(alien_seeds[key_player])[abs(key_tree) - 1];
		}
		else{
			int temp <- int(container(seeds[key_player])[key_tree - 1]);
			write "Normal before" + container(seeds[key_player])[key_tree - 1];
			container(seeds[key_player])[key_tree - 1] <- int(temp + 1);
			write "Normal after" + container(seeds[key_player])[key_tree - 1];
		}
	}
	
//	reflex random{
//		if flip(0.1) and player_id_list{
//			do collect_seeds(player_id_list[rnd(0, length(player_id_list)-1)], string(rnd(1,3)));
//		}
//	}

	list<point> init_locations <- define_init_locations();

	list<point> define_init_locations {
		list<point> init_pos;
		loop times: num_players {
//			init_pos << any_location_in(usable_area - 1.5) + {0, 0, 3};
			init_pos << {180, 120, 3};
			write "init_pos " + init_pos;
		}
		return init_pos;
	}

	init {
		do define_properties;
		player_unity_properties <- [up_player_jam,up_player_jam,up_player_jam,up_player_jam,up_player_jam,up_player_jam];
//		do add_background_geometries(road collect (each.geom_visu), up_road);
//		do add_background_geometries(island, up_island);
		
	}
	
	action define_properties {
		unity_aspect tree_aspect_1a <- prefab_aspect("temp/Prefab/Tree/FicusTree_NoFruit",1.0,0.05,1.0,0.5, precision);
		up_tree_1a <- geometry_properties("tree_1_a","tree",tree_aspect_1a,#no_interaction,false);
		unity_properties << up_tree_1a;
		
		unity_aspect tree_aspect_1b <- prefab_aspect("temp/Prefab/Tree/FicusTree",1.0,0.05,1.0,0.5, precision);
		up_tree_1b <- geometry_properties("tree_1_b","tree",tree_aspect_1b,#no_interaction,false);
		unity_properties << up_tree_1b;
		
		unity_aspect tree_aspect_2a <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/QuercusTreeAlll_NoFruit",1.0,0.05,1.0,0.5, precision);
		up_tree_2a <- geometry_properties("tree_2_a","tree",tree_aspect_2a,#no_interaction,false);
		unity_properties << up_tree_2a;
		
		unity_aspect tree_aspect_2b <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/QuercusTreeAll",1.0,0.05,1.0,0.5, precision);
		up_tree_2b <- geometry_properties("tree_2_b","tree",tree_aspect_2b,#no_interaction,false);
		unity_properties << up_tree_2b; 
		
		unity_aspect tree_aspect_3a <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/SapindusTreeAll_NoFruit",1.0,0.05,1.0,0.5, precision);
		up_tree_3a <- geometry_properties("tree_3_a","tree",tree_aspect_3a,#no_interaction,false);
		unity_properties << up_tree_3a;

		unity_aspect tree_aspect_3b <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/SapindusTreeAll",1.0,0.05,1.0,0.5, precision);
		up_tree_3b <- geometry_properties("tree_3_b","tree",tree_aspect_3b,#no_interaction,false);
		unity_properties << up_tree_3b;
		
		unity_aspect tree_aspect_4a <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/MagnoliaTreeAll_NoFruit",1.0,0.05,1.0,0.5, precision);
		up_tree_4a <- geometry_properties("tree_4_a","tree",tree_aspect_4a,#no_interaction,false);
		unity_properties << up_tree_4a;

		unity_aspect tree_aspect_4b <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/MagnoliaTreeAll",1.0,0.05,1.0,0.5, precision);
		up_tree_4b <- geometry_properties("tree_4_b","tree",tree_aspect_4b,#no_interaction,false);
		unity_properties << up_tree_4b;
		
		unity_aspect tree_aspect_5a <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/PhoebeTreeAll_NoFruit",1.0,0.05,1.0,0.5, precision);
		up_tree_5a <- geometry_properties("tree_5_a","tree",tree_aspect_5a,#no_interaction,false);
		unity_properties << up_tree_5a;

		unity_aspect tree_aspect_5b <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/PhoebeTreeAll",1.0,0.05,1.0,0.5, precision);
		up_tree_5b <- geometry_properties("tree_5_b","tree",tree_aspect_5b,#no_interaction,false);
		unity_properties << up_tree_5b;
		
		unity_aspect tree_aspect_6a <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/DiospyrosTreeAll_NoFruit",1.0,0.05,1.0,0.5, precision);
		up_tree_6a <- geometry_properties("tree_6_a","tree",tree_aspect_5a,#no_interaction,false);
		unity_properties << up_tree_6a;
		
		unity_aspect tree_aspect_6b <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/DiospyrosTreeAll",1.0,0.05,1.0,0.5, precision);
		up_tree_6b <- geometry_properties("tree_6_b","tree",tree_aspect_5b,#no_interaction,false);
		unity_properties << up_tree_6b;
		
		
		
		unity_aspect alien_tree_aspect_1 <- prefab_aspect("temp/Prefab/Tree/Alien/FicusAlien_Tree",1.0,0.05,1.0,0.5, precision);
		up_alien_tree_1 <- geometry_properties("alien_tree_1","tree",alien_tree_aspect_1,#no_interaction,false);
		unity_properties << up_alien_tree_1;
			
		unity_aspect alien_tree_aspect_2 <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/QuercusAlienAll",1.0,0.05,1.0,0.5, precision);
		up_alien_tree_2 <- geometry_properties("alien_tree_2","tree",alien_tree_aspect_2,#no_interaction,false);
		unity_properties << up_alien_tree_2;
		
		unity_aspect alien_tree_aspect_3 <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/SapindusAlienAll",1.0,0.05,1.0,0.5, precision);
		up_alien_tree_3 <- geometry_properties("alien_tree_3","tree",alien_tree_aspect_3,#no_interaction,false);
		unity_properties << up_alien_tree_3;
		
		
		
		
		unity_aspect road_aspect <- geometry_aspect(0.0,#gray,precision);
		up_road <- geometry_properties("road","road",road_aspect,#no_interaction,false);
		unity_properties << up_road;
		
		unity_aspect island_aspect <- geometry_aspect(0.0,#gray,precision);
		up_island <- geometry_properties("island","",road_aspect,#no_interaction,false);
		unity_properties << up_island;


		unity_aspect player_aspect <- prefab_aspect("temp/Prefab/Character/PlayerPrefab(JAM)",0.82,0.0,-1.0,90.0,precision);
		up_player_jam <- geometry_properties("little_ghost","",player_aspect,new_geometry_interaction(true, false,false,[]),false);
		unity_properties << up_player_jam; 
	}
	
	reflex send_geometries {
		list<tree> t1 <- tree where ((each.tree_type = 1) and (each.it_state <=3));
		list<tree> t1f <- tree where ((each.tree_type = 1) and (each.it_state = 4) and (each.it_alien = false));
		list<tree> t1a <- tree where ((each.tree_type = 1) and (each.it_state = 4) and (each.it_alien = true));
		if not empty(t1){
			do add_geometries_to_send(t1,up_tree_1a);
		}
		if not empty(t1f){
			do add_geometries_to_send(t1f,up_tree_1b);
		}
		if not empty(t1a){
			do add_geometries_to_send(t1a,up_alien_tree_1);
		}	
 
		list<tree> t2 <- tree where ((each.tree_type = 2) and (each.it_state <=3));
		list<tree> t2f <- tree where ((each.tree_type = 2) and (each.it_state = 4) and (each.it_alien = false));
		list<tree> t2a <- tree where ((each.tree_type = 2) and (each.it_state = 4) and (each.it_alien = true));
		if not empty(t2){
			do add_geometries_to_send(t2,up_tree_2a);
		}
		if not empty(t2f){
			do add_geometries_to_send(t2f,up_tree_2b);
		}
		if not empty(t2a){
			do add_geometries_to_send(t2a,up_alien_tree_2);
		}	
 
		list<tree> t3 <- tree where ((each.tree_type = 3) and (each.it_state <=3));
		list<tree> t3f <- tree where ((each.tree_type = 3) and (each.it_state = 4) and (each.it_alien = false));
		list<tree> t3a <- tree where ((each.tree_type = 3) and (each.it_state = 4) and (each.it_alien = true));
		if not empty(t3){
			do add_geometries_to_send(t3,up_tree_3a);
		}
		if not empty(t3f){
			do add_geometries_to_send(t3f,up_tree_3b);
		}
		if not empty(t3a){
			do add_geometries_to_send(t3a,up_alien_tree_3);
		}	
 
		list<tree> t4 <- tree where ((each.tree_type = 4) and (each.it_state <=3));
		list<tree> t4f <- tree where ((each.tree_type = 4) and (each.it_state = 4) and (each.it_alien = false));
		list<tree> t4a <- tree where ((each.tree_type = 4) and (each.it_state = 4) and (each.it_alien = true));
		if not empty(t4){
			do add_geometries_to_send(t4,up_tree_4a);
		}
		if not empty(t4f){
			do add_geometries_to_send(t4f,up_tree_4b);
		}
		if not empty(t4a){
			do add_geometries_to_send(t4a,up_alien_tree_2);
		}	
 
		list<tree> t5 <- tree where ((each.tree_type = 5) and (each.it_state <=3));
		list<tree> t5f <- tree where ((each.tree_type = 5) and (each.it_state = 4) and (each.it_alien = false));
		list<tree> t5a <- tree where ((each.tree_type = 5) and (each.it_state = 4) and (each.it_alien = true));
		if not empty(t5){
			do add_geometries_to_send(t5,up_tree_5a);
		}
		if not empty(t5f){
			do add_geometries_to_send(t5f,up_tree_5b);
		}
		if not empty(t5a){
			do add_geometries_to_send(t5a,up_alien_tree_3);
		}	
 
		list<tree> t6 <- tree where ((each.tree_type = 6) and (each.it_state <=3));
		list<tree> t6f <- tree where ((each.tree_type = 6) and (each.it_state = 4) and (each.it_alien = false));
		list<tree> t6a <- tree where ((each.tree_type = 6) and (each.it_state = 4) and (each.it_alien = true));
		if not empty(t6){
			do add_geometries_to_send(t6,up_tree_6a);
		}
		if not empty(t6f){
			do add_geometries_to_send(t6f,up_tree_6b);
		}
		if not empty(t6a){
			do add_geometries_to_send(t6a,up_alien_tree_3);
		}	
 
		list<tree> t7 <- tree where ((each.tree_type = 7) and (each.it_state <=3));
		list<tree> t7f <- tree where ((each.tree_type = 7) and (each.it_state = 4) and (each.it_alien = false));
		list<tree> t7a <- tree where ((each.tree_type = 7) and (each.it_state = 4) and (each.it_alien = true));
		if not empty(t7){
			do add_geometries_to_send(t7,up_tree_1a);
		}
		if not empty(t7f){
			do add_geometries_to_send(t7f,up_tree_1b);
		}
		if not empty(t7a){
			do add_geometries_to_send(t7a,up_alien_tree_1);
		}	
 
		list<tree> t8 <- tree where ((each.tree_type = 8) and (each.it_state <=3));
		list<tree> t8f <- tree where ((each.tree_type = 8) and (each.it_state = 4) and (each.it_alien = false));
		list<tree> t8a <- tree where ((each.tree_type = 8) and (each.it_state = 4) and (each.it_alien = true));
		if not empty(t8){
			do add_geometries_to_send(t8,up_tree_2a);
		}
		if not empty(t8f){
			do add_geometries_to_send(t8f,up_tree_2b);
		}
		if not empty(t8a){
			do add_geometries_to_send(t8a,up_alien_tree_2);
		}	
 
		list<tree> t9 <- tree where ((each.tree_type = 9) and (each.it_state <=3));
		list<tree> t9f <- tree where ((each.tree_type = 9) and (each.it_state = 4) and (each.it_alien = false));
		list<tree> t9a <- tree where ((each.tree_type = 9) and (each.it_state = 4) and (each.it_alien = true));
		if not empty(t9){
			do add_geometries_to_send(t9,up_tree_3a);
		}
		if not empty(t9f){
			do add_geometries_to_send(t9f,up_tree_3b);
		}
		if not empty(t9a){
			do add_geometries_to_send(t9a,up_alien_tree_3);
		}	
 
		list<tree> t10 <- tree where ((each.tree_type = 10) and (each.it_state <=3));
		list<tree> t10f <- tree where ((each.tree_type = 10) and (each.it_state = 4) and (each.it_alien = false));
		list<tree> t10a <- tree where ((each.tree_type = 10) and (each.it_state = 4) and (each.it_alien = true));
		if not empty(t10){
			do add_geometries_to_send(t10,up_tree_4a);
		}
		if not empty(t10f){
			do add_geometries_to_send(t10f,up_tree_4b);
		}
		if not empty(t10a){
			do add_geometries_to_send(t10a,up_alien_tree_2);
		}	
 
		list<tree> t11 <- tree where ((each.tree_type = 11) and (each.it_state <=3));
		list<tree> t11f <- tree where ((each.tree_type = 11) and (each.it_state = 4) and (each.it_alien = false));
		list<tree> t11a <- tree where ((each.tree_type = 11) and (each.it_state = 4) and (each.it_alien = true));
		if not empty(t11){
			do add_geometries_to_send(t11,up_tree_5a);
		}
		if not empty(t11f){
			do add_geometries_to_send(t11f,up_tree_5b);
		}
		if not empty(t11a){
			do add_geometries_to_send(t11a,up_alien_tree_2);
		}	
 
		list<tree> t12 <- tree where ((each.tree_type = 12) and (each.it_state <=3));
		list<tree> t12f <- tree where ((each.tree_type = 12) and (each.it_state = 4) and (each.it_alien = false));
		list<tree> t12a <- tree where ((each.tree_type = 12) and (each.it_state = 4) and (each.it_alien = true));
		if not empty(t12){
			do add_geometries_to_send(t12,up_tree_6a);
		}
		if not empty(t12f){
			do add_geometries_to_send(t12f,up_tree_6b);
		}
		if not empty(t12a){
			do add_geometries_to_send(t12a,up_alien_tree_3);
		}	
 
		
		

//		list<tree> t1 <- tree where (each.tree_type = 1);
//		if empty(tree where ((each.tree_type = 1) and (each.it_state <=3))){
//			do add_geometries_to_send(t1,up_tree_1a);
//		}
//		else{
//			do add_geometries_to_send(t1,up_tree_1b);
//		}
// 
//		list<tree> t2 <- tree where (each.tree_type = 2);
//		if empty(tree where ((each.tree_type = 2) and (each.it_state <=3))){
//			do add_geometries_to_send(t2,up_tree_2a);
//		}
//		else{
//			do add_geometries_to_send(t2,up_tree_2b);
//		}
// 
//		list<tree> t3 <- tree where (each.tree_type = 3);
//		if empty(tree where ((each.tree_type = 3) and (each.it_state <=3))){
//			do add_geometries_to_send(t3,up_tree_3a);
//		}
//		else{
//			do add_geometries_to_send(t3,up_tree_3b);
//		}
// 
//		list<tree> t4 <- tree where (each.tree_type = 4);
//		if empty(tree where ((each.tree_type = 4) and (each.it_state <=3))){
//			do add_geometries_to_send(t4,up_tree_4a);
//		}
//		else{
//			do add_geometries_to_send(t4,up_tree_4b);
//		}
// 
//		list<tree> t5 <- tree where (each.tree_type = 5);
//		if empty(tree where ((each.tree_type = 5) and (each.it_state <=3))){
//			do add_geometries_to_send(t5,up_tree_5a);
//		}
//		else{
//			do add_geometries_to_send(t5,up_tree_5b);
//		}
// 
//		list<tree> t6 <- tree where (each.tree_type = 6);
//		if empty(tree where ((each.tree_type = 6) and (each.it_state <=3))){
//			do add_geometries_to_send(t6,up_tree_1a);
//		}
//		else{
//			do add_geometries_to_send(t6,up_tree_1b);
//		}
// 
//		list<tree> t7 <- tree where (each.tree_type = 7);
//		if empty(tree where ((each.tree_type = 7) and (each.it_state <=3))){
//			do add_geometries_to_send(t7,up_tree_2a);
//		}
//		else{
//			do add_geometries_to_send(t7,up_tree_2b);
//		}
// 
//		list<tree> t8 <- tree where (each.tree_type = 8);
//		if empty(tree where ((each.tree_type = 8) and (each.it_state <=3))){
//			do add_geometries_to_send(t8,up_tree_3a);
//		}
//		else{
//			do add_geometries_to_send(t8,up_tree_3b);
//		}
// 
//		list<tree> t9 <- tree where (each.tree_type = 9);
//		if empty(tree where ((each.tree_type = 9) and (each.it_state <=3))){
//			do add_geometries_to_send(t9,up_tree_4a);
//		}
//		else{
//			do add_geometries_to_send(t9,up_tree_4b);
//		}
// 
//		list<tree> t10 <- tree where (each.tree_type = 10);
//		if empty(tree where ((each.tree_type = 10) and (each.it_state <=3))){
//			do add_geometries_to_send(t10,up_tree_5a);
//		}
//		else{
//			do add_geometries_to_send(t10,up_tree_5b);
//		}
// 
//		list<tree> t11 <- tree where (each.tree_type = 11);
//		if empty(tree where ((each.tree_type = 11) and (each.it_state <=3))){
//			do add_geometries_to_send(t11,up_tree_1a);
//		}
//		else{
//			do add_geometries_to_send(t11,up_tree_1b);
//		}
// 
//		list<tree> t12 <- tree where (each.tree_type = 12);
//		if empty(tree where ((each.tree_type = 12) and (each.it_state <=3))){
//			do add_geometries_to_send(t12,up_tree_2a);
//		}
//		else{
//			do add_geometries_to_send(t12,up_tree_2b);
//		}
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

experiment First_vr_xp parent:init_exp autorun: false type: unity {
	float minimum_cycle_duration <- 0.1;
	string unity_linker_species <- string(unity_linker);
	list<string> displays_to_hide <- ["Main"];
	float t_ref;

	action create_player(string id) {
		ask unity_linker {
			do create_player(id);
			
			do build_invisible_walls(
				player: last(unity_player), //player to send the information to
				id: "wall_for_free_area", //id of the walls
				height: 10.0, //height of the walls
				wall_width: 0.5, //width ot the walls
				geoms: [usable_area] + usable_area.holes //geometries used to defined the walls - the walls will be generated from the countour of these geometries
			);
//			 
//				// change the area on which the player can teleport
//			do send_teleport_area(
//				player: last(unity_player), //player to send the information to
//				id: "Teleport_free_area",//id of the teleportation area
//				geoms: to_sub_geometries((usable_area - 1.0) ,[0.5, 0.5]) //geometries used to defined the teleportation area
//			);
		}
		
		if not(id in player_id_list){
			add id to: player_id_list;
			add id::length(unity_player)-1 to:map_player_id;
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

experiment Second_vr_xp parent:init_exp autorun: false type: unity {
	
	init{
		alien_experimant <- true;
	}
	
	float minimum_cycle_duration <- 0.1;
	string unity_linker_species <- string(unity_linker);
	list<string> displays_to_hide <- ["Main"];
	float t_ref;

	action create_player(string id) {
		ask unity_linker {
			do create_player(id);
			
			do build_invisible_walls(
				player: last(unity_player), //player to send the information to
				id: "wall_for_free_area", //id of the walls
				height: 10.0, //height of the walls
				wall_width: 0.5, //width ot the walls
				geoms: [usable_area] + usable_area.holes //geometries used to defined the walls - the walls will be generated from the countour of these geometries
			);
//			 
//				// change the area on which the player can teleport
//			do send_teleport_area(
//				player: last(unity_player), //player to send the information to
//				id: "Teleport_free_area",//id of the teleportation area
//				geoms: to_sub_geometries((usable_area - 1.0) ,[0.5, 0.5]) //geometries used to defined the teleportation area
//			);
		}
		
		if not(id in player_id_list){
			add id to: player_id_list;
			add id::length(unity_player)-1 to:map_player_id;
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

