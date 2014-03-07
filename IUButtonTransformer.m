//
//  NSButtonTransformer.m
//  Mango
//
//  Created by ChoiSeungmi on 13. 10. 18..
//  Copyright (c) 2013년 JD. All rights reserved.
//

#import "IUButtonTransformer.h"

@implementation IUButtonTransformer
+(Class)transformedValueClass{
    return [NSNumber class];
}
+(BOOL)allowReverseTrasnformation{
    return FALSE;
}
-(id)transformedValue:(id)value{
    BOOL currentState = [value boolValue];
    if(currentState)
    {
        return [NSNumber numberWithInteger:1];
    }
    else{
        return [NSNumber numberWithInteger:0];
    }
}


@end
