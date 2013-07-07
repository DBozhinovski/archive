var CustomerFormView = Backbone.View.extend({

	id : false,

	$el : "div",

	attributes : {

		"id" : "customer-form",
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

		require(["text!templates/customers/customer-form.tpl", "text!templates/header/header-back.tpl"], function(template, header){

			var customer = new Customer();


			if(self.id){
				customer.id = self.id;
			}

			if(!customer.isNew()){

				customer.fetch({

					success : function(data){

						if(!Registry.get("customer")){

							Registry.set("customer", data);

						}

						self.$el.html(Mustache.render(template, { customer : Registry.get("customer").toJSON() }));

						$("#content").html(self.$el);

						Gfx.showHeader(Mustache.render( header, { "link" : "#/customers/", "back" : "Back", "title" : "Add Customer" } ) );

						return self;

					}

				});		
			
			} else {

				if(!Registry.get("customer")){

					Registry.set("customer", customer);

				}

				self.$el.html(Mustache.render(template, { customer : Registry.get("customer").toJSON() }));

				$("#content").html(self.$el);

				Gfx.showHeader(Mustache.render( header, { "link" : "#/customers/", "back" : "Back", "title" : "Add Customer" } ) );

				return self;

			}	
				

		});

	},

	events : {

		"keyup input" : "update"

	},

	update : function(e){

		Registry.get("customer").set($(e.target).attr("id"), $(e.target).val());

	}
});