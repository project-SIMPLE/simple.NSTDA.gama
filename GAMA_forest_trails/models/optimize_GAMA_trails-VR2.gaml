model optimizeGAMAtrails_model_VR

import "optimize_GAMA_trails2.gaml"

global {	
	int adjust_location <- 3;
	action save_total_seeds_to_csv{
		list header <- [];
		loop i from:0 to:length(n_tree) - 1{
			add 'Type' + (i+1) to: header;
		}
		
		int min_team_id <- 6;
		
		ask unity_player{
			if min_team_id > team_id {
				min_team_id <- team_id;
			}
		}
		
		loop j from:1 to:6{
			//write string("Save data for Player_10" + j);
			
			ask unity_player where (each.name = string("Player_10" + j)){
				int key_player <- team_id - 1;
				list temp <- [];
				list temp2 <- [];
				
				add 'Team' + int(team_id) to: temp;
				add 'Team' + int(team_id) to: temp2;
				
				loop i from:0 to:length(n_tree) - 1{
					add container(seeds[key_player])[i] to: temp;
					add container(alien_seeds[key_player])[i] to: temp2;
				}
				
				if self.name = string("Player_10" + min_team_id){
					save temp to: "../results/total_seeds.csv" header:false format:"csv" rewrite:true;
					save temp to: "../results_backup/total_seeds.csv" header:false format:"csv" rewrite:true;
					save temp to: "../results_backup_with_date/total_seeds_" + today + ".csv" header:false format:"csv" rewrite:true;
				}
				else{
					save temp to: "../results/total_seeds.csv" header:false format:"csv" rewrite:false;
					save temp to: "../results_backup/total_seeds.csv" header:false format:"csv" rewrite:false;
					save temp to: "../results_backup_with_date/total_seeds_" + today + ".csv" header:false format:"csv" rewrite:false;
				}
				
				if self.name = string("Player_10" + min_team_id){
					save temp2 to: "../results/total_alien_seeds.csv" header:false format:"csv" rewrite:true;
					save temp2 to: "../results_backup/total_alien_seeds.csv" header:false format:"csv" rewrite:true;
					save temp2 to: "../results_backup_with_date/total_alien_seeds_" + today + ".csv" header:false format:"csv" rewrite:true;
				}
				else{
					save temp2 to: "../results/total_alien_seeds.csv" header:false format:"csv" rewrite:false;
					save temp2 to: "../results_backup/total_alien_seeds.csv" header:false format:"csv" rewrite:false;
					save temp2 to: "../results_backup_with_date/total_alien_seeds_" + today + ".csv" header:false format:"csv" rewrite:false;
				}
			}
			//write string("Save data for Player_10" + j + " Completed!");
		}
	}
	action resend_command_to_unity (string player_name_ID){
		int player_ID <- -1;
		loop i from:0 to:length(unity_player) - 1{
			ask unity_player[i] {
				if self.name = player_name_ID{
					player_ID <- i;
					//write "Found " + player_name_ID + " ID= " + player_ID ;
				}
			}
		}
		if player_ID < 0{
			//write "Now Found ID " + player_name_ID + " ID= " + player_ID ;
		}
		
		if not empty(unity_player) and player_ID >= 0{
			if not tutorial_finish{
				ask unity_linker {
					do send_message players: unity_player[player_ID] as list mes: ["Head"::"Tutorial", "Body"::""];
					write "Resend command for Player: " + unity_player.name + " to Tutorial";
				}
				ask unity_player[player_ID]{
					location <- {180, 120, 0} + {0, 0, 3};
					ask unity_linker {
						new_player_position[myself.name] <- [myself.location.x *precision,myself.location.y *precision,myself.location.z *precision];
						move_player_event <- true;
					}
				}
			}
			else {
//				if skip_tutorial{
//					ask unity_linker {
//						do send_message players: unity_player[player_ID] as list mes: ["Head"::"Tutorial", "Body"::""];
//						write "Resend command for Player: " + unity_player.name + " to Tutorial";
//					}
//				}
				
				ask unity_player[player_ID]{
//					location <- any_location_in(road_midpoint[map_zone[count_start-1]] - adjust_location) + {0, 0, 3};
//					location <- road_midpoint[map_zone[count_start-1]].location + 
//						{rnd(-adjust_location,adjust_location), rnd(-adjust_location,adjust_location), 3};
					location <- any_location_in(road_midpoint[map_zone[count_start-1]] inter 
						zone_for_player_warp[count_start-1].shape);
					
					ask unity_linker {
						new_player_position[myself.name] <- [myself.location.x *precision,myself.location.y *precision,myself.location.z *precision];
						move_player_event <- true;
					}
				}
		
				ask unity_linker {
					do send_message players: unity_player[player_ID] as list mes: ["Head"::"Start", "Body"::""];
					write "Resend command for Player: " + unity_player.name + " to Trial zone " + count_start;
				}
			}	
		}	
	}
	
	action resume_game {	
		if not tutorial_finish{
			ask unity_linker {
				do send_message players: unity_player as list mes: ["Head"::"Tutorial", "Body"::""];
				write "send Tutorial";
			}
			ask unity_player{
				location <- {180, 120, 0} + {0, 0, 3};
				ask unity_linker {
					new_player_position[myself.name] <- [myself.location.x *precision,myself.location.y *precision,myself.location.z *precision];
					move_player_event <- true;
				}
			}
			
			if skip_tutorial{
				do pause;
				can_start <- true;
				tutorial_finish <- true;
			}
		}
		else {
			if skip_tutorial{
				ask unity_linker {
					do send_message players: unity_player as list mes: ["Head"::"Tutorial", "Body"::""];
					write "send Tutorial";
				}
			}
			
			ask unity_player{
//				location <- any_location_in(road_midpoint[map_zone[count_start-1]] - adjust_location) + {0, 0, 3};
//				location <- road_midpoint[map_zone[count_start-1]].location + 
//						{rnd(-adjust_location,adjust_location), rnd(-adjust_location,adjust_location), 3};
				location <- any_location_in(road_midpoint[map_zone[count_start-1]] inter 
						zone_for_player_warp[count_start-1].shape);
						
				ask unity_linker {
					new_player_position[myself.name] <- [myself.location.x *precision,myself.location.y *precision,myself.location.z *precision];
					move_player_event <- true;
				}
			}
			
			ask unity_linker {
				do send_message players: unity_player as list mes: ["Head"::"Start", "Body"::""];
				write "send Start";
			}
		}
	}
	action pause_game {
		if tutorial_finish{
			ask unity_linker {
				do send_message players: unity_player as list mes: ["Head"::"Stop", "Body"::""];
				//write "send Stop";

			}
		}
		
//		if not skip_tutorial{
//			tutorial_finish <- false;
//		}
		tutorial_finish <- false;
		player_id_finish_tutorial_list <- [];
		who_finish_tutorial <- [false,false,false,false,false,false];
	}
	
	reflex update_connection{
		who_connect <- [false,false,false,false,false,false];
		ask unity_player{
			who_connect[team_id-1] <- true;
		}
	}
	
	reflex update_player_zone when: not paused and tutorial_finish and not empty(unity_player){

		player_walk_in_zone <- [false,false,false,false,false,false];
		ask unity_player {
			if self.shape overlaps (zone[count_start-1].shape +1){
				player_walk_in_zone[team_id-1] <- true;
			}
		} 
		

	}
}

