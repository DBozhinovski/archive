<div class="paper form">
	<input id="country-search" />
</div>
<br/><br/>

<div class="paper form">
	
	{{#countries}}
		<button data-name="{{name}}" data-id="{{id}}" class="selector">
			<b class="pink">{{name}}</b>
		</button>
	{{/countries}}
			
</div>
