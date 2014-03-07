//
//  IUBindInspector.m
//  Mango
//
//  Created by JD on 13. 2. 22..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUBindInspector.h"
#import "IUInspectorCellVC.h"

@interface IUBindInspector ()

@end

@implementation IUBindInspector{
    IUInspectorViewItemManager *viewItemManager;
}
@synthesize pWC;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil pWC:(MGProjectWC*)_pWC;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        self.pWC = _pWC;
        [pWC addObserver:self forKeyPath:@"iuController.selection.visibleBinder.type" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionOld context:nil];
   
    
        //setting content view
        itemNameArray = [[NSMutableArray alloc] initWithArray:@[kHoverBinding, kVariableTrigger, kVariableReceiver, kVariableFrameReceiver]];
        viewItemManager  = [[IUInspectorViewItemManager alloc] init];
        viewItemManager.delegate = self;
        
        
       
    }
    return self;
}

-(void)awakeFromNib{
    
    NSMutableArray *titleVCs = [NSMutableArray array];
    NSMutableArray *contentVs = [[NSMutableArray alloc] initWithArray: @[_hoverBindingV, _variableTriggerV, _visibleBindingVariableV, _receiverFrameV]];
   
    //setting title view
    for(NSInteger i=0; i<numberOfBindItems; i++){
        NSString *name = [itemNameArray objectAtIndex:i];
        IUInspectorCellVC *titleView = [[IUInspectorCellVC alloc]
                                        initWithNibName:@"IUInspectorCellVC"
                                        bundle:nil
                                        name:name];
        
        [titleVCs addObject:titleView];
        
    }
    [viewItemManager setTitleVCs:titleVCs contentViews:contentVs];
}

-(void)dealloc{
    [pWC removeObserver:self forKeyPath:@"iuController.selection.visibleBinder.type"];
}

-(void)iuController_selection_visibleBinder_typeOfObject:(id)obj didChange:(NSDictionary*)change{
 
    [self.tableV reloadData];
    
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
