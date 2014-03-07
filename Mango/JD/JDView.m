//
//  JDView.m
//  Mango
//
//  Created by JD on 13. 3. 30..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "JDView.h"
@implementation JDImageView
-(BOOL)isFlipped{
    return YES;
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSString *contextStr = (__bridge NSString *)(context);
    NSString *selectorName;
    if ([[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue] != YES) {
        selectorName = [NSString stringWithFormat:@"%@OfObject:didChange:",keyPath];
    }
    else{
        selectorName = [NSString stringWithFormat:@"%@OfObject:willChange:",keyPath];
    }
    
    SEL s = NSSelectorFromString(selectorName);
    if ([self respondsToSelector:s]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:s  withObject:object withObject:change];
#pragma clang diagnostic pop
    }
    
    if (object == self) {
        if ([[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue] != YES) {
            selectorName = [NSString stringWithFormat:@"%@DidChange:",keyPath];
        }
        else{
            selectorName = [NSString stringWithFormat:@"%@WillChange:",keyPath];
        }
        
        s = NSSelectorFromString(selectorName);
        if ([self respondsToSelector:s]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:s  withObject:change];
#pragma clang diagnostic pop
        }
        
        if ([[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue] != YES) {
            selectorName = [NSString stringWithFormat:@"%@DidChange",keyPath];
        }
        else{
            selectorName = [NSString stringWithFormat:@"%@WillChange",keyPath];
        }
        
        s = NSSelectorFromString(selectorName);
        if ([self respondsToSelector:s]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:s];
#pragma clang diagnostic pop
        }
        
    }
    
    
    
    if ([[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue] != YES) {
        selectorName = [NSString stringWithFormat:@"%@ContextOfObject:didChange:",contextStr];
    }
    else{
        selectorName = [NSString stringWithFormat:@"%@ContextOfObject:willChange:",contextStr];
    }
    
    s = NSSelectorFromString(selectorName);
    if ([self respondsToSelector:s]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:s  withObject:object withObject:change];
#pragma clang diagnostic pop
    }
    
    if (object == self) {
        if ([[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue] != YES) {
            selectorName = [NSString stringWithFormat:@"%@ContextDidChange:",contextStr];
        }
        else{
            selectorName = [NSString stringWithFormat:@"%@ContextWillChange:",contextStr];
        }
        
        s = NSSelectorFromString(selectorName);
        if ([self respondsToSelector:s]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:s  withObject:change];
#pragma clang diagnostic pop
        }
        
        if ([[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue] != YES) {
            selectorName = [NSString stringWithFormat:@"%@ContextDidChange",contextStr];
        }
        else{
            selectorName = [NSString stringWithFormat:@"%@ContextWillChange",contextStr];
        }
        
        s = NSSelectorFromString(selectorName);
        if ([self respondsToSelector:s]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:s];
#pragma clang diagnostic pop
        }
        
    }
}

@end
@implementation JDView{
}

-(BOOL)isFlipped{
    return YES;
}

-(void)removeAllSubview{
    NSArray *subviews = [NSArray arrayWithArray:self.subviews];
    for (NSView *view in subviews) {
        [view removeFromSuperview];
    }
}

@end
