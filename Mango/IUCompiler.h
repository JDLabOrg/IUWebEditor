//
//  IUCompiler.h
//  Mango
//
//  Created by JD on 13. 9. 13..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Foundation/Foundation.h>

@interface IUCompiler : NSObject

-(NSString*)statementOfForEachLoopWithArray:(NSString*)array;

-(NSString*)statementOfEndOfFor;

-(NSString*)statementOfVariableInComp:(NSString*)variable;

-(NSString*)statementOfVariable:(NSString*)variable;

-(NSString*)statementOfInclude:(NSString*)variable;

-(NSString*)statementOfCSRF;
@end
