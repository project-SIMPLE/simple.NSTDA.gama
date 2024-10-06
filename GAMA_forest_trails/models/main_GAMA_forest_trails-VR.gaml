model mainGAMAforesttrails2_model_VR

import "main_GAMA_forest_trails.gaml"

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
	
//	action collect_seeds(string player_ID, string tree_ID){ 
	action collect_seeds(string player_ID, int tree_ID){ 
		write "Player " + player_ID + " collect: " + tree_ID;
		int key_player <- map_player_id[player_ID];
		
		if false{
			int temp <- int(container(alien_seeds[key_player])[tree_ID - 1]);
			container(alien_seeds[key_player])[tree_ID - 1] <- int(temp + 1);
		}
		else{
			int temp <- int(container(seeds[key_player])[tree_ID - 1]);
			container(seeds[key_player])[tree_ID - 1] <- int(temp + 1);
		}
		
//		int key_tree <- map_tree_id[tree_ID];
//		ask tree[key_tree]{
//			if it_alien{
//				int temp <- int(container(alien_seeds[key_player])[key_tree]);
//				container(alien_seeds[key_player])[key_tree] <- int(temp + 1);
//			}
//			else{
//				int temp <- int(container(seeds[key_player])[key_tree]);
//				container(seeds[key_player])[key_tree] <- int(temp + 1);
//			}
//		}
	}
	
	reflex random{
//		if flip(0.1){
//			do collect_seeds(player_id_list[rnd(0, length(player_id_list)-1)], tree_id_list[rnd(0, length(tree_id_list)-1)]);
//		}
		if flip(0.1) and player_id_list{
			do collect_seeds(player_id_list[rnd(0, length(player_id_list)-1)], rnd(1,length(n_tree)));
		}
	}


	list<point> init_locations <- define_init_locations();

	list<point> define_init_locations {
		list<point> init_pos;
		loop times: num_players {
			init_pos << any_location_in(usable_area - 1.5) + {0, 0, 1.5};
		}
		return init_pos;
	}


	init {
		do define_properties;
//		player_unity_properties <- [up_lg, up_turtle, up_slime, up_ghost];
		player_unity_properties <- [up_lg,up_lg,up_lg,up_lg,up_lg,up_lg];
		do add_background_geometries(road collect (each.geom_visu), up_road);
//		do add_background_geometries(offroad, up_offroad);
	}
	
	action define_properties {
		unity_aspect tree_aspect_1a <- prefab_aspect("temp/Prefab/Tree/FicusTree_NoFruit",1.0,0.05,1.0,0.5, precision);
		up_tree_1a <- geometry_properties("tree_1_a","tree",tree_aspect_1a,#no_interaction,false);
		unity_properties << up_tree_1a;
		
		unity_aspect tree_aspect_1b <- prefab_aspect("temp/Prefab/Tree/FicusTree",1.0,0.05,1.0,0.5, precision);
		up_tree_1b <- geometry_properties("tree_1_b","tree",tree_aspect_1b,#no_interaction,false);
		unity_properties << up_tree_1b;
		

		unity_aspect tree_aspect_2a <- prefab_aspect("temp/Prefab/Tree/QuercusTree_Short_NoFruit",1.0,0.05,1.0,0.5, precision);
		up_tree_2a <- geometry_properties("tree_2_a","tree",tree_aspect_2a,#no_interaction,false);
		unity_properties << up_tree_2a;
		
		unity_aspect tree_aspect_2b <- prefab_aspect("temp/Prefab/Tree/QuercusTree_Short",1.0,0.05,1.0,0.5, precision);
		up_tree_2b <- geometry_properties("tree_2_b","tree",tree_aspect_2b,#no_interaction,false);
		unity_properties << up_tree_2b;
		
		unity_aspect tree_aspect_3a <- prefab_aspect("temp/Prefab/Tree/SapindusTree_Short_NoFruit",1.0,0.05,1.0,0.5, precision);
		up_tree_3a <- geometry_properties("tree_3_a","tree",tree_aspect_3a,#no_interaction,false);
		unity_properties << up_tree_3a;

		
		unity_aspect tree_aspect_3b <- prefab_aspect("temp/Prefab/Tree/SapindusTree_Short",1.0,0.05,1.0,0.5, precision);
		up_tree_3b <- geometry_properties("tree_3_b","tree",tree_aspect_3b,#no_interaction,false);
		unity_properties << up_tree_3b;
		

		
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
