//
//  IUWebView.h
//  Mango
//
//  Created by JD on 7/6/13.
//  Copyright (c) 2013 JD. All rights reserved.
//

#import "IUHTML.h"
#import <WebKit/WebKit.h>

/*@interface IUWebView : IUView3{
}*/
@interface IUWebView : NSView{
    
}


@property NSString  *source;

-(id)initWithIUFrame:(IUFrame *)_iuFrame;

@end