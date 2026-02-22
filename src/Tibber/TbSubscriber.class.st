Class {
	#name : 'TbSubscriber',
	#superclass : 'Object',
	#instVars : [
		'url',
		'gqws'
	],
	#category : 'Tibber',
	#package : 'Tibber'
}

{ #category : 'ssl' }
TbSubscriber >> close [

	gqws ifNotNil:[gqws close. gqws:=nil].
]

{ #category : 'ssl' }
TbSubscriber >> connect [

	gqws := TbGraphQlWS new url: url.
]

{ #category : 'accessing' }
TbSubscriber >> gqws [

	^ gqws
]

{ #category : 'accessing' }
TbSubscriber >> url:aUrl [
url:=aUrl
]
