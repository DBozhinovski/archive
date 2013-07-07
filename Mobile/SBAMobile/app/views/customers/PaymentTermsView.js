var PaymentTermsView = Backbone.View.extend({

	$el : "div",

	attributes : {

		id : "customer-payment-terms",
		class : "wrapper"

	},

	initialize : function(){

		this.render();

	},

	render : function(){

		var self = this;

		require(["text!templates/customers/customer-payment-terms.tpl", "text!templates/header/header-back.tpl"], function(template, header){

			var paymentTerms = new PaymentTerms();

			paymentTerms.fetch({

				success : function(data){

					self.$el.html(Mustache.render(template, { "paymentTerms" : data.toJSON()}));

					$("#content").html(self.$el);

					Gfx.showHeader(Mustache.render(header, { "back" : "Back", "title" : "Payment Terms" }) );
					Gfx.hideFooter();

				}

			});

		});

	},

	events : {

		"click button" : "selectPaymentTerms"

	},

	selectPaymentTerms : function(e){

		Registry.get("customer").set("paymentTermsId", $(e.currentTarget).attr("data-id"));
		Registry.get("customer").set("paymentTermsName", $(e.currentTarget).attr("data-name"));
		history.back();
		
	}

});