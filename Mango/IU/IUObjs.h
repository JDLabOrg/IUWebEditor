//
//  IUObjs.h
//  Mango
//
//  Created by JD on 13. 2. 3..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//
/*Heade files*/
#import "IUImage.h"
#import "IUBG.h"

#import "IUObj.h"
#import "IUText.h"
#import "IUImage.h"
#import "IUView.h"
#import "IUTableList.h"

#import "IUPage.h"

#import "IUTemplate.h"
#import "IUHeaderWrapper.h"
#import "IUFooter.h"

#import "IUComp.h"
#import "IUMovie.h"

/* debug toggle */
#define DEBUG 1
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)



/*IUIcons Name*/
#define IUNoneIconFileName @"Actions-transform-move-icon"
#define IUObjIconFileName @"UIObjectIcon"
#define IUGroupIconFileName @"UICollectionViewIcon"
#define IUTableListIconFileName @"UICollectionViewControllerIcon"
#define IUTextIconFileName @"UITextViewIcon"
#define IUImageIconFileName @"UIImageViewIcon"
#define IUButtonIconFileName @"button-arrow-down-icon"
#define IUSubmitButtonIconFileName @"button-arrow-right-icon"
//#define IUToggleButtonIconFileName @"button-round-power-icon"
#define IUPageIconFileName @"Web-HTML"

#define kNodesPBoardType		@"myNodesPBoardType"	// drag and drop pasteboard type

