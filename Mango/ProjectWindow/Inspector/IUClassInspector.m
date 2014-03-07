//
//  IUClassInspector.m
//  Mango
//
//  Created by JD on 13. 2. 14..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUClassInspector.h"
#import "IUObjs.h"
#import "MGClassSelectVC.h"
#import "IUInspectorCellVC.h"
#import "JDDragAndDropImageV.h"

@implementation NSTableRowView (JDExtension)
- (void)setFrameSize:(NSSize)newSize
{
    if (!NSEqualSizes(newSize, NSZeroSize))
    [super setFrameSize:newSize];
}


@end

@interface IUClassInspector ()

@end

@implementation IUClassInspector {
    IUInspectorViewItemManager *viewItemManager;
}
@synthesize pWC;
@synthesize iuController;

-(id)valueForUndefinedKey:(NSString *)key{
//    DLog(@"undefined value at class inspector %@", key);
    return nil;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil pWC:(MGProjectWC*)_pWC;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.pWC = _pWC;
        self.iuController = pWC.iuController;
        
        [self.pWC addObserver:self forKeyPath:@"selectedIUManager" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionPrior context:nil];
        [self.iuController addObserver:self forKeyPath:@"selectedObjects" options:0 context:nil];
        
        
        self.onDivLink = FALSE;
        viewItemManager  = [[IUInspectorViewItemManager alloc] init];
        viewItemManager.delegate = self;
    }
    return self;
}

-(void)awakeFromNib{
    [self.imageTransationImageV registerForImageDraggedType:kIUImageURL];
    [self.imageTransationImageV setInsertionKeyPath:@"selection.eventImageStr"];
    [self.imageTransationImageV setInsertionObj:self.pWC.iuController];
}

-(void)dealloc{
    [self.pWC removeObserver:self forKeyPath:@"selectedIUManager"];
    [self.iuController removeObserver:self forKeyPath:@"selectedPedigree"];
}


-(void)selectedObjectsDidChange:(NSMutableDictionary*)change{
    NSMutableArray *titleVCs = [NSMutableArray array];
    NSMutableArray *contentVs = [NSMutableArray array];
    
    NSArray *classPedigree = self.iuController.selectedPedigree;
    for (NSString *className in classPedigree) {
        
        if ([self valueForKey:className]) {
            IUInspectorCellVC *itemVC = [[IUInspectorCellVC alloc] initWithNibName:@"IUInspectorCellVC" bundle:nil name:className];
            [titleVCs addObject:itemVC];            
            [contentVs addObject:[self valueForKey:className]];
        }
    }
    [self.IUObjMQSizeTV setDelegate:self.iuController.selection];
    [self.IUObjMQSizeTV setDataSource:self.iuController.selection];
    [self.IUObjMQSizeTV reloadData];
    
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



#pragma mark -
#pragma mark make html link

- (IBAction)selectedPage:(id)sender {
    NSString *linkPageName = [self.iuController.selection valueForKey:@"link"];
    
    if([linkPageName isKindOfClass:[NSString class]]){
        
        if(![linkPageName containsString:@"pgiu"]){
            self.onDivLink  = FALSE;
            return;
        }
        
        NSLog(@"here selected Page %@", linkPageName);
        self.onDivLink = TRUE;
        
        NSMutableArray *divs = [[pWC iuManagerOfFileName:linkPageName].rootIU allChildren];
        [self.selectedPageDiv setContent:divs];
        [self.selectedPageDiv arrangedObjects];
        
        
    }
}

- (NSArray *)divLinkSortDescriptors{
    return [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"HTMLID" ascending:YES]];
}

#pragma mark -
#pragma mark keydown delegate IuObj


-(BOOL)tableView:(NSTableView*)tableView keyDown:(unichar)key{
    if ([pWC.iuController.selectedObjects count] > 1) {
        return NO;
    }
    return [self.pWC.iuController.selection tableView:tableView keyDown:key];
}


-(BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if ([pWC.iuController.selectedNodes count] == 1) {
        return [pWC.iuController.selection tableView:tableView shouldEditTableColumn:tableColumn row:row];
    }
    return NO;
}

-(BOOL)tableView:(NSTableView *)tableView endEditing:(NSText *)textObject row:(NSUInteger)row column:(NSUInteger)column{
    NSAssert([tableView.identifier isEqualToString:@"IUObj"], @"Wrong Table View");
    for (IUObj *iu in pWC.iuController.selectedObjects) {
        [iu tableView:tableView endEditing:textObject row:row column:column];
    }
    return YES;
}

#pragma mark -
#pragma mark media query

-(void)reloadDataMQSize{
    [self.IUObjMQSizeTV reloadData];
}
- (IBAction)pressClearMediaQueryBtn:(id)sender {
}


@end