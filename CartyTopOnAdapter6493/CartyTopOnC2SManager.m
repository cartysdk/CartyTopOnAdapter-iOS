//
//  CartyTopOnC2SManager.m
//  CartyTopOn
//
//  Created by GZTD-03-01959 on 2026/3/10.
//

#import "CartyTopOnC2SManager.h"

@interface CartyTopOnC2SManager()
{
    NSRecursiveLock *dicLock;
}
@property (nonatomic,strong)NSMutableDictionary *eventDictionary;
@end

@implementation CartyTopOnC2SManager

+ (CartyTopOnC2SManager *)sharedInstance
{
    static CartyTopOnC2SManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CartyTopOnC2SManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        dicLock = [[NSRecursiveLock alloc] init];
        self.eventDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addEvent:(id)event placementid:(NSString *)placementid
{
    [dicLock lock];
    self.eventDictionary[placementid] = event;
    [dicLock unlock];
}

- (void)removeEvent:(NSString *)placementid
{
    [dicLock lock];
    [self.eventDictionary removeObjectForKey:placementid];
    [dicLock unlock];
}

- (ATAdCustomEvent *)getEvent:(NSString *)placementid
{
    [dicLock lock];
    [dicLock unlock];
    return self.eventDictionary[placementid];
}
@end
