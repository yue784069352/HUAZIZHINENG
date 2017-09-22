//
//  ViewController.m
//  HoauAiHuaZai
//
//  Created by 岳俊杰 on 2017/9/7.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "ViewController.h"
#import "ISRDataHelper.h"
#import "OrderViewController.h"
@interface ViewController ()<IFlySpeechRecognizerDelegate>
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;
@property (nonatomic, copy) NSString * result;
@property (weak, nonatomic) IBOutlet UITextView *textView;


@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.navigationItem.title = @"华  仔";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"跳转" style:UIBarButtonItemStylePlain target:self action:@selector(go)];
    //创建语音识别对象
    _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
    //设置识别参数
    //设置为听写模式
    [_iFlySpeechRecognizer setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
    //asr_audio_path 是录音文件名，设置value为nil或者为空取消保存，默认保存目录在Library/cache下。
    [_iFlySpeechRecognizer setParameter:@"iat.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
}
-(void)go
{
    OrderViewController *orderVC = [[OrderViewController alloc]init];
    [self.navigationController pushViewController:orderVC animated:YES];
}

/**
 启动听写
 *****/
- (IBAction)startBtnHandler:(id)sender {
    
    NSLog(@"%s[IN]",__func__);
    self.textView.text = @"";
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
    _result =[NSString stringWithFormat:@"%@%@", self.textView.text,resultString];
    NSString * resultFromJson =  [ISRDataHelper stringFromJson:resultString];
    _textView.text = [NSString stringWithFormat:@"%@%@", self.textView.text,resultFromJson];
    
    if (isLast){
        NSLog(@"听写结果(json)：%@测试",  self.result);
    }
    NSLog(@"_result=%@",_result);
    NSLog(@"resultFromJson=%@",resultFromJson);


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
    
}



////识别会话结束返回代理
//- (void)onError: (IFlySpeechError *) error
//{
//    
//}
////停止录音回调
//- (void) onEndOfSpeech
//{
//    
//}
////开始录音回调
//- (void) onBeginOfSpeech
//{
//
//}
////音量回调函数
//- (void) onVolumeChanged: (int)volume
//{
//
//}
////会话取消回调
//- (void) onCancel
//{
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
