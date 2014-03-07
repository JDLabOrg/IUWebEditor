//
//  IUProperty.h
//  Mango
//
//  Created by JD on 13. 5. 24..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Foundation/Foundation.h>
@protocol IUPropertyExtension
@optional
+(NSArray*)propertyListExclude;
+(NSArray*)undoPropertyListExclude;
@end

@protocol IUPropertyUndoExtension
@required
+(NSMutableArray *)undoPropertyList;
@end


@interface IUProperty : NSObject <JDPropertyListDelegate, IUPropertyExtension, IUPropertyUndoExtension>
@property NSUndoManager *undoManager;

+(NSArray*)propertyList;
+(NSArray*)autoPropertyList;
+(NSMutableArray*)undoPropertyList;

//defined by subclass.
-(BOOL)enableUndo;

-(NSMutableDictionary*)dict;
-(void)loadWithDict:(NSDictionary*)dict;
-(void)importPropertyFromDict:(NSDictionary*)dict ofClass:(Class)aClass;
-(NSMutableDictionary*)exportPropertyFromDictOfClass:(Class)aClass;
-(NSArray*)classPedigree;
-(void)setProperties:(NSDictionary *)properties;
@end