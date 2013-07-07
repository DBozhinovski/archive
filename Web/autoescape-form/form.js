	var AESearchForm = {
		
		pickUpSpot : "",
		
		pickUpDate : "",
		
		dropOffSpot : "",
		
		datePickers : "",
		
		dropOffDate : "",
		
		pickUpId : "",
		
		dropOffId : "",
		
		countryId : "",
		
		formId : "",
		
		pickUpDateTime : "",
		
		dropOffDateTime : "",
		
		init : function(){
			
			this.pickUpSpot = $("#PickupSpot");
		
			this.dropOffSpot = $("#DropoffSpot");
		
			this.datePickers = $("#DropoffDate, #PickupDate");
			
			this.pickUpDate = $("#PickupDate");
			
			this.dropOffDate = $("#DropoffDate");
		
			this.pickUpId = $("#PickupSpotID");
		
			this.dropOffId = $("#DropoffSpotID");
		
			this.countryId = $("#CountryID");
			
			//this.formId = $("wl-form");
			
			this.pickUpDateTime = $("#pickupDateTime");
			
			this.dropOffDateTime = $("#dropOffDateTime");
			
		},
		
		bind : {
			
			init : function(){
				
				this.bindAutocomplete();
				this.bindDatepickers();
				this.bindInputs();
				this.bindTimeSelects();
				
			},
			
			bindAutocomplete : function(){
				
				AESearchForm.pickUpSpot.autocomplete({
					focus : function(){
						
					},
					source : function(request, response){
						$.ajax({
							url: "http://staging.autoescape.dk/AjaxSearch.aspx",
							dataType: "jsonp",
							jsonpCallback: "updateSpotList",
							contentType: "application/json; charset=utf-8",
							data: {
								a: "getspots",
								c: "updateSpotList",
								/*cy: country.val(), //restriction by country code */
								q: request.term
							},
							success: function(data) {
								
								var spots = $.parseJSON(data);
 
						        response($.map(spots, function(item){
						        	
						            return{
						                label: item.Name,
						                value: item.Name,
						                id: item.Id,
						                ctry: item.CountryId
						            }
						        }));
							}
						});
				
					},
					
					minLength: 3,
					
				 	delay: 500,
				 	
					search: function(){},
					
					select: function(event, ui){
						AESearchForm.countryId.val(ui.item.ctry);
						
						if (this.id == AESearchForm.pickUpSpot.attr("id")){
							AESearchForm.pickUpId.val(ui.item.id);
							
							AESearchForm.dropOffSpot.val(ui.item.label).removeClass("error");
							AESearchForm.dropOffId.val(ui.item.id);

						}
						
						if (this.id == AESearchForm.dropOffSpot.attr("id")) {
							AESearchForm.dropOffId.val(ui.item.id);
						}
					}
					
				});
				
			},
			
			bindDatepickers : function(){
				
				 $.datepicker.regional['dk'] = {
						monthNames: ['Januar', 'Februar', 'Marts', 'April', 'Maj', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'December'],
						monthNamesShort: ['jan', 'feb', 'mar', 'apr', 'jun', 'jul', 'aug', 'sep', 'okt', 'nov', 'dec'],
						dayNames: ['Søndag', 'Mandag', 'Tirsdag', 'Onsdag', 'Torsdag', 'Fredag', 'Lørdag'],
						dayNamesShort: ['Søn', 'Man', 'Tir', 'Ons', 'Tor', 'Fre', 'Lør'],
						dayNamesMin: ['sø', 'ma', 'ti', 'on', 'to', 'fr', 'lø'],
						prevText: 'forrige',
						nextText: 'nøste'

				}
				
				$.datepicker.setDefaults($.datepicker.regional["dk"]);
				
				AESearchForm.datePickers.datepicker({
					dateFormat : "yy-mm-dd",
					firstDay : 1,
				 	minDate : AESearchForm.calculateDate(new Date(), 1, 1),
				 	onSelect : function(date){
						if(this.id==AESearchForm.pickUpDate.attr("id")){
							var selected = $(this).datepicker("getDate");
							var newDate = AESearchForm.calculateDate(selected, 5, 0);
							AESearchForm.dropOffDate.datepicker("option", "minDate", selected);
							AESearchForm.dropOffDate.datepicker("setDate", newDate);
						}
						
						AESearchForm.pickUpDateTime.val(AESearchForm.pickUpDate.val() + " " + $("#PickupTime").val());
						AESearchForm.dropOffDateTime.val(AESearchForm.dropOffDate.val() + " " + $("#DropoffTime").val());
						
					}
				
				});
				
				AESearchForm.pickUpDate.datepicker("setDate", AESearchForm.calculateDate(new Date(),7,0));
				AESearchForm.dropOffDate.datepicker("setDate", AESearchForm.calculateDate(new Date(),14,0));
				
				AESearchForm.pickUpDateTime.val(AESearchForm.pickUpDate.val() + " " + $("#PickupTime").val());
				AESearchForm.dropOffDateTime.val(AESearchForm.dropOffDate.val() + " " + $("#DropoffTime").val());
				
				
			},
			
			bindInputs : function(){
				
				AESearchForm.pickUpSpot.bind("blur", function(){
					var val = $(this).val();
					if (!val.length || val==placeholderText){
						country.val("");
						pickupID.val("");
						dropoffSpot.val("");
						dropoffID.val("");
					}
				});
				
				AESearchForm.formId.bind("focus", function(){
					$(this).removeClass("error");
				});
				
			},
			
			bindTimeSelects : function(){
				
				$("#PickupTime, #DropoffTime").bind("change", function(){
					
					AESearchForm.pickUpDateTime.val(AESearchForm.pickUpDate.val() + " " + $("#PickupTime").val());
					AESearchForm.dropOffDateTime.val(AESearchForm.dropOffDate.val() + " " + $("#DropoffTime").val());
					
				});
				
			}
			
			
			
			
		},
		
		calculateDate : function(date, incr, nw){
  
			var yy = date.getFullYear();
			var mm = date.getMonth();
			var dd = date.getDate() + incr;
			var hh = 0;
			if(nw==0){
				hh = date.getHours();
			}

			return new Date(yy, mm, dd, hh, 0);
		  
		},
		
		run : function(){
			
			
			
			$(function(){
	
				AESearchForm.init();
				AESearchForm.bind.init();
	
			});
			
		}
		
		
	}
	
	AESearchForm.run();


