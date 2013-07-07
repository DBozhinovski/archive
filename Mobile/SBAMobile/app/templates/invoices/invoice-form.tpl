{{#invoice}}
	<p><b>Customer details</b></p>
	<div class="paper">
		<a href="#/customers/invoice/"> {{#customer_details}}{{customerName}}{{/customer_details}} {{^customer_details}}{{name_placeholder}}{{/customer_details}} <img src="assets/images/arrow.png" /></a>	
		{{#customer_details}}
			<p class="details">
				{{customerAddress}} <br/>
				{{customerZip}} <br/>
				{{customerCity}} <br/>
				{{customerCountryName}}
			</p>
		{{/customer_details}}
	</div>
	
	<p><b>Invoice details</b></p>
	<div class="paper">
		<ul>

			<li><a href="#/invoice/date/">Date <img src="assets/images/arrow.png" /> <span class="value">{{date}}</span> </a></li>
			
			<li><a href="#/invoice/payment-terms/">Payment Terms <img src="assets/images/arrow.png" /> <span class="value">{{paymentTermsName}}</span> </a></li>
			
			{{^has_notes}}
			<li class="noborder"><a href="#/invoice/notes/">{{notes_placeholder}} <img src="assets/images/arrow.png" /> <span class="value thin">{{notes_message}}</span> </a></li>
			{{/has_notes}}
			
			{{#has_notes}}
			<li class="noborder"><a href="#/invoice/notes/"><p class="notes">{{notes}}</p> <img src="assets/images/arrow.png" /> </a></li>
			{{/has_notes}}

		</ul>
	</div>
	
	<p><b>Product details</b></p>
	<div class="paper form">
		{{#lines}}
			
			
				<a href="#/invoices/{{lineIndex}}/edit-line/" class="selector" >
					<b class="pink">{{productName}}</b>
					
					<span class="value">{{sum}}</span>
					
					<br/>
					<span class="description thin">
					{{quantity}} {{unitId}} @ {{unitPrice}}
					</span>
				</a>
			

		{{/lines}}
	
		<a href="#/invoices/addLine/" class="new-line"><img src="assets/images/add.png" /> New Line <span class="value">0.00</span></a>
		
		<ul id="sum">
			<li><span class="key">Subtotal</span><span class="value">{{totalNetAmount}}</span></li>
			<li><span class="key">Tax</span><span class="value">{{totalVatAmount}}</span></li>
			<li class="total"><span class="key"><b>Total</b></span><span class="value"><b>{{totalAmount}}</b></span></li>
		</ul>
	</div>
	
	<a href="#" class="button-small first">View</a>
	
	<a href="#" class="button-small last">Finalise</a>
{{/invoice}}