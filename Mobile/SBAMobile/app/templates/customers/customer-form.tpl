<p><b>Customer Details</b></p>

<div class="paper form">
	{{#customer}}
	<input type="text" id="name" placeholder="Company name" value="{{name}}" />
	
	<input type="text" id="address" placeholder="Address" value="{{address}}" />
	
	<input type="text" id="zip" placeholder="Postcode" value="{{zip}}" />

	<input type="text" id="city" placeholder="City" value="{{city}}" />
	
	<a href="#/customers/country/" class="selector">
		<b class="pink">Country</b>
		<span class="value"><b>{{countryCode}}</b></span>
		<img src="assets/images/arrow.png" />
	</a>

	<a href="#/customers/payment-terms/" class="selector">
		<b class="pink">Payment Terms</b>
		<span class="value"><b>{{paymentTermsName}}</b></span>
		<img src="assets/images/arrow.png" />
	</a>
	
	<!-- Remaining: email, homepage, paymentTermsId (but defaults to 2 for 14 days), phone, vatNumber -->

	{{/customer}}

</div>

<a href="#/customers/save/" class="button-big"><span>Save customer</span></a>

