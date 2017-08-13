# RunLoop 自定输入源 实践 custom input source

## 参考：
	1.http://modun.iteye.com/blog/1600588
	2.https://blog.ibireme.com/2015/05/18/runloop/
	3.http://blog.csdn.net/devday/article/details/6928432
	4.https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/Multithreading/RunLoopManagement/RunLoopManagement.html
	5.https://bestswifter.com/runloop-and-thread/
	

## 目标
	点击UIButton --》signal source ---》触发runloop 执行事件
	
## 遇到的问题：
	1.CFRunLoopSourceSignal source 之前要判断runloop 是否处于休眠状态(CFRunLoopIsWaiting)
	如果处于休眠状态要weakup runloop (CFRunLoopWakeUp)
	2.一个runloop 多次stop 会crash
	3.使用CFRunLoopRunInMode(kCFRunLoopCommonModes, 10, false);
	 runloop 在commn Mode 中会有一句警告,不会crash
	invalid mode 'kCFRunLoopCommonModes' provided to CFRunLoopRunSpecific - break on _CFRunLoopError_RunCalledWithInvalidMode to debug. 
    This message will only appear once per execution.
 	4.CFRunLoopRun() 最好不要用这句话执行runloop 

## 实践代码：
```
#import "ViewController.h"

@interface ViewController () {

    CFRunLoopSourceRef source; //用于signal 事件源
    CFRunLoopRef runloop;//用于weak up runloop
    
    BOOL stopRunloop;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self performSelectorInBackground:@selector(configRunloop) withObject:nil];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 150, 30);
    [button setBackgroundColor:[UIColor grayColor]];
    [button setTitle:@"Signal" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    stopButton.frame = CGRectMake(100, 200, 150, 30);
    [stopButton setBackgroundColor:[UIColor grayColor]];
    [stopButton setTitle:@"StopButton" forState:UIControlStateNormal];
    [stopButton addTarget:self action:@selector(onStopButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopButton];
    
    
    UIButton *reConfiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reConfiButton.frame = CGRectMake(100, 300, 150, 30);
    [reConfiButton setBackgroundColor:[UIColor grayColor]];
    [reConfiButton setTitle:@"reConfiButton" forState:UIControlStateNormal];
    [reConfiButton addTarget:self action:@selector(onReconfigButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reConfiButton];
    
}
- (void)configRunloop {
    
    NSLog(@"is mian thread %d",[NSThread isMainThread]);
    
    
    runloop = CFRunLoopGetCurrent();
    
    //1.创建source 上下文 ，执行source 的 响应事件
    CFRunLoopSourceContext sourceContext;
    bzero(&sourceContext, sizeof(sourceContext));
    sourceContext.perform = runLoopAction;
    
    //2.创建source
    source = CFRunLoopSourceCreate(NULL, 0, &sourceContext);
    
    //3.将source 添加到runloop 中
    CFRunLoopAddSource(runloop, source, kCFRunLoopDefaultMode);
    
    while (!stopRunloop) {
        
/*
    CFRunLoopRunInMode(kCFRunLoopCommonModes, 10, false);
    ===>
    invalid mode 'kCFRunLoopCommonModes' provided to CFRunLoopRunSpecific - break on _CFRunLoopError_RunCalledWithInvalidMode to debug. 
    This message will only appear once per execution.
*/
        NSLog(@"run loop start again");
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 10, false);
    }
    NSLog(@"run loop finished");
    
}
void runLoopAction(void *info) {

    int sleepTime = arc4random()%5;
    NSLog(@"run loop ation sleep %d +++",sleepTime);
    sleep(sleepTime);
    NSLog(@"run loop ation sleep %d ---",sleepTime);
}
- (void)onButtonClick:(UIButton *)button {
    
    NSLog(@"source signal");
    if (CFRunLoopIsWaiting(runloop)) {
        
        NSLog(@"wake up runloop");
        CFRunLoopWakeUp(runloop);
    }
    CFRunLoopSourceSignal(source);
}
- (void)onStopButtonClick:(UIButton *)stopButton {
    
    if (stopRunloop == YES) { //多次 stop 会 crash
        
        NSLog(@"run loop stoped");
        return;
    }
    NSLog(@"stop run loop");
    stopRunloop = YES;
    CFRunLoopStop(runloop); //
}
- (void)onReconfigButtonClick:(UIButton *)button {
    
    NSLog(@"[Runloop ][reconfig]");
    if (stopRunloop == NO) {
        
        stopRunloop = YES;
        CFRunLoopStop(runloop);
    }
    [self performSelectorInBackground:@selector(configRunloop) withObject:nil];
    stopRunloop = NO;
}
@end

```
## runloop 理解
### 概念：
	A run loop is an event processing loop that you use to schedule work and coordinate the receipt of incoming events
	一个处理事件 和 调度事件 的 循环
### Runloop 与线程的关系
	1.每一条线程都有唯一的一个与之对应Runloop；
	2.RunLoop 在第一次获取时创建，在线程结束时销毁；只能在一个线程的内部获取其Runloop（主线程除外）；
	3.主线程默认启动runLoop，子线程需要主动开启runloop；
	4.线程在创建的时候没有Runloop 如果不制动获取，那么它一直都不会有；
	
### 源Source
	1.port-base Sources AFNetWork  使用这种 方法使用runloop 目的保持runloop一直存在
	2.Custom Input Sources 自定义输入源：上面的代码既是
	3. Cocoa Perform Selector Sources ，NSObject 中的一个方法
	4. Timer Sources  NSTimer ，手动创建一个timer 如果不加入到runloop中是不会执行timer 的响应事件
	5. Run Loop Observers runloop 的观察者


### The Run Loop Sequence of Events  Runloop 的事件处理顺序
	1.Notify observers that the run loop has been entered.
	2.Notify observers that any ready timers are about to fire.
	3.Notify observers that any input sources that are not port based are about to fire.
	4.Fire any non-port-based input sources that are ready to fire.
	5.If a port-based input source is ready and waiting to fire, process the event immediately. Go to step 9.
	6.Notify observers that the thread is about to sleep.
	7.Put the thread to sleep until one of the following events occurs:
		An event arrives for a port-based input source.
		A timer fires.
		The timeout value set for the run loop expires.
		The run loop is explicitly woken up.
	8.Notify observers that the thread just woke up.
	9.Process the pending event.
		If a user-defined timer fired, process the timer event and restart the loop. Go to step 2.
		If an input source fired, deliver the event.
		If the run loop was explicitly woken up but has not yet timed out, restart the loop. Go to step 2.
	10.Notify observers that the run loop has exited.

 
	
	

	

	
	
	
	