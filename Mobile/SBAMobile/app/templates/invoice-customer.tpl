<div class="wrapper" id="invoice-customer">

	<a href="#/invoice/customer-list/" class="button-big">Select Customer <img src="assets/images/arrow-white.png" /></a>

	<p><b>Customer details</b></p>
	
	<div class="paper form">
		{{#customer}}
		<input type="text" id="company-name" data-to="name" placeholder="Company name" value="{{name}}" />
		
		<input type="text" id="address" data-to="address" placeholder="Address" value="{{address}}" />
		
		<input type="text" id="postcode" data-to="postcode" placeholder="Postcode" value="{{postcode}}" />
	
		<input type="text" id="city" data-to="city" placeholder="City" value="{{city}}" />
		
		<a href="#/invoice/country/" id="country" class="selector">
			<b class="pink">Country</b>
			<span class="value"><b>{{country}}</b></span>
			<img src="assets/images/arrow.png" />
		</a>
		
		{{/customer}}
	
	</div>
	
	<a href="#/invoice/edit/" class="button-small first">Add to Invoice</a>
	
	<a href="#/invoice/edit/" data-execute="Customer:save" class="button-small multiline last"><span>Add & save <br/> as Customer</span></a>

</div>
