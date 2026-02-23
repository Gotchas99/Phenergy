Class {
	#name : 'TbGraphQlWS',
	#superclass : 'Object',
	#instVars : [
		'url',
		'ws',
		'listener'
	],
	#category : 'Tibber',
	#package : 'Tibber'
}

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
	ws := ZnWebSocket to: url. 
	"ws sendMessage: '{""type"":""connection_init""}'."
	ws sendMessage: '{"type":"connection_init",
			"payload":{
				"token":"iAGWoFjL2bGDzBv_jELAwj0CZa-MsJ1a1F5zxCnA4l0"
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

	| homeId json gql token msg vars payload |
	homeId := '15949bdb-a487-4790-80f3-77156f0f8b48'.
	token := 'iAGWoFjL2bGDzBv_jELAwj0CZa-MsJ1a1F5zxCnA4l0'.
	gql := 'subscription{liveMeasurement(homeId:"' , homeId
	       ,
	       '"){timestamp power maxPower minPower accumulatedConsumption accumulatedConsumptionLastHour}}'.
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
TbGraphQlWS >> subscribeMessage_OLD [

	| homeId msg gql token |
	homeId := '15949bdb-a487-4790-80f3-77156f0f8b48'.
	token := 'iAGWoFjL2bGDzBv_jELAwj0CZa-MsJ1a1F5zxCnA4l0'.
	gql := 'subscription
		{liveMeasurement(homeId:\"' , homeId
	       , '\"){timestamp power maxPower}
		}'.
	msg := '{
		"type":"subscribe", 
		"id": 0,
		"payload":{
			"query": "' , gql , '",
			"variables":
				{"homeId":"' , homeId , '"}
		} }'.
	self traceCr: msg.
	^ msg
]

{ #category : 'accessing' }
TbGraphQlWS >> url:aUrl [

url:=aUrl
]
