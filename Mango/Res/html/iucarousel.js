document.carouselDict = {};

$.fn.carousel = function(){
	return {
	length:0,  		// 	the number of items
	current:0,		// 	current index
	width: 0,		//	carouselItemBox width -- contentbox Width
     
    //prev - click
	prev: function(iuname){
		if(this.current >0){
			this.current = this.current -1;
		}else{
			this.current = this.length-1;
		}
		this.animation(iuname);
	},
    
    //next - click
	next:function(iuname){
		if(this.current < this.length-1){
			this.current = this.current+1;
		}
		else{
			this.current = 0;
		}
		this.animation(iuname);
	},
    
    //barcontrol -click
	clickIndex:function(iuname, index){
		this.current = index;
		this.animation(iuname);
	},
    
    //move
	animation: function(iuname){
		var currentItems = IU(iuname).children().filter('.IUCarouselItemBox').children().filter('div');
		var boxWidth = IU(iuname).iuPosition().width;
		
		var left = (-1)*this.current* boxWidth;
		var firstItem = currentItems[0];
		$(currentItems).stop().animate(
                                       {'left' : left},
                                       1000
                                       );
        
		var controlItems = IU(iuname).children().filter('.IUCarouselControlBar').children().filter('div');
		$(controlItems).css('background-color', 'transparent');
        var selectedControl = controlItems[this.current];
        var color = $(selectedControl).css('border-color');
		$(selectedControl).css('background-color', color);
        
        console.log('change color');
	},
        
        
    initialize : function(iu, iuname){
            
            //setting for click
            //Next
            $(iu).children().filter(".IUNext").click(function(){
                                                     var iuname = $(this).parent().iuName();
                                                     document.carouselDict[iuname].next(iuname);
                                                     });
            
            //Prev
            $(iu).children().filter(".IUPrev").click(function(){
                                                     var iuname = $(this).parent().iuName();
                                                     document.carouselDict[iuname].prev(iuname);
                                                     });
            
			$(iu).children().filter(".IUCarouselControlBar").children().click(function(){
                                                                              var iuname = $(this).parent().parent().iuName();
                                                                              var index = $(this).attr('c-index');
                                                                              document.carouselDict[iuname].clickIndex(iuname, index);
                                                                              })
        }
	}
}

function selectIUCarousel(iuname, index){
    console.log('selectIUCarousel : '+iuname+' index :'+index);
    document.carouselDict[iuname].clickIndex(iuname, index);
}


function IUCarouselInitialize(){
	var iucarouselIUs = $('.IUCarousel').toArray();
	$.each(iucarouselIUs, function(i, iu){
           var iuname = $(iu).iuName();
           document.carouselDict[iuname] = $(iu).carousel();
           document.carouselDict[iuname].length = parseInt($(iu).children().filter('.IUCarouselItemBox').children().filter('div').length)
           document.carouselDict[iuname].width = $(iu).children().filter('.IUCarouselItemBox').iuPosition().width;
           document.carouselDict[iuname].initialize(iu, iuname);
           
           });
}

$(document).ready(function(){
                  
                  IUCarouselInitialize();
                  var iucarouselIUs = $('.IUCarousel').toArray();
                  $.each(iucarouselIUs, function(i, iu){
                         var iuname = $(iu).iuName();
                         selectIUCarousel(iuname, 0);
                         });
                  
                  
                  })