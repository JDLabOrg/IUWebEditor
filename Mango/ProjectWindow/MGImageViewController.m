//
//  MGImageViewController.m
//  Mango
//
//  Created by JD on 13. 4. 10..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "MGImageViewController.h"
#import "MGImageCollectionItem.h"
#import "IUImageUtil.h"
#import "IUStringUtil.h"


@interface MGImageViewController ()

@end

@implementation MGImageViewController
@synthesize imageDataArray;


-(void)awakeFromNib{
    imageDataArray = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setActivatedTF:) name:@"JDTextFieldBecomeFirstResponder"  object:nil];
    
    
    //TIFF : chrome 에거 drag and drop 시
    [self.view registerForDraggedTypes:@[(id)kUTTypeTIFF, (id)kUTTypeGIF, (id)kUTTypePNG,(id)kUTTypeFileURL]];
    
    //set CollectionItemSize
    [((NSCollectionView *)self.view) setMinItemSize:NSMakeSize(72, 72)];
    [((NSCollectionView *)self.view) setMaxItemSize:NSMakeSize(72, 72)];
}

- (void)setPWC:(MGProjectWC *)pwc{
    pWC = pwc;
}


- (NSDragOperation)draggingEntered:(id < NSDraggingInfo >)sender{
    return 0;
}

- (NSDragOperation)collectionView:(NSCollectionView *)collectionView validateDrop:(id < NSDraggingInfo >)draggingInfo proposedIndex:(NSInteger *)proposedDropIndex dropOperation:(NSCollectionViewDropOperation *)proposedDropOperation{
    return NSDragOperationCopy;
}

- (BOOL)collectionView:(NSCollectionView *)collectionView acceptDrop:(id < NSDraggingInfo >)draggingInfo index:(NSInteger)index dropOperation:(NSCollectionViewDropOperation)dropOperation{

    NSPasteboard *pBoard = draggingInfo.draggingPasteboard;
    for (NSString *type in pBoard.types) {
        NSLog(type, nil);
        NSLog([pBoard stringForType:type],nil);
        NSLog(@"--");
    }
    
    NSURL *fromURL = [NSURL URLWithString:[pBoard stringForType:(id)kUTTypeFileURL]];
    if (fromURL) {
        //copy
        NSError *err;
        NSString *fileName = [[pBoard stringForType:(id)kUTTypeFileURL] lastPathComponent];
        NSURL *target = [NSURL fileURLWithPath:[pWC.project.absoluteResDirPath stringByAppendingPathComponent:fileName]];
        [[NSFileManager defaultManager] copyItemAtURL:fromURL toURL:target error:&err];
        [self refreshImage];
        return YES;
    }
    
    NSArray *classArray = [NSArray arrayWithObject:[NSImage class]];
    BOOL inImg = [pBoard canReadObjectForClasses:classArray options:nil];
    if(inImg){
        //can read Imag file
        NSArray *objectsToPaste = [pBoard readObjectsForClasses:classArray options:nil];
        NSImage *image = [objectsToPaste objectAtIndex:0];
        
        //make fileName
        
        NSString *str = [pBoard stringForType:NSURLPboardType];
        NSLog([str description],nil);
        
        NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"pBoard.url"]];
        [str writeToFile:tempPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSArray *arr = [[NSArray alloc] initWithContentsOfFile:tempPath];
        NSString *fileName = [[arr firstObject] lastPathComponent];
        fileName = [IUStringUtil removeSpecialChar:fileName];
      
        [IUImageUtil writeToFile:image filePath:pWC.project.absoluteResDirPath fileName:fileName checkFileName:YES];
        [self refreshImage];
        
    }
    return YES;
}


- (void)refreshImage{
    [imageDataArray removeAllObjects];
//    double delayInSeconds = 0.5;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//    A:
    if (pWC.project) {
        NSURL *url =[NSURL fileURLWithPath:pWC.project.absoluteResDirPath];
        [self scanURLIgnoringExtras:url];
    }
    else{
//        sleep(1);
//        goto A;
    }
}

