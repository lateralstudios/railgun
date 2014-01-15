$("document").ready(function(){
	
	$("table.resource_listing").on("ajax:success", ".resource-delete", function(event, data){
		$(".resource_listing tr[role='"+data.id+"']").fadeTo(400, 0)
		$(".resource_listing tr[role='"+data.id+"'] td").slideUp(400, function(){
			$(this).remove();
		})
	});
	
	$("a.batch-action").on("click", function(event){
		event.preventDefault();
		var $link = $(this),
				$method = $link.data("batch-method"),
				$form = $("form#batch_action");
		$form.find("#batch_method").val($method);
		$form.submit();
	});
	
	$("input#batch_select_all").on("change", function(event){
		var $input = $(this),
				$value = $input.prop('checked');
				$control_inputs = $("input.batch_select");
		if($value){
			$control_inputs.each(function(){
				$(this).prop('checked', true);
			});
		}else{
			$control_inputs.each(function(){
				$(this).prop('checked', false);
			});
		}
		
	});
})