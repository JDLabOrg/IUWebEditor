//
//  IUFrame2.h
//  WebGenerator
//
//  Created by JD on 11/16/13.
//  Copyright (c) 2013 jdlab.org. All rights reserved.
//

#import "IUProperty.h"
#import "IUScreenFrame.h"
// 동작 방식 :  유져 입력 (칸, 또는 드래그)
//            --> (외부) IUFrameManager의 enableRefresh 끔. 만약에 한 값만 고칠 경우는 끄지 않음
//            --> (외부) 좌표값 계산 ( 절대좌표 또는 마진 )  // setX, setY, setMarginLeft ...
//            --> FlowLayout의 경우 setX로 들어오면 그 차이값을 margin에 적용
//            --> (외부) IUFrameManager의 enableRefresh켬. 위에서 안껐으면 키지 않음
//            --> (외부) IUFrameManager에서 setNeedsDisplay을 돌림. 만약에 changedIU가 없으면 refresh는 내부에서 명령을 무시
//            ---------------------------------------------------------------------------
//            --> (외부) IUViewManager에서  JS값을 받음
//            --> (외부) enableRefresh 끔 (setEnableNotification:NO)
//            --> setFrameWithDictionary ----------------------------------------
//            --> originFromScreen 받아옴. IUFrameManager 에 입력
//            --> 절대좌표 받아옴 (screen base) //setXFromScreen, setYFromScreen
//            --> 위에서 받아온 originFromScreen를 이용하여 본 좌표값 계산
//            --> 좌표 입력
//            --> ---------------------------------------------------------------
//            --> (외부) enableRefresh 켬

@class IUManager;

@interface IUFrameManager : NSObject

@property (nonatomic) IUManager *manager;
//template header width, height, origin point
@property (readonly)  NSPoint templatePoint;

-(void)setAutoPixelFrame:(NSDictionary*)dict; //just pixel of frame & position
-(void)setAutoPercentFrame:(NSDictionary*)dict; //with percent

@end

/********************************************************************************/

@interface IUFrame2 : IUProperty{
}


@property   IUFrameManager  *frameManager;
/* IU */
@property   IUObj           *iu;
@property   BOOL    loaded;
@property   (nonatomic) BOOL verticalCenter, horizontalCenter;
@property   (nonatomic) BOOL disableVerticalCenter, disableHorizontalCenter;
@property   (nonatomic) BOOL disablePercent;

//frame
@property (nonatomic) BOOL disableX, disableY, disableWidth, disableHeight;


/* css information */
@property (nonatomic) BOOL  autoHeight;

@property (nonatomic) BOOL  fixed;

@property (nonatomic, readonly) NSRect    frame;
@property (nonatomic, readonly) NSRect    bound;
@property (nonatomic, readonly) NSRect gridFrameFromScreen;

//originFromParent;
@property NSPoint   rootGridPoint;

@property NSMutableDictionary*  screenFrameDict;
/* frame setting for screen type */
@property (nonatomic, readonly) IUScreenFrame *currentScreenFrame;
@property (nonatomic, readonly) IUScreenFrame *defaultScreenFrame;
-(BOOL)hasFlowLayout;


-(void)iuFrameLoad;

-(void)changeRect;
-(NSRect)frameWithType:(IUScreenType)type;
-(NSRect)boundWithType:(IUScreenType)type;

-(NSRect)frameFromScreen;
-(NSPoint) originFromScreen;
-(NSPoint) originFromRoot;

/*For gridView*/
-(NSPoint)gridOriginFromScreen;


-(void)setFullWidth;


-(IUScreenFrame *)screenFrame:(IUScreenType)type;
-(NSDictionary *)CSSDictWithScreenType:(IUScreenType)screenType;



@end