// Cries for refactoring - but - make it work -> make it right -> make it fast!
// @dev: maybe add an additional router layer, because of the lack of real controllers in Backbone;
// currently, it is way too un-DRY for my taste

var InvoiceView = Backbone.View.extend({

	invoice : "",
	
	id : "",

	prepare : function(){
	
		var execute = Registry.get("execute");
		
		console.log(execute);
		
		switch(execute){
		
			case "Invoice:reset" : {
			
				Registry.set("invoice", false);
				
				Registry.set("execute", false);
				
				break;
			
			}
			
			case "Customer:save" : {
				//change method to put if a customer is updated and append their id in the api
				$.ajax({
				
					url: "http://mvp-sba.herokuapp.com/customers/",
					headers: { "x-token": localStorage.getItem("token") },
					dataType: "json",
					contentType: "application/json",
					type: "POST",
					data: JSON.stringify(Registry.get("invoice").customer_details),
					success: function(data){
						console.log(data);
						
						Registry.set("execute", false);
						Registry.set("parameters", false);
					},
					error: function(error){
						console.log(error);
					}
					
				
				});
			
				break;
			
			}
			
			case "Product:save" : {
				//change method to put if a product is updated and append it's id in the api
				var data = Registry.get("invoice").lines.products[Registry.get("parameters")];
				
				data.netUnitSalesPrice = parseFloat(data.netUnitSalesPrice);
				data.netUnitCostPrice = data.netUnitSalesprice;
				data.unitId = parseInt(data.unitId);
				data.productTypeId = parseInt(data.productTypeId);
				
				console.log(JSON.stringify(data));
				
				$.ajax({
				
					url: "http://mvp-sba.herokuapp.com/products/",
					headers: { "x-token": localStorage.getItem("token") },
					dataType: "json",
					contentType: "application/json",
					type: "POST",
					data: JSON.stringify(data),
					success: function(data){
						console.log(data);
						
						Registry.set("execute", false);
						Registry.set("parameters", false);
					},
					error: function(error){
						console.log(error);
					}
					
				
				});
			
				break;
			
			}
		
		}
	
	},

	//too controller-like to be in a view... perhaps a separate controller object? ^
	initialize : function(action, id){
	
		var token = localStorage.getItem("token");
		
		if(!token || token === "undefined"){
		
			window.location.href = "#/register/";
		
		} else {
		
			this.prepare();
	
			if(action || id){
			
				this.id = id;
			
				switch(action){
				
					case "new" : {
				
						this.invoiceForm();
					
						break;
					
					}
				
					case "edit" : {
					
						this.invoiceForm();
					
						break;
					
					}
				
					case "list" : {
					
						this.invoiceList();
					
						break;
					
					}
				
					case "customer" : {
				
						this.customerForm();
					
						break;
				
					}
				
					case "date" : {
				
						this.dateForm();
					
						break;
				
					}
				
					case "payment-terms" : {
				
						this.paymentTermsForm();
					
						break;
				
					}
				
					case "notes" : {
					
						this.notesForm();
					
						break;
					
					}
				
					case "add-line" : {
					
						this.addLine();
					
						break;
					
					}
					
					case "edit-line" : {
					
						this.editLine();
						
						break;
					
					}
					
					case "country" : {
					
						this.countryForm();
						
						break;
					
					}
					
					case "product-unit" : {
					
						this.productUnitForm();
						
						break;
					
					}
					
					case "product-type" : {
					
						this.productTypeForm();
						
						break;
					
					}
					
					case "customer-list" : {
					
						this.customerList();
						
						break;
					
					}
					
					case "product-list" : {
						
						this.productList();
						
						break;
					
					}
				
				}
			
			} else {
		
				this.home();
		
			}
		
		}
	
	},
	
	home : function(){
	
		require(["text!templates/header-home.tpl", "text!templates/footer-navigation.tpl", "text!templates/home.tpl"], function(header, footer, template){
			
			var output = Mustache.render(header, "");
			$("#header").html(output);
			Gfx.showHeader();
			
			output = Mustache.render(footer, "");
			$("#footer").html(output);
			Gfx.showFooter();
			
			Gfx.setActive("home");
			
			output = Mustache.render(template, "");
			$("#content").html(output);	
			
			Gfx.hideLoader();
			
		});
		
	
	},
	
	invoiceForm : function(){
	
		var self = this;
		var value = 0.0, tax = 0.0, total = 0.0;
	
		require(["text!templates/header-back.tpl", "text!templates/invoice-form.tpl"], function(header, template){
				
			
					
			var data = {
				
				"link" : "#/invoice/",
				"title" : "Invoice",
				"back" : "Back"
				
			}
			
			var output = Mustache.render(header, data);
			
			$("#header").html(output);
			
			Gfx.hideFooter();
			Gfx.removeActive();
			
			var date = new Date();
			
			
		
			if(!Registry.get("invoice")){
			
				self.invoice = {};
			
				self.invoice.customer_details = {
			
					name : "",
					placeholder : "Customer",
					details : false,
					address : "",
					postcode : "",
					city: "",
					country : ""
				};
				
				self.invoice.date = {
					
					date : date.toLocaleDateString()
					
				};
				
				self.invoice.payment_terms = {
					
					payment_terms : "14 days",
					paymentTermsId : 2
					//to be connected to API
					
				};
				
				self.invoice.notes = {
				
					placeholder : "Visible to client",
					value : false,
					notes : "",
				
				};
				
				self.invoice.lines = {
					
					products : []
					
				};
				
				Registry.set("invoice", self.invoice);

			} else {
			
				self.invoice = Registry.get("invoice");
			
			}
		
			
		
			if(self.invoice.lines.products.length > 0){
			
				var products = self.invoice.lines.products;
				
				$.ajax({
					url: "http://mvp-sba.herokuapp.com/sales/vatmatrix/codes/" + self.invoice.customer_details.country,
					headers: { "x-token": localStorage.getItem("token")},
					dataType: "json",
					type: "GET",
					success: function(data){
						
						total = parseFloat(total);
						value = parseFloat(value);
						tax = parseFloat(tax);
						
						for(i = 0, length = products.length; i < length; i++){
				
							products[i]["sum"] = parseFloat(products[i].quantity) * parseFloat(products[i].netUnitSalesPrice);
							products[i]["sum"] = products[i]["sum"].toFixed(2);
				
							value += parseFloat(products[i]["sum"]);
							
							
							for(j = 0; j < data.length; j++){
							
								if(products[i].type == data[j].productTypeId){
								
									tax += products[i]["sum"] * parseFloat(data[j].rate);
								
								}
							
							}
							
							total = value + tax;
				
						}
						
						var dataVat = {
						
							invoice : self.invoice,
							value : value,
							tax: tax,
							total: total
						
						}
						
						output = Mustache.render(template, dataVat);
			
						$("#content").html(output);
			
						Gfx.hideLoader();
						
						
						
					}, 
					error:function(){
						console.log("Error");
					}
		
				});
			
				
			
			} else {
			
				data = {
			
					invoice : self.invoice
			
				}
				
				output = Mustache.render(template, data);
			
				$("#content").html(output);
			
				Gfx.hideLoader();
				
			}
		
			
		
			
		
		});
	
	
	},
	
	customerForm : function(){
	
		var self = this;
	
		require(["text!templates/header-cancel-done.tpl", "text!templates/invoice-customer.tpl"], function(header, template){
					
			var data = {
				
				"link-cancel" : "#/invoice/edit/",
				"title" : "Customer Details",
				"cancel" : "Cancel",
				"link-done" : "#/invoice/edit/",
				"done" : "Done"
				
			}
			
			var output = Mustache.render(header, data);
			
			$("#header").html(output);
			
			Gfx.hideFooter();
			Gfx.removeActive();
		
		
			data = {
				customer : Registry.get("invoice").customer_details
			}
			
			var output = Mustache.render(template, data);
			
			$("#content").html(output);
			
			self.bind("customer");
			
			Gfx.hideLoader();
			
		});
		
	
	},
	
	dateForm : function(){
	
		var self = this;
	
		require(["text!templates/header-cancel-done.tpl", "text!templates/invoice-date.tpl"], function(header, template){
					
			data = {
				
				"link-cancel" : "#/invoice/edit/",
				"title" : "Date",
				"cancel" : "Cancel",
				"link-done" : "#/invoice/edit/",
				"done" : "Done"
				
			}
			
			var output = Mustache.render(header, data);
			
			$("#header").html(output);
			
			Gfx.hideFooter();
			Gfx.removeActive();
		
			var date = {
			
				date : Registry.get("invoice").date
			
			}
		
			output = Mustache.render(template, date);
			
			$("#content").html(output);
			
			self.bind("date");
			
			Gfx.hideLoader();
			
		});
	
	},
	
	paymentTermsForm : function(){
	
		var self = this;
	
		require(["text!templates/header-back.tpl", "text!templates/invoice-payment.tpl"], function(header, template){
					
			var data = {
				
				"link" : "#/invoice/edit/",
				"title" : "Payment Terms",
				"back" : "Back"
				
			}
			
			var output = Mustache.render(header, data);
			
			$("#header").html(output);
			
			Gfx.hideFooter();
			Gfx.removeActive();
		
			//request payment terms
			
			output = Mustache.render(template, "");
			
			$("#content").html(output);
			
			self.bind("terms");
			
			Gfx.hideLoader();
			
		});
	
	},
	
	notesForm : function(){
	
		var self = this;
		
		require(["text!templates/header-cancel-done.tpl", "text!templates/invoice-notes.tpl"], function(header, template){
					
			data = {
				
				"link-cancel" : "#/invoice/edit/",
				"title" : "Notes",
				"cancel" : "Cancel",
				"link-done" : "#/invoice/edit/",
				"done" : "Done"
				
			}
			
			var output = Mustache.render(header, data);
			
			$("#header").html(output);
			
			Gfx.hideFooter();
			Gfx.removeActive();
		
			var notes = {
				
				notes : Registry.get("invoice").notes
			
			}
		
			output = Mustache.render(template, notes);
			
			$("#content").html(output);
			
			self.bind("notes");
			
			Gfx.hideLoader();
			
		});
	
	},
	
	addLine : function(id){
	
		var self = this;
	
		require(["text!templates/header-cancel-done.tpl", "text!templates/invoice-add-line.tpl"], function(header, template){
					
			var data = {
				
				"link-cancel" : "#/invoice/edit/",
				"title" : "Line Details",
				"cancel" : "Cancel",
				"link-done" : "#/invoice/edit/",
				"done" : "Done"
				
			}
			
			var output = Mustache.render(header, data);
			
			$("#header").html(output);
			
			Gfx.hideFooter();
			Gfx.removeActive();
		
			var id = self.id;
		
			if(!id){
			
				data = {
			
					product : true,
					product_id: "none"
			
				}
			
			} else {
				
				data = {
					product: Registry.get("invoice").lines.products[id],
					product_id: id
				}
				
			}
			
		
			output = Mustache.render(template, data);
			
			$("#content").html(output);
			
			self.bind("addline");
			
			Gfx.hideLoader();
			
		});
	
	},
	
	editLine : function(){
	
		 this.addLine(Registry.get("product_id"));
	
	},
	
	countryForm : function(){
	
		var self = this;
	
		require(["text!templates/header-cancel-done.tpl", "text!templates/invoice-country.tpl"], function(header, template){
					
			var data = {
				
				"link-cancel" : "#/invoice/customer/",
				"title" : "Country",
				"cancel" : "Cancel",
				"link-done" : "#/invoice/customer/",
				"done" : "Done"
				
			}
			
			var headerOutput = Mustache.render(header, data);
			
			Gfx.hideFooter();
			Gfx.removeActive();
			
			$.ajax({
				url: "http://mvp-sba.herokuapp.com/countries/",
				headers: { "x-token": localStorage.getItem("token")},
				dataType: "json",
				type: "GET",
				success: function(data){
				
					$("#header").html(headerOutput);
				
					var countries = {
					
						countries : data
					
					}	
				
					var output = Mustache.render(template, countries);
			
					$("#content").html(output);
			
					Gfx.hideFooter();
					Gfx.removeActive();
					
					self.bind("country");
					
					$("#country").val(Registry.get("invoice").customer_details.country);
					
					Gfx.hideLoader();
					
				}, 
				error:function(){
					console.log("Error");
				}
		
			});
			
			
		
		});
	
	},
	
	productUnitForm : function(){
	
		var self = this;
		
		require(["text!templates/header-back.tpl", "text!templates/invoice-product-unit.tpl"], function(header, template){
		
			var data = {
				
				"link" : "#/invoice/edit-line/" + self.id,
				"title" : "Product Unit",
				"back" : "Back"
				
			}
			
			var headerOutput = Mustache.render(header, data);
			
			$.ajax({
				url: "http://mvp-sba.herokuapp.com/units/",
				headers: { "x-token": localStorage.getItem("token")},
				dataType: "json",
				type: "GET",
				success: function(data){
				
					$("#header").html(headerOutput);
				
					var units = {
						
						product_id : self.id,
						units : data
					
					}	
					
					Registry.set("units", data);
				
					var output = Mustache.render(template, units);
			
					$("#content").html(output);
			
					Gfx.hideFooter();
					Gfx.removeActive();
					
					self.bind("unit");
					
					Gfx.hideLoader();
					
				}, 
				error:function(){
					console.log("Error");
				}
				
			
			});
		
		});
	
	},
	
	productTypeForm : function(){
	
		var self = this;
		
		require(["text!templates/header-back.tpl", "text!templates/invoice-product-type.tpl"], function(header, template){
		
			var data = {
				
				"link" : "#/invoice/edit-line/" + self.id,
				"title" : "Product Type",
				"back" : "Back"
				
			}
			
			var headerOutput = Mustache.render(header, data);
			
			$.ajax({
				url: "http://mvp-sba.herokuapp.com/producttypes/",
				headers: { "x-token": localStorage.getItem("token")},
				dataType: "json",
				type: "GET",
				success: function(data){
				
					$("#header").html(headerOutput);
				
					var types = {
					
						product_id : self.id,
						types : data
					
					}	
				
					var output = Mustache.render(template, types);
			
					$("#content").html(output);
			
					Gfx.hideFooter();
					Gfx.removeActive();
					
					self.bind("type");
					
					Gfx.hideLoader();
					
				}, 
				error:function(){
					console.log("Error");
				}
				
			
			});
		
		});
	
	},
	
	customerList : function(){
	
		var self = this;
		
		require(["text!templates/header-back.tpl", "text!templates/invoice-customer-list.tpl"], function(header, template){
		
			var data = {
				
				"link" : "#/invoice/customer-details/",
				"title" : "Select Customer",
				"back" : "Back"
				
			}
			
			var headerOutput = Mustache.render(header, data);
			
			$.ajax({
			
				url: "http://mvp-sba.herokuapp.com/customers/",
				headers: { "x-token": localStorage.getItem("token")},
				dataType: "json",
				type: "GET",
				success: function(data){
				
					$("#header").html(headerOutput);
				
					for(var i=0, length = data.length; i < length; i++){
					
						data[i]["details"] = true;
						data[i]["index"] = i;
					
					}
				
					Registry.set("customers_list", data);
				
					var customers = {
					
						customers : data
					
					}	
					
					var output = Mustache.render(template, customers);
			
					$("#content").html(output);
			
					Gfx.hideFooter();
					Gfx.removeActive();
					
					self.bind("customer-list");
					
					Gfx.hideLoader();
					
				}, 
				error:function(){
					console.log("Error");
				}
			
			})
		
		});
	
	
	},
	
	productList : function(){
	
		var self = this;
		
		require(["text!templates/header-back.tpl", "text!templates/invoice-product-list.tpl"], function(header, template){
		
			var data = {
				
				"link" : "#/invoice/edit-line/",
				"title" : "Select Product",
				"back" : "Back"
				
			}
			
			var headerOutput = Mustache.render(header, data);
			
			$.ajax({
			
				url: "http://mvp-sba.herokuapp.com/products/",
				headers: { "x-token": localStorage.getItem("token")},
				dataType: "json",
				contentType: "application/json",
				type: "GET",
				success: function(data){
				
					$("#header").html(headerOutput);
					
					if(Registry.get("units")){
						
						var units = Registry.get("units");
						
						
						for(var i=0, length = data.length; i < length; i++){
					
							data[i]["index"] = i;
							
							for(var j=0; j < units.length; j++){
								
								if(data[i].unitId == units[j].id){
									
									data[i]["unit"] = units[j].name;
									
								}
								
							}
							
					
						}
						
						Registry.set("product_list", data);
						
						var products = {
					
							products : data
					
						}
					
						var output = Mustache.render(template, products);
			
						$("#content").html(output);
					
						self.bind("product-list");
					
						Gfx.hideLoader();
						
					} else {
						
						$.ajax({
							url: "http://mvp-sba.herokuapp.com/units/",
							headers: { "x-token": localStorage.getItem("token")},
							dataType: "json",
							contentType: "application/json",
							type: "GET",
							success: function(units){
				
								$("#header").html(headerOutput);
				
								var units = {
						
									units : units
					
								}	
					
								Registry.set("units", data);
								
								var units = Registry.get("units");
						
						
								for(var i=0, length = data.length; i < length; i++){
					
									data[i]["index"] = i;
							
									for(var j=0; j < units.length; j++){
								
										if(data[i].unitId == units[j].id){
									
											data[i]["unit"] = units[j].name;
									
										}
								
									}
							
					
								}
								
								Registry.set("product_list", data);
								
								var products = {
					
									products : data
					
								}
					
								var output = Mustache.render(template, products);
			
								$("#content").html(output);
					
								self.bind("product-list");
					
								Gfx.hideLoader();
					
							}, 
							error:function(){
								console.log("Error");
							}
				
			
						});
						
					}
					
				}, 
				error:function(){
					console.log("Error");
				}
			
			})
		
		});
	
	},
	
	bind : function(formName){
		
		var self = this;
		
		var invoice = Registry.get("invoice");
	
		switch(formName){
			
			case "customer" : {
			
				var companyName = $("#company-name");
				var address = $("#address");
				var postCode = $("#postcode");
				var city = $("#city");
				
				var all = $("#company-name, #address, #postcode, #city");
				
				invoice.customer_details.paymentTermsId = 2; 
				
				all.on("keyup", function(event){
				
					var boundTo = $(this).attr("data-to");
					
					invoice.customer_details[boundTo] = $(this).val();
					
					Registry.set("invoice", invoice);
					
				}); 
				
				all.on("blur", function(event){
				
					var boundTo = $(this).attr("data-to");
					
					var value = $(this).val();
					
					if(value){
						invoice.customer_details.details = true;
					}
				
				});
				
				
				
				//plus country selector, once the api is ready
				
				break;
			
			
			}
			
			case "date" : {
			
				var date = $("#date");
				
				date.on("blur", function(event){
				
					var boundTo = $(this).attr("data-to");
					
					invoice.date[boundTo] = $(this).val();
					
					console.log($(this).val());
					
					Registry.set("invoice", invoice);
				
				});
				
				break;
			
			}
			
			case "terms" : {
			
				var buttons = $("#invoice-payment").find("button");
				
				buttons.on("tap", function(event){
				
					var boundTo = $(this).attr("data-to");
					
					invoice.payment_terms[boundTo] = $(this).attr("data-value");
					
					Registry.set("invoice", invoice);
					
					location.href = "#/invoice/edit/"
				
				});
			
				break;
			
			}

			case "notes" : {
			
				var notes = $("#notes");
				
				notes.on("keyup", function(event){
				
					var boundTo = $(this).attr('data-to');
					
					var value = $(this).val();
					
					invoice.notes[boundTo] = value;
					
					if(value){
						invoice.notes.value = true;
					} else {
						invoice.notes.value = false;
					}
					
					Registry.set("invoice", invoice);
				
				});
				
				break;
			
			}
			
			case "country" : {
			
				var countries = $("#country");
				
				countries.on("change", function(event){
				
					invoice.customer_details.country = $(this).val();
					invoice.customer_details.countryCode = $(this).val();
					
					Registry.set("invoice", invoice);
				
				});
			
				break;
			
			}
			
			case "addline" : {
			
				//also handle empty input cases, and when cancel is pressed 
			
				var index = {};
				
				if($("#invoice-new-line").attr("data-index") !== "none"){
					//use an existing one, edit mode
					index = $("#invoice-new-line").attr("data-index");
				
				} else {
					//push a new one
					index = invoice.lines.products.length;
					invoice.lines.products.push({
					
						p_id : index,
						"name" : "",
						description : "",
						netUnitSalesPrice : "",
						netUnitCostPrice : "",
						quantity : "",
						unit : "",
						unitId : "",
						type : "",
						sku : "" //what the heck is SKU?
					
					});
					
					$("#type, #unit").attr("href", "#/invoice/product-unit/" + index);
					
				}
			
				var productName = $("#product-name");
				var description = $("#description");
				var price = $("#price");
				var quantity = $("#quantity");
				
				var all = $("#product-name, #description, #price, #quantity");
				
				console.log(invoice.lines); 
				 
				all.on("keyup", function(event){
				
					var boundTo = $(this).attr("data-to");
					
					invoice.lines.products[index][boundTo] = $(this).val();
					
					Registry.set("invoice", invoice);
					
				
				});
				
				break;
				
			
			}
			
			case "unit" : {
			
				$("#invoice-product-unit").find("button").on("tap", function(){
				
					 invoice.lines.products[self.id].unit = $(this).attr("data-value");
					 invoice.lines.products[self.id].unitId = $(this).attr("data-id");
					 location.href = "#/invoice/edit-line/"+self.id;
				
				});
			
			}
			
			case "type" : {
			
				$("#invoice-product-type").find("button").on("tap", function(){
				
					invoice.lines.products[self.id].type = $(this).attr("data-value");
					invoice.lines.products[self.id].productTypeId = $(this).attr("data-id");
					location.href = "#/invoice/edit-line/" + self.id;
				
				});
			
			}
			
			case "customer-list" : {
			
				$("#invoice-customer-list").find("button").on("tap, click", function(){
				
					invoice.customer_details = Registry.get("customers_list")[$(this).attr("data-value")];
					location.href = "#/invoice/edit/";
				
				});
			
			}
			
			case "product-list" : {
			
				$("#invoice-product-list").find("button").on("tap", function(){
				
					invoice.lines.products[invoice.lines.products.length - 1] = Registry.get("product_list")[$(this).attr("data-value")];
					invoice.lines.products[invoice.lines.products.length - 1]["p_id"] = invoice.lines.products.length - 1;
					location.href = "#/invoice/edit-line/" + ( invoice.lines.products.length - 1 );
				
				});
			
			}
			
		}
		
	
	}
	
	


});
