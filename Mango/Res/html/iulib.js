$.fn.iuName = function(){
	return this.attr('iuname');
}




$.fn.updatePixel = function(){
	return this.each(function(){
		var myName = $(this).iuName();
		if (this.position == undefined){
			this.position = $(this).iuPosition();
			if (document.updatedPixelIUFrame[myName] == undefined){
				document.updatedPixelIUFrame[myName] = this.position;
			}
		}
		else{
			/* check and update */
			var newPosition = $(this).iuPosition();
			if (this.position.top != newPosition.top || this.position.left != newPosition.left || this.position.width != newPosition.width || this.position.height != newPosition.height ){
				document.updatedPixelIUFrame[myName] = newPosition;
				this.position = newPosition;
			}
		}
	})
}

$.fn.updatePercent = function(){
	return this.each(function(){
		var myName = $(this).iuName();
		var dict = $(this).iuFrame();
		document.updatedPercentIUFrame[myName] = dict;
	})
    
}


$.fn.iuPosition = function(){
	var top = $(this).position().top + parseFloat($(this).css('margin-top'));
	var left = $(this).position().left + parseFloat($(this).css('margin-left'));
	var width = parseFloat($(this).css('width'));
	var height = parseFloat($(this).css('height'));
	if($(this).css('position') == "relative"){
		var marginTop =  parseFloat($(this).css('margin-top'));
		var marginLeft = parseFloat($(this).css('margin-left'));
		return { top: top, left: left, width: width, height: height, marginTop:marginTop, marginLeft:marginLeft }
	}
	return { top: top, left: left, width: width, height: height }
}

$.fn.iuFrame = function(){
	var parentWidth = parseFloat($(this).parent().css('width'));
	var parentHeight = parseFloat($(this).parent().css('height'));
    
	if($(this).css('position') == "fixed"){
		parentWidth = $(window).width();
		parentHeight = $(window).height();
	}
    
	var top = $(this).position().top + parseFloat($(this).css('margin-top'));
	var left = $(this).position().left + parseFloat($(this).css('margin-left'));
	var width = parseFloat($(this).css('width'));
	var height = parseFloat($(this).css('height'));
    
	var marginLeft = parseFloat($(this).css('margin-left'));
	var marginTop = parseFloat($(this).css('margin-top'));
    
	var percentTop, percentHeight, percentMarginTop;
	var percentLeft, percentWidth, percentMarginLeft;
    
	if(parentHeight==0){
		percentTop =100;
		percentHeight =100;
		percentMarginTop=100;
	}else{
		percentTop = Number(((top/parentHeight)*100).toFixed(2));
		percentHeight = Number(((height/parentHeight)*100).toFixed(2));
		percentMarginTop = Number(((marginTop/parentHeight)*100).toFixed(2));
	}
	if(parentWidth==0){
		percentLeft =100;
		percentWidth =100;
		percentMarginLeft=100;
	}
	else{
		percentLeft = Number(((left/parentWidth)*100).toFixed(2));
		percentWidth = Number(((width/parentWidth)*100).toFixed(2));
		percentMarginLeft = Number(((marginLeft/parentWidth)*100).toFixed(2));
	}
    
	return { top: top, left: left, width: width, height: height, marginLeft: marginLeft, marginTop: marginTop, percentTop : percentTop, percentLeft : percentLeft, percentWidth : percentWidth, percentHeight : percentHeight, percentMarginLeft : percentMarginLeft, percentMarginTop : percentMarginTop };
}

function IU(fullIUName){
	return $('[iuname = ' + fullIUName + ']' );
}

function insertIU(parentFullIUName, index, source){
	if (IU(parentFullIUName).children().length == 0){
		IU(parentFullIUName).prepend('<p style="font-size: 0px; line-height: 0px;">&nbsp;</p><p style="font-size: 0px; line-height: 0px;">&nbsp;</p>');
	}
	IU(parentFullIUName).children().eq(index).after(source);
}


function getBottom(element){
	bottom = parseInt($(element).css('height')) + parseInt( $(element).css('top') ) + parseInt( $(element).css('margin-top'))
	return bottom;
}



$.fn.textWidth = function(){
	var html_org = $(this).html();
	var html_calc = '<span>' + html_org + '</span>';
	$(this).html(html_calc);
	var width = $(this).find('span:first').width();
	$(this).html(html_org);
	return width * 1.1; // webkit 에서는 더 작게 보임
};

