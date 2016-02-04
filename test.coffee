	# # # # # # CLIENT CODE # # # # # # 
	if Meteor.isClient
		# # # TEMPLATE INIT # # #
		tplName = 'test'
		T = Template[tplName]

		# # # COMPONENTS # # #
		## COMPONENT 1 ##
		vmPropsArr = []
		vmProps =
			onRendered: ->alert 'I aint working at all('
		vmPropsArr.push vmProps

		## COMPONENT 2 ##
		vmProps =
			someProp: ''
		vmPropsArr.push vmProps

		## VIEWMODEL LOADER ##
		T.viewmodel
			load: vmPropsArr
			#works only if the next onRendered is commented out
			onRendered: ->alert "Im working only if I'm the only 'onRendered'"
			onRendered: ->alert "Im working always - yay!"