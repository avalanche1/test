Meteor.methods({
	log: function () {
		console.log(123)
	}
});

Accounts.validateNewUser(function (userData) {
	var error;
	console.log(132)
	error = 'cannot create new user if you are already logged-in';
	if (curUser() != null) {
		return gbThrowMethodErr(error);
	}
});