var Invoices = Backbone.Collection.extend({

	model : Invoice,
	
	url : Registry.get("apiRoot") + "/sales/invoices/"

});
