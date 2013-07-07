var CustomerInvoiceListView = Backbone.View.extend({

	$el : "div",

	collection : "",

	attributes : {

		id : "customers-list",
		class : "wrapper"

	},

	initialize : function(){

		this.render();

	},

	render : function(){

		var self = this;

		require(["text!templates/customers/customers-list.tpl", "text!templates/header/header-back.tpl"], function(template, header){

			var customers = new Customers();

			customers.fetch({

				success : function(data){

					self.$el.html(Mustache.render(template, { "customers" : data.toJSON() }));
					$("#content").html(self.$el);
					Gfx.showHeader(Mustache.render( header, { "back" : "Back", "title" : "Select a Customer" } ) );
					Gfx.hideFooter();

					self.collection = data;
					return self;

				}

			});

		});

	},

	events : {

		"click a" : "select",
		"keyup #customer-search" : "search"

	},

	select : function(e){

		e.preventDefault();
		Registry.set("customer", this.collection.get($(e.currentTarget).attr("data-id")));
		location.hash = "/customers/invoice/"

	},

	search : function(e){
		Utilities.search($(e.currentTarget).val(), "#customers-list a");	
	} 

});