$.fn.textHeight = function(){
	var html_org = $(this).html();
	var html_calc = '<span>' + html_org + '</span>';
	$(this).html(html_calc);
	var height = $(this).find('span:first').height();
	$(this).html(html_org);
	return height;
};

$.fn.getPercentWidth = function(pixelX){
	var parentWidth = parseFloat($(this).parent().css('width'));
    
	if($(this).css('position') == "fixed"){
		parentWidth = $(window).width();
	}
    
	var percentX =(pixelX/parentWidth)*100;
    
	if(parentWidth==0){
		percentX = 100;
	}
    
	return Number((percentX).toFixed(2));
    
}
$.fn.getPercentHeight = function(pixelY){
    
	var parentHeight = parseFloat($(this).parent().css('height'));
    
	if($(this).css('position') == "fixed"){
		parentHeight = $(window).height();
	}
    
	var percentY =(pixelY/parentHeight)*100;
    
	if(parentHeight==0){
		percentY = 100;;
	}
    
    
	return Number((percentY).toFixed(2));
    
}

function isPixel(a){
	if (a.length < 2){
		return false;
	}
	if (a.slice(-2) == 'px'){
		return true;
	}
	return false;
}



/* animation part */

function IUJSAnimation(){
	for (receiverIUName in receiverCTXs){
		var receiverInfos = receiverCTXs[receiverIUName];
		var evalString;
		var IUCTX = IUCTXs[receiverIUName];
		for (var type in receiverInfos){
			receiverInfo = receiverInfos[type];
			if (type == 'visible'){
				var currentVisible = getIUVisible(receiverIUName)
                
				if (receiverInfo['equation']){
					evalString = receiverInfo['equation'];
				}
				var evalValue = eval(evalString)
				if (currentVisible != evalValue){
					setIUVisible(receiverIUName, evalValue)
				}
			}
			if (type=='frame'){
				var currentFrameStatus = getIUFrameStatus(receiverIUName)
                
				if (receiverInfo['equation']){
					evalString = receiverInfo['equation'];
				}
				else{
					var vt = receiverInfo['valueTransformer']
					var variable = receiverInfo['variable']
					evalString = vt + '(' + variable + ')'
				}
				var evalValue = eval(evalString)
				if (currentFrameStatus != evalValue){
					setIUFrameStatus(receiverIUName, evalValue)
				}
			}
		}
	}
}

function initIUCTX(fullIUName){
	width = IU(fullIUName).width()
	height = IU(fullIUName).height();
	//            top = IU(fullIUName).position().top;
	//            left = IU(fullIUName).position().left;
 
	IUCTX = {'width':width, 'height':height, 'visible':true };
	IUCTXs[fullIUName] = IUCTX;
}



function setIUFrameStatus(fullIUName, status){
	var IUCTX = IUCTXs[fullIUName];
	var jqIU = IU(fullIUName);
	var receiverCTX = receiverCTXs[fullIUName];
	var duration = receiverCTX['frame']['duration'];
	if (duration == undefined){
		duration = 0;
	}
	if (status){
		jqIU.animate({
			width:receiverCTX['frame']['width'],
			height:receiverCTX['frame']['height'],
		}, duration*100);
	}
	else{
		jqIU.animate({
			width:IUCTX['width'],
			height:IUCTX['height'],
		}, duration*100);
	}
	IUCTX['frame'] = status;
}

function getIUFrameStatus(fullIUName){
	IUCTX = IUCTXs[fullIUName];
	return IUCTX['frame'];
}

function getIUVisible(fullIUName){
	IUCTX = IUCTXs[fullIUName];
	return IUCTX['visible'];
}

function setIUVisible(fullIUName, visible){
	var IUCTX = IUCTXs[fullIUName];
	var duration = receiverCTXs[fullIUName]['visible']['duration'];
	var isHorizontal = receiverCTXs[fullIUName]['visible']['isHorizontal'];
	var jqIU = IU(fullIUName);
    
	if (visible){
		if  (duration&& loadFinished){
			if  (isHorizontal){
				jqIU.animate({width: 'toggle'}, duration*100);
			}
			else{
				jqIU.animate({height: 'toggle'}, duration*100);
			}
			IUCTX['visible'] = true;
		}
		else {
			jqIU.show();
			IUCTX['visible'] = true;
		}
	}
	else{
		if  (duration && loadFinished){
			if  (isHorizontal){
				jqIU.animate({width: 'toggle'}, duration*100);
			}
			else{
				jqIU.animate({height: 'toggle'}, duration*100);
			}
			IUCTX['visible'] = false;
		}
		else{
			jqIU.hide();
			IUCTX['visible'] = false;
		}
	}
}