species unity_linker parent: abstract_unity_linker {
	string player_species <- string(unity_player);
	int num_players <- n_team;
	int max_num_players  <- -1;
	int min_num_players  <- 7;
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
	
//	unity_property up_player_1;
//	unity_property up_player_2;
//	unity_property up_player_3;
//	unity_property up_player_4;
//	unity_property up_player_5;
//	unity_property up_player_6;
	
	
	action tutorial_finish(string player_ID, string tutorial_status){		
		if not (player_ID in player_id_finish_tutorial_list){
			add player_ID to: player_id_finish_tutorial_list;
		}
		
		//write "Player " + player_ID + " (Team: " + map_player_id[player_ID] + ") finished tutorial.";
		who_finish_tutorial[map_player_id[player_ID]-1] <- true;
		
		if length(player_id_finish_tutorial_list) >= length(unity_player){
			//write "Tutorial Finish!!!!";
			ask world{
				ask sign{
					self.icon <- play;
					//write "do_pause Tutorial (Change Icon!)";
				}
				loop i from:0 to:length(map_player_id)-1{
					if who_connect[i]{
						ask player_status[i]{
							status_icon <- correct_image;
						}
					}
				}
				
				do pause;
				can_start <- true;
			}
			tutorial_finish <- true;
		}
	}
	
	action collect_seeds(string player_ID, string tree_ID){
		//write "Player " + player_ID + " collect: " + tree_ID;
		int key_player <- map_player_id[player_ID]-1;
		int key_tree <- int(tree_ID);
		
		if key_tree < 0{
			if (key_tree <= -2) and (key_tree >= -9){
				key_tree <- key_tree + 1;
			}
			else if (key_tree <= -11) and (key_tree >= -12){
				key_tree <- key_tree + 2;
			}
		}
		else{
			if (key_tree >= 2) and (key_tree <= 9){
				key_tree <- key_tree - 1;
			}
			else if (key_tree >= 11) and (key_tree <= 12){
				key_tree <- key_tree - 2;
			}
		}
		
		//write "TreeID: " + tree_ID;
		//write "Key Tree: " + key_tree;
		//write "abs Key Tree: " + abs(key_tree);
		
		if key_tree < 0{
			int temp <- int(container(alien_seeds[key_player])[abs(key_tree) - 1]);
			//write "Alien before" + container(alien_seeds[key_player])[abs(key_tree) - 1];
			container(alien_seeds[key_player])[abs(key_tree) - 1] <- int(temp + 1);
			//write "Alien after" + container(alien_seeds[key_player])[abs(key_tree) - 1];
		}
		else{
			int temp <- int(container(seeds[key_player])[key_tree - 1]);
			//write "Normal before" + container(seeds[key_player])[key_tree - 1];
			container(seeds[key_player])[key_tree - 1] <- int(temp + 1);
			//write "Normal after" + container(seeds[key_player])[key_tree - 1];
		}
	}

	list<point> init_locations <- define_init_locations();

	list<point> define_init_locations {
		list<point> init_pos;
		loop times: num_players {
			init_pos << {180, 120, 0} + {0, 0, 3};
			//write "init_pos " + init_pos;
		}
		return init_pos;
	}

	init {
		do define_properties;
//		player_unity_properties <- [up_player_1, up_player_2, up_player_3, up_player_4, up_player_5, up_player_6];

//		do add_background_geometries(road collect (each.geom_visu), up_road);
//		do add_background_geometries(island, up_island);
		
	}
	
	action define_properties {
		
		unity_aspect tree_aspect_1a <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/QuercusTreeAlll_NoFruit",1.0,0.05,1.0,0.5, precision);
		up_tree_1a <- geometry_properties("tree_1_a","tree",tree_aspect_1a,#no_interaction,false);
		unity_properties << up_tree_1a;
		
		unity_aspect tree_aspect_1b <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/QuercusTreeAll",1.0,0.05,1.0,0.5, precision);
		up_tree_1b <- geometry_properties("tree_1_b","tree",tree_aspect_1b,#no_interaction,false);
		unity_properties << up_tree_1b;
		
		unity_aspect tree_aspect_2a <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/SapindusTreeAll_NoFruit",1.0,0.05,1.0,0.5, precision);
		up_tree_2a <- geometry_properties("tree_2_a","tree",tree_aspect_2a,#no_interaction,false);
		unity_properties << up_tree_2a;
		
		unity_aspect tree_aspect_2b <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/SapindusTreeAll",1.0,0.05,1.0,0.5, precision);
		up_tree_2b <- geometry_properties("tree_2_b","tree",tree_aspect_2b,#no_interaction,false);
		unity_properties << up_tree_2b; 
		
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
		up_tree_6a <- geometry_properties("tree_6_a","tree",tree_aspect_6a,#no_interaction,false);
		unity_properties << up_tree_6a;
		
		unity_aspect tree_aspect_6b <- prefab_aspect("temp/Prefab/Tree/AdjustableTree/DiospyrosTreeAll",1.0,0.05,1.0,0.5, precision);
		up_tree_6b <- geometry_properties("tree_6_b","tree",tree_aspect_6b,#no_interaction,false);
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
		
		unity_aspect alien_tree_aspect_8 <- prefab_aspect("temp/Prefab/Tree/Alien/PhyllanAlienTreeAll",1.0,0.05,1.0,0.5, precision);
		up_alien_tree_8 <- geometry_properties("alien_tree_8","tree",alien_tree_aspect_8,#no_interaction,false);
		unity_properties << up_alien_tree_8;
		
		
		
		unity_aspect road_aspect <- geometry_aspect(0.0,#gray,precision);
		up_road <- geometry_properties("road","road",road_aspect,#no_interaction,false);
		unity_properties << up_road;
		
		unity_aspect island_aspect <- geometry_aspect(0.0,#gray,precision);
		up_island <- geometry_properties("island","",road_aspect,#no_interaction,false);
		unity_properties << up_island;


		
//		unity_aspect player_aspect_1 <- prefab_aspect("temp/Prefab/Character/PlayerPrefab1",1.00,0.0,-1.0,90.0,precision);
//		up_player_1 <- geometry_properties("player1","",player_aspect_1,new_geometry_interaction(true, false,false,[]),false);
//		unity_properties << up_player_1;
//		
//		unity_aspect player_aspect_2 <- prefab_aspect("temp/Prefab/Character/PlayerPrefab2",1.00,0.0,-1.0,90.0,precision);
//		up_player_2 <- geometry_properties("player2","",player_aspect_2,new_geometry_interaction(true, false,false,[]),false);
//		unity_properties << up_player_2; 
//		
//		unity_aspect player_aspect_3 <- prefab_aspect("temp/Prefab/Character/PlayerPrefab3",1.00,0.0,-1.0,90.0,precision);
//		up_player_3 <- geometry_properties("player3","",player_aspect_3,new_geometry_interaction(true, false,false,[]),false);
//		unity_properties << up_player_3; 
//		
//		unity_aspect player_aspect_4 <- prefab_aspect("temp/Prefab/Character/PlayerPrefab4",1.00,0.0,-1.0,90.0,precision);
//		up_player_4 <- geometry_properties("player4","",player_aspect_4,new_geometry_interaction(true, false,false,[]),false);
//		unity_properties << up_player_4; 
//		
//		unity_aspect player_aspect_5 <- prefab_aspect("temp/Prefab/Character/PlayerPrefab5",1.00,0.0,-1.0,90.0,precision);
//		up_player_5 <- geometry_properties("player5","",player_aspect_5,new_geometry_interaction(true, false,false,[]),false);
//		unity_properties << up_player_5; 
//		
//		unity_aspect player_aspect_6 <- prefab_aspect("temp/Prefab/Character/PlayerPrefab6",1.00,0.0,-1.0,90.0,precision);
//		up_player_6 <- geometry_properties("player6","",player_aspect_6,new_geometry_interaction(true, false,false,[]),false);
//		unity_properties << up_player_6; 
	}
	
	reflex send_geometries {
//		do add_geometries_to_send(tree,up_tree_1a);
		list<tree> t1 <- tree where ((each.tree_type = 1) and (each.it_state = 1));
		list<tree> t1f <- tree where ((each.tree_type = 1) and (each.it_state = 2) and (each.it_alien = false));
		list<tree> t1a <- tree where ((each.tree_type = 1) and (each.it_state = 2) and (each.it_alien = true));
//		write "t1 " + t1;
//		write "t1f " + t1f;
//		write "t1a " + t1a;
		if not empty(t1){
			do add_geometries_to_send(t1,up_tree_1a);
//			write "send t1";
		}
		if not empty(t1f){
			do add_geometries_to_send(t1f,up_tree_1b);
//			write "send t1f";
		}
		if not empty(t1a){
			do add_geometries_to_send(t1a,up_alien_tree_1);
//			write "send t1a";
		}	
 
		list<tree> t2 <- tree where ((each.tree_type = 2) and (each.it_state = 1));
		list<tree> t2f <- tree where ((each.tree_type = 2) and (each.it_state = 2) and (each.it_alien = false));
		list<tree> t2a <- tree where ((each.tree_type = 2) and (each.it_state = 2) and (each.it_alien = true));
		if not empty(t2){
			do add_geometries_to_send(t2,up_tree_2a);
//			write "send t2";
		}
		if not empty(t2f){
			do add_geometries_to_send(t2f,up_tree_2b);
//			write "send t2f";
		}
		if not empty(t2a){
			do add_geometries_to_send(t2a,up_alien_tree_2);
//			write "send t2a";
		}	
 
		list<tree> t3 <- tree where ((each.tree_type = 3) and (each.it_state = 1));
		list<tree> t3f <- tree where ((each.tree_type = 3) and (each.it_state = 2) and (each.it_alien = false));
		if not empty(t3){
			do add_geometries_to_send(t3,up_tree_3a);
//			write "send t3";
		}
		if not empty(t3f){
			do add_geometries_to_send(t3f,up_tree_3b);
//			write "send t3f";
		}
 
		list<tree> t4 <- tree where ((each.tree_type = 4) and (each.it_state = 1));
		list<tree> t4f <- tree where ((each.tree_type = 4) and (each.it_state = 2) and (each.it_alien = false));
		if not empty(t4){
			do add_geometries_to_send(t4,up_tree_4a);
//			write "send t4";
		}
		if not empty(t4f){
			do add_geometries_to_send(t4f,up_tree_4b);
//			write "send t4f";
		}	
 
		list<tree> t5 <- tree where ((each.tree_type = 5) and (each.it_state = 1));
		list<tree> t5f <- tree where ((each.tree_type = 5) and (each.it_state = 2) and (each.it_alien = false));
		if not empty(t5){
			do add_geometries_to_send(t5,up_tree_5a);
//			write "send t5";
		}
		if not empty(t5f){
			do add_geometries_to_send(t5f,up_tree_5b);
//			write "send t5f";
		}	
 
		list<tree> t6 <- tree where ((each.tree_type = 6) and (each.it_state = 1));
		list<tree> t6f <- tree where ((each.tree_type = 6) and (each.it_state = 2) and (each.it_alien = false));
		if not empty(t6){
			do add_geometries_to_send(t6,up_tree_6a);
//			write "send t6";
		}
		if not empty(t6f){
			do add_geometries_to_send(t6f,up_tree_6b);
//			write "send t6f";
		}
 
		list<tree> t7 <- tree where ((each.tree_type = 7) and (each.it_state = 1));
		list<tree> t7f <- tree where ((each.tree_type = 7) and (each.it_state = 2) and (each.it_alien = false));
		if not empty(t7){
			do add_geometries_to_send(t7,up_tree_7a);
//			write "send t7";
		}
		if not empty(t7f){
			do add_geometries_to_send(t7f,up_tree_7b);
//			write "send t7f";
		}
 
		list<tree> t8 <- tree where ((each.tree_type = 8) and (each.it_state = 1));
		list<tree> t8f <- tree where ((each.tree_type = 8) and (each.it_state = 2) and (each.it_alien = false));
		list<tree> t8a <- tree where ((each.tree_type = 8) and (each.it_state = 2) and (each.it_alien = true));
		if not empty(t8){
			do add_geometries_to_send(t8,up_tree_8a);
//			write "send t8";
		}
		if not empty(t8f){
			do add_geometries_to_send(t8f,up_tree_8b);
//			write "send t8f";
		}
		if not empty(t8a){
			do add_geometries_to_send(t8a,up_alien_tree_8);
//			write "send t8a";
		}	
 
		list<tree> t9 <- tree where ((each.tree_type = 9) and (each.it_state = 1));
		list<tree> t9f <- tree where ((each.tree_type = 9) and (each.it_state = 2) and (each.it_alien = false));
		if not empty(t9){
			do add_geometries_to_send(t9,up_tree_9a);
//			write "send t9";
		}
		if not empty(t9f){
			do add_geometries_to_send(t9f,up_tree_9b);
//			write "send t9f";
		}
 
		list<tree> t10 <- tree where ((each.tree_type = 10) and (each.it_state = 1));
		list<tree> t10f <- tree where ((each.tree_type = 10) and (each.it_state = 2) and (each.it_alien = false));
		if not empty(t10){
			do add_geometries_to_send(t10,up_tree_10a);
//			write "send t10";
		}
		if not empty(t10f){
			do add_geometries_to_send(t10f,up_tree_10b);
//			write "send t10f";
		}
	}
}

species unity_player parent: abstract_unity_player{
	float player_size <- 20.0;
	rgb color ; //<- player_colors[team_id-1];
	float cone_distance <- 50.0;
	float cone_amplitude <- 90.0;
	float player_rotation <- 90.0;
	bool to_display <- true;
	float z_offset <- 2.0;
	
	int team_id ;
	
	init{
		// Use m2l2 colors
		if (map_player_id_m2l2.keys contains name){
			if (map_player_id[name] != nil){
				team_id <- map_player_id_m2l2[name];
				// Move already existing player to end of index
				ask first(unity_player where (each.name = name)) {
					team_id <- length(map_player_id)+1;	
					map_player_id[name] <- team_id;
					color <- rgb(player_colors[team_id-1]);
				}
			} else {
				team_id <- map_player_id_m2l2[name];
			}
		// Other Player_IP set, put colors at random
		} else {
			team_id <- length(map_player_id)+1;//map_player_id[name];	
		}
		map_player_id[name] <- team_id;

		color <- rgb(player_colors[team_id-1]);
	}
	
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
	float minimum_cycle_duration <- 0.10;
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
	
	float minimum_cycle_duration <- 0.10;
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
