/**
* Name: NewModel
* Based on the internal empty template. 
* Author: lilti
* Tags: 
*/


model NewModel

global {
	csv_file my_csv_file <- csv_file("../includes/pheno_tz_29Oct2024.csv");
	
	list<list<int>> fruiting_stage <- list_with(12, list_with(6, 0));
	list<list<int>> n_tree <- list_with(12, list_with(6, 0));
	
	init {
		matrix data <- matrix(my_csv_file);
//		write my_csv_file;
		write data;
		loop i from: 2 to: data.columns -1{
			loop j from: 0 to: data.rows -1{
				if i = 2{
//					write "row" + j div 6 + "column" + j mod 6;
					container(fruiting_stage[j div 6])[j mod 6] <- int(data[i,j]);
				}
				else if i = 3{
					container(n_tree[j div 6])[j mod 6] <- int(data[i,j]);
				}
			}	
		}
		write fruiting_stage;
		write n_tree;	
	}
}

experiment main type: gui;

