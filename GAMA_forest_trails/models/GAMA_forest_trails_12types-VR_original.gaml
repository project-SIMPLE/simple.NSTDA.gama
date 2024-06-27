model GAMA_forest_trails_model_VR

import "GAMA_forest_trails_12types.gaml"

species unity_linker parent: abstract_unity_linker {
	string player_species <- string(unity_player); //player
	int max_num_players  <- -1;
	int min_num_players  <- 1;
	unity_property up_road;
	unity_property up_building;
	unity_property up_people;
	list<point> init_locations <- define_init_locations();

	list<point> define_init_locations {
		return [{50.0,400.0,2.0}];
	}


	init {
		do define_properties;
		do add_background_geometries(road collect (each.shape + 2.0),up_road);
	}
	action define_properties {
		unity_aspect road_aspect <- geometry_aspect(1.0,#gray,precision);
		up_road <- geometry_properties("road","road",road_aspect,#ray_interactable,false);
		unity_properties << up_road;


		unity_aspect building_aspect <- prefab_aspect("Prefabs/Visual Prefabs/Character/Tree",2,0.0,1.0,0.0,precision);
		up_building <- geometry_properties("building","",building_aspect,#no_interaction,false);
		unity_properties << up_building;


		unity_aspect people_aspect <- prefab_aspect("Prefabs/Visual Prefabs/Character/Slime",10,0.0,1.0,-180.0,precision);
		up_people <- geometry_properties("people","",people_aspect,#no_interaction,false);
		unity_properties << up_people;


	}
	reflex send_geometries {
		do add_geometries_to_send(tree_type11,up_building);
		do add_geometries_to_send(tree_type10,up_building);
		do add_geometries_to_send(player,up_people);
		do add_geometries_to_send(tree_type12,up_building);
		do add_geometries_to_send(tree_type10,up_building);
		do add_geometries_to_send(tree_type9,up_building);
		do add_geometries_to_send(tree_type8,up_building);
		do add_geometries_to_send(tree_type7,up_building);
		do add_geometries_to_send(tree_type6,up_building);
		do add_geometries_to_send(tree_type5,up_building);
		do add_geometries_to_send(tree_type4,up_building);
		do add_geometries_to_send(tree_type3,up_building);
		do add_geometries_to_send(tree_type2,up_building);
		do add_geometries_to_send(tree_type1,up_building);
	}
}

species unity_player parent: abstract_unity_player{
	float player_size <- 20.0;
	rgb color <- #red;
	float cone_distance <- 10.0 * player_size;
	float cone_amplitude <- 90.0;
	float player_rotation <- 90.0;
	bool to_display <- true;
	aspect default {
		if to_display {
			if selected {
				 draw circle(player_size) at: location + {0, 0, 4.9} color: rgb(#blue, 0.5);
			}
			draw circle(player_size/2.0) at: location + {0, 0, 5} color: color ;
			draw player_perception_cone() color: rgb(color, 0.5);
		}
	}
}

experiment vr_xp parent:forest autorun: false type: unity {
	float minimum_cycle_duration <- 0.1;
	string unity_linker_species <- string(unity_linker);
	list<string> displays_to_hide <- ["Main","Summary","Number of seeds"];
	float t_ref;

	action create_player(string id) {
		ask unity_linker {
			do create_player(id);
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
				 float t <- machine_time;
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
