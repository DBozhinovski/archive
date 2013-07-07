/**
* In charge of routing, route persistence and using require js to 
* load packages that are required in order to run the view / model pairings
*
*/
var AppRouter = Backbone.Router.extend({

//	router : "",

	initialize : function(){
//		localStorage.setItem("token","f1e6ec75a5f2aa817bdd3f15cc565371512d64a6a2096887e403c7ed87fa3cc0");
//		var credentials = localStorage.getItem("credentials");
//		
//		if(credentials){
//		
//			//perform a check for the validity of the user
//			//if valid, go to home screen (invoice)?
//			window.location.hash = "/invoice/";
//		
//		} else {
//			
//			//go to register screen
//			window.location.hash = "/register/";
//			
//		}
		
		//preload something if globally needed
		//keep synchronicty in mind though
		
	},

	routes : {

//		"/register/" : "register",
//		"/products/" : "products",
//		"/customers/" : "customers",
//		"/invoices/" : "invoices",
		"/home/" : "home"
	
	},
	
	home : function(){
	
		require(["views/HomeView"], function(template){
		
			new HomeView();
		
		});
	
	},
	
//	register : function(){
//		
//		this.router = new RegisterRouter();
//		
//	},
//	
//	invoices : function(){
//		
//		this.router = new InvoicesRouter();
//		
//	},
//	
//	products : function(){

//		this.router = new ProductsRouter();
//		
//	},
//	
//	customers : function(){
//		
//		this.router = new CustomersRouter();
//		
//	}
	
});

