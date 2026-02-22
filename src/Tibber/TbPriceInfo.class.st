Class {
	#name : 'TbPriceInfo',
	#superclass : 'Object',
	#instVars : [
		'start',
		'total'
	],
	#category : 'Tibber',
	#package : 'Tibber'
}

{ #category : 'instance creation' }
TbPriceInfo class >> from: aJSON [

	^self new from:aJSON 
	
]

{ #category : 'instance creation' }
TbPriceInfo >> from: aJSON [

	start := (aJSON at: #startsAt)asDateAndTime.
	total := aJSON at: #total
]
