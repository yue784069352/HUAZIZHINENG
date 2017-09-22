//
//  OrderViewController.m
//  HoauAiHuaZai
//
//  Created by 岳俊杰 on 2017/9/11.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "OrderViewController.h"
#import "ISRDataHelper.h"
#import "AddressTableViewController.h"
#import "BaiDuMapAddressTableViewController.h"
#import "UIImage+GIF.h"
#import "YSCVoiceWaveView.h"
#import "YSCMicrophoneWaveView.h"
//#import "SVGKit.h"
//#import "SVGKImage.h"
//#import "SVGKParser.h"
@interface OrderViewController ()<UIScrollViewDelegate,IFlySpeechRecognizerDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKLocationService *_locService;
    BMKPinAnnotationView *_newAnnotationView;
    BMKPointAnnotation* _annotation;
    BOOL                _isOKListening;
}
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;
@property (nonatomic, copy) NSString * result,*textViewIdentifier,*mapViewTextIdentifier;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextView *SHtextView;
@property (nonatomic,strong) BMKMapView* mapView;
@property (nonatomic,strong)    BMKGeoCodeSearch* geocodesearch;
@property (nonatomic,strong)NSArray *poiArray;
@property (nonatomic,strong)UIImageView * gifImageView;
@property (nonatomic,strong)YSCVoiceWaveView *voiceView;

@end

