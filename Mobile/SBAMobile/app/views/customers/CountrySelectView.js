var CountrySelectView = Backbone.View.extend({

	$el : "div",

	attributes : {

		id : "customer-country-select",
		class : "wrapper"

	},

	initialize : function(){

		this.render();

	},

	render : function(){

		var self = this;

		require(["text!templates/customers/customers-country.tpl", "text!templates/header/header-back.tpl"], function(template, header){

			var countries = new Countries();

			countries.fetch({

				success : function(data){

					self.$el.html(Mustache.render(template, {"countries" : data.toJSON()}));

					$("#content").html(self.$el);

					Gfx.showHeader(Mustache.render( header, { "back" : "Back", "title" : "Select Country" } ) );
					Gfx.hideFooter();

					return self;

				}

			})

		});

	},

	events : {

		"click button" : "selectCountry",
		"keyup #country-search" : "search"

	},

	selectCountry : function(e){

		Registry.get("customer").set("countryCode", $(e.currentTarget).attr("data-id"));
		Registry.get("customer").set("countryName", $(e.currentTarget).attr("data-name"));
		history.back();

		console.log(Registry);

	},

	search : function(e){
		Utilities.search($(e.currentTarget).val(), "#customer-country-select button");	
	}


});