//
//  IUSyncInspector.m
//  Mango
//
//  Created by JD on 13. 2. 16..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUSyncInspector.h"
#import "MGProjectWC.h"

@interface IUSyncInspector ()

@property (strong) IBOutlet NSView *coverV;
@property (weak) IBOutlet NSProgressIndicator *indi;
@property (weak) IBOutlet NSTableView *tView;
@end

@implementation IUSyncInspector{
    NSView *currentV;
    __weak NSTableView *_tView;
    
    NSView *_coverV;
    __weak NSProgressIndicator *_indi;
}

@synthesize pWC;
@synthesize commitMessage;
@synthesize remote;
@synthesize branch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil pWC:(MGProjectWC*)_pWC;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        pWC = _pWC;
        self.branch = @"master";
        self.remote = @"heroku";
        self.commitMessage = [JDDateTimeUtil stringForToday];
    }
    return self; 
}


- (void)awakeFromNib{
    currentV = _contentV;
}


- (void)showCover:(BOOL)cover{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        if (cover) {
            currentV = _coverV;
            [_indi startAnimation:nil];
        }
        else{
            currentV = _contentV;
            [_indi stopAnimation:nil];
        }
        [self.tView reloadData];
    });
}

- (IBAction)viewServerPressed:(id)sender {
    NSURL   *url = self.pWC.project.serverURL;
    [[NSWorkspace sharedWorkspace] openURL:url];
}



- (IBAction)pressSync:(id)sender{
    __block int finish = 0;
    [self showCover:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
        [pWC sync:remote branch:branch message:commitMessage];
        finish = 1;
        [self showCover:NO];
    });
    return;
}


//legacy
- (IBAction)pressExport:(id)sender {
    // Need to be build JS
    IUCompileResult *result = [pWC.project buildProject];
    [self.pWC showCompileResult:result];
}

- (IBAction)pressSource:(id)sender {

    [pWC showSourceWCWithIdx:0];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    return currentV;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return currentV.frame.size.height;
}


@end
