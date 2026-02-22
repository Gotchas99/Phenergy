Class {
	#name : 'BaselineOfTibber',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfTibber',
	#package : 'BaselineOfTibber'
}

{ #category : 'baselines' }
BaselineOfTibber >> baseline: spec [

	<baseline>
	spec for: #common do: [
			spec blessing: #baseline.
			spec
				baseline: 'NeoJSON'
				with: [ spec repository: 'github://svenvc/NeoJSON/repository' ];
				package: 'Tibber' with: [ spec requires: #( 'NeoJSON' ) ].
			spec group: 'default' with: #( 'Tibber' ) ]
]
