var Products = Backbone.Collection.extend({

	model : Product,
	
	url : Registry.get("apiRoot") + "/products/",
	
	initialize : function(){
	
		
	
	}

});
