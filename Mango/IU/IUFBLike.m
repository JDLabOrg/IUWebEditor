//
//  IUFBLike.m
//  WebGenerator
//
//  Created by ChoiSeungmi on 2014. 1. 27..
//  Copyright (c) 2014년 jdlab.org. All rights reserved.
//

#import "IUFBLike.h"

@implementation IUFBLike

#pragma mark -
#pragma mark initialize

-(id)instantiate{
    [super instantiate];
    self.fbSource = @"<iframe src=\"//www.facebook.com/plugins/like.php?href=__FB_LINK_ADDRESS__+&amp;width&amp;layout=standard&amp;action=like&amp;show_faces=__SHOW_FACE__&amp;share=true&amp;\" scrolling=\"no\" frameborder=\"0\" style=\"border:none; overflow:hidden; height:__HEIGHT__px\" allowTransparency=\"true\"></iframe>";
    self.source = self.fbSource;
    self.iuFrame.defaultScreenFrame.pixelHeight=80;
    self.iuFrame.defaultScreenFrame.pixelWidth=350;
    self.iuFrame.disableHeight = YES;
    self.bg.color = nil;
    
    //show_faces true:false
    //1)true height ==80;
    //2)false height = 35;
    self.showFriendsFace = YES;
    self.likePage = @"";
    
    return self;
}

-(void)iuLoad{
    [super iuLoad];
    [self addObserver:self forKeyPaths:@[@"showFriendsFace", @"likePage"] options:0 context:@"IUFBSource"];
    
}
-(void)dealloc{
    [self removeObserver:self forKeyPaths:@[@"showFriendsFace", @"likePage"]];
}

-(BOOL)shouldChangeHeightByUserInput:(CGFloat)height{
    return NO;
}


#pragma mark - 
#pragma mark observing

-(void)IUFBSourceContextDidChange{
    NSString *showFaces;
    if(self.showFriendsFace){
        self.iuFrame.currentScreenFrame.pixelHeight = 80;
        showFaces = @"true";
    }else{
        self.iuFrame.currentScreenFrame.pixelHeight = 35;
        showFaces = @"false";
    }
    NSString *currentPixel = [[NSString alloc] initWithFormat:@"%.0f", self.iuFrame.currentScreenFrame.pixelHeight];
    [self setNeedsDisplayStartGrouping];
    
    self.source = [self.fbSource stringByReplacingOccurrencesOfString:@"__HEIGHT__" withString:currentPixel];
    self.source = [self.source stringByReplacingOccurrencesOfString:@"__SHOW_FACE__" withString:showFaces];
    
    self.source = [self.source stringByReplacingOccurrencesOfString:@"__FB_LINK_ADDRESS__" withString:self.likePage];
    [self setNeedsDisplay:IUNeedsDisplayActionAll];
    [self setNeedsDisplayEndGrouping];
    
}

-(NSString *)innerHTML2:(id)caller{
    NSString *fbPath = [[NSBundle mainBundle] pathForResource:@"FBSampleImage" ofType:@"png"];
    NSString *innerSource = [NSString stringWithFormat:@"<div><img src=\"%@\" align=\"middle\" style=\"float:left;margin:0 5px 0 0; \" ><p style=\"font-size:11px ; font-family:'Helvetica Neue', Helvetica, Arial, 'lucida grande',tahoma,verdana,arial,sans-serif\">263,929 people like this. Be the first of your friends.</p></div>", fbPath];
    return innerSource;
    
}


@end
