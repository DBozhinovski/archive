<div class="paper form">
	<input id="customer-search" />
</div>
<br/><br/>
<div class="paper form">
{{#customers}}
<a href="#/customers/{{id}}/edit/" data-id="{{id}}" class="selector">
	{{name}}
</a> 
{{/customers}}


</div>
