## Timer
	使用Timer.init 方法创建Timer 的时候，Timer 并没有添加到Runloop 上 ,所以不会执行action
	timer = Timer.init(timeInterval: 1, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)            
   RunLoop.current.add(timer, forMode: RunLoopMode.defaultRunLoopMode)

## 字符串格式
	参考:http://swifter.tips/output-format/
	second = 0.0
	label.text = String.init(format: "%.1f", second)
	
## Swfit 枚举定义
	参考：http://swift.gg/2015/11/20/advanced-practical-enum-examples/
	Swift 和 OC 枚举不同，Swift 的枚举成员在创建时不会被赋予一个默认的整型值，相反这些枚举成员本身就是完备的值，这些值得类型已经明确定义好的的类型
	Swift 中枚举支持4中类型的管理值类型：Integer 、float 、String、Boolean
	
## 如何继承UITableViewCell
	1.在override init(style: UITableViewCellStyle, reuseIdentifier: String?) { }方法中不憋return self
	2.required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    	}
    	这个必须加上
## swift 如何设置navigation透明
	self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
	self.navigationController?.navigationBar.shadowImage = UIImage()
	self.navigationController?.navigationBar.isTranslucent = true
	设置navigation 背景颜色:
	self.navigationController?.navigationBar.barTintColor = UIColor.darkGray.withAlphaComponent(0.3)

## 如何使用NSBundle
	在swift 中 NSBundel 即为 Bundle
## Swift init 构造器
	1.给存储类型属性赋默认值或在出事构造器中设置初始值，此属性的观察者不会被调用。；
	2.（默认构造器）Swift 将为所有属性已提供默认值且自身没有定义任何构造器的结构体或者基类，提供一个默认的构造器，这个默认构造器将建的创建一个所有属性值都设置为默认值得实例；
	3.构造器的参数份内部和外部参数，不写外部参数名那么外部参数名等于内部参数名，如果不希望为构造器的某个参数提供外部名字，可以使用下划线来显示描述它的外部名；
	4.Swift 提供了两种类型的类构造器来确保所有类实例中的存储型 属性都能获得初始值，他们分别是指定构造器 和 遍历构造器；
	
## but that file does not have a valid extension 警告处理
	参考：http://www.itguai.com/ios/a4797187.html
	root Case ，图片的后缀名是大写，改成小写 Fixed
## 毛玻璃效果
	参考：http://www.jianshu.com/p/8140a2fa5cdb && http://blog.kumaya.co/2014/08/13/creating-blur-effect-in-ios-8/
	1.创建一个特效，2.创建一个UIVisualEffectView ，3. 将view 添加到需要作用的view上。
	以上只支持iOS 8 以上，iOS 7 需要使用 CIFilter 进行图片本身的处理（从新生成一张图片）

## Swift 获取引用计数
	CFGetRetainCount(var)

## 如何开启一个runLoop
	概念：一般来京一个线程一次只能执行一个任务，执行完成后线程就会推出。但是	有时候我们需要线程能够一直待命，随时处理时间而不退出，这种模型成为Event loop；
	
	作用：
	1.保持程序继续执行：例如程序已启动就会开启一个主线程，主项成已开启来就会跑一个主程序对应的RunLoop， RunLoop 保证主程序不会被销毁，也就保证了程序的持续运行；
	2.处理各种事件
	3.节省CPU 支援，优化程序性能：程序运行起来时，当什么操作都没有做的时候，RunLooop通知系统待命，这是系统就会将其资源释放，当有事情做的时候Runloop 就会立马处理
	
	Runloop 与线程的关系
	1.每一条线程都有唯一的一个与之对应Runloop；
	2.RunLoop 在第一次获取时创建，在线程结束时销毁；只能在一个线程的内部获取其Runloop（主线程除外）；
	3.主线程默认启动runLoop，子线程需要主动开启runloop；
	4.线程在创建的时候没有Runloop 如果不制动获取，那么它一直都不会有；
	
	Runloop对象与相关类 之间的关系
	1.一个Runloop包含若干个Model，而没给Mode 包含若干个Source、Timer、Observer
	2.Runloop每次只能指定一种Mode。而且如果需要切换Mode、只能退出当前的runLoop。这样做主要是为了分割开不同的Source、Timer、Observer，让其互补影响；
	3.如果一个model 中 输入源（Source、Timer、Observer） 都没有，则RunLoop会直接退出、不进入循环；
	
	CFRunLoopSourceRef输入源：
		Source0：非基于端口port ，例如触摸滚动，selector 选择器等用户触发事件；（只包含了一个回调，并不能主动出发事件）
		Source1：基于端口port ，一些系统事件；（包含了一个mach_port 和一个回调函数，被用于通过内核和其他线程相互发送消息，能主动唤醒Runloop的线程）
	CFRunloopTimerRef：
		是基于时间的触发器，它和 NSTimer 是toll-free bridged 可以混用；其包含一个时间长度和一个回调（函数指针）；当其加入到Runloop时，RunLoop会注册对应的时间点，当时间点到时，RunLoop就会被唤醒执行那个回调；
	CFRunLoopObserverRef 是观察者，每个Observer 都包含了一个回调，当Runloop的状态发生改变是，观察这就能够通过回调接收到这个变化；
	
	总结:上面的 3个统称为mode item，一个item可以同时被加入多个mode，但一个item 被重复加入同一个mode 时是不会有效果的；如果一个mode 一个itme 都没有Runloop会直接退出，不进入循环；
		
	CFRunloopModelRef Mode 类型
	kCFRunLoopDefaultMode 默认模式，通常主线程在这个模式下运行
	UITrackingRunLoopMode 界面跟中Mode ，用于追踪Scrollview 触摸滑动时的状态
	kCFRunLoopCommonModes 占位符，带有common标记的字符串，比较特殊的一个mode；
	UIInitializationRunLoopMode ：刚启动App 时进入的的第一个Model，启动之后不再使用
	GSEventReceiveRunLoop ：每部mode 接收系统事件；
	 

## Swfit 如何使用Block ，和 OC 的不同之处
   