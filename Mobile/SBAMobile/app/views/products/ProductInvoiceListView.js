var ProductInvoiceListView = Backbone.View.extend({

	$el : "div",

	collection : "",

	attributes : {

		id : "products-list",
		class : "wrapper"

	},

	initialize : function(){

		this.render();

	},

	render : function(){

		var self = this;

		require(["text!templates/products/products-list.tpl", "text!templates/header/header-back.tpl"], function(template, header){

			var products = new Products();

			products.fetch({

				success : function(data){

					self.$el.html(Mustache.render(template, { "products" : data.toJSON() }));
					$("#content").html(self.$el);
					Gfx.showHeader(Mustache.render( header, { "back" : "Back", "title" : "Select a Product" } ) );
					Gfx.hideFooter();

					self.collection = data;
					return self;

				}

			});

		});

	},

	events : {

		"click a" : "select"

	},

	select : function(e){

		e.preventDefault();
		Registry.set("product", this.collection.get($(e.currentTarget).attr("data-id")));
		location.hash = "/products/invoice/"

	} 

});