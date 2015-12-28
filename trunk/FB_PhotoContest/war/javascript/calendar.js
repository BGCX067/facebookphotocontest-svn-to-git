/* CALENDER CODE FROM 'http://forum.developers.facebook.com/viewtopic.php?id=7002' STARTS HERE */

function startCal(init) {

    /* see if we have a calendar object already and if so return it */
    if(typeof startCal.Calendar != 'undefined') {
        return startCal.Calendar;
    }
    
    var Calendar = document.getElementById("divCalender");
    
    Calendar.initialize = function(){

	    Calendar.mNames = [ "Jan", "Feb", "Mar", 
	                        "Apr", "May", "Jun", "Jul", "Aug", "Sep", 
	                            "Oct", "Nov", "Dec"];
	                            
	    Calendar.dNames = [ "Monday", "Tuesday", "Wednesday",
	                        "Thursday", "Friday", "Saturday", "Sunday"];
	        
	    Calendar.title = document.getElementById("CanlendarTitle");
	    Calendar.todaytitle = document.getElementById("TodayTitle");
	    
	    Calendar.currentDate = new Date();
	    
	    Calendar.visible = false;
	    Calendar.x = 0;
	    Calendar.y = 0;
	
	    document.getRootElement().addEventListener('mouseover',Calendar.isOutOfRange);
	
	    for(var i=1;i<43;i++){
	        document.getElementById('day_'+i).addEventListener('click',Calendar.dateSelected);
	        document.getElementById('day_'+i).addEventListener('mouseover',Calendar.onMouseOver);
	        document.getElementById('day_'+i).addEventListener('mouseout',Calendar.onMouseOut);
	    }
	
	            document.getElementById('prevMonth').addEventListener('click',Calendar.datePrevMonth);
	            document.getElementById('prevYear').addEventListener('click',Calendar.datePrevYear);
	            document.getElementById('nextMonth').addEventListener('click',Calendar.dateNextMonth);
	            document.getElementById('nextYear').addEventListener('click',Calendar.dateNextYear);
    }

    Calendar.datePrevMonth = function(){
	    var prevDate = new Date(Calendar.currentDate.getFullYear(),Calendar.currentDate.getMonth(),Calendar.currentDate.getDate());
	    prevDate.setMonth( prevDate.getMonth() - 1);
	    Calendar.setDate(prevDate);
    }

	Calendar.datePrevYear = function(){
	    var prevDate = new Date(Calendar.currentDate.getFullYear(),Calendar.currentDate.getMonth(),Calendar.currentDate.getDate());
	    prevDate.setFullYear( prevDate.getFullYear() - 1);
	    Calendar.setDate(prevDate);    
	}

	Calendar.dateNextMonth = function(){
	    var nextDate = new Date(Calendar.currentDate.getFullYear(),Calendar.currentDate.getMonth(),Calendar.currentDate.getDate());
	    nextDate.setMonth( nextDate.getMonth() + 1);
	    Calendar.setDate(nextDate);    
	}
	
	Calendar.dateNextYear = function(){
	     var nextDate = new Date(Calendar.currentDate.getFullYear(),Calendar.currentDate.getMonth(),Calendar.currentDate.getDate());
	    nextDate.setFullYear( nextDate.getFullYear() + 1);
	    Calendar.setDate(nextDate);    
	}

	Calendar.isOutOfRange = function(evt){
	    if(Calendar.visible == false) return true;
	    var root = document.getRootElement();
	    
	    var cursorX = evt.pageX - root.getAbsoluteLeft();
	    var cursorY = evt.pageY - root.getAbsoluteTop();
	    
	    var basePointX = Calendar.target.getAbsoluteLeft() - root.getAbsoluteLeft();
	    var basePointY = Calendar.target.getAbsoluteTop() - root.getAbsoluteTop();
	    
	    var secondPointX = basePointX + Calendar.target.getClientWidth() + Calendar.getClientWidth() + 50;
	    var secondPointY = basePointY + Calendar.target.getClientHeight() + Calendar.getClientHeight() + 50;        
	    
	    if((cursorX > basePointX && cursorX < secondPointX) && (cursorY > basePointY && cursorY < secondPointY)){
	        return false;
	    }
	    
	    Calendar.hide();
	    return true;
	}

	Calendar.show = function(trgt,idref){

	    Calendar.target = trgt;
	    Calendar.preid = idref;
	    
	    var root = document.getRootElement();
	    
	    if(trgt){
	        Calendar.x = trgt.getAbsoluteLeft() - root.getAbsoluteLeft() + trgt.getClientWidth();
	        Calendar.y = trgt.getAbsoluteTop() - root.getAbsoluteTop() + trgt.getClientHeight();
	        Calendar.setStyle('top',(trgt.getAbsoluteTop() - root.getAbsoluteTop() + trgt.getClientHeight())+"px");
	        Calendar.setStyle('left',(trgt.getAbsoluteLeft() - root.getAbsoluteLeft() + trgt.getClientWidth())+"px");
	    }
	    
	    Calendar.setDate(new Date(parseInt(document.getElementById(Calendar.preid + 'Year').getValue()), parseInt(document.getElementById(Calendar.preid + 'Month').getValue()) - 1, parseInt(document.getElementById(Calendar.preid + 'Day').getValue())));
	    
	    Calendar.setStyle("display","");
	    Calendar.visible = true;
	}

	Calendar.hide = function(){
	    Calendar.target = null;
	    Calendar.setStyle("display","none");
	    Calendar.visible = false;
	}

	Calendar.dateSelected = function(evt){
	    if(Calendar.target){
	        var value = evt.target.getValue();            
	        
	        if(Calendar.OnDateSelected){
	            Calendar.OnDateSelected(Calendar.target,value);
	        }
	        
	    }
	    Calendar.hide();
	}
	
	Calendar.onMouseOver = function(evt){
	    evt.target.setClassName('fb_calendar_day_hover');
	}
	Calendar.onMouseOut = function(evt){
	    evt.target.setClassName(evt.target.className);
	}

	Calendar.setDate = function (someDate){
	
	    var baseDate = new Date(someDate.getFullYear(),someDate.getMonth(),1);
	    var date_index = baseDate.getDay();                
	    
	    baseDate.setDate( - date_index + 1);
	    Calendar.currentDate = new Date(someDate.getFullYear(),someDate.getMonth(),someDate.getDate());
	
	    Calendar.title.setTextValue(Calendar.mNames[Calendar.currentDate.getMonth()] + " - " + Calendar.currentDate.getFullYear());
	    
	    
	    var divDay;
	    var i = 1;
	    for(i;i<43;i++){
	        divDay = document.getElementById("day_"+i);            
	        if(divDay){
	            divDay.setTextValue(baseDate.getDate());
	            divDay.setValue(new Date(baseDate.getFullYear(),baseDate.getMonth(),baseDate.getDate()));
	
	            if(baseDate.getMonth() == someDate.getMonth()){
	                divDay.className = "fb_calendar_day";
	            }else{
	                divDay.className = "fb_calendar_day_diff_month";                    
	            }
	            divDay.setClassName(divDay.className);
	        }
	        baseDate.setDate(baseDate.getDate() + 1);
	    }
	}
    
	Calendar.OnDateSelected = function(sender,date){    
	
	    var argCount = document.getElementById(Calendar.preid + 'Year').getChildNodes().length;
	    var sortedOptions = document.getElementById(Calendar.preid + 'Year').getChildNodes();
	    sortedOptions = sortedOptions.sort();
	    var debugStr = '';
	    
	    var addOption = true;
	
	    /* check current available options in select list */        
	    for(a=0;a<argCount;a++) {
	        if(sortedOptions[a].getValue() == date.getFullYear()) {
	            addOption = false;
	            a = argCount;
	        }
	        // debugStr = debugStr + ',' + sortedOptions[a].getValue() + ' == ' + date.getFullYear();
	    }
	    
	    //var dlg = new Dialog();            
	            //dlg.showMessage('Debug OnDateSelected()', 'Debug: ' + debugStr + ' answer: ' + addOption);
	
	    /* if we need to add the option to the select list */                
	            if(addOption == true) {
	            
	                var yearSelect = document.getElementById(Calendar.preid + 'Year').getChildNodes().sort();
	    
	                var opt = document.createElement('option');
	                opt.setId('yr'+date.getFullYear());
	            opt.setTextValue(date.getFullYear());
	        opt.setValue(date.getFullYear());
	              
	                /* if the lowest yr option value is greater than selected year */                    
	                if(yearSelect[0].getValue() > date.getFullYear() && yearSelect[1].getValue() > yearSelect[0].getValue()) {
	                
	                      /* we insertBefore() the missing option so it's at the top of list */      
	                      document.getElementById(Calendar.preid + 'Year').insertBefore(opt,document.getElementById(Calendar.preid + 'Year').getChildNodes()[0]);
	                      
	        } else if(yearSelect[0].getValue() < date.getFullYear() && yearSelect[1].getValue() > yearSelect[0].getValue()) {
	        
	              /* otherwise we append the missing yr option to the end of the list */                          
	                      document.getElementById(Calendar.preid + 'Year').appendChild(opt);
	                      
	        } else if(yearSelect[0].getValue() > date.getFullYear() && yearSelect[1].getValue() < yearSelect[0].getValue()) {
	        
	              /* otherwise we append the missing yr option to the end of the list */                          
	                      document.getElementById(Calendar.preid + 'Year').appendChild(opt);            
	                      
	        } else {
	        
	                      /* we insertBefore() the missing option so it's at the top of list */      
	                      document.getElementById(Calendar.preid + 'Year').insertBefore(opt,document.getElementById(Calendar.preid + 'Year').getChildNodes()[0]);
	        
	        }
	
	            }
	            
	            /* set the list options to the chosen date */
	            document.getElementById(Calendar.preid + 'Year').setValue("" + date.getFullYear());
	            document.getElementById(Calendar.preid + 'Day').setValue("" + date.getDate());
	            document.getElementById(Calendar.preid + 'Month').setValue("" + (date.getMonth() + 1));
	
	    /*
	    var dlg = new Dialog();            
	            dlg.showMessage('Message',sender.getId() + " is selected : " + date.getFullYear() + ' / ' + (date.getMonth() + 1) + ' / ' + date.getDate());
	            */
	                        
	}


	if(init == true) {
	    /* run initialize function */
	    Calendar.initialize();
	}
	
	startCal.Calendar = Calendar;
	
	/* return calendar object */
	return startCal.Calendar;
}    

// CALENDER CODE FROM 'http://forum.developers.facebook.com/viewtopic.php?id=7002' ENDS HERE //