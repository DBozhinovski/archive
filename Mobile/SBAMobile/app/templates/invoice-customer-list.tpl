<div class="wrapper" id="invoice-customer-list">

	<div class="paper form">
		{{#customers}}
		<button data-value="{{index}}" data-to="type" class="selector">
			<b class="pink">{{name}}</b><br/>
			<span class="description">{{address}} {{city}}</span>
		</button>
		{{/customers}}
		
	</div>

</div>
