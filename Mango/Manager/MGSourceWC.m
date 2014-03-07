//
//  MGSourceWC.m
//  Mango
//
//  Created by JD on 13. 10. 1..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "MGSourceWC.h"
#import "IUViewManager.h"

@interface MGSourceWC ()

@end

@implementation MGSourceWC

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        [self addObserver:self forKeyPath:@"selectedIdx" options:0 context:@"@selector(update)"];
    }
    return self;
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"selectedIdx"];
}

- (IBAction)pressOK:(id)sender {
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseOK];
}


-(void)update{
    switch ((int)self.selectedIdx) {
        case 0:
            self.showString = [_selectedIU outputHTMLSource2:self];
            break;
        case 1:
//            self.showString = _selectedIU.fullWebSource;
            break;
        case 2:
            self.showString = [_selectedIU HTMLSource2:self];
            break;
        case 3:
            self.showString = _selectedIU.CSSSource;
            break;
        case 4:
            self.showString = _selectedIU.iuManager.iuViewManager.initialWebSource;
            break;
        case 5:
            self.showString = _selectedIU.iuManager.iuViewManager.jsLog;
            break;
        default:
            break;
    }
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
