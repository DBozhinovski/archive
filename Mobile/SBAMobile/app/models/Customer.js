var Customer = Backbone.Model.extend({

	urlRoot : Registry.get("apiRoot") + "/customers",
	
	idAttribute : "id",
	
	defaults : {
		
		// "id" : "", //required
		"address" : "",
		"city" : "",
		"countryCode" : "", //required
		"countryName" : "",
		"email" : "",
		"homepage" : "",
		"name" : "", //required
		"paymentTermsId" : 2, //required - default to 14 days
		"phone" : "",
		"vatNumber" : "",
		"zip" : ""
		
	},
	
	validate : function(){
		
		
		
	}

});
