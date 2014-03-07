//
//  MGFrameTextField.m
//  WebGenerator
//
//  Created by JD on 1/18/14.
//  Copyright (c) 2014 jdlab.org. All rights reserved.
//

#import "MGFrameTextField.h"
#import "IUObj.h"

@implementation MGFrameTextField

-(BOOL)textShouldEndEditing:(NSText *)textObject{
    if ([[self.controller valueForKeyPath:self.conditionlKeyPath] boolValue] == YES) {
        //condition == true
        if (self.trueCheckSel) {
            for (IUObj *obj in self.controller.selectedObjects) {
                SEL selector = NSSelectorFromString(self.trueCheckSel);
                IMP imp = [obj methodForSelector:selector];
                BOOL (*func)(id, SEL, CGFloat) = (void *)imp;
                BOOL value = func(obj, selector, self.floatValue);
                if (value == NO){
                    [self setStringValue:@"N/A"];
                    return YES;
                }
            }
        }
        [self.controller setValue:@([[textObject string] floatValue]) forKeyPath:self.trueKeyPath];
    }
    else{
        //condition == false
        if (self.falseCheckSel) {
            for (IUObj *obj in self.controller.selectedObjects) {
                SEL selector = NSSelectorFromString(self.falseCheckSel);
                IMP imp = [obj methodForSelector:selector];
                BOOL (*func)(id, SEL, CGFloat) = (void *)imp;
                BOOL value = func(obj, selector, self.floatValue);
                if (value == NO){
                    [self setStringValue:@"N/A"];
                    return YES;
                }
            }
        }
        [self.controller setValue:@([[textObject string] floatValue]) forKeyPath:self.falseKeyPath];
    }
    if (self.controller.selectedObjects.count > 0) {
        IUObj *iu = [self.controller.selectedObjects objectAtIndex:0];
        [iu setNeedsDisplayStartGrouping];
        for (IUObj *obj in self.controller.selectedObjects) {
            [obj setNeedsDisplay:self.displayActionType];
        }
        [iu setNeedsDisplayEndGrouping];
    }
    return YES;
}


-(BOOL)becomeFirstResponder{
    if ([self textColor] == [NSColor lightGrayColor]) {
        [self setStringValue:@""];
        [self setTextColor:[NSColor blackColor]];
    }
    return [super becomeFirstResponder];
}

-(void)setStringValue:(NSString *)aString{
    if (aString == NSMultipleValuesMarker) {
        [super setStringValue:@"Multi"];
        [super setTextColor:[NSColor lightGrayColor]];
        return;
    }
    if (aString == NSNoSelectionMarker) {
        [super setStringValue:@"NoSelect"];
        [super setTextColor:[NSColor lightGrayColor]];
        return;
    }
    if (aString == NSNotApplicableMarker) {
        [super setStringValue:@"N/A"];
        [super setTextColor:[NSColor lightGrayColor]];
        return;
    }
    else{
        [super setStringValue:aString];
        [super setTextColor:[NSColor blackColor]];
    }
}
@end
