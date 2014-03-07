//
//  IUIconViewBox.h
//  WebGenerator
//
//  Created by ChoiSeungmi on 2014. 2. 19..
//  Copyright (c) 2014년 jdlab.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>


//This class intercept event and call Collection Item's double click operation
@interface IUIconViewBox : NSBox{
}

@property IBOutlet id delegate;

@end

//This class is for making double click operation in NSCollectionView
@interface IUIconCollectionItem : NSCollectionViewItem{
    
}

- (void)doubleClick:(id)sender;

@end