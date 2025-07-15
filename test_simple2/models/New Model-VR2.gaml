model NewModel_model_VR

import "New Model.gaml"

global {
//	action resume_game {
//		write "send Start";
//		if not empty(unity_player){
//			ask unity_linker {
//				do send_message players: unity_player as list mes: ["Head"::"Start", "Body"::"", "Content"::""];
//			}
//		}
//	}
//	
//	action pause_game {
//		write "send Stop";
//		if not empty(unity_player){
//			ask unity_linker {
//				do send_message players: unity_player as list mes: ["Head"::"Stop", "Body"::"", "Content"::""];
//			}
//		}
//	}
//	
//	reflex update_tree_state when:(cycle mod 10=0){
//		list split_tree_ID ;
//		list playerID ;
//		
//		ask p1tree{
//			if flip(0.1){
////				write "before" + self.it_state;
//				it_state <- rnd(0,2);
////				write self.name;
////				write "after" + self.it_state;
//				
//				split_tree_ID <- self.name split_with ('tree', true);
//				playerID <- split_tree_ID[0] split_with ('p', true);
////				write split_tree_ID ;
////				write playerID;
////				write int(playerID[1]) ;
//				if not empty(unity_player){
//					ask unity_linker {
//						do send_message players: unity_player as list mes: ["Head"::"Update", "Body"::myself.name, "Content"::myself.it_state];
//						write "send Update";
//					}
//				}
//			}
//		}
//		
//		ask p2tree{
//			if flip(0.1){
//				it_state <- rnd(0,2);
//				
//				split_tree_ID <- self.name split_with ('tree', true);
//				playerID <- split_tree_ID[0] split_with ('p', true);
//
//				if not empty(unity_player){
//					ask unity_linker {
//						do send_message players: unity_player as list mes: ["Head"::"Update", "Body"::myself.name, "Content"::myself.it_state];
//						write "send Update";
//					}
//				}
//			}
//		}
//		
//		ask p3tree{
//			if flip(0.1){
//				it_state <- rnd(0,2);
//				
//				split_tree_ID <- self.name split_with ('tree', true);
//				playerID <- split_tree_ID[0] split_with ('p', true);
//
//				if not empty(unity_player){
//					ask unity_linker {
//						do send_message players: unity_player as list mes: ["Head"::"Update", "Body"::myself.name, "Content"::myself.it_state];
//						write "send Update";
//					}
//				}
//			}
//		}
//		
//		ask p4tree{
//			if flip(0.1){
//				it_state <- rnd(0,2);
//				
//				split_tree_ID <- self.name split_with ('tree', true);
//				playerID <- split_tree_ID[0] split_with ('p', true);
//
//				if not empty(unity_player){
//					ask unity_linker {
//						do send_message players: unity_player as list mes: ["Head"::"Update", "Body"::myself.name, "Content"::myself.it_state];
//						write "send Update";
//					}
//				}
//			}
//		}
//		
//		ask p5tree{
//			if flip(0.1){
//				it_state <- rnd(0,2);
//				
//				split_tree_ID <- self.name split_with ('tree', true);
//				playerID <- split_tree_ID[0] split_with ('p', true);
//
//				if not empty(unity_player){
//					ask unity_linker {
//						do send_message players: unity_player as list mes: ["Head"::"Update", "Body"::myself.name, "Content"::myself.it_state];
//						write "send Update";
//					}
//				}
//			}
//		}
//		
//		ask p6tree{
//			if flip(0.1){
//				it_state <- rnd(0,2);
//				
//				split_tree_ID <- self.name split_with ('tree', true);
//				playerID <- split_tree_ID[0] split_with ('p', true);
//
//				if not empty(unity_player){
//					ask unity_linker {
//						do send_message players: unity_player as list mes: ["Head"::"Update", "Body"::myself.name, "Content"::myself.it_state];
//						write "send Update";
//					}
//				}
//			}
//		}
//		
//	}
}

