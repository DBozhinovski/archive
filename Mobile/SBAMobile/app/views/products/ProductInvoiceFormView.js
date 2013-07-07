var ProductInvoiceFormView = Backbone.View.extend({

	id : false,
	
	lineIndex: false,

	$el : "div",

	attributes : {

		"id" : "invoice-product",
		"class" : "wrapper"
	},

	initialize : function(id,lineIndex){

		if(id){
			this.id = id;	
		}
		if(lineIndex)
		{
			this.lineIndex = lineIndex;
		}
		
		
		this.render();
		Gfx.hideFooter();

	},

	render : function(){

		var self = this;

		require(["text!templates/products/product-invoice-form.tpl", "text!templates/header/header-back.tpl"], function(template, header){

			var product = new Product();


			if(self.id){
				product.id = self.id;
			}
			if(self.lineIndex)
			{
//				product = Registry.get("invoice").get("lines")[self.lineIndex];
				product.set("description", Registry.get("invoice").get("lines")[self.lineIndex].description);
				product.set("id", Registry.get("invoice").get("lines")[self.lineIndex].productId);
				product.set("name", Registry.get("invoice").get("lines")[self.lineIndex].productName);
				product.set("productTypeId",Registry.get("invoice").get("lines")[self.lineIndex].productTypeId);
				product.set("productTypeName", Registry.get("invoice").get("lines")[self.lineIndex].productTypeName);
				product.set("unitId", Registry.get("invoice").get("lines")[self.lineIndex].unitId);
				product.set("unitName", Registry.get("invoice").get("lines")[self.lineIndex].unitName);
				product.set("netUnitSalesPrice", Registry.get("invoice").get("lines")[self.lineIndex].unitPrice);
				product.set("quantity", Registry.get("invoice").get("lines")[self.lineIndex].quantity);
				product.set("lineIndex", self.lineIndex);
//				product.name = product.productName;
//				product.netUnitSalesPrice = product.unitPrice;
				
				Registry.set("product", product);
							
				self.$el.html(Mustache.render(template, {
					product:  Registry.get("product").toJSON()
				} ));

				$("#content").html(self.$el);

				Gfx.showHeader(Mustache.render( header, { "back" : "Back", "title" : "Add Product" } ) );

				return self;
			}
			
			
			else if(!product.isNew()){
//			if(product.productId != null){

				product.fetch({

					success : function(data){

						if(!Registry.get("product")){

							Registry.set("product", data);

						}					
						

						self.$el.html(Mustache.render(template, { product : Registry.get("product").toJSON() }));

						$("#content").html(self.$el);

						Gfx.showHeader(Mustache.render( header, { "link" : "#/products/", "back" : "Back", "title" : "Add Product" } ) );

						return self;

					}

				});		
			
			} else {

				if(!Registry.get("product")){

					Registry.set("product", product);

				}
							

				self.$el.html(Mustache.render(template, { product : Registry.get("product").toJSON() }));

				$("#content").html(self.$el);

				Gfx.showHeader(Mustache.render( header, { "back" : "Back", "title" : "Add Product" } ) );

				return self;

			}	
				

		});

	},

	events : {

		"keyup input" : "update",
		"click #add" : "add",
		"click #save" : "save",
		"click #edit" : "edit",
		"click #saveEdited" : "saveEdited"
	},

	update : function(e){

		Registry.get("product").set($(e.target).attr("id"), $(e.target).val());

	},

	add : function(e){

		e.preventDefault();
		
		var line = {
			description: Registry.get("product").get("description"),
			draftInvoiceId: 0,
			netAmount: 0,
			productId: Registry.get("product").get("id"),
			productName: Registry.get("product").get("name"),
			productTypeId: Registry.get("product").get("productTypeId"),
			productTypeName: Registry.get("product").get("productTypeName"),
			quantity: Registry.get("product").get("quantity"),
			sortOrder: "",
			taxAmount: "",
			unitId: Registry.get("product").get("unitId"),
			unitName: Registry.get("product").get("unitName"),
			lineIndex: (Registry.get("invoice").get("lines") != undefined) ? Registry.get("invoice").get("lines").length : null,
			unitPrice: Registry.get("product").get("netUnitSalesPrice"),
			vatCode: 0,
			vatRate: 0,
			sum: Registry.get("product").get("netUnitSalesPrice")*Registry.get("product").get("quantity"),
		};
		
		if(Registry.get("invoice").get("lines") != undefined)
			Registry.get("invoice").get("lines").push(line);
		
		Registry.set("product","");
		location.hash = "/invoices/new/";

	},
	
	edit : function(e){

		e.preventDefault();
						
		var line = {
			description: Registry.get("product").get("description"),
			draftInvoiceId: 0,
			netAmount: 0,
			productId: Registry.get("product").get("id"),
			productName: Registry.get("product").get("name"),
			productTypeId: Registry.get("product").get("productTypeId"),
			productTypeName: Registry.get("product").get("productTypeName"),
			quantity: Registry.get("product").get("quantity"),
			sortOrder: "",
			taxAmount: "",
			unitId: Registry.get("product").get("unitId"),
			unitName: Registry.get("product").get("unitName"),
			lineIndex: (Registry.get("invoice").get("lines") != undefined) ? Registry.get("product").get("lineIndex") : null,
			unitPrice: Registry.get("product").get("netUnitSalesPrice"),
			vatCode: 0,
			vatRate: 0,
			sum: Registry.get("product").get("netUnitSalesPrice")*Registry.get("product").get("quantity"),
		};
		
		if (Registry.get("invoice").get("lines") != undefined) {
			Registry.get("invoice").get("lines")[Registry.get("product").get("lineIndex")] = line;
			
		}
		Registry.set("product","");
		location.hash = "/invoices/new/";

	},

	save : function(e){
		
		e.preventDefault();
		
		var line = {
			description: Registry.get("product").get("description"),
			draftInvoiceId: 0,
			netAmount: 0,
			productId: Registry.get("product").get("id"),
			productName: Registry.get("product").get("name"),
			productTypeId: Registry.get("product").get("productTypeId"),
			productTypeName: Registry.get("product").get("productTypeName"),
			quantity: Registry.get("product").get("quantity"),
			sortOrder: "",
			taxAmount: "",
			unitId: Registry.get("product").get("unitId"),
			unitName: Registry.get("product").get("unitName"),
			lineIndex: (Registry.get("invoice").get("lines") != undefined) ? Registry.get("invoice").get("lines").length : null,
			unitPrice: Registry.get("product").get("netUnitSalesPrice"),
			vatCode: 0,
			vatRate: 0,
			sum: Registry.get("product").get("netUnitSalesPrice")*Registry.get("product").get("quantity"),
		};
		
		if(Registry.get("invoice").get("lines") != undefined)
			Registry.get("invoice").get("lines").push(line);
		
		Registry.set("jumpTo","/invoices/new/");
		location.hash = "/products/save/";

	},
	
	saveEdited : function(e){

		e.preventDefault();
						
		var line = {
			description: Registry.get("product").get("description"),
			draftInvoiceId: 0,
			netAmount: 0,
			productId: Registry.get("product").get("id"),
			productName: Registry.get("product").get("name"),
			productTypeId: Registry.get("product").get("productTypeId"),
			productTypeName: Registry.get("product").get("productTypeName"),
			quantity: Registry.get("product").get("quantity"),
			sortOrder: "",
			taxAmount: "",
			unitId: Registry.get("product").get("unitId"),
			unitName: Registry.get("product").get("unitName"),
			lineIndex: (Registry.get("invoice").get("lines") != undefined) ? Registry.get("product").get("lineIndex") : null,
			unitPrice: Registry.get("product").get("netUnitSalesPrice"),
			vatCode: 0,
			vatRate: 0,
			sum: Registry.get("product").get("netUnitSalesPrice")*Registry.get("product").get("quantity"),
		};
		
		if (Registry.get("invoice").get("lines") != undefined) {
			Registry.get("invoice").get("lines")[Registry.get("product").get("lineIndex")] = line;
			
		}
		
		Registry.set("jumpTo","/invoices/new/");
		location.hash = "/products/save/";

	},
	
});