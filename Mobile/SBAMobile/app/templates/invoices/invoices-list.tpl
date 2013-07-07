<div class="paper form">
	<input id="invoice-search" />
</div>
<br/><br/>

<div class="paper form">
{{#invoices}}
<a href="#/invoices/{{id}}/edit/" class="selector">
	{{customerName}} <br/>
	{{date}}
</a> 
{{/invoices}}
</div>
