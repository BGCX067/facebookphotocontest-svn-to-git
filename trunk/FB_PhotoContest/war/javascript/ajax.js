function showdiv(id){
    var elm = document.getElementById(id);
    if(elm.getStyle('display') == 'block'){
        Animation(elm).to('height', '0px').to('opacity', 0).hide().ease(Animation.ease.end).go(); 
        return false;
    }else{
        Animation(elm).to('height', 'auto').to('opacity', 1).show().ease(Animation.ease.end).go(); 
        return false;
    }
}

function show_dialog(localid, user_name, pic_width, title, type, thisform, divid) { 
	var context = picture_dialog["id"+localid];
	var dia = new Dialog();
	
	var d_width = parseInt(pic_width) + 22;
	if (pic_width > 400)
	{
		dia.setStyle('width', d_width.toString()+"px");
	}

	if (type == "rate")
	{
		dia.showChoice("\""+title+"\" by "+user_name, context, 'Submit Rating', 'Cancel');
		dia.onconfirm = function () 
		{
			submit_score(thisform, divid);
		}
		dia.oncancel = function () 
		{
			//document.getElementById(divid).setInnerFBML(" ");  -- Somehow this got broken.
			return true;
		}
	}
	else if (type == "vote")
	{
		dia.showChoice("\""+title+"\" by "+user_name, context, 'Vote For This Picture', 'Cancel');
		dia.onconfirm = function () 
		{
			submit_score(thisform, divid);
		}
		dia.oncancel = function () 
		{
			//document.getElementById(divid).setInnerFBML(" "); -- Somehow this got broken.
			return true;
		}
	}
	else
	{
		dia.showMessage("\""+title+"\" by "+user_name, context, 'Done');
		dia.onconfirm = function () {} // Do nothing on Confirm.
	}
	
	return true;
} 

function submit_score(formname, rewriteid)
{
	var div_id = document.getElementById(rewriteid);
	var form = document.getElementById(formname);
	var ajax = new Ajax();
	ajax.responseType = Ajax.FBML;
	ajax.requireLogin = true;
	ajax.ondone = function(data) {
	    div_id.setInnerFBML(data);
	}
	formdata = form.serialize();
	ajax.post('http://cs410-facebookphotocontest.appspot.com/set_score.jsp', formdata);
}

function display_photo(divid, formid)
{
	var mydiv = document.getElementById(divid);
	var myform = document.getElementById(formid);
	var ajax = new Ajax();
	ajax.responseType = Ajax.FBML;
	ajax.requireLogin = true;
	ajax.ondone = function(data) {
		mydiv.setInnerFBML(data)
	}
	formdata = myform.serialize();
	ajax.post('http://cs410-facebookphotocontest.appspot.com/get_photo.jsp', formdata);
}