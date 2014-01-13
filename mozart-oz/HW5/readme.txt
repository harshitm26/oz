Please find the answers to the three questions in the files:
1. 001-ports.oz
2. 002-ManagedObject.st
3. 003-SBE-Quinto.st

To run:

1. Just run simply; see the source code for comments

2. File-in the 'st' file into Squeak and execute the following in workspace:
	ManagedObject initialize
	ManagedObject ninstances			//returns 0
	object1 := ManagedObject new
	object2 := ManagedObject new
	object3 := ManagedObject new
	object4 := ManagedObject new
	ManagedObject ninstances			//returns 4
	object5 := ManagedObject new		//returns error "Cannot create more than 4 instances"

3. File-in the 'st' file into Squeak and execute the following in workspace:
	SBEMinesweeper new openInWorld
	
	This opens a 15x15 grid. When you hit a mine, the last-clicked cell turns red and you lose, nothing happens thereafter. When you hit all the safe cells, the last-clicked cell turns green and you win.
