var Customers = Backbone.Collection.extend({

	model : Customer,
	
	url : Registry.get("apiRoot") + "/customers"

})
