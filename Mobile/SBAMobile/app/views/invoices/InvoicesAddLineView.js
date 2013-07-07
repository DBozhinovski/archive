var InvoicesAddLineView = Backbone.View.extend({

	id : false,

	$el : "div",

	attributes : {

		"id" : "add-line-form",
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

		require(["text!templates/invoices/invoice-add-line.tpl", "text!templates/header/header-back.tpl"], function(template, header){

			var productLine = new ProductLine();


			if(self.id){
				productLine.id = self.id;
			}

			if(!productLine.isNew()){

				productLine.fetch({

					success : function(data){

						if(!Registry.get("productLine")){

							Registry.set("productLine", data);

						}

						self.$el.html(Mustache.render(template, { productLine : Registry.get("productLine").toJSON() }));

						$("#content").html(self.$el);

						Gfx.showHeader(Mustache.render( header, { "link" : "#/invoices/", "back" : "Back", "title" : "Add Product" } ) );

						return self;

					}

				});		
			
			} else {

				if(!Registry.get("productLine")){

					Registry.set("productLine", productLine);

				}

				self.$el.html(Mustache.render(template, { productLine : Registry.get("productLine").toJSON() }));

				$("#content").html(self.$el);

				Gfx.showHeader(Mustache.render( header, { "link" : "#/invoices/", "back" : "Back", "title" :  "Add Product"  } ) );

				return self;

			}	
				

		});

	},

	events : {

		"keyup input" : "update"

	},

	update : function(e){

		Registry.get("productLine").set($(e.target).attr("id"), $(e.target).val());

	}
});