species unity_linker parent: abstract_unity_linker {
	string player_species <- string(unity_player);
	int max_num_players  <- 6;
	int min_num_players  <- 6;
	
	unity_property up_t1;
	unity_property up_t2;
	unity_property up_t3;
	unity_property up_t4;
	unity_property up_t5;
	unity_property up_t6;
	
	action ChangeTreeState(string treeID, string state){
		list<string> split_tree_ID_ ;
		list<string> playerID_ ;
		write "ChangeTreeState: " + treeID + " state " + state;
		split_tree_ID_ <- treeID split_with ('tree', true);
		playerID_ <- split_tree_ID_[0] split_with ('p', true);
		

//		switch playerID[1] {
//			match 1 {
//				ask p1tree[int(split_tree_ID[1])]{
//					it_state <- int(state);
//				}
//			}
//			match 2 {
//				ask p2tree[int(split_tree_ID[1])]{
//					it_state <- int(state);
//				}
//			}
//			match 3 {
//				ask p3tree[int(split_tree_ID[1])]{
//					it_state <- int(state);
//				}
//			}
//			match 4 {
//				ask p4tree[int(split_tree_ID[1])]{
//					it_state <- int(state);
//				}
//			}
//			match 5 {
//				ask p5tree[int(split_tree_ID[1])]{
//					it_state <- int(state);
//				}
//			}
//			match 6 {
//				ask p6tree[int(split_tree_ID[1])]{
//					it_state <- int(state);
//				}
//			}
//		}
	}
	
	
	list<point> init_locations <- define_init_locations();

	list<point> define_init_locations {
		return [{50.0,50.0,0.0},{50.0,50.0,0.0},{50.0,50.0,0.0},{50.0,50.0,0.0},{50.0,50.0,0.0},{50.0,50.0,0.0}];
	}


	init {
//		do define_properties;
//		player_unity_properties <- [nil,nil,nil,nil,nil,nil];
	}
	action define_properties {
		unity_aspect tree1 <- prefab_aspect("temp/Prefab/VU2/Seeding",1.0,0.0,1.0,0.0,precision);
		up_t1 <- geometry_properties("tree1","",tree1,new_geometry_interaction(true, false,false,[]),true);
		unity_properties << up_t1;
		
		unity_aspect tree2 <- prefab_aspect("temp/Prefab/VU2/Seeding",1.0,0.05,1.0,0.5, precision);
		up_t2 <- geometry_properties("tree2","tree",tree2,#no_interaction,false);
		unity_properties << up_t2;
		
		unity_aspect tree3 <- prefab_aspect("temp/Prefab/VU2/Seeding",1.0,0.0,1.0,0.0,precision);
		up_t3 <- geometry_properties("tree3","",tree3,new_geometry_interaction(true, false,false,[]),true);
		unity_properties << up_t3;
		
		unity_aspect tree4 <- prefab_aspect("temp/Prefab/VU2/Seeding",1.0,0.05,1.0,0.5, precision);
		up_t4 <- geometry_properties("tree4","tree",tree4,#no_interaction,false);
		unity_properties << up_t4;
		
		unity_aspect tree5 <- prefab_aspect("temp/Prefab/VU2/Seeding",1.0,0.0,1.0,0.0,precision);
		up_t5 <- geometry_properties("tree5","",tree5,new_geometry_interaction(true, false,false,[]),true);
		unity_properties << up_t5;
		
		unity_aspect tree6 <- prefab_aspect("temp/Prefab/VU2/Seeding",1.0,0.05,1.0,0.5, precision);
		up_t6 <- geometry_properties("tree6","tree",tree6,#no_interaction,false);
		unity_properties << up_t6;

	}
	reflex send_geometries {
//		list<tree> t1 <- p1tree where ((each.tree_type = 1) and (each.it_state > 0));
//		write length(t1);
//		do add_geometries_to_send(p1tree,up_t1);
//		do add_geometries_to_send(p2tree,up_t2);
//		do add_geometries_to_send(p3tree,up_t3);
//		do add_geometries_to_send(p4tree,up_t4);
//		do add_geometries_to_send(p5tree,up_t5);
//		do add_geometries_to_send(p6tree,up_t6);
	}
}

species unity_player parent: abstract_unity_player{
	float player_agents_perception_radius <- 10.0;
	float player_size <- 1.0;
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

experiment vr_xp parent:init_exp autorun: false type: unity {
	float minimum_cycle_duration <- 0.1;
	string unity_linker_species <- string(unity_linker);
	list<string> displays_to_hide <- ["Main","Main"];
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
