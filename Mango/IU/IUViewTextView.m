//
//  IUViewTextView.m
//  Mango
//
//  Created by JD on 13. 7. 14..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUViewTextView.h"

@implementation IUViewTextView
- (id)initWithIUFrame:(IUFrame *)_iuFrame{
    self = [super initWithIUFrame:_iuFrame wantsLayer:NO];
    if (self) {
    }
    return self;
}

-(id)InitWithIUFrameContentView{
    self.cell = [[NSTextView alloc] init];
    [self.cell bind:@"attributedString" toObject:self withKeyPath:@"text" options:@{NSNullPlaceholderBindingOption: @""}];
    [self.cell setInsertionPointColor:[NSColor yellowColor]];
    [self.cell setTextContainerInset:NSMakeSize(0, 0)];
    self.cell.delegate = self;;
    return self.cell;
}

- (BOOL)textView:(NSTextView *)aTextView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString {
    NSLog([aTextView description],nil);
    return YES;
}




@end
