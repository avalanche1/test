# # # # # # CLIENT CODE # # # # # # 
if Meteor.isClient
	Template.tpl.viewmodel
		#works
		#phoneIsMobile: ->console.log @refToPhoneInput
		
		#doesnt work
		phoneIsMobile: ->console.log @refToPhoneInput.val()
