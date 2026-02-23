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

	^ zn contents atPath: #( data viewer home)
]

{ #category : 'accessing' }
TbClient >> getWSclient [

	| qry url cl |
	qry := '{viewer {websocketSubscriptionUrl} }'.
	self query: qry.
	self post.
	url := zn contents atPath: #( data viewer websocketSubscriptionUrl ).
	cl := TbSubscriber new url: url.
	cl accessToken: accessToken .
	^ cl
]

{ #category : 'accessing' }
TbClient >> home1 [

	^ (self contents at:#homes)first
]

{ #category : 'accessing' }
TbClient >> hyltan [

	^ '???'
]

{ #category : 'accessing' }
TbClient >> pilhack [

	^ '15949bdb-a487-4790-80f3-77156f0f8b48'
]

{ #category : 'accessing' }
TbClient >> post [

	zn post.
	^ self contents 
]

{ #category : 'accessing' }
TbClient >> priceToday [

	| q infoJSONs infos gql |
	q:='{currentSubscription {priceInfo {today {total startsAt }}}}'.
	gql := '{viewer {home (id: "' , self pilhack , '") ',q,' }}'.
	"q := '{viewer {name   }}'."
	self query: gql.
	self post.
	infoJSONs := self contents atPath:
		             #(  currentSubscription priceInfo today ).
	infos := infoJSONs collect: [ :each | TbPriceInfo from: each ].
	^ infos
]

{ #category : 'accessing' }
TbClient >> query: aString [

	| gql ent tmp |
	tmp := aString copyReplaceAll: String cr with: ' '.
		tmp :=tmp copyReplaceAll: String tab with: ' '.
	tmp := tmp copyReplaceAll: '"' with: '\"'.
	gql := '{  "query": "' , tmp , '"}'.
	ent := ZnEntity json: gql.
	self zn request entity: ent
]

{ #category : 'accessing' }
TbClient >> url [ ^'https://api.tibber.com/v1-beta/gql'
]

{ #category : 'accessing' }
TbClient >> zn [

	^ zn ifNil: [
			  zn := ZnClient new 
				        accept: ZnMimeType applicationJson;
				        contentReader: [ :entity |
					        NeoJSONObject fromString: entity contents ];
				        url: self url;
				        setBearerAuthentication: self accessToken.
				"zn interactivePolicy."
				zn systemPolicy. ]
]
