//
//  MGInspectorVC.m
//  Mango
//
//  Created by JD on 13. 2. 2..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "MGInspectorVC.h"
#import "IUManager.h"
#import "IUObjs.h"
#import "MGProjectWC.h"
#import "IUCSSInspector.h"

@interface MGInspectorVC ()

@end

@implementation MGInspectorVC
@synthesize currentInsType;
//@synthesize syncIns;

- (void)awakeFromNib{
    
    NSLog(@"mg inspector awaken from Nib");
    [pWC addObserver:self forKeyPath:@"selectedIUManager" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionInitial context:nil];
    [self addObserver:self forKeyPath:@"currentInsType" options:0 context:nil];

   
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"currentInsType"];
    [pWC removeObserver:self forKeyPath:@"selectedIUManager"];
}
-(void)setPWC:(MGProjectWC *)pwc{
    pWC = pwc;
    
    _classIns = [[IUClassInspector alloc] initWithNibName:@"IUClassInspector" bundle:nil pWC:pWC];
    bindIns = [[IUBindInspector alloc] initWithNibName:@"IUBindInspector" bundle:nil pWC:pWC];
    cssIns = [[IUCSSInspector alloc] initWithNibName:@"IUCSSInspector" bundle:nil pWC:pWC];
    
    [self.view addSubviewFullFrame:_classIns.view];
    [self.view addSubviewFullFrame:bindIns.view];
    [self.view addSubviewFullFrame:cssIns.view];
    
    [self hideInsView];
    [_classIns.view setHidden:NO];
    
    [self.view setNeedsDisplay:YES];
}
- (void)hideInsView{
    [_classIns.view setHidden:YES];
    [bindIns.view setHidden:YES];
    [cssIns.view setHidden:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentInsType"]) {
 
        if (currentInsType == 0){ // class Ins
            [self hideInsView];
            [_classIns.view setHidden:NO]; return;
        }
        else if (currentInsType == 1){//bind ins
            [self hideInsView];
            [bindIns.view setHidden:NO]; return;
        }

        else if (currentInsType == 2){//CSSIns
            [self hideInsView];
            [cssIns.view setHidden:NO]; return;
        }

        return;
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}



@end