@implementation OrderViewController
-(UIImageView *)gifImageView
{
    if (!_gifImageView)
    {
        _gifImageView = [[UIImageView alloc]initWithFrame:self.view.frame];
        _gifImageView.userInteractionEnabled = NO;
        [self.view addSubview:_gifImageView];
    }
    return _gifImageView;
}
//地图搜索
- (BMKGeoCodeSearch *)geocodesearch
{
    if (!_geocodesearch) {
        _geocodesearch = [[BMKGeoCodeSearch alloc] init];
        _geocodesearch.delegate = self;

    }
    return _geocodesearch;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"开  单";
    self.orderScrollView.delegate = self;
    _isOKListening = YES;
    
    //创建语音识别对象
    _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
    //设置识别参数
    //设置为听写模式
    [_iFlySpeechRecognizer setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
    //asr_audio_path 是录音文件名，设置value为nil或者为空取消保存，默认保存目录在Library/cache下。
    [_iFlySpeechRecognizer setParameter:@"iat.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
#pragma mark++++百度地图
    [self BDMapAllocInit];
    [self baiduloaction];
    
    
}
-(void)updateViewConstraints
{
    [super updateViewConstraints];
    self.scrollViewHeight.constant = self.saveButton.frame.origin.y+64;
}
/**
 启动听写寄货录音
 *****/
- (IBAction)startBtnHandler:(id)sender {
    
    NSLog(@"=======sdasdasdasdasd%s[IN]",__func__);
    if (_isOKListening == YES)
    {
        self.textView.text = @"";
        self.textViewIdentifier = @"JHIdentifier";
        [self playGIF];
        [self iFlyStartListen];
        _isOKListening = NO;
    }
 

}
//取当前位置
- (IBAction)takeMyLocation:(id)sender {
    self.textView.text = self.mapViewTextIdentifier;
    BaiDuMapAddressTableViewController *bdAddressVC = [[BaiDuMapAddressTableViewController alloc]init];
    bdAddressVC.reslutsPoiInfoList = self.poiArray;
    bdAddressVC.addressMapName = ^(NSString *addressName) {
        self.textView.text = addressName;
    };
    [self.navigationController pushViewController:bdAddressVC animated:YES];
}
//收货开始录音
- (IBAction)SHstartButtonListen:(id)sender {
    if (_isOKListening == YES)
    {
        self.SHtextView.text  = @"";
        self.textViewIdentifier = @"SHIdentifier";
        [self playGIF];
        [self iFlyStartListen];
        _isOKListening = NO;
    }
}
//寄货地址薄
- (IBAction)JHAddressButton:(id)sender {
    
    [self goAddressTableViewController];
    
}
-(void)goAddressTableViewController
{
    AddressTableViewController *addressVC = [[AddressTableViewController alloc]init];
    [self.navigationController pushViewController:addressVC animated:YES];
    
}
//收货地址薄
- (IBAction)SHAddressButton:(id)sender {
    [self goAddressTableViewController];
    
}
#pragma mark+++++打开录音
-(void)iFlyStartListen
{
    [_iFlySpeechRecognizer stopListening];
    [_iFlySpeechRecognizer cancel];
    //启动识别服务
    [_iFlySpeechRecognizer startListening];
    
    //设置音频来源为麦克风
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    //设置听写结果格式为json
    [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    [_iFlySpeechRecognizer setDelegate:self];
    
}
-(void)playGIF
{
    self.gifImageView.hidden = NO;
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"jiazai2" ofType:@"gif"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    UIImage *image = [UIImage sd_animatedGIFWithData:data];
//    self.gifImageView.image = image;
    //show 这个Safari类型的
//    self.voiceView = [[YSCVoiceWaveView alloc] init];
//    [self.voiceView showInParentView:self.gifImageView];
//    [self.voiceView startVoiceWave];
    //微信类型的额
    YSCMicrophoneWaveView *microphoneWaveView = [[YSCMicrophoneWaveView alloc] init];
    [microphoneWaveView showMicrophoneWaveInParentView:self.gifImageView withFrame:self.gifImageView.bounds];
    

}
/**
 停止录音
 *****/
- (IBAction)stopBtnHandler:(id)sender {
    
    NSLog(@"%s",__func__);
    [_iFlySpeechRecognizer stopListening];
}

/**
 取消听写
 *****/
- (IBAction)cancelBtnHandler:(id)sender {
    
    NSLog(@"%s",__func__);
    
    
    [_iFlySpeechRecognizer cancel];
    
    
}


//IFlySpeechRecognizerDelegate协议实现
//识别结果返回代理
/*!
 *  识别结果回调
 *
 *  在识别过程中可能会多次回调此函数，你最好不要在此回调函数中进行界面的更改等操作，只需要将回调的结果保存起来。<br>
 *  使用results的示例如下：
 *  <pre><code>
 *  - (void) onResults:(NSArray *) results{
 *     NSMutableString *result = [[NSMutableString alloc] init];
 *     NSDictionary *dic = [results objectAtIndex:0];
 *     for (NSString *key in dic){
 *        [result appendFormat:@"%@",key];//合并结果
 *     }
 *   }
 *  </code></pre>
 *
 *  @param results  -[out] 识别结果，NSArray的第一个元素为NSDictionary，NSDictionary的key为识别结果，sc为识别结果的置信度。
 *  @param isLast   -[out] 是否最后一个结果
 */
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    NSString * resultFromJson =  [ISRDataHelper stringFromJson:resultString];
    
    if ([self.textViewIdentifier isEqualToString:@"JHIdentifier"])
    {
        _textView.text = [NSString stringWithFormat:@"%@%@", self.textView.text,resultFromJson];
    }
    else
    {
        self.SHtextView.text = [NSString stringWithFormat:@"%@%@", self.SHtextView.text,resultFromJson];
    }
    _result =[NSString stringWithFormat:@"%@%@", self.textView.text,resultString];
    if (isLast){
        NSLog(@"听写结果(json)：%@测试",  self.result);
    }
}

/*!
 *  识别结果回调
 *
 *  在进行语音识别过程中的任何时刻都有可能回调此函数，你可以根据errorCode进行相应的处理，当errorCode没有错误时，表示此次会话正常结束；否则，表示此次会话有错误发生。特别的当调用`cancel`函数时，引擎不会自动结束，需要等到回调此函数，才表示此次会话结束。在没有回调此函数之前如果重新调用了`startListenging`函数则会报错误。
 *
 *  @param errorCode 错误描述
 */
- (void) onError:(IFlySpeechError *) errorCode
{
    
    NSLog(@"识别会话结束返回代理----%d-%d==%@",errorCode.errorCode,errorCode.errorType,errorCode.errorDesc);
    if (errorCode.errorCode == 0)
    {
        self.gifImageView.hidden = YES;
        _isOKListening = YES;
        
    }
    
    

}
//停止录音回调
- (void) onEndOfSpeech
{
    NSLog(@"停止录音回调");
    _isOKListening = YES;
    self.gifImageView.hidden = YES;
    


}
//开始录音回调
- (void) onBeginOfSpeech
{
    NSLog(@"开始录音回调");

}
//会话取消回调
- (void) onCancel
{
    NSLog(@"//会话取消回调");
    _isOKListening = NO;
    self.gifImageView.hidden = YES;


}

-(void)BDMapAllocInit
{
     self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, self.mapImageView.frame.size.width, self.mapImageView.frame.size.height)];
    self.mapView.delegate = self;
    [self.mapImageView addSubview:self.mapView];
    
    
}
//百度定位
-(void)baiduloaction
{
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];

    
}
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (!_annotation)
    {
      _annotation  = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = userLocation.location.coordinate.latitude;
        coor.longitude = userLocation.location.coordinate.longitude;
        _annotation.coordinate = coor;
        _annotation.title = @"我的位置";
        [self.mapView addAnnotation:_annotation];
        BMKCoordinateSpan span = BMKCoordinateSpanMake(0.038325, 0.028045);
        self.mapView.region =  BMKCoordinateRegionMake(coor, span);////限制地图显示范围
        
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
        
        NSLog(@"====%@===%@",@(coor.latitude),@(coor.longitude));
        [self.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
 
   
    }
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        
        if (_newAnnotationView== nil)
        {
           _newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
            _newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
            _newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
            _newAnnotationView.image = [UIImage imageNamed:@"dingwei"];
            return _newAnnotationView;
        }
       
    }
    return nil;
}
#pragma mark -BMKGeoCodeSearchDelegate
//根据 经纬度 获取 地区信息
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    /// 街道号码
//    @property (nonatomic, strong) NSString* streetNumber;
//    /// 街道名称
//    @property (nonatomic, strong) NSString* streetName;
//    /// 区县名称
//    @property (nonatomic, strong) NSString* district;
//    /// 城市名称
//    @property (nonatomic, strong) NSString* city;
//    /// 省份名称
//    @property (nonatomic, strong) NSString* province;
    if (error == BMK_SEARCH_NO_ERROR) {
        NSLog(@"%@===%@",result.address,result.businessCircle);
        NSLog(@"%@-%@-%@-%@-%@",result.addressDetail.province,result.addressDetail.city,result.addressDetail.district,result.addressDetail.streetName,result.addressDetail.streetNumber);
        self.poiArray = result.poiList;
    }else {
        NSLog(@"未找到结果");
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    
}


@end
