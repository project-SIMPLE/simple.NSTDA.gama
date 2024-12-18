model mainGAMAforesttrails2_model_VR

import "main_GAMA_forest_trails.gaml"

<<<<<<< Updated upstream
=======

global {	
	action save_total_seeds_to_csv{
		list header <- [];
		loop i from:0 to:length(n_tree) - 1{
			add 'Type' + (i+1) to: header;
		}
		ask unity_player{
			int key_player <- map_player_id[name];
			list temp <- [];
			list temp2 <- [];
			
			add 'Team' + int(key_player + 1) to: temp;
			add 'Team' + int(key_player + 1) to: temp2;
			
			loop i from:0 to:length(n_tree) - 1{
				add container(seeds[key_player])[i] to: temp;
				add container(alien_seeds[key_player])[i] to: temp2;
			}
			
			write temp;
			if self = unity_player[0]{
				save temp to: "../results/total_seeds.csv" header:false format:"csv" rewrite:true;
			}
			else{
				save temp to: "../results/total_seeds.csv" header:false format:"csv" rewrite:false;
			}
			
			write temp2;
			if self = unity_player[0]{
				save temp2 to: "../results/total_alien_seeds.csv" header:false format:"csv" rewrite:true;
			}
			else{
				save temp2 to: "../results/total_alien_seeds.csv" header:false format:"csv" rewrite:false;
			}
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
				location <- {180, 120, 2};
				ask unity_linker {
					new_player_position[myself.name] <- [myself.location.x *precision,myself.location.y *precision,myself.location.z *precision];
					move_player_event <- true;
				}
			}
		}
		else {
			ask unity_player{
				location <- any_location_in(road_midpoint[map_zone[count_start-1]] - 3) + {0, 0, 2}; //+ {0, 0, 5}
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

		if tutorial_finish{
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

>>>>>>> Stashed changes
species unity_linker parent: abstract_unity_linker {
	string player_species <- string(unity_player);
	int num_players <- n_team;
	int max_num_players  <- -1;
	int min_num_players  <- n_team;
	unity_property up_tree_1a;
	unity_property up_tree_1b;
	unity_property up_tree_2a;
	unity_property up_tree_2b;
	unity_property up_tree_3a;
	unity_property up_tree_3b;
	unity_property up_road;
	unity_property up_offroad;

	unity_property up_ghost;
	unity_property up_lg;
	unity_property up_slime;
	unity_property up_turtle;
	
	action collect_seeds(string player_ID, string tree_ID){ 
		write "Player " + player_ID + " collect: " + tree_ID;
		int key_player <- map_player_id[player_ID];
		int key_tree <- map_tree_id[tree_ID];
		ask tree[key_tree]{
			if it_alien{
				int temp <- int(container(alien_seeds[key_player])[key_tree]);
				container(alien_seeds[key_player])[key_tree] <- int(temp + 1);
			}
			else{
				int temp <- int(container(seeds[key_player])[key_tree]);
				container(seeds[key_player])[key_tree] <- int(temp + 1);
			}
		}
	}
	
	reflex random{
		if flip(0.1){
			do collect_seeds(player_id_list[rnd(0, length(player_id_list)-1)], tree_id_list[rnd(0, length(tree_id_list)-1)]);
		}
		if flip(0.1){
			do collect_seeds(player_id_list[rnd(0, length(player_id_list)-1)], tree_id_list[rnd(0, length(tree_id_list)-1)]);
		}
	}


	list<point> init_locations <- define_init_locations();

	list<point> define_init_locations {
		list<point> init_pos;
		loop times: num_players {
<<<<<<< Updated upstream
			init_pos << any_location_in(usable_area - 1.5) + {0, 0, 1.5};
=======
//			init_pos << any_location_in(usable_area - 1.5) + {0, 0, 3};
			init_pos << {180, 120, 2};
			write "init_pos " + init_pos;
>>>>>>> Stashed changes
		}
		return init_pos;
	}


	init {
		do define_properties;
//		player_unity_properties <- [up_lg, up_turtle, up_slime, up_ghost];
		player_unity_properties <- [up_lg];
		do add_background_geometries(road collect (each.geom_visu), up_road);
//		do add_background_geometries(offroad, up_offroad);
	}
	
	action define_properties {
		
		unity_aspect tree_aspect_1a <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/QuercusTreeAlll_NoFruit",1.0,0.05,1.0,0.5, precision);
		up_tree_1a <- geometry_properties("tree_1_a","tree",tree_aspect_1a,#no_interaction,false);
		unity_properties << up_tree_1a;
		
<<<<<<< Updated upstream
		unity_aspect tree_aspect_1b <- prefab_aspect("temp/Prefab/Tree/FicusTree",1.0,0.01,1.0,0.5, precision);
		up_tree_1b <- geometry_properties("tree_1_b","tree",tree_aspect_1b,#no_interaction,false);
		unity_properties << up_tree_1b;
		

		unity_aspect tree_aspect_2a <- prefab_aspect("temp/Prefab/Tree/QuercusTree_Short_NoFruit",1.0,0.05,1.0,0.5, precision);
		up_tree_2a <- geometry_properties("tree_2_a","tree",tree_aspect_2a,#no_interaction,false);
		unity_properties << up_tree_2a;
		
		unity_aspect tree_aspect_2b <- prefab_aspect("temp/Prefab/Tree/QuercusTree_Short",1.0,0.05,1.0,0.5, precision);
=======
		unity_aspect tree_aspect_1b <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/QuercusTreeAll",1.0,0.05,1.0,0.5, precision);
		up_tree_1b <- geometry_properties("tree_1_b","tree",tree_aspect_1b,#no_interaction,false);
		unity_properties << up_tree_1b;
		
		unity_aspect tree_aspect_2a <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/SapindusTreeAll_NoFruit",1.0,0.05,1.0,0.5, precision);
		up_tree_2a <- geometry_properties("tree_2_a","tree",tree_aspect_2a,#no_interaction,false);
		unity_properties << up_tree_2a;
		
		unity_aspect tree_aspect_2b <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/SapindusTreeAll",1.0,0.05,1.0,0.5, precision);
>>>>>>> Stashed changes
		up_tree_2b <- geometry_properties("tree_2_b","tree",tree_aspect_2b,#no_interaction,false);
		unity_properties << up_tree_2b;
		
<<<<<<< Updated upstream
		unity_aspect tree_aspect_3a <- prefab_aspect("temp/Prefab/Tree/SapindusTree_Short_NoFruit",1.0,0.05,1.0,0.5, precision);
		up_tree_3a <- geometry_properties("tree_3_a","tree",tree_aspect_3a,#no_interaction,false);
		unity_properties << up_tree_3a;

		
		unity_aspect tree_aspect_3b <- prefab_aspect("temp/Prefab/Tree/SapindusTree_Short",1.0,0.05,1.0,0.5, precision);
		up_tree_3b <- geometry_properties("tree_3_b","tree",tree_aspect_3b,#no_interaction,false);
		unity_properties << up_tree_3b;
		

=======
		unity_aspect tree_aspect_3a <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/MagnoliaTreeAll_NoFruit",1.0,0.05,1.0,0.5, precision);
		up_tree_3a <- geometry_properties("tree_3_a","tree",tree_aspect_3a,#no_interaction,false);
		unity_properties << up_tree_3a;

		unity_aspect tree_aspect_3b <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/MagnoliaTreeAll",1.0,0.05,1.0,0.5, precision);
		up_tree_3b <- geometry_properties("tree_3_b","tree",tree_aspect_3b,#no_interaction,false);
		unity_properties << up_tree_3b;
		
		unity_aspect tree_aspect_4a <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/PhoebeTreeAll_NoFruit",1.0,0.05,1.0,0.5, precision);
		up_tree_4a <- geometry_properties("tree_4_a","tree",tree_aspect_4a,#no_interaction,false);
		unity_properties << up_tree_4a;

		unity_aspect tree_aspect_4b <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/PhoebeTreeAll",1.0,0.05,1.0,0.5, precision);
		up_tree_4b <- geometry_properties("tree_4_b","tree",tree_aspect_4b,#no_interaction,false);
		unity_properties << up_tree_4b;
		
		unity_aspect tree_aspect_5a <- prefab_aspect("temp/Prefab/Tree/6.Debregeasia/DebregeasiaTree_Short_NoFruit",1.0,0.05,1.0,0.5, precision);
		up_tree_5a <- geometry_properties("tree_5_a","tree",tree_aspect_5a,#no_interaction,false);
		unity_properties << up_tree_5a;
		
		unity_aspect tree_aspect_5b <- prefab_aspect("temp/Prefab/Tree/6.Debregeasia/DebregeasiaTree_Short",1.0,0.05,1.0,0.5, precision);
		up_tree_5b <- geometry_properties("tree_5_b","tree",tree_aspect_5b,#no_interaction,false);
		unity_properties << up_tree_5b;
		
		unity_aspect tree_aspect_6a <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/DiospyrosTreeAll_NoFruit",1.0,0.05,1.0,0.5, precision);
		up_tree_6a <- geometry_properties("tree_6_a","tree",tree_aspect_5a,#no_interaction,false);
		unity_properties << up_tree_6a;
		
		unity_aspect tree_aspect_6b <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/DiospyrosTreeAll",1.0,0.05,1.0,0.5, precision);
		up_tree_6b <- geometry_properties("tree_6_b","tree",tree_aspect_5b,#no_interaction,false);
		unity_properties << up_tree_6b;
		
		unity_aspect tree_aspect_7a <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/OstodesTreeAll_NoFruit",1.0,0.05,1.0,0.5, precision);
		up_tree_7a <- geometry_properties("tree_7_a","tree",tree_aspect_7a,#no_interaction,false);
		unity_properties << up_tree_7a;
		
		unity_aspect tree_aspect_7b <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/OstodesTreeAll",1.0,0.05,1.0,0.5, precision);
		up_tree_7b <- geometry_properties("tree_7_b","tree",tree_aspect_7b,#no_interaction,false);
		unity_properties << up_tree_7b;
		
		unity_aspect tree_aspect_8a <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/PhyllanTree_All_NoFruit",1.0,0.05,1.0,0.5, precision);
		up_tree_8a <- geometry_properties("tree_8_a","tree",tree_aspect_8a,#no_interaction,false);
		unity_properties << up_tree_8a;
		
		unity_aspect tree_aspect_8b <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/PhyllanTree_All",1.0,0.05,1.0,0.5, precision);
		up_tree_8b <- geometry_properties("tree_8_b","tree",tree_aspect_8b,#no_interaction,false);
		unity_properties << up_tree_8b;
		
		unity_aspect tree_aspect_9a <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/Castanore_All_NoFruit",1.0,0.05,1.0,0.5, precision);
		up_tree_9a <- geometry_properties("tree_9_a","tree",tree_aspect_9a,#no_interaction,false);
		unity_properties << up_tree_9a;
		
		unity_aspect tree_aspect_9b <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/Castanoree_All",1.0,0.05,1.0,0.5, precision);
		up_tree_9b <- geometry_properties("tree_9_b","tree",tree_aspect_9b,#no_interaction,false);
		unity_properties << up_tree_9b;
		
		unity_aspect tree_aspect_10a <- prefab_aspect("temp/Prefab/Tree/12.Gmelina/Gmelina_Tree_NoFruit",1.0,0.05,1.0,0.5, precision);
		up_tree_10a <- geometry_properties("tree_10_a","tree",tree_aspect_10a,#no_interaction,false);
		unity_properties << up_tree_10a;
		
		unity_aspect tree_aspect_10b <- prefab_aspect("temp/Prefab/Tree/12.Gmelina/Gmelina_Tree",1.0,0.05,1.0,0.5, precision);
		up_tree_10b <- geometry_properties("tree_10_b","tree",tree_aspect_10b,#no_interaction,false);
		unity_properties << up_tree_10b;
		
		
		
		unity_aspect alien_tree_aspect_1 <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/QuercusAlienAll",1.0,0.05,1.0,0.5, precision);
		up_alien_tree_1 <- geometry_properties("alien_tree_1","tree",alien_tree_aspect_1,#no_interaction,false);
		unity_properties << up_alien_tree_1;
		
		unity_aspect alien_tree_aspect_2 <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/SapindusAlienAll",1.0,0.05,1.0,0.5, precision);
		up_alien_tree_2 <- geometry_properties("alien_tree_2","tree",alien_tree_aspect_2,#no_interaction,false);
		unity_properties << up_alien_tree_2;
		
>>>>>>> Stashed changes
		
//		unity_aspect tree_aspect_1a <- prefab_aspect("Prefabs/Visual Prefabs/Nature/PREFABS/Plants/SM_Arbre_001",2.0,0,1.0,0.5, precision);
//		up_tree_1a <- geometry_properties("tree_1_a","tree",tree_aspect_1a,#no_interaction,false);
//		unity_properties << up_tree_1a;
//		
//		unity_aspect tree_aspect_1b <- prefab_aspect("Prefabs/Visual Prefabs/Nature/PREFABS/Plants/SM_Arbre_003",2.0,0,1.0,0.5, precision);
//		up_tree_1b <- geometry_properties("tree_1_b","tree",tree_aspect_1b,#no_interaction,false);
//		unity_properties << up_tree_1b;
//
//		unity_aspect tree_aspect_2a <- prefab_aspect("Prefabs/Visual Prefabs/Nature/PREFABS/Plants/SM_Bananier_005",3.0,0,1.0,0.5, precision);
//		up_tree_2a <- geometry_properties("tree_2_a","tree",tree_aspect_2a,#no_interaction,false);
//		unity_properties << up_tree_2a;
//		
//		unity_aspect tree_aspect_2b <- prefab_aspect("Prefabs/Visual Prefabs/Nature/PREFABS/Plants/SM_Bananier_002",3.0,0,1.0,0.5, precision);
//		up_tree_2b <- geometry_properties("tree_2_b","tree",tree_aspect_2b,#no_interaction,false);
//		unity_properties << up_tree_2b;
//		
//		unity_aspect tree_aspect_3a <- prefab_aspect("Prefabs/Visual Prefabs/Nature/PREFABS/Plants/SM_ClayPot_001",8.0,0,1.0,0.5, precision);
//		up_tree_3a <- geometry_properties("tree_3_a","tree",tree_aspect_3a,#no_interaction,false);
//		unity_properties << up_tree_3a;
//		
//		unity_aspect tree_aspect_3b <- prefab_aspect("Prefabs/Visual Prefabs/Nature/PREFABS/Plants/SM_ClayPotPlant_001",8.0,0,1.0,0.5, precision);
//		up_tree_3b <- geometry_properties("tree_3_b","tree",tree_aspect_3b,#no_interaction,false);
//		unity_properties << up_tree_3b;
		
		unity_aspect road_aspect <- geometry_aspect(0.0,#gray,precision);
//		unity_aspect road_aspect <- prefab_aspect("Prefabs/Visual Prefabs/Nature/PREFABS/grounddd",1.0,0.0,0.0,-180,precision);
//		unity_aspect road_aspect <- prefab_aspect("Prefabs/Visual Prefabs/Character/Ghost",2.0,0.0,-1.0,90.0,precision);
		up_road <- geometry_properties("road","",road_aspect,#no_interaction,false);
		unity_properties << up_road;
		
		unity_aspect offroad_aspect <- geometry_aspect(0.0,#blue,precision);
//		unity_aspect offroad_aspect <- prefab_aspect("Prefabs/Visual Prefabs/Character/Ghost",2.0,0.0,-1.0,90.0,precision);
		up_offroad <- geometry_properties("offroad","",offroad_aspect,#no_interaction,false);
		unity_properties << up_offroad;

//		unity_aspect ghost_aspect <- prefab_aspect("Prefabs/Visual Prefabs/Character/Ghost",2.0,0.0,-1.0,90.0,precision);
//		up_ghost <- geometry_properties("ghost","",ghost_aspect,#collider,false);
//		unity_properties << up_ghost; 
//		
//		unity_aspect slime_aspect <- prefab_aspect("Prefabs/Visual Prefabs/Character/Slime",2.0,0.0,-1.0,90.0,precision);
//		up_slime <- geometry_properties("slime","",slime_aspect,new_geometry_interaction(true, false,false,[]),false);
//		unity_properties << up_slime; 
		
		unity_aspect lg_aspect <- prefab_aspect("temp/Prefab/Character/LittleGhost",2.0,0.0,-1.0,90.0,precision);
		up_lg <- geometry_properties("little_ghost","",lg_aspect,new_geometry_interaction(true, false,false,[]),false);
		unity_properties << up_lg; 
//		
//		unity_aspect turtle_aspect <- prefab_aspect("Prefabs/Visual Prefabs/Character/TurtleShell",2.0,0.0,-1.0,90.0,precision);
//		up_turtle <- geometry_properties("turtle","",turtle_aspect,new_geometry_interaction(true, false,false,[]),false);
//		unity_properties << up_turtle; 
	}
	
//	reflex send_geometries {
//		do add_geometries_to_send(road,up_road);
//		do add_geometries_to_send(tree,up_tree_1a);
//	}

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
<<<<<<< Updated upstream
=======
		if not empty(t3f){
			do add_geometries_to_send(t3f,up_tree_3b);
		}
		if not empty(t3a){
			do add_geometries_to_send(t3a,up_alien_tree_1);
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
			do add_geometries_to_send(t5a,up_alien_tree_1);
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
			do add_geometries_to_send(t6a,up_alien_tree_2);
		}	
 
		list<tree> t7 <- tree where ((each.tree_type = 7) and (each.it_state <=3));
		list<tree> t7f <- tree where ((each.tree_type = 7) and (each.it_state = 4) and (each.it_alien = false));
		list<tree> t7a <- tree where ((each.tree_type = 7) and (each.it_state = 4) and (each.it_alien = true));
		if not empty(t7){
			do add_geometries_to_send(t7,up_tree_7a);
		}
		if not empty(t7f){
			do add_geometries_to_send(t7f,up_tree_7b);
		}
		if not empty(t7a){
			do add_geometries_to_send(t7a,up_alien_tree_1);
		}	
 
		list<tree> t8 <- tree where ((each.tree_type = 8) and (each.it_state <=3));
		list<tree> t8f <- tree where ((each.tree_type = 8) and (each.it_state = 4) and (each.it_alien = false));
		list<tree> t8a <- tree where ((each.tree_type = 8) and (each.it_state = 4) and (each.it_alien = true));
		if not empty(t8){
			do add_geometries_to_send(t8,up_tree_8a);
		}
		if not empty(t8f){
			do add_geometries_to_send(t8f,up_tree_8b);
		}
		if not empty(t8a){
			do add_geometries_to_send(t8a,up_alien_tree_2);
		}	
 
		list<tree> t9 <- tree where ((each.tree_type = 9) and (each.it_state <=3));
		list<tree> t9f <- tree where ((each.tree_type = 9) and (each.it_state = 4) and (each.it_alien = false));
		list<tree> t9a <- tree where ((each.tree_type = 9) and (each.it_state = 4) and (each.it_alien = true));
		if not empty(t9){
			do add_geometries_to_send(t9,up_tree_9a);
		}
		if not empty(t9f){
			do add_geometries_to_send(t9f,up_tree_9b);
		}
		if not empty(t9a){
			do add_geometries_to_send(t9a,up_alien_tree_1);
		}	
 
		list<tree> t10 <- tree where ((each.tree_type = 10) and (each.it_state <=3));
		list<tree> t10f <- tree where ((each.tree_type = 10) and (each.it_state = 4) and (each.it_alien = false));
		list<tree> t10a <- tree where ((each.tree_type = 10) and (each.it_state = 4) and (each.it_alien = true));
		if not empty(t10){
			do add_geometries_to_send(t10,up_tree_10a);
		}
		if not empty(t10f){
			do add_geometries_to_send(t10f,up_tree_10b);
		}
		if not empty(t10a){
			do add_geometries_to_send(t10a,up_alien_tree_2);
		}	
 

>>>>>>> Stashed changes
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
	list<string> displays_to_hide <- ["Main"];
	float t_ref;

	action create_player(string id) {
		ask unity_linker {
			do create_player(id);
			
			do build_invisible_walls(
				player: last(unity_player), //player to send the information to
				id: "wall_for_free_area", //id of the walls
				height: 40.0, //height of the walls
				wall_width: 1.0, //width ot the walls
				geoms: [usable_area] + usable_area.holes  //geometries used to defined the walls - the walls will be generated from the countour of these geometries
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
