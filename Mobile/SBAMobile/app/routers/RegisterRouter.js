var RegisterRouter = Backbone.Router.extend({

	routes : {
		
		"/register/" : "register",
		"/register/sign-up/" : "signUp",
		"/register/log-in/" : "logIn"
	
	},

	initialize : function(){
		
		
	},
	
	register : function(){
	
		var self = this;

		require(["views/register/RegisterView"], function(){
			self.view = new RegisterView();
		});
	
	},
	
	signUp : function(){
		
		var self = this;

		require(["views/register/SignUpView"], function(){
			self.view = new SignUpView();
		});
		
	},
	
	logIn : function(){
	
		var self = this;

		require(["views/register/LogInView"], function(){
			self.view = new LogInView();
		});
	
	}
	

});
