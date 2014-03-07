//
//  MGInitWC3.m
//  Mango
//
//  Created by JD on 13. 5. 10..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "MGNewProjectWC.h"
#import "MGAppDelegate.h"
#import "IUProject.h"
#import "MGProjectWC.h"
#import <objc/message.h>
#import "MGNewProjectVC.h"
#import "IURackProject.h"
#import "IUPresProject.h"
#import "IUDjangoProject.h"
#import "IUBody.h"
#import "IUHttpLog.h"
#import "MGSampleProjectSelectionVC.h"


@interface MGNewProjectWC ()

@end

@implementation MGNewProjectWC {
}

@synthesize templateProjectVC;

-(NSArray*)projectTypeList{
    return @[@"IURackProject", @"IUPresProject", @"IUDjangoProject"];
}

- (id)initWithWindowNibName:(NSString *)windowNibName PWC:(MGProjectWC*)pWC startType:(IUStartType)aStartType{
    self = [super initWithWindowNibName:windowNibName];
    if (self) {
        _pWC = pWC;
        startType = aStartType;

    }
    return self;
}


-(void)windowDidLoad{
    /* new project*/
    [_mainV addSubview:_firstV];
    [_prevBtn setEnabled:NO];
    
    IUWidget *rackWidget = [IURackProject widget];
    [self.projectTypeAC addObject:rackWidget];

    IUWidget *presWidget = [IUPresProject widget];
    [self.projectTypeAC addObject:presWidget];

    IUWidget *djangoWidget = [IUDjangoProject widget];
    [self.projectTypeAC addObject:djangoWidget];

    [self.projectTypeAC setSelectionIndex:0];
    
    
    /* template Project */
    templateProjectVC = [[MGSampleProjectSelectionVC alloc] initWithNibName:@"MGSampleProjectSelectionVC" bundle:nil];
    templateProjectVC.nProjectWC = self;
    [self.templateV addSubviewFullFrame:templateProjectVC.view];
    
    
    /* recent Project*/
    NSArray *recentDocuments = [[NSDocumentController sharedDocumentController] recentDocumentURLs];
    
    for(NSURL *url in recentDocuments){

        NSDictionary *documentDict = [[NSFileManager defaultManager] attributesOfItemAtPath:[url path] error:nil];
        
        NSMutableDictionary *recentDict = [NSMutableDictionary dictionary];
        [recentDict setObject:[url lastPathComponent] forKey:@"name"];
        [recentDict setObject:url forKey:@"url"];
        [recentDict setObject:[url path] forKey:@"path"];

        NSMutableDictionary *projectDict = [self projectDictWithPath:[url path]];
        [recentDict merge:projectDict];
        
        NSImage *image = [NSClassFromString([projectDict objectForKey:@"projectType"]) icon];
        [recentDict setObject:image forKey:@"image"];
        
        //set date
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
        
        NSDate *date = [documentDict objectForKey:@"NSFileModificationDate"];
        NSString *formattingDateString = [dateFormatter stringFromDate:date];
        [recentDict setObject:formattingDateString forKey:@"fileDate"];
        
        //set dict
        [self.recentArray addObject:recentDict];
    }
    
    [self.recentArray setSelectionIndex:0];
    if(startType == IUStartTypeLaunch){
        if(recentDocuments.count > 0){
            //show recent project
            [self.tabView selectTabViewItemAtIndex:IUStartTypeRecent];
        }else{
            [self.tabView selectTabViewItemAtIndex:IUStartTypeTemplate];
        }
    }else{
        [self.tabView selectTabViewItemAtIndex:startType];
    }
//    [self.tabView selectTabViewItemAtIndex:IUStartTypeNew];


    
}

/* index : select tab
 * 0 : template project
 * 1 : new project
 * 2 : recent project
 */
-(void)selectTabViewItemAtIndex:(NSInteger)index{
    [self.tabView selectTabViewItemAtIndex:index];
}


- (void)loadProject:(NSString *)loadPath type:(NSString *)type{
    //type is loaded, new, template -- use when checking
    self.filePath = loadPath;
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseOK];
    
}

-(void)doubleClick:(id)sender{
    NSLog(@"double Click");
    NSInteger index = [self.tabView indexOfTabViewItem:[self.tabView selectedTabViewItem]];
    if(index == IUStartTypeRecent){
        [self loadRecentProject:sender];
    }else if(index == IUStartTypeNew){
        [self pressNextBtn:sender];
    }
    
}

#pragma mark -
#pragma mark make new projects


- (IBAction)pressCancel:(id)sender {
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseCancel];
}

