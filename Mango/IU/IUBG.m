//
//  IUBG.m
//  Mango
//
//  Created by JD on 13. 5. 24..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUBG.h"
#import "IULeftVC.h"
#import "MGImageViewController.h"
#import "MGImageCollectionItem.h"

@interface IUBG ()

@end

@implementation IUBG

@synthesize x,y, color, imgRepeat, imgType;


#pragma mark -
#pragma mark Init

+(NSArray *)propertyList{
    return @[@"x",@"y",@"img",@"imgType",@"imgRepeat", @"color", @"bgSize"];
}

+(NSMutableArray*)undoPropertyList{
  NSMutableArray *array =  [[NSMutableArray alloc] initWithArray:@[@"x",@"y",@"img",@"imgType",@"imgRepeat", @"color", @"bgSize"]];
    return array;
}


- (id)initWithIU:(IUObj*)_iu{
    self = [super init];
    if (self) {
        iu = _iu;
        // TODO : change local type
        self.imgType = @"local";
        [self addObserver:self forKeyPaths:[[[IUBG class] propertyList] arrayByAddingObject:@"color"] options:0 context:@"css"];
        self.bgSize = IUBGSizeNone;
    }
    return self;
}

-(void)dealloc{
    if (iu) { // initWithIU
        [self removeObserver:self forKeyPaths:[[[IUBG class] propertyList] arrayByAddingObject:@"color"] context:@"css"];
    }
}

-(NSMutableDictionary*)dict{
    NSMutableDictionary *dict = [self exportPropertyFromDictOfClass:[IUBG class]];
    return dict;
}

-(void)loadWithDict:(NSDictionary *)dict{
    [super importPropertyFromDict:dict ofClass:[IUBG class]];
}

#pragma mark -
#pragma mark

-(void)cssContextDidChange:(NSDictionary*)change{
    [iu setNeedsDisplay:IUNeedsDisplayActionCSS];
}


-(NSImage *)image{
    return [iu.iuManager.pWC image:self.img];
}

-(void)setImg:(NSString *)img{
    [self willChangeValueForKey:@"image"];
    _img = img;
    [self didChangeValueForKey:@"image"];
}

-(void)setRandomOpaqueColor{
    self.color = [JDUIUtil randomOpaqueColor];
}

-(void)setBgSize:(IUBGSize)bgSize{
    _bgSize = bgSize;
    self.sizeName = [IUBG stringToSize:bgSize];
}


+(NSString *)stringToSize:(IUBGSize)size{
    NSString *sizeTitle;
    switch(size){
        case IUBGSizeNone:
            sizeTitle = @"None";
            break;
        case IUBGSizeCenter:
            sizeTitle = @"Center";
            break;
        case IUBGSizeContain:
            sizeTitle = @"Contain";
            break;
        case IUBGSizeCover:
            sizeTitle = @"Cover";
            break;
        case IUBGSizeStretch:
            sizeTitle = @"Stretch";
            break;
        default:
            sizeTitle = @"error";
            
    }
    
    return sizeTitle;
}

-(void)setColor:(NSColor *)_color{
    if ([iu shouldChangeBGColorByUserInput:color]) {
        color = _color;
    }
    return;
}

@end
