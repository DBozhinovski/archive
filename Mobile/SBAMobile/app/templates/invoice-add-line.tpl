<div class="wrapper" id="invoice-new-line" data-index="{{product_id}}" >

	<a href="#/invoice/product-list/" class="button-big">Select Product <img src="assets/images/arrow-white.png" /></a>

	<p><b>Line details</b></p>
	
	<div class="paper form">
		{{#product}}
		<input type="text" id="product-name" data-to="name" placeholder="Product name" value="{{name}}" />
		
		<input type="text" id="description" data-to="description" placeholder="Description" value="{{description}}" />
		
		<input type="text" id="price" data-to="netUnitSalesPrice" placeholder="Price" value="{{netUnitSalesPrice}}" />
	
		<input type="text" id="quantity" data-to="quantity" placeholder="Quantity" value="{{quantity}}" />
		
		<a href="#/invoice/product-unit/{{product_id}}" id="unit" class="selector" data-index="{{product_id}}">
			<b class="pink">Unit</b>
			<span class="value"><b>{{unit}}</b></span>
			<img src="assets/images/arrow.png" />
		</a>
		
		<a href="#/invoice/product-type/{{product_id}}" id="type" class="selector" data-index="{{product_id}}">
			<b class="pink">Type</b>
			<span class="value"><b>{{type}}</b></span>
			<img src="assets/images/arrow.png" />
		</a>
		
		{{/product}}
	</div>
	
	<a href="#/invoice/edit/" class="button-small first">Add to Invoice</a>
	
	<a href="#/invoice/edit/" data-execute="Product:save" data-parameters="{{product_id}}" class="button-small multiline last"><span>Add & save <br/> Product</span></a>

</div>
