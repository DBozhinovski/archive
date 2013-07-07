<div class="wrapper" id="invoice-product-list">

	<div class="paper form">
		{{#products}}
		<button data-value="{{index}}" data-id="{{id}}" data-to="type" class="selector">
			<b class="pink">{{name}}</b><br/>
			<span class="description">{{unit}} @ {{netUnitSalesPrice}}</span>
		</button>
		{{/products}}
		
	</div>

</div>
