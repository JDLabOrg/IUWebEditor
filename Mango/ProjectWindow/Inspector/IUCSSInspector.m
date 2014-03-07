//
//  IUCSSInspector.m
//  Mango
//
//  Created by JD on 13. 8. 28..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUCSSInspector.h"
#import "MGProjectWC.h"
#import "IUInspectorCellVC.h"

@implementation IUCSSInspector{
    IUInspectorViewItemManager *viewItemManager;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil pWC:(MGProjectWC*)pWC;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.pWC = pWC;
        
        //setting content view
        itemNameArray = [[NSMutableArray alloc] initWithArray:@[kIUInspectorCSSColor, kIUInspectorCSSShadow, kIUInspectorCSSBorder]];
        viewItemManager  = [[IUInspectorViewItemManager alloc] init];
        viewItemManager.delegate = self;

       
        
    }
    return self;
}

-(void)awakeFromNib{
    
    NSMutableArray *titleVCs = [NSMutableArray array];
    NSMutableArray *contentVs = [[NSMutableArray alloc] initWithArray: @[_colorV, _shadowV, _borderV]];

    //setting title view
    for(NSInteger i=0; i<numberOfCSSItems; i++){
        NSString *name = [itemNameArray objectAtIndex:i];
        IUInspectorCellVC *titleView = [[IUInspectorCellVC alloc]
                                        initWithNibName:@"IUInspectorCellVC"
                                        bundle:nil
                                        name:name];
        [titleVCs addObject:titleView];
        
    }
    [viewItemManager setTitleVCs:titleVCs contentViews:contentVs];
    
}

-(void)IUInspectorItemArrayIsChanged:(IUInspectorViewItemManager *)inspectorItemArray{
    [self.tableV reloadData];
}

#pragma mark -
#pragma mark tableView datasource **required methods**

//getting Vlaues
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [viewItemManager countOfVisibleViews];
}


#pragma mark data delegate
-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    return [viewItemManager viewForRow:row];
}


-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    NSView *v = [viewItemManager viewForRow:row];
    return v.frame.size.height;
}

@end
