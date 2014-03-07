//
//  IUTwitter.m
//  Mango
//
//  Created by JD on 7/7/13.
//  Copyright (c) 2013 JD. All rights reserved.
//

#import "IUTwitter.h"

@implementation IUTwitter

@synthesize twitterSource;
@synthesize twitterType;

+(NSArray*)propertyList{
    return @[@"twitterSource" ];
}
-(BOOL)disableSource{
    return YES;
}

+(NSArray*)undoPropertyList{
    return @[@"twitterSource" ];
}


-(void)dealloc{
    [self removeObserver:self forKeyPath:@"twitterSource"];
}

-(void)twitterSourceDidChange{
    if (self.twitterSource) {
        self.source = self.twitterSource;
    }
    else{
        self.twitterSource = @"";
        self.source = @"";
    }
    [self setNeedsDisplay:IUNeedsDisplayActionHTML];
}

-(NSMutableDictionary*)dict{
    NSMutableDictionary *dict = [super dict];
    NSMutableDictionary *myDict = [self exportPropertyFromDictOfClass:[IUTwitter class]];
    if ([myDict count]) {
        [dict setObject:myDict forKey:@"IUTwitter"];
    }
    return dict;
}

-(void)loadWithDict:(NSDictionary *)dict{
    [super loadWithDict:dict];
    [self importPropertyFromDict:[dict objectForKey:@"IUTwitter"] ofClass:[IUTwitter class]];
}

-(void)iuLoad{
    [super iuLoad];
    [self addObserver:self forKeyPath:@"twitterSource" options:0 context:nil];
    
    self.iuFrame.disablePercent = YES;
    if (self.loadFromFile == NO) {
        self.twitterSource = @"<a class=\"twitter-timeline\" href=\"https://twitter.com/search?q=ashton+kutcher\" data-widget-id=\"388129232859041792\">Tweets about \"ashton kutcher\"</a>\
        <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+\"://platform.twitter.com/widgets.js\";fjs.parentNode.insertBefore(js,fjs);}}(document,\"script\",\"twitter-wjs\");</script>";
        self.iuFrame.currentScreenFrame.pixelWidth = 300;
        self.iuFrame.currentScreenFrame.pixelHeight = 400;
    }
}



@end
