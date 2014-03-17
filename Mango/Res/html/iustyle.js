
//IUName, (string)
//style : css style, (string)
//size : media query size (integer)
function setIUStyle(IUName, style, size){
	var length = arguments.length;
	var stylesheet, newStyleElement;
	var styleElement;
	
	if(length==2){
		styleElement = document.getElementById("default");
	}
	else if(length==3){
		//find current mq size sheet
		styleElement = getIUStyleSheetElement(size);
	}
	else{
		//this is error, nothing to set
		return;
	}
	if (styleElement) {
		stylesheet = styleElement.sheet;
	}
	//there is no style sheet, make new style sheet
	else {
		stylesheet = addStyleSheet(size);
	}
	setIUStyleRule(IUName, stylesheet, style);
}

function removeIUStyle(IUName, size){
	var length = arguments.length;
	
	//remove spacific size style
	if(length==2){
		var styleElement = getIUStyleSheetElement(size);
		if (styleElement){
			removeStyleRule(styleElement.sheet, IUName);
		}
	}
	//remove all IU's style
	else if(length ==1){
		removeAllIUStyle(IUName);
	}
}

function removeAllIUStyle(IUName){
	var styleSheets = document.styleSheets;
	for(var i=0; i<styleSheets.length; i++){
		removeStyleRule(styleSheets[i], IUName);
	}
}

function removeStyleRule(sheet, IUName){
	var index = indexOfRules(IUName, sheet);
	if(index > -1){
		sheet.removeRule(index);
		return true;
	}
	return false;
}

function getIUStyleSheetElement(size){
	return document.getElementById(styleSheetID(size));
}

function indexOfRules(IUName, sheet){
	var selectorText = '[iuname="' + IUName + '"]';
	for(var i=0; i<sheet.rules.length; i++){
		if(sheet.rules[i].selectorText == selectorText){
			return i;
		}
	}
	return -1;
}

function setIUStyleRule(IUName, stylesheet, style){
	var selectorText = '[iuname="' + IUName + '"]';
	var rules = stylesheet.rules;
	
	for(var index=0; index<rules.length; index++){
		if(rules[index].selectorText == selectorText){
			rules[index].style.cssText = style;
			return "replace";
		}
	}
	
	stylesheet.addRule(selectorText, style, 0);
	return "insertRule";
}

function styleSheetID(size){
	return 'screentype_'+size;
}

function addStyleSheet(size){
	
	var newStyle = document.createElement('style');
	newStyle.setAttribute('id', styleSheetID(size));
	newStyle.setAttribute('type', 'text/css');
	newStyle.setAttribute('media', 'screen and (max-width:'+size+'px)');
	
	newStyle.appendChild(document.createTextNode(""));
	document.head.appendChild(newStyle);
	
	return newStyle.sheet;
}
