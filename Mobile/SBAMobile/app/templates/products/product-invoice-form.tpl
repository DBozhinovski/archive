<div class="wrapper" id="invoice-new-line" data-index="{{product_id}}" >

	<a href="#/products/list-invoice/" class="button-big">Select Product <img src="assets/images/arrow-white.png" /></a>

	<p><b>Line details</b></p>
	{{#product}}
	<div class="paper form">
		
		<input type="text" id="name"  placeholder="Product name" value="{{name}}" />
		
		<input type="text" id="description"  placeholder="Description" value="{{description}}" />
		
		<input type="text" id="netUnitSalesPrice"  placeholder="Price" value="{{netUnitSalesPrice}}" />
	
		<input type="text" id="quantity"  placeholder="Quantity" value="{{quantity}}" />
		
					
		<a href="#/products/product-units/" id="unit" class="selector">
			<b class="pink">Unit</b>
			<span class="value"><b>{{unitName}}</b></span>
			<img src="assets/images/arrow.png" />
		</a>
		
		<a href="#/products/product-types/" id="type" class="selector">
			<b class="pink">Type</b>
			<span class="value"><b>{{productTypeName}}</b></span>
			<img src="assets/images/arrow.png" />
		</a>
		
		
	</div>
	
	{{#lineIndex}}
	<a href="#" id="edit" class="button-small first">Edit and Add to Invoice</a>
	
	<a href="#" id="saveEdited" data-execute="Product:save" data-parameters="{{product_id}}" class="button-small multiline last"><span>Edit Add & save <br/> Product</span></a>
	{{/lineIndex}}
	
	{{^lineIndex}}
	<a href="#" id="add" class="button-small first">Add to Invoice</a>
	
	<a href="#" id="save" data-execute="Product:save" data-parameters="{{product_id}}" class="button-small multiline last"><span>Add & save <br/> Product</span></a>
	{{/lineIndex}}
	
	{{/product}}
</div>

