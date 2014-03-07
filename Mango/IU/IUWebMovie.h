//
//  IUWebMovie.h
//  Mango
//
//  Created by JD on 8/19/13.
//  Copyright (c) 2013 JD. All rights reserved.
//

#import "IUHTML.h"

@interface IUWebMovie : IUHTML{
    NSString *thumbnailID;
    NSString *thumbnailSource;
    NSString *thumbnailBar;
    BOOL thumbnail;
}

@property NSString *webMovieSource;
@end
