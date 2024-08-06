model myexperiment_model_VR

import "experiment.gaml"

species unity_linker parent: abstract_unity_linker {
	string player_species <- string(unity_player);
	int num_players <- 1;
	int max_num_players  <- num_players;
	int min_num_players  <- num_players;
	unity_property up_tree_1;
	unity_property up_tree_2;
	unity_property up_tree_3;
	unity_property up_road;
	list<point> init_locations <- define_init_locations();

	list<point> define_init_locations {
		list<point> init_pos;
		loop times: num_players {
			init_pos << any_location_in(one_of(road));
		}
		return init_pos;
	}


	init {
		do define_properties;
		do add_background_geometries(road, up_road);
	}
	action define_properties {
		unity_aspect tree_aspect_1 <- prefab_aspect("Prefabs/Visual Prefabs/Nature/PREFABS/Plants/SM_Arbre_001",2.0,0,1.0,0.5, precision);
		up_tree_1 <- geometry_properties("tree_1_","tree",tree_aspect_1,#ray_interactable,false);
		unity_properties << up_tree_1;

		unity_aspect tree_aspect_2 <- prefab_aspect("Prefabs/Visual Prefabs/Nature/PREFABS/Plants/SM_Bananier_005",3.0,0,1.0,0.5, precision);
		up_tree_2 <- geometry_properties("tree_2_","tree",tree_aspect_2,#ray_interactable,false);
		unity_properties << up_tree_2;
		
		unity_aspect tree_aspect_3 <- prefab_aspect("Prefabs/Visual Prefabs/Nature/PREFABS/Plants/SM_Coriandre_001",8.0,0,1.0,0.5, precision);
		up_tree_3 <- geometry_properties("tree_3_","tree",tree_aspect_3,#ray_interactable,false);
		unity_properties << up_tree_3;
		

		unity_aspect road_aspect <- geometry_aspect(1.0,#gray,precision);
		up_road <- geometry_properties("road","",road_aspect,#no_interaction,false);
		unity_properties << up_road;

	}
	reflex send_geometries {
//		list<tree> t1a <- tree where (each.tree_type < 3 and each.it_state <=3);
//		list<tree> t1b <- tree where (each.tree_type < 3 and each.it_state =4);
		
		list<tree> t1 <- tree where (each.tree_type <= 2);
		list<tree> t2 <- tree where ((each.tree_type <= 4) and (each.tree_type > 2));
		list<tree> t3 <- tree where (each.tree_type > 4);
		do add_geometries_to_send(t1,up_tree_1);
		do add_geometries_to_send(t2,up_tree_2);
		do add_geometries_to_send(t3,up_tree_3);
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
	
	action move_unity_player{
		point cursor_location <- #user_location;
		if (geometry(cursor_location) overlaps geometry(road)){ //(not paused) and (geometry(cursor_location) overlaps shape)
			ask unity_player[0] {
	    		location <- cursor_location;
	    	}
		}
	}

	action create_player(string id) {
		ask unity_linker {
			do create_player(id);
			
//			do build_invisible_walls(
//				player: last(unity_player), //player to send the information to
//				id: "wall_for_free_area", //id of the walls
//				height: 40.0, //height of the walls
//				wall_width: 1.0, //width ot the walls
//				geoms: [road] //geometries used to defined the walls - the walls will be generated from the countour of these geometries
//			);
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
