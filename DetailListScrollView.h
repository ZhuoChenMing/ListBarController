//
//  BYSelectionDetails.h
//  BYDailyNews
//
//  Created by bassamyan on 15/1/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListBarSetup.h"

@interface DetailListScrollView : UIScrollView

@property (nonatomic,strong) NSMutableArray *topViewArray;
@property (nonatomic,strong) NSMutableArray *bottomViewArray;
@property (nonatomic,strong) NSMutableArray *listAllAray;

@property (nonatomic,copy) void(^longPressedBlock)();
@property (nonatomic,copy) void(^opertionFromItemBlock)(animateType type, NSString *itemName, int index);

- (void)itemRespondFromListBarClickWithItemName:(NSString *)itemName;

@end
