//
//  MGImageCollectionItem.m
//  Mango
//
//  Created by JD on 13. 4. 10..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "MGImageCollectionItem.h"

@implementation MGImageCollectionItem


-(void)setURL:(NSURL *)URL{
    _URL = URL;
    self.name = [_URL lastPathComponent];
    NSMutableString *desc = [NSMutableString string];
    [desc appendFormat:@"Relative Path : %@\n\n", URL.relativePath];
    self.desc = desc;

    CFStringRef UTIRef = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,                                                                       (__bridge CFStringRef)[[URL absoluteString] pathExtension],NULL);
    NSString * UTI = (NSString *)CFBridgingRelease(UTIRef);
    [desc appendFormat:@"UTI : %@\n\n", UTI];
    self.UTI = UTI;
    
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:_URL];
    if (image) {
        self.image = image;
        [desc appendFormat:@"Size : %.0f x %.0f\n\n", image.size.height, image.size.width];
        self.isImageFile = YES;
        return;
    }
    
    
    
    if([self.name containsString:@".mp4"]
       || [self.name containsString:@".ogg"]
       || [self.name containsString:@".mov"]){
        self.isMovieFile = YES;
    }
    
    id value;

    [_URL getResourceValue:&value forKey:NSURLCustomIconKey error:nil]; // NSImage icon
    if (value) {
        self.image = value;
        return;
    }
    
    [_URL getResourceValue:&value forKey:NSURLEffectiveIconKey error:nil]; // NSImage icon
    if (value) {
        self.image = value;
    }
}
@end
