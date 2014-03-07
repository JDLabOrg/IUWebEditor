//
//  IUTwitter.h
//  Mango
//
//  Created by JD on 7/7/13.
//  Copyright (c) 2013 JD. All rights reserved.
//

#import "IUHTML.h"

@interface IUTwitter : IUHTML{
    NSString    *twitterSource;
    NSUInteger  twitterType;
}

@property   NSString    *twitterSource;
@property   NSUInteger  twitterType;

@end
