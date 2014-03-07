//
//  MGLogWC.m
//  Mango
//
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

#import "MGLogWC.h"
#import "JDDateTimeUtil.h"
@interface MGLogWC ()

@end

@implementation MGLog
@synthesize log;
@synthesize time;
@synthesize state;

-(id)init{
    if (self = [super init]) {
        [self addObserver:self forKeyPath:@"log" options:0 context:nil];
        [self addObserver:self forKeyPath:@"state" options:0 context:nil];
        self.log = [NSMutableString string];
        self.state = MGLogStateGoing;
    }
    return self;
}

-(void)logDidChange{
    self.time = [JDDateTimeUtil stringForTime:[NSDate date]];
}

-(void)stateDidChange{
    [self willChangeValueForKey:@"result"];
    [self didChangeValueForKey:@"result"];
}

-(NSString*)result{
    switch (self.state) {
        case MGLogStateFail:
            return @"Error";
            break;
        case MGLogStateGoing:
            return @"Still Working...";
            break;
        case MGLogStateSuccess:
            return @"Success";
            break;
        case MGLogStateWarning:
            return @"Warning";
            break;
        default:
            return @"";
            break;
    }
}
@end


@implementation MGLogWC
@synthesize currentLog;
@synthesize selectedLogType;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        compileLogs = [NSMutableArray array];
        networkLogs = [NSMutableArray array];
        [self addObserver:self forKeyPath:@"selectedLogType" options:0 context:nil];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (IBAction)pressOK:(id)sender {
    [self.window endSheet:self.window returnCode:0];
}

- (IBAction)pressPrev:(id)sender {
    NSArray *objects;
    switch (self.selectedLogType) {
        case 0:
            objects = compileLogs;
            break;
        case 1:
        default:
            objects = networkLogs;
            break;
    }
    NSUInteger idx = [objects indexOfObject:currentLog];
#ifdef DEBUG
    assert(idx != 0);
#endif
    idx = idx - 1;
    self.currentLog = [objects objectAtIndex:idx];
}

- (IBAction)pressNext:(id)sender {
    NSArray *objects;
    switch (self.selectedLogType) {
        case 0:
            objects = compileLogs;
            break;
        case 1:
        default:
            objects = networkLogs;
            break;
    }
    NSUInteger idx = [objects indexOfObject:currentLog];
#ifdef DEBUG
    assert(idx != [objects count]);
#endif
    idx ++;
    self.currentLog = [objects objectAtIndex:idx];
}

- (void)startNetworkSession{
    MGLog *log = [[MGLog alloc] init];
    log.time = [JDDateTimeUtil stringForTime:[NSDate date]];
    log.state = MGLogStateGoing;
    [networkLogs addObject:log];
    self.selectedLogType = 1;
    self.currentLog = log;
}

- (void)addNetworkLog:(NSString*)_log{
    MGLog *log = [networkLogs lastObject];
    
#ifdef DEBUG
    assert(log.state == MGLogStateGoing);
#endif
    
    [log.log appendString:_log];
    self.selectedLogType = 1;
    self.currentLog = log;
}

- (void)closeNetworkSession:(MGLogState)result{
    MGLog *log = [networkLogs lastObject];
    log.state = result;
    self.selectedLogType = 1;
    self.currentLog = log;
}


-(void)addCompileLog:(MGLogState)result log:(NSString*)_log{
    MGLog   *log = [[MGLog alloc] init];
    log.log = [_log mutableCopy];
    log.state = result;
    [compileLogs addObject:log];
    self.selectedLogType = 0;
    self.currentLog = log;
}


-(void)selectedLogTypeDidChange{
    switch (self.selectedLogType) {
        case 0:
            self.currentLog = [compileLogs lastObject];
            break;
        case 1:
        default:
            self.currentLog = [networkLogs lastObject];
            break;
    }
}

@end