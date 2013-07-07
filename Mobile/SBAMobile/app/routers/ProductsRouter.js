var ProductsRouter = Backbone.Router.extend({

	routes : {
		
		"/products/" : "listProducts",
		"/products/new/" : "newProduct",
		"/products/invoice/" : "newProductForInvoice",
		
		"/products/save/" : "saveProduct",
		"/products/product-units/" : "selectUnit",
		"/products/product-types/" : "selectType",
		
		"/products/list-invoice/" : "selectProductForInvoice",
		
		"/products/create/" : "createProduct",
		"/products/:id/" : "viewProduct",
		"/products/:id/edit/" : "editProduct",
		"/products/:id/add-invoice/" : "addProductToInvoice",
		"/products/:id/update/" : "updateProduct",
		"/products/:id/delete/" : "deleteProduct",
	
	},

	initialize : function(){
		
		console.log("Product router");
		require(["models/Product"]);
	},
	
	listProducts : function()
	{
		console.log("products list");
		var self = this;

		require(["views/products/ProductsListView", "order!models/Product", "order!collections/Products"], function(){

			self.view = new ProductsListView();

		});
	},
	
	viewProduct : function(id)
	{
		console.log("product" + id);
		
		var self = this;

		require(["views/products/ProductView", "models/Product"], function(){

			self.view = new ProductView(id);

		});
	},
	
	newProduct : function()
	{
		console.log("New product");
		var self = this;

		require(["views/products/ProductFormView", "models/Product"], function(){

			self.view = new ProductFormView();

		});
	},
	
	newProductForInvoice : function(){

		var self = this;

		require(["views/products/ProductInvoiceFormView", "models/Product"], function(){

			self.view = new ProductInvoiceFormView();

		});

	},
	
	selectProductForInvoice : function(){
		
		var self = this;

		require(["views/products/ProductInvoiceListView", "order!models/Product", "order!collections/Products"], function(){

			self.view = new ProductInvoiceListView();

		});

	},
	
	createProduct : function()
	{
		console.log("Creating product");
	},
	
	editProduct : function(id)
	{
		console.log("Edit product");
		
		var self = this;

		require(["views/products/ProductFormView", "models/Product"], function(){

			self.view = new ProductFormView(id);

		});
	},
	
	updateProduct : function(id)
	{
		console.log("Updating product");
	},
	
	deleteProduct : function(id)
	{
		console.log("Deleting product");
		
		Registry.get("product").destroy({ //assuming one has been selected from the list first and set to the Registry
			success : function(){ 
				Registry.remove("product");
				location.hash = "/products/"; 
			} 
		});
	},
	
	saveProduct : function(){
		
		//console.log(Registry.get("product"));
		
//		Registry.get("product").set("netUnitSalesPrice", parseFloat(Registry.get("product").toJSON().netUnitSalesPrice));
//		Registry.get("product").set("netUnitCostPrice", 0);
				
		Registry.get("product").save({},{
			silent : true,
			success : function() { 
				
				if(!Registry.get("jumpTo")){
				location.hash = "/products/"; //it is perhaps better to set this through the Registry
				} else {
					location.hash = Registry.get("jumpTo");
					Registry.get("invoice").set("productId", Registry.get("product").id);
				}
				
				Registry.remove("product");
			} 
		});
		
	},

	selectUnit : function(){
		
		var self = this;

		require(["views/products/UnitSelectView", "models/Unit", "collections/Units"], function(){

			self.view = new UnitSelectView();

		});

	},
	
	selectType : function(){

		var self = this;

		require(["views/products/ProductTypeSelectView", "models/ProductType", "collections/ProductTypes"], function(){

			self.view = new ProductTypeSelectView();

		});

	},

})
