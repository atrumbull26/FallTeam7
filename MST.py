# -*- coding: utf-8 -*-
"""
Created on Tue Nov 28 09:58:35 2023

Minimal Spanning Tree MST:
    
-connect nodes with minimal distance
-like TSP but without directionality
-solution will have n-1 links (constraint)
-no complete tours
-no sub tours (must include all locations round trip without islands)
    -there are 2^n sub tours

Data:
    L = location points
    d_ij = distance between locations i and j in L
        -since direction doesn't matter we can use an upper triangle matrix to save space
        -flattened distance vector (<d[0][1] d[0][2] ... d[1][2] ... d[2][3]>)
            ~will need to use list decision vars -> lose speed, gain memory

Decision Variables:
    x_ij = 1 if there is a link between points i and j in L
    
Objective Function:
    min sum(sum(x_ij * d_ij))
    
Constraints:
    sum(sum(x_ij)) = n-1
    sum_S(x_ij) <= |S| where S is a subset of the links in L    -   no subtour
        -this would take too long to run so have to think of another way to do it
        
        
        -write initial LP without subtour constraints
        -constrain the sub tours that appear in the optimal value (loop)
"""

#GENERATORS
g = (i for i in range(15) if i%2 == 1)
print(type(g)) #generator object
print(g) #generator object

print([*g])

for i in g:
    print(i) #this does nothing because we've already unpacked the generator 

    #benefit of generator is low memory and speed
    #they are outputs of map(), zip(), filter()

def odd_generator(n):
    for i in range(n):
        if i%2 == 1:
            yield i
            
import itertools

x = [0,1,2]
[*itertools.combinations(x,2)] #good tool to identify and constrain subtours 
