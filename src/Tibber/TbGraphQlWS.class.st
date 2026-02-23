Class {
	#name : 'TbGraphQlWS',
	#superclass : 'Object',
	#instVars : [
		'url',
		'ws',
		'listener',
		'accessToken'
	],
	#category : 'Tibber',
	#package : 'Tibber'
}

{ #category : 'accessing' }
TbGraphQlWS >> accessToken: aToken [

	accessToken := aToken
]

{ #category : 'accessing' }
TbGraphQlWS >> close [

	| msg json |
	ws ifNotNil: [ 
		ws isConnected ifTrue: [ 
			msg := Dictionary newFromPairs: { #type. #complete. #id. '0' }.
			json := NeoJSONWriter toStringPretty: msg.
			ws sendMessage: json. 
			listener terminate.
			listener := nil. ws close ].
		ws := nil ]
]

{ #category : 'accessing' }
TbGraphQlWS >> connect [

	| res |
	self assert: url isNotNil.
	ws := ZnWebSocket to: url config:[:httpClient|
		httpClient  headerAt: 'Sec-WebSocket-Protocol' put: 'graphql-transport-ws'].
	"ws sendMessage: '{	""type"":""connection_init""	}'."
ws sendMessage: '{
			"type":"connection_init",
			"payload":{
				"token":"' , accessToken , '"
			}}'.
	res := ws readMessage.
	self traceCr: res
]

{ #category : 'accessing' }
TbGraphQlWS >> processJSON: aJsonString [

	| msg payload data measurement |
	"self traceCr: 'Received: ' , aJsonString."
	msg := NeoJSONReader fromString: aJsonString.
	payload := msg at: #payload.
	data := payload at: #data.
	measurement := data at: #liveMeasurement.
	measurement at: #timestamp put: (measurement at: #timestamp) asDateAndTime.
	self traceCr: measurement
]

{ #category : 'accessing' }
TbGraphQlWS >> subscribe [

	self assert: ws isNotNil.
	self assert: ws isConnected.
	ws sendMessage: self subscribeMessage.
	listener := [ 
	            [ 
	            ws runWith: [ :message | self processJSON: message
		     ] ]
		            on: ConnectionClosed
		            do: [ :ex | 
			            self traceCr:
				            'Ignoring connection close, done ' , ex printString ] ]
		            forkAt: 33
		            named: 'TibberListener'
]

{ #category : 'accessing' }
TbGraphQlWS >> subscribeMessage [

	| homeId json gql msg vars payload |
	homeId := '15949bdb-a487-4790-80f3-77156f0f8b48'.
	gql := 'subscription{liveMeasurement(homeId:"' , homeId
	       ,
	       '"){timestamp power currentL1 currentL2 currentL3 accumulatedConsumptionLastHour}}'.
	vars := Dictionary newFromPairs: {
			        #homeId.
			        homeId }.
	payload := Dictionary newFromPairs: {
			           #query.
			           gql.
			           #variables.
			           vars }.
	msg := Dictionary newFromPairs: {
			       #type.
			       #subscribe.
			       #id.
			       '0'.
			       #payload.
			       payload }.
	json := NeoJSONWriter toStringPretty: msg.
	"self traceCr: '-----------------------------'.
	self traceCr: json.
	self traceCr: '-----------------------------'."
	^ json
]

{ #category : 'accessing' }
TbGraphQlWS >> url:aUrl [

url:=aUrl
]
