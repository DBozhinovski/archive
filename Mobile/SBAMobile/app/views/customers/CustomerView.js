var CustomerView = Backbone.View.extend({

	id : false,

	$el : "div",

	attributes : {

		id : "customer-view",
		class : "wrapper"

	},

	initialize : function(id){

		this.id = id;
		this.render();

	},

	render : function(){

		var self = this;

		require(["text!templates/customers/customer-view.tpl"], function(template){

			var customer = new Customer();

			customer.id = self.id;

			customer.fetch({

				success : function(data){

					self.$el.html(Mustache.render(template, { "customer" : data.toJSON() }));
					$("#content").html(self.$el);
					return self;

				}

			});

		});

	}

});