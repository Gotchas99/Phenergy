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
				baseline: 'Teapot'
				with: [ spec repository: 'github://zeroflag/Teapot/source' ];
				baseline: 'ZincHTTPComponents' with: [
						spec
							repository: 'github://svenvc/NeoJSON/repository';
							loads: #( 'WebSocket' );
							"Handle conflicts - skip if already loaded"onConflict: [ :e |
								e useIncoming ];
							"Handle upgrades - stay with current version"onUpgrade: [ :e |
								e useIncoming ];
							"Silence warnings"onWarning: [ :e | e load ] ].
			spec package: 'Tibber' with: [ spec requires: #( 'NeoJSON' ) ].
			spec group: 'default' with: #( 'Tibber' ) ]
]