- (IBAction)pressPrevBtn:(id)sender {
    NSRect firstFrame =[_firstV frame];
    firstFrame.origin.x = 0;
    NSRect nextFrame =[_nextVC.view frame];
    nextFrame.origin.x = _firstV.frame.size.width;

    NSMutableDictionary* aniFirstVDict = [NSMutableDictionary dictionary];
    [aniFirstVDict setObject:_firstV forKey:NSViewAnimationTargetKey];
    [aniFirstVDict setObject:[NSValue valueWithRect:_firstV.frame] forKey:NSViewAnimationStartFrameKey];
    [aniFirstVDict setObject:[NSValue valueWithRect:firstFrame] forKey:NSViewAnimationEndFrameKey];

    NSMutableDictionary* aniNextVDict = [NSMutableDictionary dictionary];
    [aniNextVDict setObject:_nextVC.view forKey:NSViewAnimationTargetKey];
    [aniNextVDict setObject:[NSValue valueWithRect:_nextVC.view.frame] forKey:NSViewAnimationStartFrameKey];
    [aniNextVDict setObject:[NSValue valueWithRect:nextFrame] forKey:NSViewAnimationEndFrameKey];


    NSAnimation* theAnim = [[NSViewAnimation alloc]
               initWithViewAnimations:[NSArray arrayWithObjects:
                                       aniFirstVDict,aniNextVDict, nil]];
    [theAnim setAnimationBlockingMode:NSAnimationBlocking];
    [theAnim setDuration:0.3];    // One and a half seconds.
    [theAnim setAnimationCurve:NSAnimationEaseIn];
    
    // Run the animation.
    [theAnim startAnimation];
    [theAnim stopAnimation];

    [_nextVC.view removeFromSuperview];
    [_nextBtn unbind:@"enabled"];

    [_prevBtn setEnabled:NO];
    [_nextBtn setEnabled:YES];
    _nextVC = nil;
}


-(void)pushVC:(NSViewController*)VC{
    [self.mainV addSubview:VC.view];
    [VC.view setX:_firstV.frame.size.width];

    NSRect firstFrame =[_firstV frame];
    firstFrame.origin.x = _firstV.frame.size.width * (-1);
    NSRect nextFrame =[_nextVC.view frame];
    nextFrame.origin.x = 0;
    
    NSMutableDictionary* aniFirstVDict = [NSMutableDictionary dictionary];
    [aniFirstVDict setObject:_firstV forKey:NSViewAnimationTargetKey];
    [aniFirstVDict setObject:[NSValue valueWithRect:_firstV.frame] forKey:NSViewAnimationStartFrameKey];
    [aniFirstVDict setObject:[NSValue valueWithRect:firstFrame] forKey:NSViewAnimationEndFrameKey];
    
    NSMutableDictionary* aniNextVDict = [NSMutableDictionary dictionary];
    [aniNextVDict setObject:_nextVC.view forKey:NSViewAnimationTargetKey];
    [aniNextVDict setObject:[NSValue valueWithRect:_nextVC.view.frame] forKey:NSViewAnimationStartFrameKey];
    [aniNextVDict setObject:[NSValue valueWithRect:nextFrame] forKey:NSViewAnimationEndFrameKey];
    
    
    NSAnimation* theAnim = [[NSViewAnimation alloc]
                            initWithViewAnimations:[NSArray arrayWithObjects:
                                                    aniFirstVDict,aniNextVDict, nil]];

    [theAnim setAnimationBlockingMode:NSAnimationBlocking];
    [theAnim setDuration:0.3];    // One and a half seconds.
    [theAnim setAnimationCurve:NSAnimationEaseIn];
    
    // Run the animation.
    [theAnim startAnimation];

    [_prevBtn setEnabled:YES];
}

- (IBAction)pressNextBtn:(id)sender {
    if (_nextVC == nil) {
        if ([_projectTypeAC.selectedObjects count] == 0) {
            return;
        }
        IUWidget *widget = [_projectTypeAC.selectedObjects objectAtIndex:0];
        Class class = NSClassFromString(widget.value);
        _project = objc_msgSend(class, @selector(project));
        _nextVC = _project.initializeVC;
        _nextVC.pWC = _pWC;
        _nextVC.initilizeWidget = widget;
        
        if (_nextVC == nil) {
            // default initialize
            _nextVC = [[MGNewProjectVC alloc] init];
            _nextVC.view = _defaultNextV;
        }
        else{
            [self.nextBtn bind:@"enabled" toObject:_nextVC withKeyPath:@"nextEnabled" options:nil];
        }
        [self pushVC:_nextVC];
    }
    else{
        if ([_nextVC pressFinishBtn]) {
            [self loadProject:_nextVC.project.filePath type:@"newproject"];
        }
        [IUHttpLog sendNewProjectLog:_project.projectType cloudType:_project.cloud git:_project.git];
    }
}


#pragma mark -
#pragma mark open recent projects;

- (IBAction)loadRecentProject:(id)sender {
    if([self.recentArray selectedObjects].count <=0) return;
    NSString  *path = [[[self.recentArray selectedObjects] objectAtIndex:0] objectForKey:@"path"];
    [self loadProject:path type:@"recentProject"];
}



-(NSMutableDictionary *)projectDictWithPath:(NSString*)path{
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *err;
    NSMutableDictionary *contentDict =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err] ;
    if (err) {
        [JDLogUtil log:@"load project" err:err];
        assert(0);
    }
    return contentDict;
}




@end
