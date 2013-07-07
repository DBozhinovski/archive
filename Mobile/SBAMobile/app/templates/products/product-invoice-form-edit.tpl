<div class="wrapper" id="invoice-new-line" data-index="{{product_id}}" >

	<a href="#/products/list-invoice/" class="button-big">Select Product <img src="assets/images/arrow-white.png" /></a>

	<p><b>Line details</b></p>
	
	<div class="paper form">
		{{#product}}
		<input type="text" id="name"  placeholder="Product name" value="{{name}}" />
		
		<input type="text" id="description"  placeholder="Description" value="{{description}}" />
		
		<input type="text" id="netUnitSalesPrice"  placeholder="Price" value="{{netUnitSalesPrice}}" />
	
		<input type="text" id="quantity"  placeholder="Quantity" value="{{quantity}}" />
		
			
		<a href="#/products/product-units/" class="selector">
			<b class="pink">Unit</b>
			<span class="value"><b>{{unitName}}</b></span>
			<img src="assets/images/arrow.png" />
		</a>
		
		<a href="#/products/product-types/" class="selector">
			<b class="pink">Type</b>
			<span class="value"><b>{{typeName}}</b></span>
			<img src="assets/images/arrow.png" />
		</a>
		
		{{/product}}
	</div>
	
	<a href="#" id="edit" class="button-small first">Add to Invoice</a>
	
	<a href="#" id="saveEdited" data-execute="Product:save" data-parameters="{{product_id}}" class="button-small multiline last"><span>Add & save <br/> Product</span></a>

</div>