% CSE341 Programming Languages HW3 part1
% Ahmet Denizli 161044020

% knowledge base

% ROOM (id, capacity, equipment, [handicapped])
room(z10, 90, projector, [handicapped, notH]).
room(z23, 100, smartboard, [handicapped, notH]).

% OCCUPANCY (id, hour, course)
occupancy(z10, 8, cse341).
occupancy(z10, 9, cse341).
occupancy(z10, 10, cse341).
occupancy(z10, 11, cse341).
occupancy(z10, 12, null).
occupancy(z10, 13, null).
occupancy(z10, 14, cse331).
occupancy(z10, 15, cse331).
occupancy(z10, 16, cse331).
occupancy(z23, 8, null).
occupancy(z23, 9, cse321).
occupancy(z23, 10, cse321).
occupancy(z23, 11, cse321).
occupancy(z23, 12, null).
occupancy(z23, 13, null).
occupancy(z23, 14, cse343).
occupancy(z23, 15, cse343).
occupancy(z23, 16, cse343).

% COURSE (id, instructor, capacity, hour, room, prefs)
course(cse321, didemgozupek, 45, 3, z23, smartboard).
course(cse331, alpaslanbayrakci, 40, 3, z10, projector).
course(cse341, yakupgenc, 45, 4, z10, projector).
course(cse343, habilkalkan, 40, 3, z23, smartboard).

% INSTRUCTOR (id, courses, prefs)
instructor(didemgozupek, cse321, smartboard).
instructor(alpaslanbayrakci, cse331, projector).
instructor(yakupgenc, cse341, projector).
instructor(habilkalkan, cse343, smartboard).

% STUDENT (id, listOfCourses, handicapped)
student(1, [cse341, cse321], notH).
student(2, [cse343, cse321], notH).
student(3, [cse343, cse331, cse321], notH).
student(4, [cse343, cse321], notH).
student(5, [cse343, cse321], handicapped).
student(6, [cse341, cse343, cse331], handicapped).
student(7, [cse341, cse343], notH).
student(8, [cse341, cse331], handicapped).
student(9, [cse341], notH).
student(10, [cse341, cse321], notH).


% rules

% CONFLICTS
% Check whether there is any scheduling conflict. 
% conflicts(CourseID1, CourseID2) -> true | false
conflicts(CourseID1, CourseID2) :- 
    course(CourseID2, _, _, _, Room2, _),
    course(CourseID1, _, _, T1, Room1, _),
    Room1 == Room2, 
    occupancy(Room2, Hour2, CourseID2),
    occupancy(Room1, Hour1, CourseID1),
    C1lasthour is T1 + Hour1, !,
    ((Hour1 =< Hour2), (Hour2 < C1lasthour)).


% ASSIGN
% Check which room can be assigned to a given class. 
% assign(RoomID, CourseID) -> true | false
% Check which room can be assigned to which classes. 
% assign(RoomID, Y) -> Y = CourseID1 ; Y = CourseID2 ...
assign(RoomID, CourseID):- 
	room(RoomID, RoomCapacity, Nr, _),
    course(CourseID, _, CourseCapacity, H, RoomID, Nr),
    occupancy(RoomID, Hl, CourseID),
    CourseCapacity =< RoomCapacity,
    Q is H + Hl -1,
    occupancy(RoomID, Q, CourseID).

% ENROLL
% Check whether a student can be enrolled to a given class.
% enroll(StudentID, CourseID) -> true | false
% Check which classes a student can be assigned.
% enroll(StudentID, Y) -> Y = CourseID1 ; Y = CourseID2 ...
enroll(StudentID, CourseID):- 
    course(CourseID, _, _, _, RoomID, _),
	student(StudentID, CourseList, Handicapped),
    room(RoomID, _, _, RL),
    \+member(CourseID, CourseList),
    member(Handicapped,RL).


% ADDROOM
% addRoom(z01, 5, projector, [handicapped, notH]). -> true
addRoom(A, B, C, D) :- 
	\+room(A, _, _,_), 
	assert(room(A, B, C, D)).

% ADDCOURSE
% addCourse(cse101, mehmetgokturk, 50, 4, z10, smartboard). -> true
addCourse(A, B, C, D, E, F) :- 
	\+course(A, _, _, _, _, _), 
	room(E, _, _,_), 
	assert(course(A, B, C, D, E, F)).

% ADDSTUDENT
% addStudent(100, [cse341], notH). -> true
% addStudent(1, [cse321], handicapped). -> false
addStudent(X, Y, Z):- 
	\+student(X, _, _), 
	isSt(Y), 
	assert(student(X, Y, Z)).

isSt([]).
isSt([K|L]) :- helper1(K), isSt(L).
helper1(K):- course(K, _, _, _, _, _).