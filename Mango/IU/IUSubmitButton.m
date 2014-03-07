//
//  IUSubmitButton.m
//  WebGenerator
//
//  Created by JD on 2/13/14.
//  Copyright (c) 2014 jdlab.org. All rights reserved.
//

#import "IUSubmitButton.h"

@implementation IUSubmitButton

-(id)instantiate{
    [super instantiate];
    self.sampleText = @"Submit";
    
    return self;
}
-(NSString*)HTMLTag2{
    return @"input";
}

-(NSMutableDictionary*)outputDict2{
    NSMutableDictionary *dict = [super outputDict2];
    [dict putString:@"submit" forKey:@"type" param:nil];
    [dict putString:self.sampleText forKey:@"value" param:nil];
    return dict;
}

-(NSMutableDictionary*)HTMLDict2{
    NSMutableDictionary *dict = [super HTMLDict2];
    [dict putString:@"submit" forKey:@"type" param:nil];
    [dict putString:self.sampleText forKey:@"value" param:nil];
    return dict;
}

-(NSString*)innerHTML2:(id)caller{
    return nil;
}

-(NSMutableString *)innerOutputHTML2{
    return nil;
}

-(BOOL)appendClosingTag{
    return NO;
}

@end
