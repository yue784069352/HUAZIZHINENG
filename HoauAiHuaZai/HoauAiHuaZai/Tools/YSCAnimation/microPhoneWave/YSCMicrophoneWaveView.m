//
//  YSCMicrophoneWaveView.m
//  YSCAnimationDemo
//
//  Created by yushichao on 16/8/23.
//  Copyright © 2016年 YSC. All rights reserved.
//

#import "YSCMicrophoneWaveView.h"

@interface YSCMicrophoneWaveView ()

@property (nonatomic, strong) NSTimer *microphoneTimer;
@property (nonatomic, strong) CAShapeLayer *microPhoneMaskLayer;

@end

@implementation YSCMicrophoneWaveView

- (void)showMicrophoneWaveInParentView:(UIView *)parentView withFrame:(CGRect)frame
{
    if (![self.superview isKindOfClass:[parentView class]]) {
        [parentView addSubview:self];
    } else {
        return;
    }
    self.frame = frame;
    
    UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 63, 90)];
    bottomImageView.image = [UIImage imageNamed:@"Phonebottom"];
    bottomImageView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    [self addSubview:bottomImageView];
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 63, 90)];
    topImageView.image = [UIImage imageNamed:@"PhoneTop"];
    topImageView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    [self addSubview:topImageView];
    _microPhoneMaskLayer = [CAShapeLayer layer];
    _microPhoneMaskLayer.position = CGPointMake(topImageView.bounds.size.width / 2, 3 * topImageView.bounds.size.height / 2);
    _microPhoneMaskLayer.bounds = topImageView.bounds;
    _microPhoneMaskLayer.backgroundColor = [UIColor yellowColor].CGColor;
    
    topImageView.layer.mask = _microPhoneMaskLayer;
    
    [self setMicroPhoneTimer];
}

- (void)addMicroPhoneAnimation
{
    CGPoint beginPoint = _microPhoneMaskLayer.position;
    CGFloat height = arc4random() % 90;
    CGPoint endPoint = CGPointMake(63/2, 3 * 90 / 2 - height);
    _microPhoneMaskLayer.position = endPoint;
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:beginPoint];
    positionAnimation.toValue = [NSValue valueWithCGPoint:endPoint];
    positionAnimation.duration = 0.3;
    
    [_microPhoneMaskLayer addAnimation:positionAnimation forKey:@""];
}

- (void)setMicroPhoneTimer
{
    [self closeMicroPhoneTimer];
    
    NSInteger mode = 1;
    NSDictionary *dic = @{@"mode":[NSNumber numberWithInteger:mode]};
    _microphoneTimer = [NSTimer timerWithTimeInterval:0.3 target:self selector:@selector(addMicroPhoneAnimation) userInfo:dic repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_microphoneTimer forMode:NSDefaultRunLoopMode];
}

- (void)closeMicroPhoneTimer
{
    if (_microphoneTimer) {
        if ([_microphoneTimer isValid]) {
            [_microphoneTimer invalidate];
        }
        _microphoneTimer = nil;
    }
}

@end
