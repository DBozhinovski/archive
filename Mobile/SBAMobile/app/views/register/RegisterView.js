var RegisterView = Backbone.View.extend({

	attributes : {
		"id" : "register"
	},

	initialize : function(){

		this.render();

	},

	render : function(){

		var self = this;

		require(["text!templates/register/register.tpl"], function(template){

			self.$el.html(Mustache.render(template, ""));

			$("#content").html(self.$el);

			Gfx.hideHeader();
			Gfx.hideFooter();

			return self;

		});

	}

});