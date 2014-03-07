//
//  IUOverlapImage.h
//  WebGenerator
//
//  Created by JD on 1/24/14.
//  Copyright (c) 2014 jdlab.org. All rights reserved.
//

#import "IUImage.h"

@interface IUOverlapImage : IUImage
@property (nonatomic) NSImage   *eventImage;
@property (nonatomic) NSString  *eventImageStr;
@property (nonatomic) NSInteger targetOpacity;
@property (nonatomic) NSString  *transitionEvent;
@end
