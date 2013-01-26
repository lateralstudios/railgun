$("document").ready(function(){
	$(".resource_listing").on("ajax:success", ".resource-delete", function(event, data){
		$(".resource_listing tr[role='"+data.id+"']").remove();
	});
})