var Countries = Backbone.Collection.extend({

	model : Country,
	
	url : Registry.get("apiRoot") + "/countries"

});
