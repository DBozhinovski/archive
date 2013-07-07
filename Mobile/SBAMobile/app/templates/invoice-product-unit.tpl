<div class="wrapper" id="invoice-product-unit" data-index="{{#units}}{{product_id}}{{/units}}" >

	<div class="paper form">
		{{#units}}
		<button data-value="{{name}}" data-id="{{id}}" data-to="unit" class="selector">
			<b class="pink">{{name}}</b>
		</button>
		{{/units}}
		
	</div>

</div>
