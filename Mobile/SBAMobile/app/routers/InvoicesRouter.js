var InvoicesRouter = Backbone.Router.extend({
	//ToDo: set invoice type in registry or routes?
	view : false,
	
	routes : {
	
		"/invoices/new/" : "newInvoice",
		"/invoices/create/" : "createInvoice",
		"/invoices/finalized/" : "listFinalizedInvoices",
		"/invoices/addLine/" : "addLine",
		"/invoices/:id/edit-line/" : "editLine",
		"/invoices/:id/edit-line-product/" : "editLineProduct",
		"/invoices/:id/edit/" : "editInvoice",
		"/invoices/:id/update/" : "updateInvoice",
		"/invoices/:id/delete/" : "deleteInvoice",
		"/invoices/:id/" : "viewInvoice",
		"/invoices/" : "listInvoices"
		
	},

	initialize : function(){
	
		//console.log("Invoices Router");
	
	},
	
	listInvoices : function(){
	
		var self = this;

		require(["views/invoices/InvoicesListView", "order!models/ProductLine", "order!collections/ProductLines", "order!models/DraftInvoice", "order!collections/DraftInvoices"], function(){

			self.view = new InvoicesListView();

		});
	
	},
	
	viewInvoice : function(id){
		
		console.log("Viewing invoice " + id);
		
		return;
		
	},
	
	newInvoice : function(){
		
		//console.log("New invoice form");
		
		var self = this;
		if (Registry.get("invoice")) {
			var i;
			var totalNet=0;
			for(i=0;i<Registry.get("invoice").get("lines").length;i++)
			{
				totalNet += Registry.get("invoice").get("lines")[i].sum;
			}
			Registry.get("invoice").set("totalNetAmount", totalNet);
			
			Registry.get("invoice").set("totalAmount", Registry.get("invoice").get("totalNetAmount") + Registry.get("invoice").get("totalVatAmount"));
		}
		
		require(["views/invoices/InvoiceFormView", "order!models/ProductLine", "order!collections/ProductLines", "order!models/DraftInvoice"], function(){
		
			self.view = new InvoiceFormView();
		
		});
		
		
	},
	
	createInvoice : function(){
		
		console.log("Sending new invoice data to API");
		
	},
	
	editInvoice : function(id){
		
		console.log("Editing customer " + id);
		
	},
	
	updateInvoice : function(id){
		
		console.log("Updating invoice " + id);
		
	},
	
	deleteInvoice : function(id){
		
		console.log("Deleting invoice " + id);
		
	},
	
	addLine: function()
	{
		var self = this;
		
		if(Registry.get("product") && !Registry.get("product").get("PropertyChangedFlag"))
			Registry.set("product",null);
		
		require(["views/products/ProductInvoiceFormView",  "order!models/ProductLine", "order!collections/ProductLines", "order!models/DraftInvoice"], function(){

			self.view = new ProductInvoiceFormView();

		});
	},	
	
	editLine: function(id)
	{
		var self = this;

		require(["views/products/ProductInvoiceFormView",  "order!models/ProductLine", "order!collections/ProductLines", "order!models/DraftInvoice"], function(){

			self.view = new ProductInvoiceFormView(null,id);

		});
	},	
	
	editLineProduct: function(id)
	{
		var self = this;

		require(["views/products/ProductInvoiceFormView",  "order!models/ProductLine", "order!collections/ProductLines", "order!models/DraftInvoice"], function(){

			self.view = new ProductInvoiceFormView();

		});
	}	

})
