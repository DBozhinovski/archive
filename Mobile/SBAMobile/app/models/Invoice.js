//! requires:  ProductLines Collection and ProductLine Model
var Invoice = Backbone.Model.extend({

	urlRoot : Registry.get("apiRoot") + "/sales/invoices/",

	idAttribute : "id",

	defaults : {
		//all attributes are required
		// "id" : "", 
		"customerAddress" : "", 
		"customerCity" : "", 
		"customerCountry" : "", 
		"customerCountryName" : "",
		"customerId" : "",
		"customerName" : "",
		"customerVATNumber" : "",
		"customerZip" : "",
		"date" : "",
		"defaultPaymentTermsId" : "",
		"dueDate" : "",
		"heading" : "",
		"lines" : [], // a collection of lines
		"paymentTermsId" : "",
		"totalAmount" : "",
		"totalNetAmount" : "",
		"totalVatAmount" : ""
	
	},
	
	validate : function(){
	
		
	
	}

});
