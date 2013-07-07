var HomeView = Backbone.View.extend({

	$el : "div",
	
	attributes : {
	
		"id" : "home",
		"class" : "wrapper paper"
	
	},
	
	initialize : function(){
	
		this.render();
	
	},

	render : function(){
		
		var self = this;
		
		require(["text!templates/home.tpl", "text!templates/header/header-logo.tpl", "text!templates/footer/footer-navigation.tpl"], function(template, header, footer){
		
			self.$el.html(Mustache.render(template, ""));
			
			$("#content").html(self.$el);

			Gfx.showHeader(Mustache.render(header, ""));
			Gfx.showFooter(Mustache.render(footer, ""));
			
			return self;
		
		});
	
	},

	events : {

		"click a" : "reset"

	},

	reset : function(e){

		e.preventDefault();
		Registry.remove($(e.currentTarget).attr("id"));
		location.href = $(e.currentTarget).attr("href"); 
			
	}

});
