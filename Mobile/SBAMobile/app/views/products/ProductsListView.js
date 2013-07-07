var ProductsListView = Backbone.View.extend({

	$el : "div",

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
					return self;

				}

			});

		});

	},

	events : {

		"click a" : "select",
		"keyup #product-search" : "search"

	},

	select : function(e){

		e.preventDefault();
		Registry.remove("product");
		location.href = $(e.currentTarget).attr("href");

	},

	search : function(e){

		Utilities.search($(e.currentTarget).val(), "#products-list a");
			
	}

});