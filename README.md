# Maze-Solver
This project is a Ruby program that processes text files containing maze data.
The program will analyze that data to determine certain features of each maze. 
Then it will use that knowledge to solve the maze. 

# Maze File Format 
Example format: 
```text
16 0 2 13 11 
0 0 du 123.456 0.123456
0 1 uldr 43.3 5894.2341 20.0 5896.904
... 
path path1 0 2 urdl
path path2 0 2 dlr 
```
# Find Maze Properties 
Once the maze is read in, the program will compute various properties of the maze, according to the command (mode) it is given. Here are three simple properties the program computes: the number of open cells in the maze, the number of "bridges", and the list of all cells sorted by their number of openings.

# Process & Sort Paths By Cost
As described in the introduction, some maze files will contain paths. Only paths that travel between cells through openings are valid. For each valid path, the program uses the weights for each opening in the maze to calculate the cost of the path and sort the paths by their total cost. 

# Print Maze
Each cell will be represented by either a space, the letter "s" (for the start cell), or the letter "e" (for the end cell).
Left/right walls will be represented by a pipe character "|", up/down walls will be represented by a dash "-", and wall junctions will be represented with a plus "+".
If the maze file contains paths, print asterics in the cells on the shortest (cost of path is smallest) path. If the shortest path includes the start cell or end cell, print capital letter "S" or "E" instead of "s" or "e".
The program will print a maze in this format when executed with the print command.
Example maze: 
```
% ruby runner.rb print inputs/maze1
+-+-+-+-+
|s|   | |
+ + + +-+
|       |
+-+ + + +
|     | |
+ +-+ +-+
| | |  e|
+-+-+-+-+
```

# Solve Maze
The program calculates the distance of maze cells from the start and use the data to determine whether the maze is solvable and the solution to the maze if it is solvable.
Example distance: 
```text
% ruby runner.rb distance inputs/maze2
0,(0,3)
1,(0,2)
2,(1,2)
3,(1,1),(2,2)
4,(0,1),(1,0),(2,1),(2,3)
5,(0,0),(2,0),(3,1),(3,3)
6,(3,2)
```
