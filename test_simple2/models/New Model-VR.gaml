model NewModel_model_VR

import "New Model.gaml"

global {
	init{
//		list<map<string,string>> send_tree_update <- [];
//		ask p1tree{
//			add map<string, string>(["PlayerID"::map_player_id[1], "Name"::self.name, "State"::""]) to:send_tree_update;
//		}
//		ask p2tree{
//			add map<string, string>(["PlayerID"::map_player_id[2], "Name"::self.name, "State"::""]) to:send_tree_update;
//		}
//		ask p3tree{
//			add map<string, string>(["PlayerID"::map_player_id[3], "Name"::self.name, "State"::""]) to:send_tree_update;
//		}
//		ask p4tree{
//			add map<string, string>(["PlayerID"::map_player_id[4], "Name"::self.name, "State"::""]) to:send_tree_update;
//		}
//		ask p5tree{
//			add map<string, string>(["PlayerID"::map_player_id[5], "Name"::self.name, "State"::""]) to:send_tree_update;
//		}
//		ask p6tree{
//			add map<string, string>(["PlayerID"::map_player_id[6], "Name"::self.name, "State"::""]) to:send_tree_update;
//		}
//		write send_tree_update;
//		write "End Init";
//		
//		if not empty(unity_player){
//			ask unity_linker {
//				do send_message players: unity_player as list mes: ["Head"::"ReadID", "Body"::"", "Content"::send_tree_update];
//			}
//		}
//		write "Send ReadID";
	}
	
	reflex send_readID when:cycle=50{
		list<map<string,string>> send_tree_update <- [];
		ask p1tree{
			add map<string, string>(["PlayerID"::map_player_id[1], "Name"::self.name, "State"::""]) to:send_tree_update;
		}
		ask p2tree{
			add map<string, string>(["PlayerID"::map_player_id[2], "Name"::self.name, "State"::""]) to:send_tree_update;
		}
		ask p3tree{
			add map<string, string>(["PlayerID"::map_player_id[3], "Name"::self.name, "State"::""]) to:send_tree_update;
		}
		ask p4tree{
			add map<string, string>(["PlayerID"::map_player_id[4], "Name"::self.name, "State"::""]) to:send_tree_update;
		}
		ask p5tree{
			add map<string, string>(["PlayerID"::map_player_id[5], "Name"::self.name, "State"::""]) to:send_tree_update;
		}
		ask p6tree{
			add map<string, string>(["PlayerID"::map_player_id[6], "Name"::self.name, "State"::""]) to:send_tree_update;
		}
		write send_tree_update;
		write "End First Start";
		
		if not empty(unity_player){
			ask unity_linker {
				do send_message players: unity_player as list mes: ["Head"::"ReadID", "Body"::"", "Content"::send_tree_update];
			}
			write "Send ReadID";
		}
	}
	
	action resume_game {
		write "send Start";
		if not empty(unity_player){
			ask unity_linker {
				do send_message players: unity_player as list mes: ["Head"::"Start", "Body"::"", "Content"::""];
			}
		}
	}
	
	action pause_game {
		write "send Stop";
		if not empty(unity_player){
			ask unity_linker {
				do send_message players: unity_player as list mes: ["Head"::"Stop", "Body"::"", "Content"::""];
			}
		}
	}
	
	reflex update_tree_state when:(cycle mod 100=0) and (cycle !=0) {
		list split_tree_ID ;
		list playerID ;
		
		list<map<string,string>> send_tree_update <- [];
		ask p1tree{
			if it_state = 3{
				it_state <- 0;
			}
			else {
				it_state <- it_state + 1;
			}
			
			split_tree_ID <- self.name split_with ('tree', true);
			playerID <- split_tree_ID[0] split_with ('p', true);
			
			add map<string, string>(["PlayerID"::map_player_id[1], "Name"::self.name, "State"::it_state]) to:send_tree_update;			
		}
		
		ask p2tree{
//			if flip(1.0){
//			it_state <- rnd(0,2);
			if it_state = 3{
				it_state <- 0;
			}
			else {
				it_state <- it_state + 1;
			}
			
			split_tree_ID <- self.name split_with ('tree', true);
			playerID <- split_tree_ID[0] split_with ('p', true);
			
			add map<string, string>(["PlayerID"::map_player_id[2], "Name"::self.name, "State"::it_state]) to:send_tree_update;
		}
		
		ask p3tree{
//			if flip(1.0){
//			it_state <- rnd(0,2);
			if it_state = 3{
				it_state <- 0;
			}
			else {
				it_state <- it_state + 1;
			}
			
			split_tree_ID <- self.name split_with ('tree', true);
			playerID <- split_tree_ID[0] split_with ('p', true);
			
			add map<string, string>(["PlayerID"::map_player_id[3], "Name"::self.name, "State"::it_state]) to:send_tree_update;
		}
		
		ask p4tree{
//			if flip(1.0){
//			it_state <- rnd(0,2);
			if it_state = 3{
				it_state <- 0;
			}
			else {
				it_state <- it_state + 1;
			}
			
			split_tree_ID <- self.name split_with ('tree', true);
			playerID <- split_tree_ID[0] split_with ('p', true);
			
			add map<string, string>(["PlayerID"::map_player_id[4], "Name"::self.name, "State"::it_state]) to:send_tree_update;
		}
		
		ask p5tree{
//			if flip(1.0){
//			it_state <- rnd(0,2);
			if it_state = 3{
				it_state <- 0;
			}
			else {
				it_state <- it_state + 1;
			}
			
			split_tree_ID <- self.name split_with ('tree', true);
			playerID <- split_tree_ID[0] split_with ('p', true);
			
			add map<string, string>(["PlayerID"::map_player_id[5], "Name"::self.name, "State"::it_state]) to:send_tree_update;
		}
		
		ask p6tree{
//			if flip(1.0){
//			it_state <- rnd(0,2);
			if it_state = 3{
				it_state <- 0;
			}
			else {
				it_state <- it_state + 1;
			}
			
			split_tree_ID <- self.name split_with ('tree', true);
			playerID <- split_tree_ID[0] split_with ('p', true);
			
			add map<string, string>(["PlayerID"::map_player_id[6], "Name"::self.name, "State"::it_state]) to:send_tree_update;
		}
		
//		if flip(0.5){
//			if not empty(unity_player){
//				ask unity_linker {
//					do send_message players: unity_player as list mes: ["Head"::"Stop", "Body"::"", "Content"::""];
//				}
//			}
//		}
		write send_tree_update;
		write length(send_tree_update);

		if not empty(unity_player){
			ask unity_linker {
				do send_message players: unity_player as list mes: ["Head"::"Update", "Body"::"", "Content"::send_tree_update];
				write "send Update" + p1tree.name;
			}
		}

		send_tree_update <- [];
	}
}

