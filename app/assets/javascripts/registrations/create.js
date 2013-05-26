$(document).ready(function(){
	// $('.field_with_errors input').effect('pulsate', 1000);
	$('.field_with_errors input').animate({
		'background-color' : 'rgba(255,0,0,0.3)'
	}).bind({
		click: function() {
			$(this).animate({
				'background-color': 'white'
			});
		}
	});
});