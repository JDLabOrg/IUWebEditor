//
//  IURender.m
//  Mango
//
//  Created by JD on 13. 9. 25..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IURender.h"
#import "IUViewManager.h"

@implementation IURender

-(id)instantiate{
    [super instantiate];
    
    //set to default, if self.comp is nil, error occurs
    self.comp = @"comp.coiu";
    self.enableShadowLayer = YES;
    return self;
}

-(void)loadWithDict:(NSDictionary *)dict{
    [super loadWithDict:dict];
    [self importPropertyFromDict:[dict objectForKey:NSStringFromClass([IURender class])] ofClass:[IURender class]];
}

-(NSMutableDictionary*)dict{
    NSMutableDictionary *dict = [super dict];
    NSDictionary *myDict = [self exportPropertyFromDictOfClass:[IURender class]];
    [dict setObject:myDict forKey:NSStringFromClass([IURender class])];
    return dict;
}

-(void)iuLoad{
    [super iuLoad];
    [self addObserver:self forKeyPath:@"comp" options:NSKeyValueObservingOptionInitial context:nil];
    [self addObserver:self forKeyPath:@"compIU" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionPrior context:nil];
}

-(void)compDidChange{
    
    self.compIU = (IUComp*)[self.iuManager.pWC iuManagerOfFileName:self.comp].rootIU;
}

-(NSMutableString*)CSSSourceWithScreenType:(IUScreenType)screenType{
    NSMutableString *retStr = [super CSSSourceWithScreenType:screenType];
    if (self.compIU) {
        [retStr appendString:[self.compIU CSSSourceWithScreenType:screenType]];
    }
    return retStr;
}

-(void)compIUWillChange{
    [self.compIU.referenceIUs removeObject:self];

}

-(void)setCompIU:(IUComp *)compIU{
    /*
    [_compIU.referenceIUs removeObject:self];
    _compIU = compIU;
    [_compIU.referenceIUs addObject:self];

    [_compIU setNeedsDisplay:IUNeedsDisplayActionAll];
    [self setNeedsDisplay:IUNeedsDisplayActionAll];

    for (IUObj *child in _compIU.allChildren) {
        [child setNeedsDisplay:IUNeedsDisplayActionCSS];
    }
     */
    [_compIU.referenceIUs removeObject:self];
    _compIU = compIU;
    [_compIU.referenceIUs addObject:self];

    [self.iuManager.iuViewManager reset];
    
    [self.iuManager.pWC.iuController performSelector:@selector(setSelectionObject:) withObject:self afterDelay:0.2];
}

-(void)dealloc{
    [self.compIU.referenceIUs removeObject:self];
}

+(NSArray*)propertyList{
    return @[@"comp"];
}





-(NSString*)innerHTML2:(id)caller{
    return [_compIU HTMLSource2:caller];
}

-(NSString*)innerOutputHTML2{
    return [_compIU outputHTMLSource2:self];
}

-(NSMutableDictionary*)jsVariableDictionary{
    NSMutableDictionary *dict = [super jsVariableDictionary];
    if (dict == nil) {
        dict = [NSMutableDictionary dictionary];
    }
    [dict merge:_compIU.jsVariableDictionary];
    if ([dict count]) {
        return dict;
    }
    return nil;
}


-(NSMutableDictionary*)jsTriggerDictionary{
    NSMutableDictionary *dict = [super jsTriggerDictionary];
    if (dict == nil) {
        dict = [NSMutableDictionary dictionary];
    }
    [dict merge:_compIU.jsTriggerDictionary];
    if ([dict count]) {
        return dict;
    }
    return nil;
}

-(NSMutableDictionary*)jsReceiverDictionary{
    NSMutableDictionary *dict = [super jsReceiverDictionary];
    if (dict == nil) {
        dict = [NSMutableDictionary dictionary];
    }
    [dict merge:_compIU.jsReceiverDictionary];
    if ([dict count]) {
        return dict;
    }
    return nil;
}

@end
