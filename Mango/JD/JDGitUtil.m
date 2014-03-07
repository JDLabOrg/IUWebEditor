//
//  JDGitUtil.m
//  Mango
//
//  Created by JD on 13. 5. 16..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "JDGitUtil.h"

@implementation JDGitUtil

-(id)initWithProject:(IUProject*)_project{
    self = [super init];
    if (self) {
        project = _project;
    }
    return self;
}

-(BOOL)gitInit{
    NSString *gitPath = [[NSBundle mainBundle] pathForResource:@"git" ofType:@""];
    NSString *string = [[JDFileUtil util] launch:gitPath atDirectory:project.absoluteGitDir argument:@"init"];
    NSLog (@"grep returned:\n%@", string);
    return YES;
}

-(NSString*)addAll{
    NSString *gitPath = [[NSBundle mainBundle] pathForResource:@"git" ofType:@""];
    
    return [[JDFileUtil util] launch:gitPath atDirectory:project.absoluteGitDir arguments:@[@"add", @"."]];
}

-(NSString*)commit:(NSString*)commitMsg{
    NSString *gitPath = [[NSBundle mainBundle] pathForResource:@"git" ofType:@""];
    NSString *msg = [NSString stringWithFormat:@"'%@'", commitMsg];

    return [[JDFileUtil util] launch:gitPath atDirectory:project.absoluteGitDir arguments:@[@"commit", @"-a", @"-m",msg]];
}

-(NSString*)push:(NSString*)remote branch:(NSString*)branch{
    NSString *gitPath = [[NSBundle mainBundle] pathForResource:@"git" ofType:@""];
    
    return [[JDFileUtil util] launch:gitPath atDirectory:project.absoluteGitDir arguments:[NSMutableArray arrayWithObjects:@"push", remote, branch, nil]];
}

@end
