var Product = Backbone.Model.extend({
	
	urlRoot: Registry.get("apiRoot") + "/products", 
	
	idAttribute: "id",
	
	defaults: {
		// "id": "",
		"unitId": "",
		"unitName": "",
		"name": "",
		"description": "",
		"netUnitSalesPrice": "",
		"netUnitCostPrice": "",
		"productTypeId": "",
		"productTypeName": "",
		"sku": ""
	},
	
	validate: function(){
	
		
	
	}	
	
});
