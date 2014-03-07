//
//  IUView3.m
//  Mango
//
//  Created by JD on 7/6/13.
//  Copyright (c) 2013 JD. All rights reserved.
//

#import "IUView3.h"
#import "IUObj.h"
#import "IULayer.h"
#import "IUViewManager.h"


@implementation IUView3 {
    // if wantsLayer = YES
    // IULayer includes coverView
    IULayer        *iuLayer;
    
    // webView = YES;
    // if wantsLayer = YES and webView = YES, it makes error
    WebView         *webView;
    NSView          *layerView;
    
    BOOL            wantsLayer;
    
    NSView *contentView;
    
    NSMutableArray  *copiedViews;
    NSMutableArray  *iuSubviews;
}

@synthesize bgColor, bgImage;

@synthesize image;
@synthesize string;

@synthesize iuLayer;
@synthesize contentView;


-(id)initWithIUFrame:(IUFrame*)iuFrame{
    return [self initWithIUFrame:iuFrame wantsLayer:YES];
}

-(void)addIUSubview:(IUView3*)aView{
    [self.childView addSubview:aView];
    [iuSubviews insertObject:aView atIndex:0];
}


-(void)removeIUSubview:(IUView3*) subView{
    [subView removeFromSuperview];
    [iuSubviews removeObject:subView];
}

-(void)removeFromIUSuperview{
    IUView3 *superView = (IUView3*)[self superview].superview;
    [superView removeIUSubview:self];
}

-(void)insertIUSubview:(IUView3 *)aView{
    int z = aView.iuFrame.layout.z;
    for (IUView3 *subview in iuSubviews) {
        if (subview.iuFrame.layout.z < z) {
            [self insertIUSubview:aView positioned:NSWindowAbove relativeTo:subview];
            return;
        }
    }
}

-(void)insertIUSubview:(IUView3 *)aView positioned:(NSWindowOrderingMode)place relativeTo:(IUView3*)otherView{
    //인덱스가 높을 수록 위로
    NSUInteger otherIdx = [iuSubviews indexOfObject:otherView];
    if (otherView == nil) {
        otherIdx = 0;
        place = NSWindowAbove;
    }
    if (otherIdx == NSNotFound) {
        [NSException raise:@"insert error" format:nil];
    }
    if (place == NSWindowBelow && otherView == [iuSubviews lastObject]) {
        [self.childView addSubview:aView positioned:place relativeTo:otherView];
    }
    else{
        [self.childView addSubview:aView positioned:place relativeTo:otherView];
    }
    if (place == NSWindowAbove) {
        [iuSubviews insertObject:aView atIndex:otherIdx];
    }
    else{
        [iuSubviews insertObject:aView atIndex:otherIdx+1];
    }
}

//wantslayer 가 No 일 경우 :
//textview나 webview 일경우
//contentView 를 폐기하고 edit view를 넣어야할듯.
//최대한 webview로 이용

-(id)initWithIUFrame:(IUFrame*)iuFrame wantsLayer:(BOOL)_wantsLayer{
    self = [super initWithFrame:iuFrame.layout.rect];
    if (self) {

        wantsLayer = _wantsLayer;
        self.iuFrame = iuFrame;
        if (wantsLayer) {
            //only IUObj support this
            contentView = [[JDView alloc] init];
            iuLayer = [[IULayer alloc] init];
            [contentView setLayer:iuLayer];
            [contentView setWantsLayer:YES];
            [self addSubviewFullFrame:contentView];
        }
        else{
            contentView = [self InitWithIUFrameContentView];
            if (contentView) {
                [contentView setWantsLayer:YES];
                [self addSubviewFullFrame:contentView];
            }
            [self setWantsLayer:YES];
        }

        self.childView = [[JDView alloc] init];
        [self addSubviewFullFrame:self.childView];

        [self.iuFrame addObserver:self forKeyPaths:@[@"layout.rect"] options:NSKeyValueObservingOptionInitial contexts:@[@"frame", @"webView"]];
        [self addObserver:self forKeyPaths:@[@"webSource"] options:NSKeyValueObservingOptionInitial context:@"webView"];
        [self addObserver:self forKeyPaths:@[@"bgColor"] options:NSKeyValueObservingOptionInitial context:@"webView"];
        
        //TODO : change it manually;
        self.borderColor = [NSColor yellowColor];
        [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"showBorder" options:NSKeyValueObservingOptionInitial context:nil];
        
        copiedViews = [NSMutableArray array];
        iuSubviews = [NSMutableArray array];
    }
    return self;
}


