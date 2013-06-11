var dic = [];
var gender = 'none';

dic['men'] = ['Clothing', 'Shoes', 'Accessories'];

dic['men']['Clothing'] = ['Blazers','Coats and jackets','Casual shirts','Formal shirts','Jeans','Knitwear','Polos','Shorts','Activewear','Suits','Sweats','Swimwear','T-shirts','Trousers','Tuxedos','Underwear'];
dic['men']['Shoes'] = ['Boat shoes','Boots','Derbies','Espadrilles','Loafers','Oxfords','Sandals','Shoe accessories','Slippers','Sneakers'];
dic['men']['Accessories'] =['Bags','Belts','Cufflinks','Tie clips','Hats','Jewellery','Pocket squares','Scarves','Socks','Sunglasses','Ties','Travel','Wallets','Watches'];



dic['women'] =  ['Clothing', 'Shoes', 'Bags', 'Accessories'];

dic['women']['Clothing'] = ['Dresses','Tops','Jackets, Blazers & Vests','Sweaters','Denim','Pants, Shorts & Jumpsuits','Leggings','Skirts','Suits','Swimwear','Outerwear','Lingerie','Sleepwear & Loungewear'];
dic['women']['Shoes'] = ['Boots','Flat shoes','Pumps','Sandals','Sneakers'];
dic['women']['Bags'] = ['Clutch Bags','Shoulder Bags','Tote Bags','Travel Bags'];
dic['women']['Accessories'] = ['Belts','Jewelry','Hat','Scarves','Sunglasses','Travel','Wallets','Watches'];

function set_product_type()
{
	val = $('#product_product_type').val();
	g = val.split("_")[0];
	name = val.split("_")[1];

	type_gender(g);	

	for(i=0 ; i<dic[g].length ; i++)
	{
		c = dic[g][i];
		for(k=0 ; k<dic[g][c].length ; k++)
		{			
			if(name == dic[g][c][k])
			{				
				type_category(g, c);
				type_name(g, dic[g][c][k]);
				i = dic[g].length;
				break;
			}
		}
	}
}

function type_gender(g)
{
	if(g=='men') g = 'Men';
	if(g=='women') g = 'Women';
	$('#type_gender t')[0].innerHTML = g;
	g = g.toLowerCase();

	$('#type_category ul').children().remove();
	
	for(i=0 ; i<dic[g].length ; i++)
	{
		obj = $("<li><a onclick=\"type_category('"+g+"','" + dic[g][i] + "')\">"+dic[g][i]+"</a></li>");
		$('#type_category ul').append(obj);
	}
	$('#type_category').slideDown(200);
	$('#type_name').hide();
	$('#type_category t')[0].innerHTML = "Category";	
}

function type_category(g, c)
{
	$('#type_category t')[0].innerHTML = c;
	$('#type_name ul').children().remove();
	
	for(i=0 ; i<dic[g][c].length ; i++)
	{
		obj = $("<li><a onclick=\"type_name('"+g+"','" + dic[g][c][i] + "')\">"+dic[g][c][i]+"</a></li>");
		$('#type_name ul').append(obj);
	}	
	$('#type_name').slideDown(200);
	$('#type_name t')[0].innerHTML = "Type";
}

function type_name(g, t)
{
	$('#type_name t')[0].innerHTML = t;
	$('#product_product_type').val(g+'_'+t);
}

