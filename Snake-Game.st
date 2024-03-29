AlignmentMorph subclass: #SnakeGameMorph
	instanceVariableNames: 'board scoreMorph highMorph'
	classVariableNames: 'High'
	poolDictionaries: ''
	category: 'Snake-Game'!
!SnakeGameMorph commentStamp: 'JS 5/21/2022 12:30' prior: 0!
Jaime Silvela  (jaime.silvela@gmail.com)

This is the toplevel class  for the snake game. All it does is package the SnakeMorph board, which does the real stuff, in an alignment morph with a score & controls panel.

Game controls:

* Left arrow -- Turn counterclockwise
* Right arrow -- Turn clockwise!


!SnakeGameMorph methodsFor: 'as yet unclassified' stamp: 'JSM 9/9/2001 16:01'!
initialize
	super initialize.
	High = nil 
		ifTrue: [ High _ 0].
	self color: Color darkGray;
		 borderWidth: 0;
		 hResizing: #shrinkWrap;
		 vResizing: #shrinkWrap;
		 listDirection: #topToBottom;
		 addMorphBack: (board _ SnakeMorph new);
		 addMorphBack: self makeControlPanel.
	self startStepping! !

!SnakeGameMorph methodsFor: 'as yet unclassified' stamp: 'JSM 9/9/2001 16:12'!
makeControlPanel
	^ AlignmentMorph newRow color: Color lightGray;
		 borderWidth: 0;
		 layoutInset: 3;
		 vResizing: #shrinkWrap;
		 wrapCentering: #center;
		 addMorphBack: AlignmentMorph newVariableTransparentSpacer;
		 addMorphBack: (SimpleButtonMorph new label: 'New game';
			 color: Color lightGray;
			 borderColor: #raised;
			 borderWidth: 2;
			 actionSelector: #newGame;
			 target: board);
		 addMorphBack: AlignmentMorph newVariableTransparentSpacer;
		 addMorphBack: (SimpleButtonMorph new label: 'Quit';
			 color: Color lightGray;
			 borderColor: #raised;
			 borderWidth: 2;
			 actionSelector: #delete;
			 target: self);
		 addMorphBack: AlignmentMorph newVariableTransparentSpacer;
		
		addMorphBack: (StringMorph contents: 'Score ');
		 addMorphBack: (scoreMorph _ LedMorph new digits: 4;
					 extent: 40 @ 15);
		 addMorphBack: AlignmentMorph newVariableTransparentSpacer;
		
		addMorphBack: (StringMorph contents: 'High ');
		 addMorphBack: (highMorph _ LedMorph new digits: 4;
					 extent: 40 @ 15);
		 addMorphBack: AlignmentMorph newVariableTransparentSpacer! !

!SnakeGameMorph methodsFor: 'as yet unclassified' stamp: 'JSM 9/9/2001 15:59'!
step
	scoreMorph value: board length.
	board length > High
		ifTrue: [High _ board length].
	highMorph value: High! !


Morph subclass: #SnakeMorph
	instanceVariableNames: 'speed cells grow'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Snake-Game'!
!SnakeMorph commentStamp: 'JS 5/21/2022 12:32' prior: 0!
Jaime Silvela  (jaime.silvela@gmail.com)
21 September 2001

This class contains the game proper.
The lion's share of this class is in the step method.
The class contains three instance variables:

* speed: a vector that keeps track of orientation
* cells: an ordered collection of square Morphs.
* grow: the number of cells to be added to the snake.

`step` will move the first cell in the "cells" variable according to speed,
then it will move through "cells", making each one take the position of
the previous one. It also checks for collision of the snake with the walls
or with itself.
Finally, if the snake eats one of the numbers that pop up on the screen,
it updates "grow" accordingly.!


!SnakeMorph methodsFor: 'as yet unclassified' stamp: 'JSM 8/25/2001 23:42'!
growCells: aNumber 
	grow _ aNumber! !

!SnakeMorph methodsFor: 'as yet unclassified' stamp: 'JSM 8/25/2001 22:36'!
handlesKeyboard: evt
	^ true! !