function valueInit(){
	for (variable in variableCTXs){
		eval (variable + '=' + variableCTXs[variable]['value'])
	}
}

function valueAdd (){
	var fullIUName = $(this).attr('IUName');
	console.log('IUClicked : ' + fullIUName);
	var triggerInfo = triggerCTXs[fullIUName];
	if (triggerInfo){
		//                    if (triggerInfo['event'] == 'click'){
			var variable = triggerInfo['variable'];
			variableCTXs[variable]['value'] ++;
			if (variableCTXs[variable]['value'] > variableCTXs[variable]['range']){
				variableCTXs[variable]['value'] = 0;
			}
			eval(variable+'='+variableCTXs[variable]['value'])
			IUJSAnimation();
			console.log('variable ' + variable + ' : ' +variableCTXs[variable]['value']);
			//                    }
		}
	}

	$(document).ready(function(){
		/* build IUOverLapImage class */
		$('.IUOverlapImage').filter('[transitionevent = "MouseOn"]').mouseenter(function(){        var targetOpacity = $(this).attr('targetOpacity');
		console.log(targetOpacity);
		$($(this).children()[1]).animate({opacity:targetOpacity});
	})  
	$('.IUOverlapImage').filter('[transitionevent = "MouseOn"]').mouseleave(function(){
		$($(this).children()[1]).animate({opacity:0});
	})  
	$('.IUOverlapImage').filter('[transitionevent = "Click"]').click(function(){
		console.log('clicked');
		var clicked = parseInt($(this).attr('clicked'));
		var targetOpacity = $(this).attr('targetOpacity');
		if (clicked == undefined){
			clicked = 0;
		}   
		if (clicked){
			$($(this).children()[1]).animate({opacity:0});
		}   
		else{
			$($(this).children()[1]).animate({opacity:targetOpacity});
		}
		if (clicked){
			$(this).attr('clicked', 0);
		}
		else{
			$(this).attr('clicked', 1);
		}
	})
	
	/* build IUTransitionImageClass */
	if (isIUEditor == false){
		$('.IUTransitionView').children().css('visibility', 'visible');
	}

	$.each($('.IUTransitionView').filter('[animation = "Fly From Right Side"]'), function(index, value){
		var secondIU = $(this).children()[1];
		$(secondIU).css('left', $(this).css('width'));
		$(this).hover(function(){
			$(secondIU).animate({'left':'0px'}, 200);
		},
		function(){
			$(secondIU).animate({'left':$(this).css('width')}, 200);
		});
	});
	$.each($('.IUTransitionView').filter('[animation = "Overlap"]'), function(index, value){
		var secondIU = $(this).children()[1];
		$(secondIU).css('opacity', 0);
		$(this).hover(function(){
			$(secondIU).animate({'opacity':$(this).attr('targetOpacity')}, 200);
		},
		function(){
            $(secondIU).animate({'opacity':0}, 200);
		});
	});
	console.log ('!!!!!!!!!!');
	
});

function goNextPage(){
	var currentIndex = projectInfo.pageFiles.indexOf(projectInfo.currentPage);
	var nextIndex = currentIndex + 1;
	if (nextIndex >= projectInfo.pageFiles.length ){
		nextIndex = 0;
	}
	var nextLink = projectInfo.pageFiles[nextIndex];
	window.location.replace(nextLink);
}

function goPrevPage(){
	var currentIndex = projectInfo.pageFiles.indexOf(projectInfo.currentPage);
	var nextIndex = currentIndex - 1;
	if (nextIndex < 0) {
		nextIndex = projectInfo.pageFiles.length - 1;
	}
	var nextLink = projectInfo.pageFiles[nextIndex];
	window.location.replace(nextLink);
}

if (projectInfo.projectType == 'IUPresProject') {
	$(document).ready(function() {
		$(document).click(goNextPage);
	})

	document.addEventListener('keydown', function(event) {
		if (event.keyCode == 34 || event.keyCode == 39) {
			goNextPage();
		} else if (event.keyCode == 33 || event.keyCode == 37) {
			goPrevPage();
		}
	})
	$(document).ready(function() {
		$(document).click(function() {
			goNextPage();
		})
	})
}

$(document).ready(function(){
                  $.each($('[movienocontrol=1]'), function(index, value){value.removeAttribute("controls")});
})
