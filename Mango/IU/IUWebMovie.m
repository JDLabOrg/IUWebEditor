//
//  IUWebMovie.m
//  Mango
//
//  Created by JD on 8/19/13.
//  Copyright (c) 2013 JD. All rights reserved.
//

#import "IUWebMovie.h"
#import "IUManager.h"
#import "IUViewManager.h"

@implementation IUWebMovie

@synthesize webMovieSource;

+(NSArray *)propertyList{
    return@[@"webMovieSource"];
}

/*thumbnail
 <youtube - video id>
 http://stackoverflow.com/questions/2068344/how-do-i-get-a-youtube-video-thumbnail-from-the-youtube-api
 http://img.youtube.com/vi/9bZkp7q19f0/sddefault.jpg
 
 <vimeo - >
 http://stackoverflow.com/questions/1361149/get-img-thumbnails-from-vimeo 
 
*/


-(id)instantiate{
    [super instantiate];
    self.iuFrame.defaultScreenFrame.pixelWidth = 560;
    self.iuFrame.defaultScreenFrame.pixelHeight = 315;
    self.webMovieSource=@"<iframe width=\"560\" height=\"315\" src=\"//www.youtube.com/embed/9bZkp7q19f0?list=PLEC422D53B7588DC7\" frameborder=\"0\" allowfullscreen></iframe>";
    self.iuFrame.disablePercent = YES;
    return self;
}


-(void)iuLoad{
    [super iuLoad];
    [self addObserver:self forKeyPaths:@[@"iuFrame.currentScreenFrame.pixelWidth", @"iuFrame.currentScreenFrame.pixelHeight", @"webMovieSource"] options:NSKeyValueObservingOptionInitial context:@"IUWebMovie"];
    
    //initialize source
    //[self IUWebMovieContextDidChange];
}

-(void)dealloc{
    [self removeObserver:self forKeyPaths:@[@"iuFrame.currentScreenFrame.pixelWidth", @"iuFrame.currentScreenFrame.pixelHeight", @"webMovieSource"]];
}

#pragma mark -
#pragma mark XXXDidChange

-(void)webMovieSourceDidChange{
    // get a thumbnail
    // editor에서는 tumbnail로 표시한다.
    // 비디오 동작이 느리기 때문.
    // 1. youtube
    if ([self.webMovieSource containsString:@"youtube"]){
        NSRange range = [self.webMovieSource rangeOfString:@"/embed/"];
        NSInteger start = range.length+range.location;
        NSString *idStr = [self.webMovieSource substringWithRange:NSMakeRange(start, 11)];
        if([thumbnailID isEqualToString:idStr]){
            return;
        }
        thumbnailID = idStr;
        thumbnailSource = [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/sddefault.jpg", idStr ];
        thumbnail = YES;
        NSString *barPath = [[NSBundle mainBundle] pathForResource:@"youtubebar" ofType:@"png"];
        
        thumbnailBar = [NSString stringWithFormat:@"<img src = \"%@\" width='100%%' height='44px' style='position:absolute; bottom:0px; left:0px; opacity:0.6'>", barPath];
        
        [self setNeedsDisplay:IUNeedsDisplayActionHTML];
        return;

    }
    // 2. vimeo
    else if ([self.webMovieSource containsString:@"vimeo"]){
        NSRange range = [self.webMovieSource rangeOfString:@"/video/"];
        NSInteger start = range.length+range.location;
        NSString *idStr = [self.webMovieSource substringWithRange:NSMakeRange(start, 8)];
        if([thumbnailID isEqualToString:idStr]){
            return;
        }
        thumbnailID = idStr;
        NSURL *filePath =[NSURL URLWithString:[NSString stringWithFormat:@"http://www.vimeo.com/api/v2/video/%@.json", idStr]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) , ^{
            NSData* data = [NSData dataWithContentsOfURL:
                            filePath];
            [self performSelectorOnMainThread:@selector(fetchedVimeoData:)
                                   withObject:data waitUntilDone:YES];
        });
        
        /* vimeo example src
         *
         <iframe src="//player.vimeo.com/video/87939713?title=0&amp;byline=0&amp;portrait=0&amp;color=afd9cd" width="500" height="281" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe> <p><a href="http://vimeo.com/87939713">Happy Camper - The Daily Drumbeat</a> from <a href="http://vimeo.com/jobjorismarieke">Job, Joris &amp; Marieke</a> on <a href="https://vimeo.com">Vimeo</a>.</p>
         */
        return;
    }
    thumbnail = NO;
    
}

- (void)fetchedVimeoData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSArray* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];

    NSDictionary* vimeoDict = json[0];
    NSString *thumbnailAddr = [vimeoDict objectForKey:@"thumbnail_large"]; //2
    thumbnailSource = thumbnailAddr;
    thumbnail = YES;
    
    NSString *barPath = [[NSBundle mainBundle] pathForResource:@"vimeobar" ofType:@"png"];

    thumbnailBar = [NSString stringWithFormat:@"<img src = \"%@\" width='100%%' height='57px' style='position:absolute; bottom:0px; left:0px; opacity:0.6'>", barPath];
    
    [self setNeedsDisplay:IUNeedsDisplayActionHTML];

    
}

-(void)IUWebMovieContextDidChange{
    
    
    NSLog(@"moviechange");
    [self setNeedsDisplayStartGrouping];
    
    if ([webMovieSource containsString:@"src=\"//"]) {
        self.source = [webMovieSource stringByReplacingOccurrencesOfString:@"src=\"//" withString:@"src=\"http://"];
    }
    
    if([self.source containsString:@"height"]){
        NSRegularExpression *regex=[NSRegularExpression regularExpressionWithPattern:@"height=\"([0-9]*)\""
                                                                             options:NSRegularExpressionCaseInsensitive error:nil];
        
        self.source = [regex stringByReplacingMatchesInString:self.source
                                                    options:0
                                                    range:NSMakeRange(0, [self.source length])
                                                    withTemplate:[NSString stringWithFormat:@"height=100%%"]];
    }
    
    if([self.source containsString:@"width"]){
        NSRegularExpression *regex=[NSRegularExpression regularExpressionWithPattern:@"width=\"([0-9]*)\""
                                                                             options:NSRegularExpressionCaseInsensitive error:nil];
        
        self.source = [regex stringByReplacingMatchesInString:self.source
                                                         options:0
                                                           range:NSMakeRange(0, [self.source length])
                                                    withTemplate:[NSString stringWithFormat:@"width=100%%"]];
    }
    
    [self setNeedsDisplay:IUNeedsDisplayActionAll];
    [self setNeedsDisplayEndGrouping];

}

#pragma mark - HTML
-(NSString *)innerHTML2:(id)caller{
    if(thumbnail){
        NSString *imgSrc = [NSString stringWithFormat: @"<img src = \"%@\" width='100%%' height='100%%' style='position:relative'> %@", thumbnailSource, thumbnailBar];
        
        return imgSrc;
    }
    else{
        return self.source;
    }
}

#pragma mark - dict

-(NSMutableDictionary *)dict{
    NSMutableDictionary *dict = [super dict];
    [dict setObject:[self exportPropertyFromDictOfClass:[IUWebMovie class]] forKey:@"IUWebMovie"];
    return dict;
}

-(void)loadWithDict:(NSDictionary *)dict{
    [super loadWithDict:dict];
    [self importPropertyFromDict:[dict objectForKey:@"IUWebMovie"] ofClass:[IUWebMovie class]];
}
@end