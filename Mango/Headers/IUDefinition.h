//
//  definition.h
//  WebGenerator
//
//  Created by ChoiSeungmi on 2014. 2. 18..
//  Copyright (c) 2014년 jdlab.org. All rights reserved.
//

#ifndef WebGenerator_IUDefinition_h
#define WebGenerator_IUDefinition_h

#pragma mark -
#pragma mark enum type

//IUtextToolbar
typedef enum {
    IUSelectTypeNone,
    IUSelectTypeText,
    IUSelectTypeTextFieldEdit,
}IUSelectType;

//Use IUAnimation
typedef enum {
    IUAnimationDirectionVertical = 0,
    IUAnimationDirectionHorizontal = 1,
} IUAnimationDirection;

//IUBG
typedef enum{
    /* example sites
     * http://www.w3schools.com/cssref/playit.asp?filename=playcss_background-size&preval=cover
     */
    IUBGSizeNone,     //default, none setting
    IUBGSizeCenter,     //Center
    IUBGSizeContain,    //Contain, match with smaller size
    IUBGSizeCover,      //Cover , match with larger size
    IUBGSizeStretch,    //100%, 100%
    IUBGSizeCount,
}IUBGSize;

//IUCarouselControl
typedef enum{
    IUCarouselControlPrev,
    IUCarouselControlNext,
}IUCarouselControlType;

//IUFile
typedef enum _IUSourceType{
    IUSourceTypeEditor,
    IUSourceTypeOutput,
    IUSourceTypeEditorInclude,
    IUSourceTypeOutputInclude,
} IUSourceType;

//IUObj
typedef enum{
    IUNeedsDisplayActionAll,
    IUNeedsDisplayActionCSS,
    IUNeedsDisplayActionHTML,
} IUNeedsDisplayActionType;

//IUProject
typedef enum _IUGitType{
    IUGitTypeNone,
    IUGitTypeSource,
    IUGitTypeOutput,
} IUGitType;

//IUscreenFrame
typedef enum{
    IUScreenTypeDefault,
    IUScreenTypeTablet,
    IUScreenTypeMobile,
    NumberOfIUScreentType,
}IUScreenType;

//MGFileItem
typedef enum _MGFileItemType{
    MGFileItemTypeProject=0x01,
    MGFileItemTypeDir=0x02,
    MGFileItemTypePGIU = 0x04,
    MGFileItemTypeCOIU = 0x08,
    MGFileItemTypeTMIU= 0x16,
    
} MGFileItemType;

//MGNewProjectWC
typedef enum {
    IUStartTypeTemplate,    //menu template
    IUStartTypeNew,         //menu new
    IUStartTypeRecent,      //menu recent
    IUStartTypeLaunch,      //program launch
} IUStartType;

#endif
