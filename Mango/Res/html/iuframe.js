// iuframe.js

document.updatedPixelIUFrame = {};
document.updatedPercentIUFrame = {};

/* cocoa 에서 select 를 하면 이 함수가 불려서 Javascript에 선택된 IU를 저장 */
function selectIU ( iunameList ){
    console.log('--------------------------');
    $('.selectedIUObj').removeClass('selectedIUObj');
    for (var i=0; i < iunameList.length ; i++ ){
        var iu = IU(iunameList[i]);
        iu.addClass('selectedIUObj');
        console.log(iu.attr('iuname'));
    }
    console.log('select'+iunameList);
    console.log('--------------------------');
    
    $('.selectedIUObj').updatePercent();

    var retDict = document.updatedPercentIUFrame;
    var retStr = JSON.stringify(retDict);
    document.updatedPercentIUFrame = {};
    return retStr;
}


function IUJSRun(str){
    eval(str);
    
    setAutoFrame();
    
    document.carouselDict = {};
    IUCarouselInitialize();
    
    
    $('.IUObj').updatePixel();
    $('.selectedIUObj').updatePercent();
    
    //document.updatedPixelIUFrame['window'] = {'width': $(window).width(), 'height': $(window).height() };
    //document.updatedPixelIUFrame['document'] = {'width': $(document).width(), 'height': $(document).height() };
    
    
    var retDict = {};
    retDict['pixel'] = document.updatedPixelIUFrame;
    retDict['percent'] = document.updatedPercentIUFrame;
    
    var retStr = JSON.stringify(retDict);
    
    document.updatedPixelIUFrame = {};
    document.updatedPercentIUFrame = {};
    
    return retStr;
}


/* 뭔 일이 있을때마다 불러주는 함수. Object들의 위치를 맞춰준다 */
function setAutoFrame() {
    var percentMarginElements = $('[percentHeightMargin="1"]').toArray();
    $.each(percentMarginElements, function(i, iu){
           var parentHeight = (parseFloat($(iu).parent().css('height')));
           var marginTop = 0
           var marginBottom =0 ;
           if(parentHeight!=0){
            marginTop = ((parseFloat($(iu).attr("marginTop")))*parentHeight)/100;
            marginBottom = ((parseFloat($(iu).attr("marginBottom")))*parentHeight)/100;
           }
           $(iu).css('margin-top',marginTop+'px');
           $(iu).css('margin-bootom', marginBottom+'px');
           
    });
    
    
    var respc = $('[verticalCenter="1"]').toArray();
    $.each(respc, function( i, iu ){
           var top = ((parseFloat($(iu).parent().css('height')) - parseFloat($(iu).parent().css('border-top')) - parseFloat($(iu).parent().css('border-bottom')) )-parseFloat($(iu).css('height')) )/2;
           var position = $(iu).css('position');
           if(position == "absolute")   $(iu).css('top', top);
           else $(iu).css('margin-top', top);
           
           });
    
    var respc = $('[horizontalCenter="1"]').toArray();
    $.each(respc, function( i, iu ){
           var left = ((parseFloat($(iu).parent().css('width')) - parseFloat($(iu).parent().css('border-left')) - parseFloat($(iu).parent().css('border-right')) )-parseFloat($(iu).css('width')) )/2;
           var position = $(iu).css('position');
           if(position == "absolute") $(iu).css('left', left);
           else $(iu).css('margin-left', left);
           });
    

    var naviBars = $('.IUNaviLinkBar').toArray();
    $.each(naviBars, function(i, naviBar){
        var naviItems = naviBar.children[0].children;
        var len = naviItems.length;
        var check = 100%naviItems.length;
           var width;

           if (check){
                width = 100/naviItems.length - 0.001 + '%'
           }
           else{
                width = 100/naviItems.length + '%'
           }

        for (var i=0; i<naviItems.length; i++){
            var child = naviItems[i];
            $(child).css('width',width);
            $(child).css('left','0px');
        }
    })
    
    var carousel = $('.IUCarouselItemBox').toArray();
    $.each(carousel, function(i, carouselbox){
           var items = $(carouselbox.children).filter('div');
           var boxwidth = $(carouselbox).parent().iuPosition().width;
           var boxheight = $(carouselbox).parent().iuPosition().height;
           
           for(var i=0; i<items.length; i++){
           
                var child = items[i]
                $(child).css('width', boxwidth+'px');
                $(child).css('height', boxheight+'px');
           }
        
    })
    
    var bottomStickers = $('.IUBottomSticker').toArray();
    $.each(bottomStickers, function(i, iu){
           var heightPixel = parseFloat($(iu).css('height'));
           var parentHeightPixel = parseFloat($(iu).parent().css('height'));
           $(iu).css('top', parentHeightPixel - heightPixel + 'px');
           })

    
    $.each($('.IUMovie').toArray(), function(index, value){
           var vid_w_orig;  // original video dimensions
           var vid_h_orig;
           var video = $(value).children()[0];
           vid_w_orig = parseInt($(video).attr('width'));
           vid_h_orig = parseInt($(video).attr('height'));
           
           // use largest scale factor of horizontal/vertical
           var scale_h = jQuery(value).width() / vid_w_orig;
           var scale_v = jQuery(value).height() / vid_h_orig;
           var scale = scale_h > scale_v ? scale_h : scale_v;
           
           // now scale the video
           $(video).width(scale * vid_w_orig);
           $(video).height(scale * vid_h_orig);
           
           // and center it by scrolling the video viewport
           $(video).css('left', '-' + ($(video).width() - $(value).width()) / 2 + 'px' );
           $(video).css('top', '-' + ($(video).height() - $(value).height()) / 2+ 'px' );
           $(video).css('position', 'relative' );
           });
    
    //template case
    if($('.IUPage').length ==0){
        //select body
        var templateHeight = $('.IUBody').parent().height();
        var headerwrapperHeight  = $('.IUHeaderWrapper').height();
        $('.IUBody').css('height', templateHeight - headerwrapperHeight);

    }
    
}


