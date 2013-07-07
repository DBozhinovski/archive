<div class="paper form">
	<input id="product-search" />
</div>
<br/><br/>

<div class="paper form">
{{#products}}
<a href="#/products/{{id}}/edit/" data-id="{{id}}" class="selector">
	{{name}}
</a> 
{{/products}}


</div>
