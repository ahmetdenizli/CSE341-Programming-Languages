CSE341 Programming Languages HW3
Ahmet Denizli 161044020

Part1:
For get costs from canakkele to other cities:
route(canakkale,X,C).
For get all possible flights:
route(X,Y,C).


Part2:

CONFLICTS: Check whether there is any scheduling conflict.
conflicts(cse341, cse331).
-> false
conflicts(cse321, cse321).
-> true

ASSIGN: Check which room can be assigned to a given class or Check which room can be assigned to which classes.
For test:
assign(z10, cse341). 
-> true
assign(z10,Y).
-> Y = cse331, Y = cse341

ENROLL :Check whether a student can be enrolled to a given class or Check which classes a student can be assigned.
For test:
enroll(1, cse341).
-> false
enroll(1, Y).
-> Y = cse331, Y = cse343

for adding functions:
addRoom(A, B, C, D)
    addRoom(z01, 5, projector, [handicapped, notH]). -> true

addCourse(A, B, C, D, E, F)
    addCourse(cse101, mehmetgokturk, 50, 4, z10, smartboard). -> true

addStudent(X, Y, Z):
    addStudent(100, [cse341], notH). -> true
    addStudent(1, [cse321], handicapped). -> false

