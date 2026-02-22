Class {
	#name : 'TsAuth',
	#superclass : 'Object',
	#instVars : [
		'client',
		'base64enc',
		'code_challenge',
		'code_verifier',
		'state',
		'fields'
	],
	#category : 'Tesla',
	#package : 'Tesla'
}

{ #category : 'private' }
TsAuth >> client [

	| hashed |
	code_verifier := self randomString: 86.
	hashed := SHA256 hashMessage: code_verifier.
	code_challenge := base64enc encode: hashed.
	state := self randomString: 50.
	client := ZnClient new.
	client
		url: 'https://auth.tesla.com/oauth2/v3/authorize';
		accept:'application/json';
		beBinary;
		debugPolicy.
	client
		queryAt: 'client_id' put: 'ownerapi';
		queryAt: 'code_challenge' put: code_challenge;
		queryAt: 'code_challenge_method' put: 'S256';
		queryAt: 'redirect_uri' put: 'https://auth.tesla.com/void/callback';
		queryAt: 'response_type' put: 'code';
		queryAt: 'scope' put: 'openid email offline_access';
		queryAt: 'state' put: state.
	^ client
]

{ #category : 'as yet unclassified' }
TsAuth >> getAuthCode [

	fields
		at: #identity put: 'christer@assmundsson.com';
		at: #credential put: 'mj9SD*^M*9o8eGXWyQqu'.
	client formAddAll: fields.
	^client post.
]

{ #category : 'as yet unclassified' }
TsAuth >> getForm [

	| htmlBytes soup form flds |
	htmlBytes := self client get.
	soup := Soup fromString: htmlBytes asString.
	form := (soup findAllTagsByClass: 'sso-form') first.
	flds := (form findAllTags: 'input')
		        collect: [ :tag | 
			        | key val |
			        key := tag attributeAt: #name.
			        val := tag attributeAt: #value.
			        key -> val ]
		       " thenReject: [ :assoc | assoc value isEmptyOrNil ]".
	^ fields := flds asDictionary
]

{ #category : 'initialization' }
TsAuth >> initialize [

	base64enc := ZnBase64Encoder new.
	base64enc beForURLEncoding.

]

{ #category : 'as yet unclassified' }
TsAuth >> randomString: anSizeInt [
| dom s |
dom := 'abcdefghijkmnopqrstuvwxyzABCDEFGHIJKMNOPQRSTUVWXYZ1234567890'.
	s:=''.
1 to: anSizeInt do: [ :ix | s := s copyWith: dom atRandom. ].^s
]