-(void)setActivatedTF:(NSNotification *)noti{
    activatedTF = noti.object;
}

-(void)scanURLIgnoringExtras:(NSURL *)directoryToScan
{
    NSFileManager *localFileManager=[[NSFileManager alloc] init];
    NSDirectoryEnumerator *dirEnumerator = [localFileManager enumeratorAtURL:directoryToScan
                                                  includingPropertiesForKeys:@[NSURLNameKey,NSURLIsDirectoryKey, NSURLCustomIconKey, NSURLEffectiveIconKey]
                                            options:NSDirectoryEnumerationSkipsHiddenFiles
                                            errorHandler:nil];
    
    for (NSURL *theURL in dirEnumerator) {

        NSNumber *isDirectory;
        [theURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];
        if ([isDirectory boolValue]==NO){
            /* reset as baseURL + relative path */
            NSString *relativePath = [[theURL absoluteString] stringByPathDiff:[directoryToScan absoluteString]];
            NSURL *url = [[NSURL alloc] initWithString:relativePath relativeToURL:directoryToScan];
            MGImageCollectionItem *data = [[MGImageCollectionItem alloc]init];
            data.URL = url;
            data.relativePath = relativePath;
            if (data.isImageFile || data.isMovieFile) {
                id idv;
                [theURL getResourceValue:&idv forKey:NSURLEffectiveIconKey error:nil]; // NSImage icon
                [url setResourceValue:idv forKey:NSURLCustomIconKey error:nil];
                
                [theURL getResourceValue:&idv forKey:NSURLEffectiveIconKey error:nil]; // NSImage icon
                [url setResourceValue:idv forKey:NSURLEffectiveIconKey error:nil];
                
                
                [[self mutableArrayValueForKey:@"imageDataArray"] addObject:data];
                //            dispatch_async(dispatch_get_main_queue(), ^(void){
                //these lines to separate image and video
                //if(data.isImageFile) [[self mutableArrayValueForKey:@"imageDataArray"] addObject:data];
                //else if(data.isMovieFile) [[self mutableArrayValueForKey:@"movieDataArray"] addObject:data];
                //            });
            }
            
            
        }
    }
}


- (BOOL)collectionView:(NSCollectionView *)collectionView writeItemsAtIndexes:(NSIndexSet *)indexes toPasteboard:(NSPasteboard *)pasteboard{
    MGImageCollectionItem *item = [imageDataArray objectAtIndex:[indexes firstIndex]];
    [pasteboard declareTypes:[NSArray arrayWithObjects:(id)kUTTypePlainText,(id)kUTTypeIUType, nil] owner:nil];
    
    NSMutableDictionary *propertyDict = [NSMutableDictionary dictionary];
    NSData *data;
    
    if(item.isImageFile){
        [pasteboard setString:@"IUView" forType:(id)kUTTypeIUType];
        
    
        [propertyDict setObject:item.URL.relativePath forKey:@"bg.img"];
        
        data = [NSJSONSerialization dataWithJSONObject:propertyDict options:0 error:nil];
       
        [pasteboard setString:item.URL.relativePath forType:(id)kIUImageURL];

        
        [pasteboard setString:@"u" forType:@"public.utf8-plain-text"];
        [pasteboard setString:@"ab" forType:(id)(kUTTypeRTF)];
        [pasteboard setString:@"c" forType:@"public.utf8-plain-text"];
        [pasteboard setString:@"d" forType:NSPasteboardTypeHTML];
    }
    //Movie Type
    else{
        [pasteboard setString:@"IUMovie" forType:(id)kUTTypeIUType];
        [propertyDict setObject:item.URL.relativePath forKey:@"movieFile"];
        
        data = [NSJSONSerialization dataWithJSONObject:propertyDict options:0 error:nil];
        
        
    }
    [pasteboard setData:data forType:kUTTypeIUProperty];
    

    return YES;
}

-(NSImage *)image:(NSString*)imageResourceString{
    for(MGImageCollectionItem *item in imageDataArray){
        if([item.relativePath isEqualToString:imageResourceString]){
            return item.image;
        }
    }
    
    return nil;
}


@end
