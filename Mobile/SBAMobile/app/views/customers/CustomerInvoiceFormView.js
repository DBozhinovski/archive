var CustomerInvoiceFormView = Backbone.View.extend({

	id : false,

	$el : "div",

	attributes : {

		"id" : "invoice-customer",
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

		require(["text!templates/customers/customer-invoice-form.tpl", "text!templates/header/header-back.tpl"], function(template, header){

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

				Gfx.showHeader(Mustache.render( header, { "back" : "Back", "title" : "Add Customer" } ) );

				return self;

			}	
				

		});

	},

	events : {

		"keyup input" : "update",
		"click #add" : "add",
		"click #save" : "save"

	},

	update : function(e){

		Registry.get("customer").set($(e.target).attr("id"), $(e.target).val());

	},

	add : function(e){

		e.preventDefault();
		
		//Create an object, and set that object to the invoice afterwards, instead of writing a bajillion lines
		Registry.get("invoice").set("customerName", Registry.get("customer").get("name"));
		Registry.get("invoice").set("customerAddress", Registry.get("customer").get("address"));
		Registry.get("invoice").set("customerCity", Registry.get("customer").get("city"));
		Registry.get("invoice").set("customerZip", Registry.get("customer").get("zip"));
		Registry.get("invoice").set("customerCountryName", Registry.get("customer").get("countryName"));
		Registry.get("invoice").set("customerCountry", Registry.get("customer").get("countryCode"));
		Registry.get("invoice").set("paymentTermsId", Registry.get("customer").get("paymentTermsId"));
		Registry.get("invoice").set("paymentTermsName", Registry.get("customer").get("paymentTermsName"));
		Registry.get("invoice").set("customer_details", true);
		
		location.hash = "/invoices/new/";

	},

	save : function(e){
		
		e.preventDefault();
		
		//Create an object, and set that object to the invoice afterwards, instead of writing a bajillion lines
		Registry.get("invoice").set("customerName", Registry.get("customer").get("name"));
		Registry.get("invoice").set("customerAddress", Registry.get("customer").get("address"));
		Registry.get("invoice").set("customerCity", Registry.get("customer").get("city"));
		Registry.get("invoice").set("customerZip", Registry.get("customer").get("zip"));
		Registry.get("invoice").set("customerCountryName", Registry.get("customer").get("countryName"));
		Registry.get("invoice").set("customerCountry", Registry.get("customer").get("countryCode"));
		Registry.get("invoice").set("paymentTermsId", Registry.get("customer").get("paymentTermsId"));
		Registry.get("invoice").set("paymentTermsName", Registry.get("customer").get("paymentTermsName"));
		Registry.get("invoice").set("customer_details", true);
		
		Registry.set("jumpTo","/invoices/new/");
		location.hash = "/customers/save/";

	}
	
});