//
//  IUEventVariableFrameReceiver.h
//  WebGenerator
//
//  Created by JD on 13. 10. 31..
//  Copyright (c) 2013년 jdlab.org. All rights reserved.
//

#import "IUEventVariableReceiver.h"
#import "IUEvent.h"

@interface IUEventVariableFrameReceiver : IUEventVariableReceiver
@property   (nonatomic) NSString  *x;
@property   (nonatomic) NSString  *y;
@property   (nonatomic) NSString  *width;
@property   (nonatomic) NSString  *height;
@end