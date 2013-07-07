var Utilities = {

	search : function(term, list){

		var items = $(list);

		//console.log(items);

		for(var i = 0, length = items.length; i < length; i++){

			if($(items[i]).text().toLowerCase().indexOf(term.toLowerCase()) === -1){
					$(items[i]).hide();
			} else {
					$(items[i]).show();
			}
			
		}

		if(!term){
			$(list).show();	
		}

	}

}