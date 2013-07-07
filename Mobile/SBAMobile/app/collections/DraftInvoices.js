var DraftInvoices = Backbone.Collection.extend({

	model : DraftInvoice,
	
	url : Registry.get("apiRoot") + "/sales/draftinvoices/"

});
