<p><b>Product details</b></p>
	
	<div class="paper form">
		{{#product}}
		<input type="text" id="name"  placeholder="Product name" value="{{name}}" />
		
		<input type="text" id="description"  placeholder="Description" value="{{description}}" />
		
		<input type="text" id="netUnitSalesPrice"  placeholder="Price" value="{{netUnitSalesPrice}}" />
	
		<input type="text" id="netUnitCostPrice"  placeholder="Price" value="{{netUnitCostPrice}}" />
		<!--input type="text" id="quantity"  placeholder="Quantity" value="{{quantity}}" /-->
		
		<a href="#/products/product-units/" id="unit" class="selector" >
			<b class="pink">Unit</b>
			<span class="value"><b>{{unitName}}</b></span>
			<img src="assets/images/arrow.png" />
		</a>
		
		<a href="#/products/product-types/" id="type" class="selector" >
			<b class="pink">Type</b>
			<span class="value"><b>{{productTypeName}}</b></span>
			<img src="assets/images/arrow.png" />
		</a>
		
		{{/product}}
	</div>

	<a href="#/products/save/" class="button-big"><span>Save product</span></a>