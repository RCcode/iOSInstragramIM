//
//  PS_LoginViewController.h
//  iPhotoSocial
//
//  Created by lisongrc on 15-4-1.
//  Copyright (c) 2015年 Chen.Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LoginSuccessBlock)(NSString *codeStr);

@interface PS_LoginViewController : UIViewController

@property (nonatomic, copy) LoginSuccessBlock loginSuccessBlock;

@end
