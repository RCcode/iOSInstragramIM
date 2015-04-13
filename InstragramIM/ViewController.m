//
//  ViewController.m
//  InstragramIM
//
//  Created by lisongrc on 15-4-11.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "ViewController.h"
#import "PS_LoginViewController.h"
#import "UserModel.h"

// 引用 IMKit 头文件。
#import "RCIM.h"

@interface ViewController ()<RCIMUserInfoFetcherDelegagte, RCIMFriendsFetcherDelegate>

@property (nonatomic, strong) UIView *loginView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic, strong) NSMutableArray *modelArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _modelArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    // 设置用户信息提供者。
    [RCIM setUserInfoFetcherWithDelegate:self isCacheUserInfo:NO];
    // 设置好友信息提供者。
    [RCIM setFriendsFetcherWithDelegate:self];
    
    _loginView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 50)];
    [self.view addSubview:_loginView];
    _button = [[UIButton alloc] initWithFrame:_loginView.bounds];
    _button.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [_loginView addSubview:_button];

    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin] == YES) {
        [self getModel];
    }else{
        [_button setTitle:@"login" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)getModel
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/follows",[[NSUserDefaults standardUserDefaults] objectForKey:kUid]];

    NSDictionary *params = @{@"access_token":[[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken]};
    [PS_DataRequest requestWithURL:url params:[params mutableCopy] httpMethod:@"GET" block:^(NSObject *result) {
        NSLog(@"%@",result);
        NSDictionary *resultDic = (NSDictionary *)result;
        NSArray *dataArr = resultDic[@"data"];
        for (NSDictionary *dic in dataArr) {
            UserModel *model = [[UserModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_modelArray addObject:model];
        }
        [_button setTitle:@"会话列表" forState:UIControlStateNormal];
        [_button removeTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        [_button addTarget:self action:@selector(chatList:) forControlEvents:UIControlEventTouchUpInside];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

// 获取好友列表的方法。
-(NSArray*)getFriends
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (UserModel *model in _modelArray) {
            RCUserInfo *user = [[RCUserInfo alloc]init];
            user.userId = model.uid;
            user.name = model.username;
            user.portraitUri = model.profile_picture;
            [array addObject:user];
    }
    return array;
}

// 获取用户信息的方法。
-(void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
    // 此处最终代码逻辑实现需要您从本地缓存或服务器端获取用户信息。
    for (UserModel *model in _modelArray) {
        if ([model.uid isEqualToString:userId]) {
            RCUserInfo *user = [[RCUserInfo alloc]init];
            user.userId = model.uid;
            user.name = model.username;
            user.portraitUri = model.profile_picture;
            return completion(user);
        }
    }
    return completion(nil);
}

- (void)chatList:(UIButton *)button
{
    // 连接融云服务器。
//    D0VzNoF8mLDgojiPeO7464I4Bpu3aeaKgB+xtviUuJiILS24rg2PfYiPiJWXQtl8/4L+7OlV7oHgZ19Nz7nr9MQn35aElcgN
//    aTWdZGtNTRyfLMezrizds+qxNDahgG1VlBNGrCbQeiORAIgTgLNsC0qer0qJnPLckmAmteB5WeBQW687oHmW3ybsScDkVtnw
    [RCIM connectWithToken:@"aTWdZGtNTRyfLMezrizds+qxNDahgG1VlBNGrCbQeiORAIgTgLNsC0qer0qJnPLckmAmteB5WeBQW687oHmW3ybsScDkVtnw" completion:^(NSString *userId) {
        // 此处处理连接成功。
        NSLog(@"Login successfully with userId: %@.", userId);
        
        
        // 2.创建会话列表视图控制器。
        RCChatListViewController *chatListViewController = [[RCIM sharedRCIM]createConversationList:^(){
            // 创建 ViewController 后，调用的 Block，可以用来实现自定义行为。
        }];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        // 把会话列表视图控制器添加到导航栈。
        [self.navigationController pushViewController:chatListViewController animated:YES];
        
    } error:^(RCConnectErrorCode status) {
        // 此处处理连接错误。
        NSLog(@"Login failed.");
    }];
}

#pragma mark -- login --
- (void)login:(UIButton *)button
{
    PS_LoginViewController *loginVC = [[PS_LoginViewController alloc] init];
    loginVC.loginSuccessBlock = ^(NSString *codeStr){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //获取token
        NSString *url = @"https://api.instagram.com/oauth/access_token?scope=likes+relationships";
        NSDictionary *params = @{@"client_id":kClientId,
                                 @"client_secret":kClientSecret,
                                 @"grant_type":@"authorization_code",
                                 @"redirect_uri":kRedirectUri,
                                 @"code":codeStr};
        _manager = [AFHTTPRequestOperationManager manager];
        [_manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *resultDic = (NSDictionary*)responseObject;
            NSLog(@"%@",resultDic);
            //获取用户信息
            NSString *userurl= [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/",resultDic[@"user"][@"id"]];
            NSDictionary *userParams = @{@"access_token":resultDic[@"access_token"]};
            [PS_DataRequest requestWithURL:userurl params:[userParams mutableCopy] httpMethod:@"GET" block:^(NSObject *result) {
                NSLog(@"user info = %@",result);
                NSDictionary *userInfoDic = (NSDictionary *)result;
                NSDictionary *dataDic = userInfoDic[@"data"];
                
                //记录用户信息
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:dataDic[@"id"] forKey:kUid];
                [userDefaults setObject:dataDic[@"username"] forKey:kUsername];
                [userDefaults setObject:dataDic[@"profile_picture"] forKey:kPic];
                [userDefaults setObject:resultDic[@"access_token"] forKey:kAccessToken];
                [userDefaults setBool:YES forKey:kIsLogin];
                [userDefaults synchronize];
                
                [RCIM connectWithToken:@"aTWdZGtNTRyfLMezrizds+qxNDahgG1VlBNGrCbQeiORAIgTgLNsC0qer0qJnPLckmAmteB5WeBQW687oHmW3ybsScDkVtnw" completion:^(NSString *userId) {
                    NSLog(@"Login successfully with userId: %@.", userId);
                    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/follows",[userDefaults objectForKey:kUid]];

                    NSDictionary *params = @{@"access_token":[userDefaults objectForKey:kAccessToken]};
                    [PS_DataRequest requestWithURL:url params:[params mutableCopy] httpMethod:@"GET" block:^(NSObject *result) {
                        NSLog(@"%@",result);
                        NSDictionary *resultDic = (NSDictionary *)result;
                        NSArray *dataArr = resultDic[@"data"];
                        for (NSDictionary *dic in dataArr) {
                            UserModel *model = [[UserModel alloc] init];
                            [model setValuesForKeysWithDictionary:dic];
                            [_modelArray addObject:model];
                        }
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        [_button setTitle:@"会话列表" forState:UIControlStateNormal];
                        [_button removeTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
                        [_button addTarget:self action:@selector(chatList:) forControlEvents:UIControlEventTouchUpInside];
                    }];
//                    // 2.创建会话列表视图控制器。
//                    RCChatListViewController *chatListViewController = [[RCIM sharedRCIM]createConversationList:^(){
//                        // 创建 ViewController 后，调用的 Block，可以用来实现自定义行为。
//                    }];
//                    
//                    [MBProgressHUD hideHUDForView:self.view animated:YES];
//                    // 把会话列表视图控制器添加到导航栈。
//                    [self.navigationController pushViewController:chatListViewController animated:YES];

                } error:^(RCConnectErrorCode status) {
                    
                }];
            }];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@",error.description);
        }];
    };
    
    UINavigationController *loginNC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:loginNC animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
