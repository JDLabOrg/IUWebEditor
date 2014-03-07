//
//  MGNewFileVC.m
//  Mango
//
//  Created by JD on 13. 6. 28..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "MGNewFileVC.h"
#import "IUWidget.h"

@interface MGNewFileVC ()

@end

@implementation MGNewFileVC{
    NSArray *templateWidgets;
    NSArray *pageWidgets;
    NSArray *compWidgets;
}

@synthesize fileName;
@synthesize currentSelectableIUs;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil project:(IUProject*)project
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self addObserver:self forKeyPaths:@[@"fileName",@"selectedIdx"] options:0 context:nil];
        templateWidgets = [[project class] templateWidgets];
        pageWidgets = [[project class] pageWidgets];
        compWidgets = [[project class] compWidgets];
    }
    
    return self;
}


-(void)awakeFromNib{
    self.selectedIdx = 1;
}

-(void)fileNameDidChange{
    NSLog(fileName,nil);
}

-(void)selectedIdxDidChange{
    switch (self.selectedIdx) {
        case 1:
            self.currentSelectableIUs = pageWidgets;
            break;
        case 2:
            self.currentSelectableIUs = templateWidgets;
            break;
        case 3:
            self.currentSelectableIUs = compWidgets;
            break;
        default:
            break;
    }
    NSIndexSet *selectSet = [[NSIndexSet alloc] initWithIndex:0];
    [self.collectionV setSelectionIndexes:selectSet];
}

-(void)setSelectedIndexSet:(NSIndexSet *)selectedIndexSet{
    _selectedIndexSet = selectedIndexSet;
    if ([selectedIndexSet count] == 0) {
        return;
    }
    NSUInteger index = [selectedIndexSet firstIndex];
    NSString *className = [[self.currentSelectableIUs objectAtIndex:index] objectForKey:@"class"];
    self.selectedTypeName = className;
    self.selectedTypeDesc = [[[NSClassFromString(className) alloc] init] desc];
}

-(void)dealloc{
    [self removeObserver:self forKeyPaths:@[@"fileName", @"selectedIdx"]];
}

@end
