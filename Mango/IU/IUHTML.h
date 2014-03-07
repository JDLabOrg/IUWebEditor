//
//  IUHTML.h
//  Mango
//
//  Created by JD on 13. 7. 5..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUObj.h"

@interface IUHTML : IUObj{
}

-(IBAction)stopLoading;

@property  (nonatomic) NSString *source;
@property   NSString *sampleImage;
@property   BOOL    disableSource;

@end
