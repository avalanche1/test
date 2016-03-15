# # # # # # CLIENT CODE # # # # # # 
if Meteor.isClient
	Template.tpl.viewmodel
		autorun: ->
			console.log  'autorun function called ' + new Date
			$('#districtDD').dropdown('clear')
		propertyA: false
		onRendered: ->
			$('#districtDD').dropdown
				onChange: =>@propertyA()

