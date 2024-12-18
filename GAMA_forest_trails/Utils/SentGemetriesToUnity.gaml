/**
* Name: sendGeometriesToUnity
* Author: Patrick Taillandier
* Description: A simple model allow to send geometries to Unity. To be used with the "Load geometries from GAMA"
* Tags: gis, shapefile, unity, geometry, 
*/
model sendGeometriesToUnity

import "../models/optimize_GAMA_trails.gaml"


global {
	unity_property up_tree_1a;
	unity_property up_tree_1b;
	unity_property up_tree_2a;
	unity_property up_tree_2b;
	unity_property up_tree_3a;
	unity_property up_tree_3b;
	unity_property up_road;
	unity_property up_offroad;
	unity_property up_island;

	unity_property up_ghost;
	unity_property up_lg;
	unity_property up_slime;
	unity_property up_turtle;
	


} 



//Species that will make the link between GAMA and Unity. It has to inherit from the built-in species asbtract_unity_linker
species unity_linker parent: abstract_unity_linker {
	//name of the species used to represent a Unity player
	string player_species <- string(unity_player);

	//in this model, no information will be automatically sent to the Player at every step, so we set do_info_world to false
	bool do_send_world <- false;
	
	
	//initial location of the player
	list<point> init_locations <- [world.location];
	
		
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
		
		unity_aspect tree_aspect_2b <- prefab_aspect("temp/Prefab/Tree/QuercusTree_Short_2",1.0,0.05,1.0,0.5, precision);
		up_tree_2b <- geometry_properties("tree_2_b","tree",tree_aspect_2b,#no_interaction,false);
		unity_properties << up_tree_2b; 
		
		unity_aspect tree_aspect_3a <- prefab_aspect("temp/Prefab/Tree/SapindusTree_Short_NoFruit",1.0,0.05,1.0,0.5, precision);
		up_tree_3a <- geometry_properties("tree_3_a","tree",tree_aspect_3a,#no_interaction,false);
		unity_properties << up_tree_3a;

		
		unity_aspect tree_aspect_3b <- prefab_aspect("temp/Prefab/Tree/SapindusTree_Short_2",1.0,0.05,1.0,0.5, precision);
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
		
		unity_aspect island_aspect <- geometry_aspect(0.0,#gray,precision);
//		unity_aspect road_aspect <- prefab_aspect("Prefabs/Visual Prefabs/Nature/PREFABS/grounddd",1.0,0.0,0.0,-180,precision);
//		unity_aspect road_aspect <- prefab_aspect("Prefabs/Visual Prefabs/Character/Ghost",2.0,0.0,-1.0,90.0,precision);
		up_island <- geometry_properties("island","",road_aspect,#no_interaction,false);
		unity_properties << up_island;
		
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
	
	init {
		do define_properties;
//		player_unity_properties <- [up_lg, up_turtle, up_slime, up_ghost];
		player_unity_properties <- [up_lg,up_lg,up_lg,up_lg,up_lg,up_lg];
		do add_background_geometries(road collect (each.geom_visu), up_road);
		do add_background_geometries(island, up_island);
		
		list<tree> t1 <- tree where (each.tree_type = 1);
		if empty(tree where ((each.tree_type = 1) and (each.it_state <=3))){
			do add_background_geometries(t1,up_tree_1a);
		}
		else{
			do add_background_geometries(t1,up_tree_1b);
		}
 
		list<tree> t2 <- tree where (each.tree_type = 2);
		if empty(tree where ((each.tree_type = 2) and (each.it_state <=3))){
			do add_background_geometries(t2,up_tree_2a);
		}
		else{
			do add_background_geometries(t2,up_tree_2b);
		}
 
		list<tree> t3 <- tree where (each.tree_type = 3);
		if empty(tree where ((each.tree_type = 3) and (each.it_state <=3))){
			do add_background_geometries(t3,up_tree_3a);
		}
		else{
			do add_background_geometries(t3,up_tree_3b);
		}
 
		list<tree> t4 <- tree where (each.tree_type = 4);
		if empty(tree where ((each.tree_type = 4) and (each.it_state <=3))){
			do add_background_geometries(t4,up_tree_1a);
		}
		else{
			do add_background_geometries(t4,up_tree_1b);
		}
 
		list<tree> t5 <- tree where (each.tree_type = 5);
		if empty(tree where ((each.tree_type = 5) and (each.it_state <=3))){
			do add_background_geometries(t5,up_tree_2a);
		}
		else{
			do add_background_geometries(t5,up_tree_2b);
		}
 
		list<tree> t6 <- tree where (each.tree_type = 6);
		if empty(tree where ((each.tree_type = 6) and (each.it_state <=3))){
			do add_background_geometries(t6,up_tree_3a);
		}
		else{
			do add_background_geometries(t6,up_tree_3b);
		}
 
		list<tree> t7 <- tree where (each.tree_type = 7);
		if empty(tree where ((each.tree_type = 7) and (each.it_state <=3))){
			do add_background_geometries(t7,up_tree_1a);
		}
		else{
			do add_background_geometries(t7,up_tree_1b);
		}
 
		list<tree> t8 <- tree where (each.tree_type = 8);
		if empty(tree where ((each.tree_type = 8) and (each.it_state <=3))){
			do add_background_geometries(t8,up_tree_2a);
		}
		else{
			do add_background_geometries(t8,up_tree_2b);
		}
 
		list<tree> t9 <- tree where (each.tree_type = 9);
		if empty(tree where ((each.tree_type = 9) and (each.it_state <=3))){
			do add_background_geometries(t9,up_tree_3a);
		}
		else{
			do add_background_geometries(t9,up_tree_3b);
		}
 
		list<tree> t10 <- tree where (each.tree_type = 10);
		if empty(tree where ((each.tree_type = 10) and (each.it_state <=3))){
			do add_background_geometries(t10,up_tree_1a);
		}
		else{
			do add_background_geometries(t10,up_tree_1b);
		}
 
		list<tree> t11 <- tree where (each.tree_type = 11);
		if empty(tree where ((each.tree_type = 11) and (each.it_state <=3))){
			do add_background_geometries(t11,up_tree_2a);
		}
		else{
			do add_background_geometries(t11,up_tree_2b);
		}
 
		list<tree> t12 <- tree where (each.tree_type = 12);
		if empty(tree where ((each.tree_type = 12) and (each.it_state <=3))){
			do add_background_geometries(t12,up_tree_3a);
		}
		else{
			do add_background_geometries(t12,up_tree_3b);
		}
		
//		do add_background_geometries(offroad, up_offroad);
	}
}



//species used to represent an unity player, with the default attributes. It has to inherit from the built-in species asbtract_unity_player
species unity_player parent: abstract_unity_player {
	//size of the player in GAMA
	float player_size <- 1.0;

	//color of the player in GAMA
	rgb color <- #red ;
	
	//vision cone distance in GAMA
	float cone_distance <- 10.0 * player_size;
	
	//vision cone amplitude in GAMA
	float cone_amplitude <- 90.0;

	//rotation to apply from the heading of Unity to GAMA
	float player_rotation <- 90.0;
	
	//display the player
	bool to_display <- true;
	
	
	//default aspect to display the player as a circle with its cone of vision
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

experiment SendGeometriesToUnity parent:init_exp autorun: false type: unity {
	//minimal time between two simulation step
	float minimum_cycle_duration <- 0.05;

	//name of the species used for the unity_linker
	string unity_linker_species <- string(unity_linker);
	
	//allow to hide the "map" display and to only display the displayVR display 
	list<string> displays_to_hide <- ["map"];
	


	//action called by the middleware when a player connects to the simulation
	action create_player(string id) {
		ask unity_linker {
			do create_player(id);
		}
	}

	//action called by the middleware when a plyer is remove from the simulation
	action remove_player(string id_input) {
		if (not empty(unity_player)) {
			ask first(unity_player where (each.name = id_input)) {
				do die;
			}
		}
	}
	
	//variable used to avoid to move too fast the player agent
	float t_ref;

		 
	output { 
		//In addition to the layers in the map display, display the unity_player and let the possibility to the user to move players by clicking on it.
		display displayVR parent: Main  {
			species unity_player;
			
		}
		
	} 
}