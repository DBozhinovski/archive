var InvoiceFormView = Backbone.View.extend({

	id : false,

	$el : "div",
	
	attributes : {
	
		"id" : "invoice-form",
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
		
		require(["text!templates/invoices/invoice-form.tpl", "text!templates/header/header-back.tpl"], function(template, header){
		
			var invoice = new DraftInvoice();

			if(self.id){
				invoice.id = self.id;
			}

			if(!invoice.isNew()){

				invoice.fetch({

					success : function(data){
						
						if(!Registry.get("invoice")){

							Registry.set("invoice", data);

						}

						self.$el.html(Mustache.render(template, {"invoice": data.toJSON()}));

						$("#content").html(self.$el);

						Gfx.showHeader(Mustache.render( header, { "back" : "Back", "title" : "Invoice" } ) );

						return self;
						
					}

				});

			} else {

				

				if(!Registry.get("invoice")){

					//Placeholders for the form - important for internationalization	
					invoice.set("customer_details", false);
					invoice.set("name_placeholder", "Customer"); //translated
					invoice.set("has_notes", false);
					invoice.set("notes_placeholder", "Notes"); //translated
					invoice.set("notes_message", "Visible to customer"); //translated
					invoice.set("paymentTermsName", "Invoice date + 14 days"); //translated

					Registry.set("invoice", invoice);

				}



				self.$el.html(Mustache.render(template, {"invoice": Registry.get("invoice").toJSON()}));

				$("#content").html(self.$el);

				Gfx.showHeader(Mustache.render( header, { "back" : "Back", "title" : "Invoice" } ) );

				return self;

			}
			
		
		});
	
	},
	
	events : {
	
		
	
	}
	
	

});
