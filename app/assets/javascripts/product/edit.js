function eject_image(e)
{
	$("#img_"+e.id).remove();
	$(e).remove();
	$("#product_photos_attributes_"+e.id+"_id").remove();
	$("#product_photos_attributes_"+e.id+"_photo")[0].type = "file";
}