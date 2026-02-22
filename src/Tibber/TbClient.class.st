Class {
	#name : 'TbClient',
	#superclass : 'Object',
	#instVars : [
		'zn',
		'accessToken'
	],
	#category : 'Tibber',
	#package : 'Tibber'
}

{ #category : 'accessing' }
TbClient >> accessToken [
self assert: (accessToken isNotNil).
	^ accessToken
]

{ #category : 'accessing' }
TbClient >> accessToken:aToken [

 accessToken:=aToken 
]

{ #category : 'accessing' }
TbClient >> contents [

	^ zn contents atPath: #(#data #viewer)
]

{ #category : 'as yet unclassified' }
TbClient >> getWSclient [

	| qry res url cl |
	qry := '{viewer {websocketSubscriptionUrl} }'.
	self query: qry.
	res := self post.
	url := res at: #websocketSubscriptionUrl.
	cl:= TbSubscriber new url:url.
	^ cl
]

{ #category : 'accessing' }
TbClient >> home1 [

	^ (self contents at:#homes)first
]

{ #category : 'as yet unclassified' }
TbClient >> hyltan [

	^ '???'
]

{ #category : 'as yet unclassified' }
TbClient >> pilhack [

	^ '\"15949bdb-a487-4790-80f3-77156f0f8b48\"'
]

{ #category : 'accessing' }
TbClient >> post [

	zn post.
	^ self contents 
]

{ #category : 'as yet unclassified' }
TbClient >> priceToday [

	| q infoJSONs infos |
	q := '{viewer {home
		(id: ',self pilhack,') 
		 {currentSubscription {priceInfo {today {total startsAt }}}}}}'.
	self query: q.
	self post.
	infoJSONs := self contents  atPath:
		             #( home currentSubscription priceInfo today ).
	infos := infoJSONs collect: [ :each | TbPriceInfo from: each ].
	^ infos
]

{ #category : 'accessing' }
TbClient >> query: aString [

	| gql ent |
	gql := '{  "query": "' , aString , '"}'.
	ent := ZnEntity json: gql.
	self zn request entity: ent
]

{ #category : 'accessing' }
TbClient >> url [ ^'https://api.tibber.com/v1-beta/gql'
]

{ #category : 'accessing' }
TbClient >> zn [

	^ zn ifNil: [
			  zn := ZnClient new interactivePolicy
				        accept: ZnMimeType applicationJson;
				        contentReader: [ :entity |  
					        NeoJSONObject fromString: entity contents ];
				        url: self url;
				        setBearerAuthentication: self accessToken ]
]
