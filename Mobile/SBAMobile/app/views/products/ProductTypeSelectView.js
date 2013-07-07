var ProductTypeSelectView = Backbone.View.extend({

	$el : "div",

	attributes : {

		id : "product-type-select",
		class : "wrapper"

	},

	initialize : function(){

		this.render();

	},

	render : function(){

		var self = this;

		require(["text!templates/products/product-type.tpl", "text!templates/header/header-back.tpl"], function(template, header){

			var types = new ProductTypes();

			types.fetch({

				success : function(data){

					self.$el.html(Mustache.render(template, {"ProductTypes" : data.toJSON()}));

					$("#content").html(self.$el);

					Gfx.showHeader(Mustache.render( header, { "back" : "Back", "title" : "Select Type" } ) );
					Gfx.hideFooter();

					return self;

				}

			})

		});

	},

	events : {

		"click button" : "selectType"

	},

	selectType : function(e){

		Registry.get("product").set("productTypeId", parseInt($(e.currentTarget).attr("data-id")));
		Registry.get("product").set("productTypeName", $(e.currentTarget).attr("data-name"));
		
		Registry.get("product").set("PropertyChangedFlag",true);
		history.back();

		console.log(Registry);

	}


});