!SnakeMorph methodsFor: 'as yet unclassified' stamp: 'JSM 8/25/2001 22:37'!
handlesMouseOver: evt
	^ true! !

!SnakeMorph methodsFor: 'as yet unclassified' stamp: 'JSM 9/1/2001 14:51'!
initialize
	super initialize.
	self extent: 300 @ 300.
	self newGame! !

!SnakeMorph methodsFor: 'as yet unclassified' stamp: 'JSM 8/25/2001 23:26'!
keyStroke: evt
	| keyValue |
	keyValue _ evt keyCharacter asciiValue.
	keyValue = 28 ifTrue: [ self turnRight ].
	keyValue = 29 ifTrue: [ self turnLeft]! !

!SnakeMorph methodsFor: 'as yet unclassified' stamp: 'JSM 9/1/2001 15:34'!
length
	^ cells size + grow! !

!SnakeMorph methodsFor: 'as yet unclassified' stamp: 'JSM 8/25/2001 22:38'!
mouseEnter: evt
	evt hand newKeyboardFocus: self! !

!SnakeMorph methodsFor: 'as yet unclassified' stamp: 'JSM 9/1/2001 15:41'!
newGame
	| cell |
	self
		submorphsDo: [:m | m delete].
	cell _ Morph new extent: 10 @ 10;
				 color: Color yellow.
	cell position: self position." + self extent / 2."
	self addMorph: cell.
	cells _ OrderedCollection new.
	cells addLast: cell.
	speed _ 1 @ 0.
	self growCells: 6.
	self numberAtRandom.
	self startStepping! !

!SnakeMorph methodsFor: 'as yet unclassified' stamp: 'JSM 9/1/2001 14:40'!
numberAtRandom
	| value x y string stringMorph temp |
	value _ 9 atRandom.
	string _ String fromString: value printString.
	stringMorph _ StringMorph contents: string.
	stringMorph extent: 10 @ 10;
		 color: Color yellow.
	temp _ self extent - stringMorph extent.
	x _ temp x atRandom - 1.
	y _ temp y atRandom - 1.
	stringMorph position: self position + (x @ y).
	self
		submorphsDo: [:m | (m bounds intersects: stringMorph bounds)
				ifTrue: [self numberAtRandom.
					^ self]].
	self addMorph: stringMorph! !

!SnakeMorph methodsFor: 'as yet unclassified' stamp: 'JSM 9/21/2001 20:48'!
step
	| head lastPosition tmp cell |
	head _ cells first.
	lastPosition _ head position.
	(self bounds
			containsRect: (head bounds translateBy: speed * head width))
		ifFalse: [self stopStepping.
			^ self].

	"Move the first cell according to the speed vector, then have the second cell take the place of the first one, the third one take the place of the second one etc."
	head position: head position + (speed * head width).
	2
		to: cells size
		do: [:index | 
			tmp _ (cells at: index) position.
			(cells at: index)
				position: lastPosition.
			lastPosition _ tmp].
	"If the snake needs to grow, make a new cell and append to the snake"
	grow > 0
		ifTrue: [cell _ Morph new.
			cell extent: 10 @ 10.
			cell color: Color yellow.
			cell position: lastPosition.
			cells addLast: cell.
			self addMorph: cell.
			grow _ grow - 1].
	2
		to: cells size
		do: [:index | (cells at: index) position = head position
				ifTrue: [self stopStepping]].
	self
		submorphsDo: [:m | ((m isMemberOf: StringMorph)
					and: [head bounds intersects: m bounds])
				ifTrue: [self growCells: m contents asInteger.
					m delete.
					self numberAtRandom]]! !

!SnakeMorph methodsFor: 'as yet unclassified' stamp: 'JSM 8/25/2001 23:48'!
stepTime
	^ 100! !

!SnakeMorph methodsFor: 'as yet unclassified' stamp: 'JSM 8/25/2001 22:40'!
turnLeft
	speed _ speed y negated @ speed x! !

!SnakeMorph methodsFor: 'as yet unclassified' stamp: 'JSM 8/25/2001 22:40'!
turnRight
	speed _ speed y @ speed x negated! !
