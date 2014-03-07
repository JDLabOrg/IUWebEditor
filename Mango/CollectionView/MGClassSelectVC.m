//
//  MGObjSelectVC.m
//  Mango
//
//  Created by JD on 13. 4. 8..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "MGClassSelectVC.h"
#import <objc/message.h>


@implementation MGClassSelectVC

@synthesize classArray;


-(void)awakeFromNib{
    
}

-(void)setPWC:(MGProjectWC *)pWC{
    _pWC = pWC;
    [pWC addObserver:self forKeyPath:@"project" options:NSKeyValueObservingOptionInitial context:nil];
}

-(void)projectDidChange{
    
    NSMutableArray *tempClassArray = [NSMutableArray array];
    
    MGCollectionItem *item;
    NSArray *arr;
    if  (self.pWC.project.programmable){
        arr = @[@"IUView",
          @"IUFixedGroup",
          @"IUTableList",
          @"IUImage",
          @"IUResponsiveSection",
          @"IUSubmitButton",
          @"IUTextFieldEdit",
          @"IUHTML",
          @"IUTwitter",
          @"IUFBLike",
          @"IUWebMovie",
          @"IUMovie",
          @"IURender",
          @"IUNavi",
          @"IUNaviLinkBar",
          @"IUNaviLinkBarItem",
          @"IUBottomSticker",
          @"IUOverlapImage",
          @"IUMailLink",
          @"IUTransitionView",
          @"IUCarousel",
          @"IUCarouselItem",
          ];
    }
    else{
        arr = @[@"IUView",

                @"IUFixedGroup",
                @"IUImage",
                @"IUResponsiveSection",
                @"IUTextFieldEdit",
                @"IUHTML",
                @"IUTwitter",
                @"IUFBLike",
                @"IUWebMovie",
                @"IUMovie",
                @"IURender",
                @"IUNavi",
                @"IUNaviLinkBar",
                @"IUNaviLinkBarItem",
                @"IUBottomSticker",
                @"IUOverlapImage",
                @"IUMailLink",
                @"IUTransitionView",
                @"IUCarousel",
                @"IUCarouselItem",
                ];
    }
    for (NSString *str in arr) {
        Class class = NSClassFromString(str);
        item = [[MGCollectionItem alloc] init];
        item.name = [class displayName];
        item.value = str;
        item.desc = NSLocalizedString(str, @"");
        item.image = [class classImage];
        
        //add discription for popover explain
        
        NSDictionary *mydict;
        NSString *rtfPath = [[NSBundle mainBundle] pathForResource:str ofType:@"rtf"];
        /*
         * This is for the localized rtf(directory setting)
         1. language selection
         
         NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
         language = [[NSLocale autoupdatingCurrentLocale] objectForKey:NSLocaleLanguageCode];
         
         2. add language directory apth to rtf path
         inDirectory:[@"en" stringByAppendingPathExtension:@"lproj"]];
         
         */
        NSData *rtfData = [NSData dataWithContentsOfFile:rtfPath];
        item.longDesc = [[NSAttributedString alloc] initWithRTF:rtfData documentAttributes:&mydict];
        
        
        [tempClassArray addObject:item];
    }
    
    self.classArray = tempClassArray;
    
    self.selectedIndexes = [[NSIndexSet alloc] initWithIndex:0];
    MGCollectionViewItem *viewItem = (MGCollectionViewItem *)[self.collectionV itemAtIndex:_selectedIndexes.firstIndex];
    
    self.selectedItem = viewItem.representedObject;
    [self addObserver:self forKeyPath:@"selectedIndexes" options:0 context:nil];
    
    
    [self.collectionV setMinItemSize:NSMakeSize(50, 50)];
    [self.collectionV setMaxItemSize:NSMakeSize(50, 50)];
}

- (BOOL)collectionView:(NSCollectionView *)collectionView writeItemsAtIndexes:(NSIndexSet *)indexes toPasteboard:(NSPasteboard *)pasteboard{
    
    [pasteboard declareTypes:[NSArray arrayWithObjects:kUTTypeIUType, nil] owner:self];
    MGCollectionItem *item = [classArray objectAtIndex:[indexes firstIndex]];
    [pasteboard setString:item.value forType:(id)kUTTypeIUType];    
    return YES;
}


- (void)selectedIndexesDidChange{
    if (_selectedIndexes.firstIndex == NSNotFound) {
        self.selectedItem = nil;
        return;
    }
    else{

        MGCollectionViewItem *viewItem = (MGCollectionViewItem *)[self.collectionV itemAtIndex:_selectedIndexes.firstIndex];
        
        self.selectedItem = viewItem.representedObject;
    }
    //NSLog(@"change");
}


@end
