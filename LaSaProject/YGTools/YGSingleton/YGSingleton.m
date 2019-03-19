//
//  YGSingleton.m
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/8/2.
//  Copyright © 2016年 ccyouge. All rights reserved.
//


@implementation YGSingleton
{
    NSInteger _totalTime;
}
+ (YGSingleton *)sharedManager
{
    static YGSingleton *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^
    {
        sharedAccountManagerInstance = [[self alloc] init];
        if ([[NSFileManager defaultManager] fileExistsAtPath:DEFAULT_USER_FILE_PATH])
        {
            sharedAccountManagerInstance.user = [NSKeyedUnarchiver unarchiveObjectWithFile:DEFAULT_USER_FILE_PATH];
        }
        else
        {
            sharedAccountManagerInstance.user = [[YGUser alloc] init];
            sharedAccountManagerInstance.user.userId = @"";
        }
        sharedAccountManagerInstance.deviceToken = @"";
    });
    return sharedAccountManagerInstance;
}

- (void)startTimerWithTime:(NSInteger)time;
{
    if(_totalTime == 0)
    {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerStart:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
        _totalTime = time;
        [self timerStart:timer];
    }
}

- (void)timerStart:(NSTimer *)timer
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_TIMER_COUNT_DOWN object:nil userInfo:@{NC_TIMER_COUNT_DOWN:@(_totalTime)}];
    _totalTime --;
    if(_totalTime == 0)
    {
        [timer invalidate];
        timer = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_TIMER_FINISH object:nil userInfo:@{}];
    }
}

- (void)archiveUser
{
    // 归档
    [[NSFileManager defaultManager] removeItemAtPath:DEFAULT_USER_FILE_PATH error:nil];
    [NSKeyedArchiver archiveRootObject:self.user toFile:DEFAULT_USER_FILE_PATH];
    [[NSUserDefaults standardUserDefaults] setObject:self.user.phone forKey:@"phone"];
}

- (void)deleteUser
{
    [[NSFileManager defaultManager] removeItemAtPath:DEFAULT_USER_FILE_PATH error:nil];
    self.user = [[YGUser alloc] init];
    self.user.userId = @"";
}

@end
