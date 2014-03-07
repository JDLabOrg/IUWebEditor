//
//  IUVideo.m
//  Mango
//
//  Created by JD on 8/18/13.
//  Copyright (c) 2013 JD. All rights reserved.
//

#import "IUMovie.h"
#import <AVFoundation/AVFoundation.h>
#import "IUImageUtil.h"

@interface IUMovie()
@property (nonatomic) CGFloat width, height;
@end
@implementation IUMovie{
    NSString *embedSource;
}

#pragma mark -
#pragma mark initialize

-(id)instantiate{
    [super instantiate];
//    self.showOverflow = YES;
    self.enablePoster = YES;
    return self;
}

+(NSArray*)propertyList{
    return [self autoPropertyList];
}

+(NSMutableArray *)undoPropertyList{
    NSMutableArray *array = [super undoPropertyList];
    [array addObjectsFromArray:@[@"movieFile", @"posterPath", @"enableControl", @"enablePreload",
                                @"enableLoop", @"enableAutoPlay", @"enableMute", @"enablePoster",
                                 ]];
    return array;
}

-(void)iuLoad{
    [super iuLoad];
    embedSource = @"<source src=\"$moviename$\" type=\"video/$type$\">\
    \n\t<object data=\"$moviename$\" width=\"100%\" height=\"100%\">\
    \n\t\t<embed width=\"100%\" height=\"100%\" src=\"$moviename$\">\
    \n\t</object>\
    \n";
    
    [self addObserver:self forKeyPaths:@[@"poster", @"enableControl", @"enablePreload", @"enableLoop", @"enableAutoPlay", @"enableMute", @"enablePoster", @"cover"]
              options:nil context:@"@selector(setNeedsDisplayHTML)"];

    [self prepareMovieFile];
}


#pragma mark load

-(NSMutableDictionary *)dict{
    NSMutableDictionary *dict = [super dict];
    [dict setObject:[self exportPropertyFromDictOfClass:[IUMovie class]] forKey:@"IUMovie"];
    return dict;
}

-(NSString*)HTMLClassString{
    NSString *superStr = [super HTMLClassString];
    if (self.enableControl == NO) {
        return [superStr stringByAppendingString:@" NoControl"];
    }
    return superStr;
}


-(void)loadWithDict:(NSDictionary *)dict{
    [super loadWithDict:dict];
    [self importPropertyFromDict:[dict objectForKey:@"IUMovie"] ofClass:[IUMovie class]];
}

#pragma mark -
#pragma mark video thumbnail

-(void)setMovieFile:(NSString *)movieFile{
    _movieFile = movieFile;
    [self setNeedsDisplayStartGrouping];
    if (self.iuLoaded) {
        self.gettingInfo = YES;
        [self prepareMovieFile];
    }
    [self setNeedsDisplay:IUNeedsDisplayActionHTML];
    [self setNeedsDisplayEndGrouping];
}

-(void)prepareMovieFile{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void){
        //get thumbnail from video file
        NSURL *movefileURL;
        if ([_movieFile isHTTPURL]) {
            movefileURL = [NSURL URLWithString:_movieFile];
        }
        else{
            NSString *moviefilePath = [[NSString alloc] initWithFormat:@"%@/%@", self.iuManager.pWC.project.absoluteResDirPath ,_movieFile];
            movefileURL = [NSURL fileURLWithPath:moviefilePath];
        }
        NSImage *thumbnail = [self thumbnailOfVideo:movefileURL];
        
        
        
        //save thumbnail
        NSString *videoname = [[_movieFile lastPathComponent] stringByDeletingPathExtension];
        NSString *thumbFileName = [[NSString alloc] initWithFormat:@"%@_thumbnail.png", videoname];
        
        [IUImageUtil writeToFile:thumbnail filePath:self.iuManager.pWC.project.absoluteResDirPath fileName:thumbFileName checkFileName:NO];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //set ImageFileSize
            [self setNeedsDisplayStartGrouping];
            self.width  = thumbnail.size.width;
            self.height = thumbnail.size.height;
            self.posterPath = [self.iuManager.pWC.project.resDir stringByAppendingString:thumbFileName];
            [self setNeedsDisplay:IUNeedsDisplayActionHTML];
            [self setNeedsDisplayEndGrouping];
            self.gettingInfo = NO;
        });
    });
}

