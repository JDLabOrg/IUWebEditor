//
//  IUTransitionView.h
//  WebGenerator
//
//  Created by JD on 3/3/14.
//  Copyright (c) 2014 jdlab.org. All rights reserved.
//

#import "IUView.h"

@interface IUTransitionInnerView : IUView
@property (nonatomic) BOOL  showing;
@end

@interface IUTransitionView : IUView{
    IUTransitionInnerView  *defaultView;
    IUTransitionInnerView  *overlapView;
}

@property (nonatomic) NSString  *transitionEvent;
@property (nonatomic) NSString  *animation;
@property (nonatomic) NSUInteger targetOpacity;

@end
