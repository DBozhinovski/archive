<div class="wrapper" id="invoice-product-type" data-index="{{#types}}{{product_id}}{{/types}}" >

	<div class="paper form">
		{{#types}}
		<button data-value="{{name}}" data-id="{{id}}" data-to="type" class="selector">
			<b class="pink">{{name}}</b>
		</button>
		{{/types}}
		
	</div>

</div>
