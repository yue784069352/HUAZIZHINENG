//
//  OrderViewController.h
//  HoauAiHuaZai
//
//  Created by 岳俊杰 on 2017/9/11.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *orderScrollView;
@property (weak, nonatomic) IBOutlet UITextField *JHName;
@property (weak, nonatomic) IBOutlet UITextField *JHIphone;
@property (weak, nonatomic) IBOutlet UITextField *JHAddress;
@property (weak, nonatomic) IBOutlet UITextField *JHDetailsAddress;
@property (weak, nonatomic) IBOutlet UITextField *SHName;
@property (weak, nonatomic) IBOutlet UITextField *SHIPhone;
@property (weak, nonatomic) IBOutlet UITextField *SHAddress;
@property (weak, nonatomic) IBOutlet UITextField *SHDetailsAddress;
@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;




@end