species unity_linker parent: abstract_unity_linker {
	string player_species <- string(unity_player);
//	int max_num_players  <- 6;
//	int min_num_players  <- 6;
	unity_property up_tree_1;
	unity_property up_tree_2;
	unity_property up_tree_3;
	unity_property up_tree_Dead;
	unity_property up_default;
	
	action ChangeTreeState(string tree_Name, string status){
		list split_tree_ID ;
		list playerID ;
		write "ChangeTreeState: " + tree_Name + " state " + status;
		split_tree_ID <- tree_Name split_with ('tree', true);
		playerID <- split_tree_ID[0] split_with ('p', true);
		

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
		do define_properties;
		player_unity_properties <- [nil,nil,nil,nil,nil,nil];
		
		do add_background_geometries(p1tree,up_default);
		do add_background_geometries(p2tree,up_default);
		do add_background_geometries(p3tree,up_default);
		do add_background_geometries(p4tree,up_default);
		do add_background_geometries(p5tree,up_default);
		do add_background_geometries(p6tree,up_default);
	}
	action define_properties {
		unity_aspect tree1_aspect <- prefab_aspect("temp/Prefab/VU2/Seeding_1",1.0,0.0,1.0,0.0,precision);
		up_tree_1 <- geometry_properties("tree_state1","",tree1_aspect,new_geometry_interaction(true, false,false,[]),false);
		unity_properties << up_tree_1;
		
		unity_aspect tree2_aspect <- prefab_aspect("temp/Prefab/VU2/Seeding_2",1.0,0.0,1.0,0.0,precision);
		up_tree_2 <- geometry_properties("tree_state2","",tree2_aspect,new_geometry_interaction(true, false,false,[]),false);
		unity_properties << up_tree_2;
		
		unity_aspect tree3_aspect <- prefab_aspect("temp/Prefab/VU2/Seeding_3",1.0,0.0,1.0,0.0,precision);
		up_tree_3 <- geometry_properties("tree_state3","",tree3_aspect,new_geometry_interaction(true, false,false,[]),false);
		unity_properties << up_tree_3;
		
		unity_aspect treeDead_aspect <- prefab_aspect("temp/Prefab/VU2/Seeding_Dead",1.0,0.0,1.0,0.0,precision);
		up_tree_Dead <- geometry_properties("tree_stateDead","",treeDead_aspect,new_geometry_interaction(true, false,false,[]),false);
		unity_properties << up_tree_Dead;


		unity_aspect default_aspect <- prefab_aspect("temp/Prefab/VU2/Seeding",1.0,0.0,1.0,0.0,precision);
		up_default <- geometry_properties("default","",default_aspect,new_geometry_interaction(true, false,false,[]),false);
		unity_properties << up_default;

	}
	reflex send_geometries {
//		list<tree> t1_state1 <- p1tree where ((each.it_state = 1));
//		list<tree> t1_state2 <- p1tree where ((each.it_state = 2));
//		list<tree> t1_state3 <- p1tree where ((each.it_state = 3));
//		list<tree> t1_stateDead <- p1tree where ((each.it_state = 0));
////		write "State1:" + t1_state1;
////		write "State2:" + t1_state2;
////		write "State3:" + t1_state3;
////		write "State0:" + t1_stateDead;
//		if not empty(t1_state1){
//			do add_geometries_to_send(t1_state1,up_tree_1);
////			write "Send t1_state1";
//		}
//		if not empty(t1_state2){
//			do add_geometries_to_send(t1_state2,up_tree_2);
////			write "Send t1_state2";
//		}
//		if not empty(t1_state3){
//			do add_geometries_to_send(t1_state3,up_tree_3);
////			write "Send t1_state3";
//		}
//		if not empty(t1_stateDead){
//			do add_geometries_to_send(t1_stateDead,up_tree_Dead);
////			write "Send t1_stateDead";
//		}
//		
//		
//		list<tree> t2_state1 <- p2tree where ((each.it_state = 1));
//		list<tree> t2_state2 <- p2tree where ((each.it_state = 2));
//		list<tree> t2_state3 <- p2tree where ((each.it_state = 3));
//		list<tree> t2_stateDead <- p2tree where ((each.it_state = 0));
//		do add_geometries_to_send(t2_state1,up_tree_1);
//		do add_geometries_to_send(t2_state2,up_tree_2);
//		do add_geometries_to_send(t2_state3,up_tree_3);
//		do add_geometries_to_send(t2_stateDead,up_tree_Dead);
//		
//		list<tree> t3_state1 <- p3tree where ((each.it_state = 1));
//		list<tree> t3_state2 <- p3tree where ((each.it_state = 2));
//		list<tree> t3_state3 <- p3tree where ((each.it_state = 3));
//		list<tree> t3_stateDead <- p3tree where ((each.it_state = 0));
//		do add_geometries_to_send(t3_state1,up_tree_1);
//		do add_geometries_to_send(t3_state2,up_tree_2);
//		do add_geometries_to_send(t3_state3,up_tree_3);
//		do add_geometries_to_send(t3_stateDead,up_tree_Dead);
//		
//		list<tree> t4_state1 <- p4tree where ((each.it_state = 1));
//		list<tree> t4_state2 <- p4tree where ((each.it_state = 2));
//		list<tree> t4_state3 <- p4tree where ((each.it_state = 3));
//		list<tree> t4_stateDead <- p4tree where ((each.it_state = 0));
//		do add_geometries_to_send(t4_state1,up_tree_1);
//		do add_geometries_to_send(t4_state2,up_tree_2);
//		do add_geometries_to_send(t4_state3,up_tree_3);
//		do add_geometries_to_send(t4_stateDead,up_tree_Dead);
//		
//		list<tree> t5_state1 <- p5tree where ((each.it_state = 1));
//		list<tree> t5_state2 <- p5tree where ((each.it_state = 2));
//		list<tree> t5_state3 <- p5tree where ((each.it_state = 3));
//		list<tree> t5_stateDead <- p5tree where ((each.it_state = 0));
//		do add_geometries_to_send(t5_state1,up_tree_1);
//		do add_geometries_to_send(t5_state2,up_tree_2);
//		do add_geometries_to_send(t5_state3,up_tree_3);
//		do add_geometries_to_send(t5_stateDead,up_tree_Dead);
//		
//		list<tree> t6_state1 <- p6tree where ((each.it_state = 1));
//		list<tree> t6_state2 <- p6tree where ((each.it_state = 2));
//		list<tree> t6_state3 <- p6tree where ((each.it_state = 3));
//		list<tree> t6_stateDead <- p6tree where ((each.it_state = 0));
//		do add_geometries_to_send(t6_state1,up_tree_1);
//		do add_geometries_to_send(t6_state2,up_tree_2);
//		do add_geometries_to_send(t6_state3,up_tree_3);
//		do add_geometries_to_send(t6_stateDead,up_tree_Dead);
		
	}
}

species unity_player parent: abstract_unity_player{
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
	list<string> displays_to_hide <- ["Main","Main","Main"];
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