-(void)stopWebViewLoading{
    [webView setMainFrameURL:nil];
    [webView stopLoading:nil];
    [webView.mainFrame stopLoading];
}


-(void)showBorderDidChange{
   
    BOOL border = [[NSUserDefaults standardUserDefaults] boolForKey:@"showBorder"];
 
    if (border) {
        
        BOOL showWebSimulator = [[NSUserDefaults standardUserDefaults] boolForKey:@"webSimulatorView"];
        if(showWebSimulator){//if websimulator is true, turn off it
            [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"webSimulatorView"];
        }
        
        if (self.layer == nil) {
            double delayInSeconds = 0.01;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    if (self.layer != nil) {
                        self.layer.borderWidth = 1;
                        self.layer.borderColor = [self.borderColor CGColor];

                    }
                });
            
        }
        else{
            self.layer.borderWidth = 1;
            self.layer.borderColor = [self.borderColor CGColor];
        }
    }
    else{
        self.layer.borderWidth = 0;
    }
}

-(id)InitWithIUFrameContentView{
    return [[JDView alloc] init];
}

-(void)webViewContextDidChange{
    /*
    if (useWebView) {
        NSRect  rect = self.iuFrame.layout.rect;
        self.frame = rect;

        [self setWidth:_iuFrame.layout.width + _additionalWidth];
        [self setHeight:_iuFrame.layout.height + _additionalHeight];
        
        if (webView == nil) {
//            webView = [[ alloc] init];
            [self addSubviewFullFrame:webView positioned:NSWindowAbove relativeTo:contentView];
        }
        

        [contentView setHidden:YES];
        
        [webView setHidden:NO];
        [[webView mainFrame] loadHTMLString:self.webSource baseURL:self.webBaseURL];
    }
    else{
        NSRect  rect = self.iuFrame.layout.rect;
        self.frame = rect;

        [contentView setHidden:NO];
        [webView setHidden:YES];
    }*/
}


-(void)frameContextDidChange{
//    NSRect  rect = self.iuFrame.layout.rect;
//    self.frame = rect;
    [self webViewContextDidChange];
}


-(BOOL)isFlipped{
    return YES;
}

/*
- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender{
    if (self.draggingDelegate) {
        return [self.draggingDelegate performDragOperation:sender];
    }
    return NO;
}


-(NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender    {
    return NSDragOperationEvery;
}
*/

- (void)keyDown:(NSEvent *)event{
    
}

-(id)copyView{
    IUView3 *v = [[IUView3 alloc] initWithIUFrame:self.iuFrame wantsLayer:wantsLayer];
    [v bind:@"image" toObject:self withKeyPath:@"image" options:nil];
    [v bind:@"bgColor" toObject:self withKeyPath:@"bgColor" options:nil];
    [v bind:@"bgImage" toObject:self withKeyPath:@"bgImage" options:nil];
    [v bind:@"bgRepeat" toObject:self withKeyPath:@"bgRepeat" options:nil];
    [v bind:@"webSource" toObject:self withKeyPath:@"webSource" options:nil];
 //   [v bind:@"useWebView" toObject:self withKeyPath:@"useWebView" options:nil];
    [v bind:@"borderColor" toObject:self withKeyPath:@"borderColor" options:nil];
//    [v bind:@"draggingDelegate" toObject:self withKeyPath:@"draggingDelegate" options:nil];
    for (IUView3 * sView in iuSubviews) {
        [v addSubview:[sView copyView]];
    }
    
    [copiedViews addObject:v];
    return v;
}

@end