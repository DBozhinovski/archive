//This one is listing the drafts, in order to have a fully by-convention RESTful routing for invoices
//The finalized/bookes invoices are listed by invoices/finalized/ (InvoicesRouter.js)
var InvoicesListView = Backbone.View.extend({

	$el : "div",

	attributes : {

		"id" : "invoices-list",
		"class" : "wrapper"

	},

	initialize : function(){

		this.render();

	},

	render : function(){

		var self = this;

		require(["text!templates/invoices/invoices-list.tpl", "text!templates/header/header-back.tpl"], function(template, header){

			var invoices = new DraftInvoices();

			invoices.fetch({

				success : function(data){

					self.$el.html(Mustache.render(template, {"invoices": data.toJSON()}));

					$("#content").html(self.$el);

					Gfx.showHeader(Mustache.render( header, { "back" : "Back", "title" : "Draft Invoices" } ) );
					Gfx.hideFooter();

					return self;

				}

			});

		});

	},

	events : {

		"keyup #invoice-search" : "search"

	},

	search : function(e){
		Utilities.search($(e.currentTarget).val(), "#invoices-list a");	
	}

});