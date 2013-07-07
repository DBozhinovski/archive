var AppRouter = Backbone.Router.extend({

	view : '',

	initialize : function(){
		if(Storage.Credentials.getId()){
			window.location.hash = '#/tracker';
		} else {
			window.location.hash = '#/settings';
		}

		if(Storage.Ride.getRide()){

			var ride = Storage.Ride.getRide();
			ride.send('pending');

		}

	},

	routes : {

		'/tracker' : 'tracker',
		'/log' : 'logger',
		'/settings' : 'settings',
		'/quit' : 'quit',
		'/submit' : 'submit'

	},

	tracker : function(){
		console.log('CykelScore: Tracker');
		this.view = new Views.TrackView();
		this.view.render();
	},

	logger : function(userId){
		console.log('CykelScore: Log');
		this.view = new Views.LogView();
		this.view.render();
	},

	settings : function(){
		this.view = new Views.SettingsView();
		this.view.render();
		console.log('CykelScore: Settings');
	},

	quit : function(){
		console.log('CykelScore: Quit');
	},

	submit : function(){
		console.log('CykelScore: Submitting data to server...');
	}

});

