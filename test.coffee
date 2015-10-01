# # # # # # SHARED OBJECTS # # # # # # 
@Geo = new Mongo.Collection('geo')
# # # # # # SHARED LOGIC # # # # # # 

# # # # # # SERVER CODE # # # # # # 
if Meteor.isServer
	Meteor.startup ->
		collection = Geo
		if collection.find().count() == 0
			#INSERT
			items = [
				{name: 'Moscow', _id: 'RU-R001', type: 'region', sort: '3'}
				{name: 'Region2', _id: 'RU-R002', type: 'region', sort: '4'}
				{name: 'Region3', _id: 'RU-R003', type: 'region', sort: '5'}
				{name: 'Moscow', _id: 'RU-R001-C001', type: 'city'}
				{name: 'Region2City1', _id: 'RU-R002-C001', type: 'city'}
				{name: 'Region2City2', _id: 'RU-R002-C002', type: 'city'}
				{name: 'Region2City3', _id: 'RU-R002-C003', type: 'city'}
				{name: 'Region3City1', _id: 'RU-R003-C001', type: 'city'}
				{name: 'Region3City2', _id: 'RU-R003-C002', type: 'city'}
			]
			_.each(items, (doc)-> collection.insert(doc))
		if Meteor.users.find().count() == 0
			Accounts.createUser
				username: 'user'
				password: '1234'
				profile:
					name: 'John Doe'
					region: "RU-R001-C001"
					city: "RU-R001-C001"

# # # PUBLICATIONS # # #

# # # METHODS # # #

# # # # # # CLIENT CODE # # # # # # 
if Meteor.isClient
	Meteor.startup ->
		Meteor.loginWithPassword 'user', '1234'

	# # # TPL-LEVEL OBJECTS # # #
	#define tpl
	tplName = 'cityAndRegion'
	T = Template[tplName]
	#define VM and give it a name to persist its data across hot code push
	vm = new ViewModel tplName
	T.onRendered ->
		#get tpl instance handle
		tplInstance = this
		#bind VM to the tpl
		vm.bind(this)

	# # # ROUTES # # #

	# # # SUBSCRIPTIONS # # #
	# SUBSCRIPTION CACHING #

	# # # COMPONENTS # # #
	## SHARED OBJECTS ##
	popup = chooseRegionDD = chooseCityDD = null

	## POPUP INIT ##
	T.onRendered ->
		#popup formatting
		popup = $('#cityAndRegion .ui.segment')
		popup.popup
			inline: on, hoverable: off, on: 'click', exclusive: off, position: 'bottom left', duration: 0
	vm.extend
	#get user city and region data for initial display 
		cityId: -> Meteor.user().profile.city
		cityName: -> Geo.findOne(_id: @cityId())?.name
		#OUR CASE - works with hardcoded value
		#regionId:  'RU-R001'
		#OUR CASE - supposed to work, but doesnt
		#regionId: -> Geo.findOne(_id: @cityId().substr(0, 7))?._id
		regionName: -> Geo.findOne(_id: @cityId().substr(0, 7))?.name
	#value to display in the field
		city_region: ->
			#if city is city-region - show only city name
			if @cityName() == @regionName() then @cityName()
				#else show city and region
			else @cityName() + " <span class='text curRegion'>(#{@regionName()})</span>"
	#field click event
		showPopup: ->
			#OUR CASE - current solution: session to circumvent not working regionId method
			Session.set 'regionId', Geo.findOne(_id: vm.cityId().substr(0, 7))?._id

	## REGION CHOOSER ##
	tplName = 'regionChooser'
	T = Template[tplName]
	T.helpers
	#populate regions
		regions: -> Geo.find({type: 'region'}, {sort: {sort: 1}})
	T.onRendered ->
		#init regionDD
		chooseRegionDD = $('#cityAndRegion .ui.popup .ui.dropdown.chooseRegion')
		chooseRegionDD.dropdown
			onShow: ->
				#focus on search field
				Meteor.defer -> $(chooseRegionDD).find('input').focus()
			onChange: ->
				#store selected region id (need vm.extend here as initially regionId is a method and cannot be set; for this it needs to become a property)
				#OUR CASE - works with hardcoded initial value
				#vm.extend regionId: chooseRegionDD.dropdown('get item').data('id')
				#OUR CASE - supposed to work, but doesnt
				#vm.extend regionId: -> chooseRegionDD.dropdown('get item').data('id')
				#OUR CASE - current solution: session to circumvent...
				Session.set 'regionId', chooseRegionDD.dropdown('get item').data('id')
				#show cityDD and focus on search field
				chooseCityDD.dropdown('show')
				chooseCityDD.find('input').focus()

	## CITY CHOOSER ##
	tplName = 'cityChooser'
	T = Template[tplName]
	T.helpers
	#populate cities
		cities: ->
			#OUR CASE - works only with hardcoded initial value
			#id = new RegExp '^' + vm.regionId()
			#OUR CASE - current solution: session to circumvent...
			id = new RegExp '^' + Session.get 'regionId'
			Geo.find({_id: id, type: 'city'})
	T.onRendered ->
		#init cityDD
		chooseCityDD = $('#cityAndRegion .ui.popup .ui.dropdown.chooseCity')
		chooseCityDD.dropdown
		#focus on search field
			onShow: -> Meteor.defer -> $(chooseCityDD).find('input').focus()
			onChange: (value, text, $choice)->
				vm.extend cityName: text
				popup.popup('hide')


	# # # CLEANUP # # #
	T.onDestroyed ->
		#empty Session
		Session.keys = {}
