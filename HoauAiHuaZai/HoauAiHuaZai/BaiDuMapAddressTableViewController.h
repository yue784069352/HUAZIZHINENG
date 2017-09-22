//
//  BaiDuMapAddressTableViewController.h
//  HoauAiHuaZai
//
//  Created by 岳俊杰 on 2017/9/18.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^addressBlock) (NSString *addressName);
@interface BaiDuMapAddressTableViewController : UITableViewController
@property (nonatomic,strong)NSArray * reslutsPoiInfoList;
@property (nonatomic,copy) addressBlock addressMapName;

@end
