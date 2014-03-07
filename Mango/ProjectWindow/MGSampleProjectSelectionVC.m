//
//  MGSampleProjectSelectionVC.m
//  WebGenerator
//
//  Created by JD on 2/6/14.
//  Copyright (c) 2014 jdlab.org. All rights reserved.
//

#import "MGSampleProjectSelectionVC.h"
#import "MGAppDelegate.h"
#import "MGNewProjectWC.h"


@interface IUProjectSample(){
    
}
@property (nonatomic) NSString              *name;
@property (nonatomic) NSString              *type;
@property (nonatomic) NSString              *directory;
@property (nonatomic) NSString              *projectFile;
@property (nonatomic) NSString              *desc;
@property (nonatomic) NSString              *pageSize;
@property (nonatomic) NSArray               *images;
@property (nonatomic) NSString              *feature;
@property (nonatomic) NSString              *projectPackageFile;
@end


@implementation IUProjectSample{
    IUProject   *_project;
}

-(id)initWithDictionary:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        for (NSString *key in dict) {
            [self setValue:dict[key] forKey:key];
        }
        NSArray *imageFileArrays = self.images;
        NSMutableArray *images = [NSMutableArray array];
        for (NSString *imageFileName in imageFileArrays) {
            NSImage *image = [NSImage imageNamed:imageFileName];
            [images addObject:image];
        }
        self.images = images;
    }
    return self;
}


-(IUProject*)project{
    if (_project == nil) {
        _project = [[NSClassFromString(self.type) alloc] init];
    }
    return _project;
}

-(NSImage*)firstImage{
    return [self.images objectAtIndex:0];
}

@end



@interface MGSampleProjectSelectionVC ()

@end

@implementation MGSampleProjectSelectionVC{
    NSUInteger      imageIndex;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        
    }
    return self;
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"plist"];
    NSArray* pList = [NSArray arrayWithContentsOfFile:strPath];
    
    for (NSDictionary *dict in pList) {
        IUProjectSample *sampleProject = [[IUProjectSample alloc] initWithDictionary:dict];
        [self.arrayController addObject:sampleProject];
    }
    
    [self.arrayController setSelectionIndex:0];
    imageIndex = 0;
    self.imageIndexString = [self makeImageIndexString];

}

-(NSString*)makeImageIndexString{
    IUProjectSample *selectedSample = [self.arrayController.selectedObjects objectAtIndex:0];
    self.selectionImage = [selectedSample.images objectAtIndex:imageIndex];
    return [NSString stringWithFormat:@"%ld/%ld", imageIndex+1, selectedSample.images.count];
}

- (IBAction)pressPrevBtn:(id)sender {
    if (imageIndex == 0) {
        return;
    }
    imageIndex --;
    self.imageIndexString = [self makeImageIndexString];
}

- (IBAction)pressNextBtn:(id)sender {
    IUProjectSample *selectedSample = [self.arrayController.selectedObjects objectAtIndex:0];
    if (imageIndex == selectedSample.images.count - 1) {
        return;
    }
    imageIndex ++;
    self.imageIndexString = [self makeImageIndexString];
}

- (IBAction)pressSelectBtn:(id)sender {
    if(self.arrayController.selectedObjects.count <=0) return;
    
    IUProjectSample *selectedSample = [self.arrayController.selectedObjects objectAtIndex:0];
    NSURL *url = [[JDFileUtil util] openDirectoryByNSOpenPanel:@"Select Directory"];
    
    //cancel
    if(url == nil) return;
    
    NSURL *targetURL = [url URLByAppendingPathComponent:selectedSample.name];

    int i=2;
    while (1) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[targetURL path]]) {
            targetURL = [url URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%d",selectedSample.projectPackageFile, i]];
            i++;
        }
        else{
            break;
        }
    }
    
    [[JDFileUtil util] unzipResource:selectedSample.projectPackageFile toDirectory:[targetURL path] createDirectory:YES];
    
    NSString *path =[[targetURL path] stringByAppendingPathComponent:selectedSample.projectFile];
    [self.nProjectWC loadProject:path type:@"template project"];

}

-(void)doubleClick:(id)sender{
    [self pressSelectBtn:sender];
    
}


@end
