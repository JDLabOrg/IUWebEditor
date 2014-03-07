//
//  IUVideo.h
//  Mango
//
//  Created by JD on 8/18/13.
//  Copyright (c) 2013 JD. All rights reserved.
//

#import "IUObj.h"

@interface IUMovie : IUObj

@property (nonatomic) NSString *movieFile;
@property NSString *posterPath;

@property BOOL enableControl, enablePreload, enableLoop, enableAutoPlay, enableMute, enablePoster;
@property BOOL cover;

@property (readonly) CGFloat width, height;
@property BOOL  gettingInfo;
@end