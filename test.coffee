# # # # # # CLIENT CODE # # # # # # 
if Meteor.isClient
	# # # TEMPLATE INIT # # #
	tplName = 'parent'
	T = Template[tplName]

	# # # COMPONENTS # # #
	## COMPONENT 1 ##
	vmPropsArr = []
	vmProps =
		getChildProp: -> console.log @child('child').childProp()
	vmPropsArr.push vmProps

	## VIEWMODEL LOADER ##
	T.viewmodel
		load: vmPropsArr

	## COMPONENT 2 ##
	Template.child.viewmodel
		childProp: 'childProp value'
		onRendered: -> @parent().getChildProp()