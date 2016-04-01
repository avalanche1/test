@Users = Meteor.users 
return unless Meteor.isClient

Template.tpl.viewmodel
	text1: 'logged-in'
	text2: 'NOT logged-in'
	login: ->Meteor.loginWithPassword('user','123')
	logout: ->Meteor.logout()
	onRendered:->
		if Users.find().count() is 0 then Accounts.createUser(username:'user',password:'123')