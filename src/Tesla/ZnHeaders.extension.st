Extension { #name : 'ZnHeaders' }

{ #category : '*Tesla' }
ZnHeaders >> atAsIs: headerName put: value [

	"Store value under headerName, replace existing entries"

	^ self headers at: headerName put: value
]