-(NSImage *)thumbnailOfVideo:(NSURL *)url{
    
    AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform=TRUE;
    CMTime thumbTime = CMTimeMakeWithSeconds(0,30);
    CMTime actualTime;
    NSImage *thumbImg;
    
    CGImageRef halfWayImage = [generator copyCGImageAtTime:thumbTime actualTime:&actualTime error:nil];
    if(halfWayImage != NULL){
        thumbImg=[[NSImage alloc] initWithCGImage:halfWayImage size:NSZeroSize];

    }
    
    return thumbImg;

}

#pragma mark -
#pragma mark Make HTML

//video attributes - (name) - no value
-(NSMutableArray *)movieHTMLArray{
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@"controls"]; // always set controls = true, if it does not use control, remove it at javascript (Chrome overlay video bug)
    
    if (self.enableControl == NO) {
        [array addObject:@"movieNoControl = \"1\""];
    }
    if(self.enableLoop){
        [array addObject:@"loop"];
    }
    
    if(self.enableMute){
        [array addObject:@"muted"];
    }
    if(self.enableAutoPlay){
        [array addObject:@"autoplay"];
    }

    return array;
}

//video attribute - (name, value)
-(NSMutableDictionary *)movieHTMLDict{
    NSMutableDictionary *dict =[NSMutableDictionary dictionary];
    if(self.enablePoster){
        [dict setObject:self.posterPath forKey:@"poster"];
    }
    
    
    return dict;
}

-(NSMutableString *)videoHTML:(BOOL)inner{
    NSMutableString *videoSrc = [NSMutableString string];
    if (self.cover) {
        [videoSrc appendFormat:@"<video width=%.0fpx height=%.0fpx", self.width, self.height];
    }
    else{
        [videoSrc appendString:@"<video width=100% height=100%"];
    }
    
    NSMutableArray *movieArray = [self movieHTMLArray];
    
    if(inner == YES){
        [movieArray removeObject:@"autoplay"];
    }
    
    for(NSString *attribute in movieArray){
        [videoSrc appendFormat:@" %@", attribute];
    }
    
    NSMutableDictionary *movieDict = [self movieHTMLDict];
    for(NSString *key in movieDict){
        [videoSrc appendFormat:@" %@='%@'", key, [movieDict objectForKey:key]];
    }
    
    [videoSrc appendString:@">\n"];
    
    //for supporting all browser
    NSMutableString *retStr = [embedSource mutableCopy];
    if ([self.movieFile isHTTPURL]) {
        [retStr replaceOccurrencesOfString:@"$moviename$" withString:self.movieFile options:0 range:NSMakeRange(0, retStr.length)];
    }
    else {
        [retStr replaceOccurrencesOfString:@"$moviename$" withString:[self.iuManager.pWC.project.resDir stringByAppendingString:self.movieFile] options:0 range:NSMakeRange(0, retStr.length)];
    }
    [retStr replaceOccurrencesOfString:@"$type$" withString:self.movieFile.pathExtension options:0 range:NSMakeRange(0, retStr.length)];
    
    [videoSrc appendString:retStr];
    
    [videoSrc appendString:@"</video>\n"];
    
    return videoSrc;
    
}


-(NSString*)innerHTML2:(id)caller{
    if (self.movieFile == nil) {
        return @"";
    }
    else{
        return [self videoHTML:YES];
    }
}

-(NSMutableString*)innerOutputHTML2{
    if (self.movieFile == nil) {
        return [@"" mutableCopy];
    }
    else{
        return [self videoHTML:NO];
    
    }
}

#pragma mark -
#pragma mark overriding

-(void)setShowOverflow:(BOOL)_showOverflow{
    //화면이 깨질 경우엔 showOverflow를 무조건 YES로 처리한다.
    //현재는 그런 경우 업ㅂ음
    showOverflow = _showOverflow;
//    showOverflow = YES;
    return;
}
@end