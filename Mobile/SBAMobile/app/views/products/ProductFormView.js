var ProductFormView = Backbone.View.extend({

	id : false,

	$el : "div",

	attributes : {

		"id" : "product-form",
		"class" : "wrapper"
	},

	initialize : function(id){

		if(id){
			this.id = id;	
		}
		this.render();
		Gfx.hideFooter();

	},

	render : function(){

		var self = this;

		require(["text!templates/products/product-form.tpl", "text!templates/header/header-back.tpl"], function(template, header){

			var product = new Product();


			if(self.id){
				product.id = self.id;
			}

			if(!product.isNew()){

				product.fetch({

					success : function(data){

						if(!Registry.get("product")){

							Registry.set("product", data);

						}

						self.$el.html(Mustache.render(template, { product : Registry.get("product").toJSON() }));

						$("#content").html(self.$el);

						Gfx.showHeader(Mustache.render( header, { "link" : "#/products/", "back" : "Back", "title" : Registry.get("product").toJSON().name } ) );

						return self;

					}

				});		
			
			} else {

				if(!Registry.get("product")){

					Registry.set("product", product);

				}

				self.$el.html(Mustache.render(template, { product : Registry.get("product").toJSON() }));

				$("#content").html(self.$el);

				Gfx.showHeader(Mustache.render( header, { "link" : "#/products/", "back" : "Back", "title" :  Registry.get("product").toJSON().name  } ) );

				return self;

			}	
				

		});

	},

	events : {

		"keyup input" : "update"

	},

	update : function(e){

		Registry.get("product").set($(e.target).attr("id"), $(e.target).val());
		Registry.get("product").set("netUnitSalesPrice", parseFloat(Registry.get("product").toJSON().netUnitSalesPrice));
		Registry.get("product").set("netUnitCostPrice", 0);

	}
});