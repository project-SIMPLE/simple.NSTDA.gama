/**
* Name: NewModel
* Based on the internal empty template. 
* Author: lilti
* Tags: 
*/

// map=150*250
// player_area=50*40
// tree/player_area=50 มี 3 size

// 6 โซน โซนละ 20 ต้น done!
// ต้นไม้มี 4 step 1เกิด 2โต 3โตสุด 4ตาย แล้ว ส่ง tree_id เมื่อโตขึ้น done!
// มี 3 species ที่แตกต่างกัน โตต่างกัน มี cutoff ให้เลือกจากของคิต แล้ว ramdom ดูว่าจะ 123 ยังไง แล้วค่อยลองส่งข้อมูลให้ unity โดย
// 1. ลองส่งไปเลย 100 ว่าโต เพื่อดูว่าไหวไหม
// 2. แต่จริง ๆ มันจะส่งแค่บางตัวแต่มันโตเท่านั้น เช่น จาก 10 ต้นมี 1,3,8 ที่โตก็ส่งไปแค่นั้น เอาเป็น 50% ของต้นไม้ที่มีการเปลี่ยน
// ขากลับจาก unity จะส่งกลับมาว่าตาย/บ่ตาย 
// ดูด้วยว่าโซนไหนเหลือกี่ต้น ให้มี count ของต้นไม้


//29May2025
// Start, stop ส่งเหมือนเดิม done!
// อัพเดทต้นไม้แยกเป็น 6 ทีม ชื่อ 1tree, 2tree ... 6tree เลขหน้าคือเลข player ตามด้วยคำว่า tree เพื่อที่จะสร้าง object บน unity ว่า 1tree0 done!
// State ของต้นไม้ 0ตาย 1default 2โต 3โตใหญ่ ตอนเริ่มเป็น 1 ไว้ done!
// เวลาส่ง ส่งทีละต้น head คือชื่อต้นไม้, body คือ state อีกอันคือ Content done!
// Head ส่งคำสั่งหลัก start stop update done!
// Body เจาะจงว่า object ไหน เช่นต้นไม้ไหน ต้นหญ้าไหน done!
// content คือทำอะไร หรือก็คือ state 0 1 2 3 done!
// ส่งไปว่าต้นไม้สร้างเสร็จแล้ว พร้อมให้พี่เติ้ลลบ 

// unity ส่งกลับ มี str 2 อัน คือ tree_name เช่น 1tree0 ... , tree_status เป็นตัวเลข 0 1 2 done!

//11Jun2025
// 1. ลองเปลี่ยนมาให้ GAMA เปลี่ยน prefab ลองดูว่าแลคไหม ประมาณไหน
// 2. รอรัับ massage จากพี่เติ้ลว่าต้นไหนตาย
// 3. ลองส่งข้อมูลไปเป็นชุดให้พี่เติ้ลเป็น json (พี่เก๋จะคุยกับ patrick ด้วย)

//25Jun2025
// 1. เพิ่ม Head ชื่อว่า ReadID ให้ส่งเมื่อ GAMA พร้อมแล้ว ส่งมาหลังจากต้นไม้ครั้งแรก

// 2Jul2025
// ส่ง agent พื้นที่ผู้เล่น + กำแพง
// ผู้เล่นโซนละ 100
// ปรับให้สร้างโซนตามจำนวนผู้เล่น

model NewModel

import "optimize_species.gaml"

global{
//	shape_file map_shape_file <- shape_file("grid_area.shp");
	geometry shape <- rectangle(250#m, 150#m);
//	geometry shape <- (envelope(map_shape_file));
	
//	int max_y <- 4 - 1 ;
//	int max_x <- 5 - 1 ;
	int max_y <- 4 - 1 ;
	int max_x <- 5 - 1 ;

	list<point> big_tree <- [{max_y,0},{0,max_x}];
	list<point> med_tree <- [{0,0},{max_y,max_x}];
	float size_of_tree <- 50.0;
	
	map<int, string> map_player_id <- [1::"Player_59", 2::"Player_102", 3::"Player_103", 4::"Player_104", 5::"Player_105", 6::"Player_106"];
	
	bool can_start <- true;
	action resume_game;
	action pause_game;
	
	init{	
		loop i from:0 to:2{
			loop j from:0 to:1{
				create playerable_area{
					point at_location <- {((83.33*i)+41.67)#m,((75*j)+37.5)#m,0};
					location <- at_location;
				}
			}	
		}
		
		
		loop i from:0 to:max_y{
			loop j from:0 to:max_x{
				int temp_type <- rnd(1, 3);
				create p1tree{
					point at_location <- {((83.33*0)+16.67+7+(4*j))#m,((75*0)+17.5+8+(6*i))#m,0};
					location <- at_location;
					shape <- circle(size_of_tree#cm);
					tree_type <- temp_type;
					it_state <- 1;
				}
				create p2tree{
					point at_location <- {((83.33*1)+16.67+7+(4*j))#m,((75*0)+17.5+8+(6*i))#m,0};
					location <- at_location;
					shape <- circle(size_of_tree#cm);
					tree_type <- temp_type;
					it_state <- 1;
				}
				create p3tree{
					point at_location <- {((83.33*2)+16.67+7+(4*j))#m,((75*0)+17.5+8+(6*i))#m,0};
					location <- at_location;
					shape <- circle(size_of_tree#cm);
					tree_type <- temp_type;
					it_state <- 1;
				}
				create p4tree{
					point at_location <- {((83.33*0)+16.67+7+(4*j))#m,((75*1)+17.5+8+(6*i))#m,0};
					location <- at_location;
					shape <- circle(size_of_tree#cm);
					tree_type <- temp_type;
					it_state <- 1;
				}
				create p5tree{
					point at_location <- {((83.33*1)+16.67+7+(4*j))#m,((75*1)+17.5+8+(6*i))#m,0};
					location <- at_location;
					shape <- circle(size_of_tree#cm);
					tree_type <- temp_type;
					it_state <- 1;
				}
				create p6tree{
					point at_location <- {((83.33*2)+16.67+7+(4*j))#m,((75*1)+17.5+8+(6*i))#m,0};
					location <- at_location;
					shape <- circle(size_of_tree#cm);
					tree_type <- temp_type;
					it_state <- 1;
				}
			}
		}
//		save my_grid to:"grid_area.shp" format:"shp";
	}
	
	reflex for_send_start when:(can_start and not paused){
		can_start <- false;
		do resume_game;
	}
	
	reflex for_send_stop when:paused{
		can_start <- false;
		do pause_game;
	}
}

grid my_grid width:3 height:2{
	
}

experiment init_exp type: gui {
	output{
		layout
		toolbars: true tabs: false parameters: false consoles: true navigator: false controls: true tray: false ;
		display "Main" type: 3d background: rgb(50,50,50) locked:true antialias:true {
			camera 'default' location: {125.0,75.0038,218.3806} target: {125.0,75.0,0.0};
			grid my_grid border: #black;
			species playerable_area;
			species p1tree;
			species p2tree;
			species p3tree;
			species p4tree;
			species p5tree;
			species p6tree;
		}
	}
}
