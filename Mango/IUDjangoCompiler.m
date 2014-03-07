//
//  IUDjangoCompiler.m
//  Mango
//
//  Created by JD on 13. 9. 26..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUDjangoCompiler.h"

@implementation IUDjangoCompiler

-(NSString*)statementOfForEachLoopWithArray:(NSString*)array{
    return [NSString stringWithFormat:@"{%% for representedObject in %@ %%}", array];
}

-(NSString*)statementOfEndOfFor{
    return @"{% endfor %}";
}

-(NSString*)statementOfInclude:(NSString*)variable{
    return [NSString stringWithFormat:@"{%% include 'object/%@' %%}",  variable];
}


-(NSString*)statementOfVariableInComp:(NSString*)variable{
    return [NSString stringWithFormat:@"{{ representedObject.%@ }}", variable];
}

-(NSString*)statementOfVariable:(NSString*)variable{
    return [NSString stringWithFormat:@"{{%@}}", variable];
}

-(NSString*)statementOfCSRF{
    return @"{% csrf_token %}";
}
@end
