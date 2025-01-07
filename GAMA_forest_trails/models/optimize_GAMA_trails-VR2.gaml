model optimizeGAMAtrails_model_VR

import "optimize_GAMA_trails2.gaml"

global {	
	action save_total_seeds_to_csv{
		list header <- [];
		loop i from:0 to:length(n_tree) - 1{
			add 'Type' + (i+1) to: header;
		}
		ask unity_player{
			int key_player <- team_id-1;
			list temp <- [];
			list temp2 <- [];
			
			add 'Team' + int(key_player + 1) to: temp;
			add 'Team' + int(key_player + 1) to: temp2;
			
			loop i from:0 to:length(n_tree) - 1{
				if not (i=0 or i=9){
					add container(seeds[key_player])[i] to: temp;
					add container(alien_seeds[key_player])[i] to: temp2;
				}
			}
			
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
			}
			ask unity_player{
				location <- {180, 120, 0};
				ask unity_linker {
					new_player_position[myself.name] <- [myself.location.x *precision,myself.location.y *precision,myself.location.z *precision];
					move_player_event <- true;
				}
			}
		}
		else {
			ask unity_player{
				location <- any_location_in(road_midpoint[map_zone[count_start-1]] - 3) + {0, 0, 0};
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
				write "send Stop";

			}
		}
			
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
	
	unity_property up_player_1;
	unity_property up_player_2;
	unity_property up_player_3;
	unity_property up_player_4;
	unity_property up_player_5;
	unity_property up_player_6;
	
	
	action tutorial_finish(string player_ID, string tutorial_status){		
		if not (player_ID in player_id_finish_tutorial_list){
			add player_ID to: player_id_finish_tutorial_list;
		}
		
		write "Player " + player_ID + " (Team: " + map_player_id[player_ID] + ") finished tutorial.";
		who_finish_tutorial[map_player_id[player_ID]-1] <- true;
		
		if length(player_id_finish_tutorial_list) >= length(unity_player){
			write "Tutorial Finish!!!!";
			ask world{
				ask sign{
					self.icon <- play;
				}
				do pause;
				can_start <- true;
			}
			tutorial_finish <- true;
		}
	}
	
	action collect_seeds(string player_ID, string tree_ID){
		write "Player " + player_ID + " collect: " + tree_ID;
		int key_player <- map_player_id[player_ID]-1;
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

	list<point> init_locations <- define_init_locations();

	list<point> define_init_locations {
		list<point> init_pos;
		loop times: num_players {
			init_pos << {180, 120, 0};
			write "init_pos " + init_pos;
		}
		return init_pos;
	}

	init {
		do define_properties;
		player_unity_properties <- [up_player_1, up_player_2, up_player_3, up_player_4, up_player_5, up_player_6];
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


		
		unity_aspect player_aspect_1 <- prefab_aspect("temp/Prefab/Character/PlayerPrefab1",0.82,0.0,-1.0,90.0,precision);
		up_player_1 <- geometry_properties("player1","",player_aspect_1,new_geometry_interaction(true, false,false,[]),false);
		unity_properties << up_player_1;
		
		unity_aspect player_aspect_2 <- prefab_aspect("temp/Prefab/Character/PlayerPrefab2",0.82,0.0,-1.0,90.0,precision);
		up_player_2 <- geometry_properties("player2","",player_aspect_2,new_geometry_interaction(true, false,false,[]),false);
		unity_properties << up_player_2; 
		
		unity_aspect player_aspect_3 <- prefab_aspect("temp/Prefab/Character/PlayerPrefab3",0.82,0.0,-1.0,90.0,precision);
		up_player_3 <- geometry_properties("player3","",player_aspect_3,new_geometry_interaction(true, false,false,[]),false);
		unity_properties << up_player_3; 
		
		unity_aspect player_aspect_4 <- prefab_aspect("temp/Prefab/Character/PlayerPrefab4",0.82,0.0,-1.0,90.0,precision);
		up_player_4 <- geometry_properties("player4","",player_aspect_4,new_geometry_interaction(true, false,false,[]),false);
		unity_properties << up_player_4; 
		
		unity_aspect player_aspect_5 <- prefab_aspect("temp/Prefab/Character/PlayerPrefab5",0.82,0.0,-1.0,90.0,precision);
		up_player_5 <- geometry_properties("player5","",player_aspect_5,new_geometry_interaction(true, false,false,[]),false);
		unity_properties << up_player_5; 
		
		unity_aspect player_aspect_6 <- prefab_aspect("temp/Prefab/Character/PlayerPrefab6",0.82,0.0,-1.0,90.0,precision);
		up_player_6 <- geometry_properties("player6","",player_aspect_6,new_geometry_interaction(true, false,false,[]),false);
		unity_properties << up_player_6; 
	}
	
	reflex send_geometries {
		list<tree> t1 <- tree where ((each.tree_type = 2) and (each.it_state <=3));
		list<tree> t1f <- tree where ((each.tree_type = 2) and (each.it_state = 4) and (each.it_alien = false));
		list<tree> t1a <- tree where ((each.tree_type = 2) and (each.it_state = 4) and (each.it_alien = true));
		if not empty(t1){
			do add_geometries_to_send(t1,up_tree_1a);
		}
		if not empty(t1f){
			do add_geometries_to_send(t1f,up_tree_1b);
		}
		if not empty(t1a){
			do add_geometries_to_send(t1a,up_alien_tree_1);
		}	
 
		list<tree> t2 <- tree where ((each.tree_type = 3) and (each.it_state <=3));
		list<tree> t2f <- tree where ((each.tree_type = 3) and (each.it_state = 4) and (each.it_alien = false));
		list<tree> t2a <- tree where ((each.tree_type = 3) and (each.it_state = 4) and (each.it_alien = true));
		if not empty(t2){
			do add_geometries_to_send(t2,up_tree_2a);
		}
		if not empty(t2f){
			do add_geometries_to_send(t2f,up_tree_2b);
		}
		if not empty(t2a){
			do add_geometries_to_send(t2a,up_alien_tree_2);
		}	
 
		list<tree> t3 <- tree where ((each.tree_type = 4) and (each.it_state <=3));
		list<tree> t3f <- tree where ((each.tree_type = 4) and (each.it_state = 4) and (each.it_alien = false));
		list<tree> t3a <- tree where ((each.tree_type = 4) and (each.it_state = 4) and (each.it_alien = true));
		if not empty(t3){
			do add_geometries_to_send(t3,up_tree_3a);
		}
		if not empty(t3f){
			do add_geometries_to_send(t3f,up_tree_3b);
		}
		if not empty(t3a){
			do add_geometries_to_send(t3a,up_alien_tree_8);
		}	
 
		list<tree> t4 <- tree where ((each.tree_type = 5) and (each.it_state <=3));
		list<tree> t4f <- tree where ((each.tree_type = 5) and (each.it_state = 4) and (each.it_alien = false));
		list<tree> t4a <- tree where ((each.tree_type = 5) and (each.it_state = 4) and (each.it_alien = true));
		if not empty(t4){
			do add_geometries_to_send(t4,up_tree_4a);
		}
		if not empty(t4f){
			do add_geometries_to_send(t4f,up_tree_4b);
		}
		if not empty(t4a){
			do add_geometries_to_send(t4a,up_alien_tree_8);
		}	
 
		list<tree> t5 <- tree where ((each.tree_type = 6) and (each.it_state <=3));
		list<tree> t5f <- tree where ((each.tree_type = 6) and (each.it_state = 4) and (each.it_alien = false));
		list<tree> t5a <- tree where ((each.tree_type = 6) and (each.it_state = 4) and (each.it_alien = true));
		if not empty(t5){
			do add_geometries_to_send(t5,up_tree_5a);
		}
		if not empty(t5f){
			do add_geometries_to_send(t5f,up_tree_5b);
		}
		if not empty(t5a){
			do add_geometries_to_send(t5a,up_alien_tree_8);
		}	
 
		list<tree> t6 <- tree where ((each.tree_type = 7) and (each.it_state <=3));
		list<tree> t6f <- tree where ((each.tree_type = 7) and (each.it_state = 4) and (each.it_alien = false));
		list<tree> t6a <- tree where ((each.tree_type = 7) and (each.it_state = 4) and (each.it_alien = true));
		if not empty(t6){
			do add_geometries_to_send(t6,up_tree_6a);
		}
		if not empty(t6f){
			do add_geometries_to_send(t6f,up_tree_6b);
		}
		if not empty(t6a){
			do add_geometries_to_send(t6a,up_alien_tree_8);
		}	
 
		list<tree> t7 <- tree where ((each.tree_type = 8) and (each.it_state <=3));
		list<tree> t7f <- tree where ((each.tree_type = 8) and (each.it_state = 4) and (each.it_alien = false));
		list<tree> t7a <- tree where ((each.tree_type = 8) and (each.it_state = 4) and (each.it_alien = true));
		if not empty(t7){
			do add_geometries_to_send(t7,up_tree_7a);
		}
		if not empty(t7f){
			do add_geometries_to_send(t7f,up_tree_7b);
		}
		if not empty(t7a){
			do add_geometries_to_send(t7a,up_alien_tree_8);
		}	
 
		list<tree> t8 <- tree where ((each.tree_type = 9) and (each.it_state <=3));
		list<tree> t8f <- tree where ((each.tree_type = 9) and (each.it_state = 4) and (each.it_alien = false));
		list<tree> t8a <- tree where ((each.tree_type = 9) and (each.it_state = 4) and (each.it_alien = true));
		if not empty(t8){
			do add_geometries_to_send(t8,up_tree_8a);
		}
		if not empty(t8f){
			do add_geometries_to_send(t8f,up_tree_8b);
		}
		if not empty(t8a){
			do add_geometries_to_send(t8a,up_alien_tree_8);
		}	
 
		list<tree> t9 <- tree where ((each.tree_type = 11) and (each.it_state <=3));
		list<tree> t9f <- tree where ((each.tree_type = 11) and (each.it_state = 4) and (each.it_alien = false));
		list<tree> t9a <- tree where ((each.tree_type = 11) and (each.it_state = 4) and (each.it_alien = true));
		if not empty(t9){
			do add_geometries_to_send(t9,up_tree_9a);
		}
		if not empty(t9f){
			do add_geometries_to_send(t9f,up_tree_9b);
		}
		if not empty(t9a){
			do add_geometries_to_send(t9a,up_alien_tree_8);
		}	
 
		list<tree> t10 <- tree where ((each.tree_type = 12) and (each.it_state <=3));
		list<tree> t10f <- tree where ((each.tree_type = 12) and (each.it_state = 4) and (each.it_alien = false));
		list<tree> t10a <- tree where ((each.tree_type = 12) and (each.it_state = 4) and (each.it_alien = true));
		if not empty(t10){
			do add_geometries_to_send(t10,up_tree_10a);
		}
		if not empty(t10f){
			do add_geometries_to_send(t10f,up_tree_10b);
		}
		if not empty(t10a){
			do add_geometries_to_send(t10a,up_alien_tree_8);
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
		team_id <- map_player_id[name];
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
	float minimum_cycle_duration <- 0.30;
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

