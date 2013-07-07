var DraftInvoice = Backbone.Model.extend({

	urlRoot : Registry.get("apiRoot") + "/sales/draftinvoices/",
	
	idAttribute : "id",

	defaults : {
	
		// "id" : "", //required
		"customerAddress" : "",
		"customerCity" : "",
		"customerCountry" : "",
		"customerCountryName" : "",
		"customerId" : "",
		"customerName" : "",
		"customerVATNumber" : "",
		"customerZip" : "",
		"date" : new Date().toLocaleDateString(),
		"defaultPaymentTermsId" : "",
		"dueDate" : "",
		"heading" : "",
		"lines" : [], // a collection of lines
		"paymentTermsId" : "",
		"totalAmount" : 0.0,
		"totalNetAmount" : 0.0,
		"totalVatAmount" : 0.0
	
	},
	
	validate : function(){
	
	
	
	}

});