function setIUStyle(IUName, style, type) {
    s = style
    var classes = document.styleSheets[type].rules
    var selector = '[iuname="' + IUName + '"]'
    
    for(var x=0;x<classes.length;x++) {
        if(classes[x].selectorText==selector) {
            if (style!=null){
                classes[x].style.cssText = style;
            }
            else {
                document.styleSheets[type].deleteRule(x);
    
            }
            return "replace";
        }
    }
    if (style != null){
        document.styleSheets[type].addRule(selector, style, 0);
    }
    return "insert";
}


function responsiveSectionInit(){
    var resps = $('.IUResponsiveSection').toArray();
    console.log(resps);
    $.each(resps, function( i, iu ){
           var height = $(window).height() * (i+1) - $(iu).offset().top;
           $(iu).css('height', height);
           });
    
    var respc = $('.IUResponsiveContainer').toArray();
    $.each(respc, function( i, iu ){
           var top = (parseFloat($(iu).parent().css('height'))-parseFloat($(iu).css('height')) )/2;
           var heightCSS = $(iu).css('height');
           if (isPixel(heightCSS)){
           if ($(iu).parent().height() < parseFloat(heightCSS)){
                $(iu).parent().height(parseFloat(heightCSS));
           }
           }
           $(iu).css('top', top);
           });
    
}

function pageInit(){
   if ($('.IUPage').attr('autoHeight') == '0'){
        var windowHeight = $(window).height();
        var headerHeight = $('.IUHeaderWrapper').height();
        var minPageHeight = windowHeight - headerHeight;
        
        var originalPageHeight = 99999;
        for (var i=0; i<pageHeight.length; i++){
            dict = pageHeight[i];
            if ( $(window).width() < dict.width){
                originalPageHeight = dict.height;
            }
            else{
                break;
            }
        }
        
        if (minPageHeight > originalPageHeight){
            $('.IUPage').height(minPageHeight);
        }
        else{
            $('.IUPage').height(originalPageHeight);
        }
   }
   else{
       var windowHeight = $(window).height();
       var headerHeight = $('.IUHeaderWrapper').height();
       var minPageHeight = windowHeight - headerHeight;
       
       var originalPageHeight = 99999;
       for (var i=0; i<pageHeight.length; i++){
           dict = pageHeight[i];
           if ( $(window).width() < dict.width){
               originalPageHeight = dict.height;
           }
           else{
               break;
           }
       }
       
       if (minPageHeight > originalPageHeight){
           $('.IUPage').height(minPageHeight);
       }
   }
}


$(window).resize(function(){
                 if (isIUEditor == false){
                    responsiveSectionInit();
                    pageInit();
                 }
                 setAutoFrame();
                 });


function IURunResultThread(){
    $('.IUObj').updatePixel();
    if (document.updatedPixelIUFrame.length){
        console.log('IURunResult:'+JSON.stringify(document.updatedPixelIUFrame));
        document.updatedPixelIUFrame = {};
    }
}


$(document).ready(function(){
    valueInit();
    if (isIUEditor == 0){
        responsiveSectionInit();
        pageInit();
    }
                  
    else{
         setInterval(function(){IURunResultThread()}, 3000);
    }
    for (var iuReceiverName in receiverCTXs){
        initIUCTX(iuReceiverName);
    }
    for (var triggerObjName in triggerCTXs){
        triggerObj = triggerCTXs[triggerObjName];
        triggerIU = $('[iuname ='+triggerObjName + ']');
        triggerIU.bind(triggerObj['event'], valueAdd);
    }
    IUJSAnimation();
    document.updatedPixelIUFrame = {};
    document.updatedPercentIUFrame = {};

    loadFinished = true;


    console.log(setAutoFrame());
})
