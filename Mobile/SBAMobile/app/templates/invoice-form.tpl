<div class="wrapper" id="invoice-form">
{{#invoice}}
	<p><b>Customer details</b></p>
	<div class="paper">
		{{#customer_details}}
		<a href="#/invoice/customer/"> {{#details}}{{name}}{{/details}} {{^details}}{{name_placeholder}}{{/details}} <img src="assets/images/arrow.png" /></a>
		{{#details}}	
			<p class="details">
				{{address}} <br/>
				{{postcode}} <br/>
				{{city}}
			</p>
		{{/details}}
		{{/customer_details}}
	</div>
	
	<p><b>Invoice details</b></p>
	<div class="paper">
		<ul>
			{{#date}}
			<li><a href="#/invoice/date/">Date <img src="assets/images/arrow.png" /> <span class="value">{{date}}</span> </a></li>
			{{/date}}
			
			{{#payment_terms}}
			<li><a href="#/invoice/payment-terms/">Payment Terms <img src="assets/images/arrow.png" /> <span class="value">{{payment_terms}}</span> </a></li>
			{{/payment_terms}}
			
			{{#notes}}
				{{^value}}
					<li class="noborder"><a href="#/invoice/notes/">Notes <img src="assets/images/arrow.png" /> <span class="value thin">{{placeholder}}</span> </a></li>
				{{/value}}
				
				{{#value}}
				
					<li class="noborder"><a href="#/invoice/notes/"><p class="notes">{{notes}}</p> <img src="assets/images/arrow.png" /> </a></li>
				
				{{/value}}
				
				
				
			{{/notes}}
		</ul>
	</div>
	
	<p><b>Product details</b></p>
	<div class="paper form">
		{{#lines}}
			{{#products}}
			
				<a href="#/invoice/edit-line/{{p_id}}" class="selector" >
					<b class="pink">{{name}}</b>
					
					<span class="value">{{sum}}</span>
					
					<br/>
					<span class="description thin">
					{{quantity}} {{unit}} @ {{netUnitSalesPrice}}
					</span>
				</a>
			
			{{/products}}
		{{/lines}}
	
		<a href="#/invoice/add-line/" class="new-line"><img src="assets/images/add.png" /> New Line <span class="value">0.00</span></a>
		
		<ul id="sum">
			<li><span class="key">Subtotal</span><span class="value">{{value}}</span></li>
			<li><span class="key">Tax</span><span class="value">{{tax}}</span></li>
			<li class="total"><span class="key"><b>Total</b></span><span class="value"><b>{{total}}</b></span></li>
		</ul>
	</div>
	
	<a href="#" class="button-small first">View</a>
	
	<a href="#" class="button-small last">Finalise</a>
{{/invoice}}
</div>
