//
//  MGLogWC.h
//  Mango
//
/// Copyright (c) 2004-2012, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

#import <Cocoa/Cocoa.h>

typedef enum _MGLogState{
    MGLogStateSuccess,
    MGLogStateFail,
    MGLogStateWarning,
    MGLogStateGoing,
}MGLogState;

@interface MGLog : NSObject{
    NSMutableString *log;
    NSString *time;
    MGLogState  state;
}
@property (readonly) NSString  *result;
@property NSMutableString   *log;
@property NSString   *time;
@property MGLogState        state;
@end

@interface MGLogWC : NSWindowController{
    NSMutableArray  *compileLogs;
    NSMutableArray  *networkLogs;
    MGLog           *currentLog;
    NSUInteger      selectedLogType;
}
 
@property MGLog *currentLog;
@property NSUInteger    selectedLogType;

- (void)startNetworkSession;
- (void)addNetworkLog:(NSString*)log;
- (void)closeNetworkSession:(MGLogState)result;

- (void)addCompileLog:(MGLogState)result log:(NSString*)log;

- (IBAction)pressOK:(id)sender;
- (IBAction)pressPrev:(id)sender;
- (IBAction)pressNext:(id)sender;

@end