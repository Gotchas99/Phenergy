Class {
	#name : 'TbSubscriber',
	#superclass : 'Object',
	#instVars : [
		'url',
		'gqws',
		'accessToken'
	],
	#category : 'Tibber',
	#package : 'Tibber'
}

{ #category : 'accessing' }
TbSubscriber >> accessToken: aToken [

	accessToken := aToken
]

{ #category : 'ssl' }
TbSubscriber >> close [

	gqws ifNotNil:[gqws close. gqws:=nil].
]

{ #category : 'ssl' }
TbSubscriber >> connect [

	gqws := TbGraphQlWS new url: url.
	gqws accessToken: accessToken 


]

{ #category : 'accessing' }
TbSubscriber >> gqws [

	^ gqws
]

{ #category : 'accessing' }
TbSubscriber >> url:aUrl [
url:=aUrl
]
