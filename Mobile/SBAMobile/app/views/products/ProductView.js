var ProductView = Backbone.View.extend({

	id : false,

	$el : "div",

	attributes : {

		id : "product-view",
		class : "wrapper"

	},

	initialize : function(id){

		this.id = id;
		this.render();

	},

	render : function(){

		var self = this;

		require(["text!templates/products/product-view.tpl"], function(template){

			var product = new Product();

			product.id = self.id;

			product.fetch({

				success : function(data){

					self.$el.html(Mustache.render(template, { "product" : data.toJSON() }));
					$("#content").html(self.$el);
					return self;

				}

			});

		});

	}

});