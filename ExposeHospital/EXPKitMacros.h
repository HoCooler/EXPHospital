//
//  EXPKitMacros.h
//  ExposeHospital
//
//  Created by HoCooler on 16/7/19.
//  Copyright © 2016年 HoCooler. All rights reserved.
//

#ifndef EXPKitMacros_h
#define EXPKitMacros_h

#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define HEXCOLOR(hexValue) HEXACOLOR(hexValue, 1.0)

#define HEXACOLOR(hexValue, alphaValue) [UIColor colorWithRed : ((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.0 green : ((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.0 blue : ((CGFloat)(hexValue & 0xFF)) / 255.0 alpha : (alphaValue)]

#define Font(x)                         [UIFont systemFontOfSize : x]

#endif /* EXPKitMacros_h */
