function fileList()
{
	table = $('#file_list tr');
	for(i=1 ; i<table.length ; i++)
	{
		$(table[i]).remove();
	}

	table = $('#file_list');
	files = $('#product_images').prop("files");
	if(files.length > 5)
	{
		alert("You could only upload 5 images.");
		$('#product_images').val("");
		files = [];
	}

	for (i = 0 ; i < files.length ; i++) 
	{
		str = "<tr><td><b>" + (i+1) + "</b></td><td>" + files[i].name + "</td></tr>",
		html = $.parseHTML(str);
		table = table.append(html);
	}
}

function set_gender()
{
	value = $("#product_gender").val();
	if(value == "men")
		$($("#gender_checkbox .btn")[0]).toggleClass("active");
	else if(value == "women")
		$($("#gender_checkbox .btn")[1]).toggleClass("active");
	else if(value == "all")
	{
		$($("#gender_checkbox .btn")[0]).toggleClass("active");
		$($("#gender_checkbox .btn")[1]).toggleClass("active");
	}
}

function gender_select()
{
	list = $('#gender_checkbox .btn.active');

	if(list.length == 1)
		$('#product_gender').val(list[0].id);		
	else if(list.length == 2)
		$('#product_gender').val('all');
	else
		$('#product_gender').val('N/A');		
}

function size_list_change()
{
	table = $('#size_table tbody tr');
	list = $('#size_list').val().split(",");

	for(i=1 ; i<table.length ; i++)
	{
		$(table[i]).hide().remove();
	}

	table = $('#size_table tbody');
	if(list.length==1 && list[0] == "")
		list = [];
	for (i = 0 ; i < list.length ; i++)
	{
		str = "<tr><td><b>" + list[i] + "</b></td><td><input type='number' class='span12'/></td></tr>";
		html = $.parseHTML(str);
		table = table.append(html);
	}
}

function form_submit()
{
	list = size_table_to_json();
	obj = {};
	for(i=1 ; i<list.length ; i++)
	{
		obj[list[i][0].html()] = list[i][1].val();
	}
	$('#product_sizes').val(JSON.stringify(obj));
	gender_select();
	$('form').submit();
}

function size_table_to_json()
{
	var tbl = $('#size_table tr').get().map(function(row) {
		return $(row).find('td').get().map(function(cell) {
			return $(cell).children();
		});
	});
	return tbl;
}

function json_to_table()
{
	table = $('#size_table tbody tr');
	list = JSON.parse($('#product_sizes').val());

	table = $('#size_table tbody');
	sizes = [];
	for (key in list)
	{
		str = "<tr><td><b>" + key + "</b></td><td><input type='number' class='span12' value='" + list[key] + "' /></td></tr>";
		html = $.parseHTML(str);
		table = table.append(html);
		sizes.push(key);
	}
	$("#size_list").val(sizes.join(','));
}

