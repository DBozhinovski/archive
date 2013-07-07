var App = {
	
	override : function(){
	
		// Overrides default browser / webview behavior to increase response time and
		// give an impression of a native application
	
//		var touch = false;
//		var move = false;
	
//		$("body, html").bind("touchmove", function(event){
//		
//			event.preventDefault();
//		
//		});
	
//		$('body').delegate('a', 'touchstart', function(event){ 
//		
//			touch = true;
//		
//		});
//		
//		$('body').delegate('a', 'touchmove', function(event){ 
//		
//			if(touch){
//				move = true;
//			}
//			
//		
//		});
//		
//		$('body').delegate('a', 'touchend', function(event){ 
//		
//			event.preventDefault();
//			
//			touch = false;
//			
//			if(!move){
//				
//				location.href = $(this).attr("href");
//				
//				Gfx.showLoader();
//				
//				if($(this).attr("data-execute")){
//					
//					Registry.set("execute", $(this).attr("data-execute"));
//				
//				}
//				
//			}
//			
//			move = false;
//		
//		});

		$("body").css("min-height",(window.innerHeight-20) + "px");

		$("body").delegate("a", "tap", function(event){
		
			location.href = $(this).attr("href");
				
			Gfx.showLoader();
			
			if($(this).attr("data-execute")){
				
				Registry.set("execute", $(this).attr("data-execute"));
				Registry.set("parameters", $(this).attr("data-parameters"));
			
			}
		
		});
		
		// $('body').delegate('a', 'click', function(event){
		
		// 	event.preventDefault();
		
		// 	return false;
		
		// });
	},
	
	load : function(){
	
		var self = this;
	
		require(["routers/Approuter", "routers/RegisterRouter", "routers/InvoicesRouter", "routers/ProductsRouter", "routers/CustomersRouter"], function(){
		
			self.run();
			self.override();
		
		});
		
		window.scrollTo(0, 1)
	
	},
	
	run : function(){
	
		$(document).ready(function(){
		
			Registry.set("apiRoot", "http://mvp-sba.herokuapp.com");
			Registry.set("partnerId", "58d1f7fc358c4ae995a1ee94a758e7f3");

			Backbone.osync = Backbone.sync;
			Backbone.sync = function(method, model, options) {
				var new_options =  _.extend({
					beforeSend: function(xhr) {
						//switch this to registry instead; faster lookup than querying the localStorage all the time;
						var token = localStorage.getItem("token");
						if (token) xhr.setRequestHeader("x-token", token);
					}
				}, options)
				Backbone.osync(method, model, new_options);
			};	
		
			new AppRouter();
			new InvoicesRouter();
			new CustomersRouter();
			new ProductsRouter();
			new RegisterRouter();
			
			Backbone.history.start();
			
		});
	
	}
	
}

App.load();


