//
//  IUSyncInspector.h
//  Mango
//
//  Created by JD on 13. 2. 16..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Cocoa/Cocoa.h>


@interface IUSyncInspector : NSViewController{
    MGProjectWC     *pWC;
    NSString        *commitMessage;
    NSString        *branch;
    NSString        *remote;
}

@property MGProjectWC *pWC;
@property NSString  *commitMessage;
@property NSString  *remote;
@property NSString  *branch;
@property (strong) IBOutlet NSView *contentV;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil pWC:(MGProjectWC*)_pWC;

- (IBAction)pressSync:(id)sender;
- (IBAction)pressExport:(id)sender;
- (IBAction)pressSource:(id)sender;

@end
