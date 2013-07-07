/**
* In charge of routing, route persistence and using require js to 
* load packages that are required in order to run the view / model pairings
*
*/
var AppRouter = Backbone.Router.extend({

	view : "",

	initialize : function(){
		
		var credentials = localStorage.getItem("credentials");
		
		if(credentials){
		
			//perform a check for the validity of the user
			//if valid, go to home screen (invoice)?
			window.location.hash = "/invoice/";
		
		} else {
			
			//go to register screen
			window.location.hash = "/register/";
			
		}
		
		//preload something if globally needed
		//keep synchronicty in mind though
		
	},

	routes : {
	
		"/register/" : "register",
		"/register/:action/" : "register",
		"/register/:action/:view/" : "register",
		"/invoice/" : "invoice", //root screen after login?
		"/invoice/:action/" : "invoice",
		"/invoice/:action/:id" : "invoice",
		"/product/" : "product", //redundant?
		"/product/:action/" : "product",
		"/product/:action/id" : "product",
		"/customer/" : "customer", //redundant?
		"/customer/:action/" : "customer",
		"/customer/:action/:id" : "customer",
		"/:action" : "invalid", //invalid routes
		":action" : "invalid" //invalid routes		
	
	},
	
	register : function(action, view){
		
		require(["views/Register"], function(){
				
				self.view = new RegisterView(action, view);
				
		}); 
		
	},
	
	invoice : function(action, id){
		
		require(["views/Invoice"], function(){
		
			self.view = new InvoiceView(action, id);
		
		});
		
	},
	
	product : function(){
		
		require(["views/Product"], function(){
		
			self.view = new InvoiceView(action, id);
		
		});
		
	},
	
	customer : function(){
		
		require(["views/Customer"], function(){
		
			self.view = new InvoiceView(action, id);
		
		});
		
	},
	
	invalid : function(){
	
		console.error("SBAMobile: Error - Invalid route [approuter.js]");
	
	}
	
});

