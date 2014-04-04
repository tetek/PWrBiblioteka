//
//  WMMacros.h
//  WMCodeBase
//
//  Created by Wojciech Mandrysz on 21/02/14.
//  Copyright (c) 2014 Wojciech Mandrysz. All rights reserved.
//


// Do not use this one in code.
#define __WMFuncLog NSLog(@"%s:%d (%p)", __PRETTY_FUNCTION__, __LINE__, self)

//////////////////////////////////////////////////
#pragma mark - Logging
//////////////////////////////////////////////////


#ifdef DEBUG

    #define WMFuncLog __WMFuncLog
    #define WMLog(...) NSLog(__VA_ARGS__)
    #define WMAssertLog(...) [[NSAssertionHandler currentHandler] handleFailureInFunction:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] file:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lineNumber:__LINE__ description:__VA_ARGS__]

#else

    #define WMFuncLog do {} while(0)
    #define WMLog(...) do {} while(0)
    #define WMAssertLog(...) __WMFuncLog

#endif

//Log if condition is met.
#define WMConditionLog(condition, ...) if (condition) { WMLog(__VA_ARGS__); }

//Assert, log otherwise.
#define WMAssert(condition, ...)  if (!(condition)) { WMAssertLog(__VA_ARGS__); }

//////////////////////////////////////////////////
#pragma mark - Helpers
//////////////////////////////////////////////////

//UIColor instance from hex value.
#define WMUIColorFromRGB(rgbValue) [UIColor colorWithRed:(((rgbValue & 0xFF0000) >> 16))/255. green:(((rgbValue & 0xFF00) >> 8))/255. blue:((rgbValue & 0xFF))/255. alpha:1.]