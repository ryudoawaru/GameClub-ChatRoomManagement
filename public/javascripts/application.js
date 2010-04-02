// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function(){
//		$('a.Hidden').hide();
		$('a.Hidden').hover(function(){
			$(this).find('img').css('visibility', 'visible');
		}, function(){$(this).find('img').css('visibility', 'hidden');});
		if($('input.CheckAll')){
			$('input.CheckAll').each(function(){
						$(this).bind('click',function(){
							var val =  this.checked;
							$(this.form).find('input.Select').each(function(){this.checked = val;});
						});
					}
			);
		}
	}
);
