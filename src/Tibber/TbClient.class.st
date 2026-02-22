Class {
	#name : 'TbClient',
	#superclass : 'Object',
	#instVars : [
		'zn'
	],
	#category : 'Tibber',
	#package : 'Tibber'
}

{ #category : 'accessing' }
TbClient >> accessToken [

	^ 'iAGWoFjL2bGDzBv_jELAwj0CZa-MsJ1a1F5zxCnA4l0' 
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

{ #category : 'accessing' }
TbClient >> post [

	zn post.
	^ self contents 
]

{ #category : 'as yet unclassified' }
TbClient >> priceToday [

	| q infoJSONs infos |
	q := '{viewer {homes {currentSubscription {priceInfo {today {total startsAt }}}}}}'.
	self query: q.
	self post.
	infoJSONs := self home1 atPath:
		             #( currentSubscription priceInfo today ).
	infos := infoJSONs collect: [ :each | TbPriceInfo from:each ].
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

	^ zn ifNil:[zn:= ZnClient new interactivePolicy
		        accept: ZnMimeType applicationJson;
		        contentReader: [ :entity | 
			        NeoJSONObject fromString: entity contents ];
		        url: self url;
		        setBearerAuthentication: self accessToken]
]
