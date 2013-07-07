var UnitSelectView = Backbone.View.extend({

	$el : "div",

	attributes : {

		id : "product-unit-select",
		class : "wrapper"

	},

	initialize : function(){

		this.render();

	},

	render : function(){

		var self = this;

		require(["text!templates/products/product-unit.tpl", "text!templates/header/header-back.tpl"], function(template, header){

			var units = new Units();

			units.fetch({

				success : function(data){

					self.$el.html(Mustache.render(template, {"Units" : data.toJSON()}));

					$("#content").html(self.$el);

					Gfx.showHeader(Mustache.render( header, { "back" : "Back", "title" : "Select Unit" } ) );
					Gfx.hideFooter();

					return self;

				}

			})

		});

	},

	events : {

		"click button" : "selectUnit"

	},

	selectUnit : function(e){

		Registry.get("product").set("unitId", parseInt($(e.currentTarget).attr("data-id")));
		Registry.get("product").set("unitName", $(e.currentTarget).attr("data-name"));
		
		Registry.get("product").set("PropertyChangedFlag",true);
		
		
		history.back();

		console.log(Registry);

	}


});