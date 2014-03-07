//
//  IUViewTextField.m
//  Mango
//
//  Created by JD on 13. 7. 22..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUViewTextField.h"
#import "JDTextField.h"
@implementation IUViewTextField
//
//  IUViewTextView.m
//  Mango
//
//  Created by JD on 13. 7. 14..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//


{
    NSTextField  *cell;
}

@synthesize cell;

- (id)initWithIUFrame:(IUFrame *)_iuFrame{
    self = [super initWithIUFrame:_iuFrame wantsLayer:NO];
    if (self) {
    }
    return self;
}

-(id)InitWithIUFrameContentView{
    cell = [[NSTextField alloc] init];
//    cell.delegate = self;
//    [cell bind:@"stringValue" toObject:self withKeyPath:@"text" options:@{NSNullPlaceholderBindingOption: @""}];
    return cell;
}

- (void)textDidChange:(NSNotification *)aNotification{
//    NSLog(@"textDid");
}



@end
