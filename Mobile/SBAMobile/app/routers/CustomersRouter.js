var CustomersRouter = Backbone.Router.extend({

	view : false,

	routes : {
	
		"/customers/" : "listCustomers",
		"/customers/new/" : "newCustomer",
		"/customers/invoice/" : "newCustomerForInvoice",
		"/customers/list-invoice/" : "selectCustomerForInvoice",
		"/customers/save/" : "saveCustomer",
		"/customers/country/" : "selectCountry",
		"/customers/payment-terms/" : "selectPaymentTerms",
		"/customers/:id/" : "viewCustomer",
		"/customers/:id/edit/" : "editCustomer",
		"/customers/:id/delete/" : "deleteCustomer"
		
	},

	initialize : function(){
	
	},
	
	listCustomers : function(){
		
		var self = this;

		require(["views/customers/CustomersListView", "order!models/Customer", "order!collections/Customers"], function(){

			self.view = new CustomersListView();

		});
	
	},
	
	viewCustomer : function(id){
		
		var self = this;

		require(["views/customers/CustomerView", "models/Customer"], function(){

			self.view = new CustomerView(id);

		});
		
	},
	
	newCustomer : function(){
		
		var self = this;

		require(["views/customers/CustomerFormView", "models/Customer"], function(){

			self.view = new CustomerFormView();

		});
		
	},

	selectCountry : function(){

		var self = this;

		require(["views/customers/CountrySelectView", "models/Country", "collections/Countries"], function(){

			self.view = new CountrySelectView();

		});

	},

	selectPaymentTerms : function(){

		var self = this;

		require(["views/customers/PaymentTermsView", "models/PaymentTerm", "collections/PaymentTerms"], function(){

			self.view = new PaymentTermsView();

		});

	},

	newCustomerForInvoice : function(){

		var self = this;

		require(["views/customers/CustomerInvoiceFormView", "models/Customer"], function(){

			self.view = new CustomerInvoiceFormView();

		});

	},

	selectCustomerForInvoice : function(){
		
		var self = this;

		require(["views/customers/CustomerInvoiceListView", "order!models/Customer", "order!collections/Customers"], function(){

			self.view = new CustomerInvoiceListView();

		});

	},
	
	saveCustomer : function(){
		
		//console.log(Registry.get("customer"));

		Registry.get("customer").save({},{
			silent : true,
			success : function() { 
				
				if(!Registry.get("jumpTo")){
					location.hash = "/customers/";
				} else {
					location.hash = Registry.get("jumpTo");
					Registry.get("invoice").set("customerId", Registry.get("customer").id);
				}

				Registry.remove("customer");
				 
			} 
		});
		
	},
	
	editCustomer : function(id){
		
		var self = this;

		require(["views/customers/CustomerFormView", "models/Customer"], function(){

			self.view = new CustomerFormView(id);

		});
		
	},
	
	deleteCustomer : function(id){
		
		Registry.get("customer").destroy({ //assuming one has been selected from the list first and set to the Registry
			success : function(){ 
				Registry.remove("customer");
				location.hash = "/customers/"; 
			} 
		});
		
	}	


});
