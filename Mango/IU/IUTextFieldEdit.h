//
//  IUTextFieldEdit.h
//  Mango
//
//  Created by JD on 9/11/13.
//  Copyright (c) 2013 JD. All rights reserved.
//

#import "IUObj.h"

@interface IUTextFieldEdit : IUObj
@property NSString      *sampleText;
@property NSString      *formName;
@property NSAttributedString *attributeText;

//font attributes
@property NSString      *fontName;
@property NSColor       *fontColor;
@property CGFloat       fontSize;
@end
