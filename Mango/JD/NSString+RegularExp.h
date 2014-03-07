//
//  NSString+RegularExp.h
//  shopScrapper
//
//  Created by JD YANG on 12. 1. 28..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum RGXMatchOption{
    SORGXMatchOptionExtractToEnd=1, // 매치되는 부분부터 스트링의 끝까지 가져옴
} SORGXMatchOption;

@interface NSString (RegularExp)
- (BOOL)hasSubString:(NSString*)subString;
- (NSUInteger)countOccurencesOfSubString:(NSString*)subString;

- (NSArray*) rgxMatchAllStringsWithPatten:(NSString*)patten;
- (NSArray*) rgxMatchAllStringsWithPatten:(NSString*)patten option:(SORGXMatchOption)option;

- (NSString*) rgxMatchFirstStringWithPatten:(NSString*)patten;
- (NSString*) rgxMatchFirstStringWithPatten:(NSString*)patten option:(SORGXMatchOption)option;

- (NSNumber *) rgxMatchFirstNumberWithPatten:(NSString*)patten option:(SORGXMatchOption)option;
- (NSArray*) rgxMatchAllNumberWithPatten:(NSString*)patten option:(SORGXMatchOption)option;
- (NSDictionary *) rgxDictSeparatedByPatten:(NSString*)patten;


- (NSString *) rgxExtractFirstStringWithTag:(NSString*)tag; // 예: <body.*</body> 등을 추출
- (NSArray*) rgxExtractWithTag:(NSString*)tag; // 예: <tr.*</tr> 등을 추출
- (NSString *) subStringFromString:(NSString*)subStr;

- (NSString*) rgxRemoveTag;
@end