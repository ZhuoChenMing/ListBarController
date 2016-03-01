//
//  ListBarScrollViewProtocol.h
//  BYDailyNews
//
//  Created by boleketang on 16/3/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#define kStatusHeight 20
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define RGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RGBColorAlpha(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define padding 20
#define itemPerLine 4
#define kItemW (kScreenW-padding*(itemPerLine+1))/itemPerLine
#define kItemH 25

typedef enum{
    topViewClick = 0,
    FromTopToTop = 1,
    FromTopToTopLast = 2,
    FromTopToBottomHead = 3,
    FromBottomToTopLast = 4
} animateType;
