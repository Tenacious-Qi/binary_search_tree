This was an exercise in data structures and algorithms as part of the The Odin Project.

The Tree class includes the build_tree method which removes duplicates and sorts the array. 

This was more challenging than the linked list assignment. The biggest challenge was getting the delete method to work.

I used the visualization here to help me figure out what was happening when you delete a node with two children. https://www.cs.usfca.edu/~galles/visualization/BST.html

The idea was to find the maximum value of the left subtree and use it to replace the node you want to delete. It's also possible to find the minimum value of the right subtree and use that. For example, given a balanced level_order array of [4, 2, 6, 1, 3, 5, 7], three is the max value of left subtree and five is the min value of right subtree.

