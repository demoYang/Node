## 响应链
响应链分为两个阶段:

1.寻找合适的View（hitTest的过程）； hitTest 的响应顺序为UIApplication->UIWindow->UIViewController->....->UIView

2.寻找Event响应的过程 ； Event 的响应顺序正好相反

hitTest: 先于 ，touchBegan 方法掉用，前者寻找合适的View，后者事件传递
如果hitTest 方法返回nil 代表当前的View 就是最适合的View

```
ViewController 中代码
let viewOne = DemoView.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100));
let viewTwo = DemoView.init(frame: CGRect.init(x: 20, y: 20, width: 40, height: 40));

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        viewOne.backgroundColor = UIColor.red
        let tapGA = UITapGestureRecognizer.init(target: self, action: #selector(onTapOneClick))
        viewOne.addGestureRecognizer(tapGA)
        viewOne.tag = 10
        self.view.addSubview(viewOne)
        
        viewTwo.backgroundColor = UIColor.green
        viewTwo.tag = 20
        viewOne.addSubview(viewTwo)
        
    }
    
    func  onTapOneClick(tap:UITapGestureRecognizer) -> Void {
        
        print("Tap \(#function)")
    }
    
//自定义UIView 监听 hitTest 和 touchBegan
class DemoView: UIView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        logInof(#function)
        return super.hitTest(point, with: event)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.logInof(#function)
        super.touchesBegan(touches, with: event)
    }
    
    func logInof(_ str:String) -> Void {
        
        print("响应 \(str) tag\(self.tag)")
    }
}
==log 如下===
响应 hitTest(_:with:) tag10
响应 hitTest(_:with:) tag20
响应 hitTest(_:with:) tag10
响应 hitTest(_:with:) tag20
响应 touchesBegan(_:with:) tag20
响应 touchesBegan(_:with:) tag10
Tap onTapOneClick(tap:)
```
## import 为什么对导致循环引用
	如：AB 都是头文件；A->B(a引用b) ；B->A(b引用A)  会导致循环引用


## CocoaPod 使用
	官方文档(http://guides.cocoapods.org/using/using-cocoapods.html)
	使用教程(https://juejin.im/entry/57b3bafd6be3ff006a06baa4)
	pod install 使用场景，在工程第一次使用pods 的时候，并且有编辑Podfile 的时候使用
	podfile.lock 每次install 的时候都会产生一个，该文件的作用防止库更新影响到其他协同开发的人。
	
1.cd 到工程目录，执行Pod init ，系统会帮你创建一个Podfile 文件。

2.在文件中添加你想要的库 和 版本。

3.Pod install ,版本库就会安装。


##method swizzling 
	参考：http://nshipster.cn/method-swizzling/
	为什么在load中写交换方法：
	load 方法能够确保类在初始化的时候调用， 能够保证改变行为的一致性，而initialize 在执行时，不提供这种保证；
	
	load 和 initialize 的区别：
	load 会在类初始化加载的时候调用，initialze 方法会在程序调用类的第一个实例或类方法的时候调用；


## Block
	参考：http://blog.devtang.com/2013/07/28/a-look-inside-blocks/
	Block 分三中类型：
	NSConcreateGlobalBlock：全局的静态 block，不会访问任何外部变量（写在main中的block，或者声明成静态属性的block）；
	NSConcreateStackBlock：保存在栈中的 block，当函数返回时会被销毁（就是写在函数内部的Block就是栈Block）；
	NSConcreateMallocBlock：保存在堆中的 block，当引用计数为 0 时会被销毁（运行时，动态创建的Block）；
	ARC 对Block 的影响：将只会有 NSConcreteGlobalBlock 和 NSConcreteMallocBlock 类型的 block ，所以在ARC 的时代，对Block 使用copy 或者 strong 是没有影响的；
	__Block 修饰的外部引用，Block 是复制 引用地址来实现访问的；
	
##	Method ,selector ,IMP 关系
	/// Method 结构体如下
	struct objc_method {
    	SEL method_name; 
	   char *method_types;
   		IMP method_imp;
	};
	从结构体重可以看出，IMP(实现) 和 SEL(方法名称)是Method 中的一个变量，并且
	通过SEL 可以找到对应的Method ，函数 class_getClassMethod(cls, SEL);
	
	
## 系统的ReadOnly 属性怎么修改
	通过KVO 进行修改

## property 和 synthesize 和 dynamic

	@property = ivar + getter  + setter：
	property 让系统生成get 和 setter 方法；
	synthesize 让系统帮忙实现 get 和 setter 方法；
	dynamic 告诉系统我自己去实现 get 和 setter 方法；
	
	什么情况下不会autosynthesis；
	1.同时重写了 setter 和 getter 时
	2.重写了只读属性的 getter 时
	3.使用了 @dynamic 时
	4.在 @protocol 中定义的所有属性
	5.在 category 中定义的所有属性
	6.重载的属性
	
## 关联
	删除关联：调用 objc_setAssociatedObject 方法并传入一个 nil 值来清除一个关联objc_removeAssociatedObject 这个方法，系统不推荐使用，所以使用remove的；
	关联属性的释放，会在在NSObject  中dealloc 中进行释放；
	obj_setAssociatedObject(instance, key, value ,释放策略);
	obj_getAssociatedObject(instance, key);

## ARC GC 区别：
	参考：http://zhang.hu/arc-vs-gc/
	ARC 在引用计数为0 的时候，自动释放（内存泄漏是指有块内存没有释放）；
	GC 是定期查找的方式，释放没有使用的内存（内存泄漏是指：有块内存在使用却被释放了）；

## Cookie 使用
	参考：http://www.jianshu.com/p/d2c478bbcca5
	
	// 将可变字典转化为cookie
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:fromappDict];
    // 获取cookieStorage
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage]
    // 存储cookie
    [cookieStorage setCookie:cookie]; 注意系统原来有的cookie 会被  cookie reset！！！！！；
	需要了解WKWebView	

## layoutSubView 调用时机
	参考：http://www.jianshu.com/p/eb2c4bb4e3f1
### layoutSubViews
	layoutSubView：默认没有做任何操作，需要子类重写，系统很多时候回去调用这个方法。
	layoutSubViews的调用时机：
	1.初始化不会触发layoutSubViews，但是如果设置了不为CGRectZero的frame的时候就会触发。
	2.addSubView 会触发layoutSubView；
	3.设置View的Frame会触发layoutSubViews，当然前提是frame的值前后发生了变化
	4.滚动一个UIScrollView会触发layoutSubViews；
	5.旋转Screen 会触发UIView 的layoutSubViews；
	6.改变一个UIView 大小的时候，也会触发UIView 的layoutSubViews 事件；
### setNeedslayout
	标记为需要重新布局，不立刻刷新，但layoutSubView 一定会被调用，配合layoutifNeeded 立即更新。
	layoutIfNeeded 如果有需要刷新的标记，立刻调用layoutSubViews进行布局。

## FMDB 数据库如何保证线程安全
	首先用一个数据库文件地址来初使化 FMDatabaseQueue，然后就可以将一个闭包 (block) 传入 inDatabase 方法中。该队列是同步队列。FMDatabaseQueue是一个串行队列，它不支持串行任务嵌套执行
	
## id instance 的区别
	参考：http://www.jianshu.com/p/bd913b3a8e93
	在ARC(auto reference count)环境下：instancetype 用在在编译器确定实例的类型，而使用id 的话，编译器不检查类型，运行时检查类型；
	在MRC环境下，instancetype 和 id 一样，不做具体类型检查；
	id 可以作为方法的参数，单instancetype 不可以；
	instancetype 只适用于初始化 和 便利构造器的返回值类型；
## HTTPS
	1.server 向服务器发送证书
	2.clinet 验证证书，
## 面向对象的理解
	参考：https://my.oschina.net/shaw1688/blog/601142
	面向对象3大特征：封装 ，继承、 多态
	封装：一系列方法 和 数据的组合
	继承:子类拥有父类的公有属性 和 方法
	多态:多态，就是同一个实现接口，对不同的实例而执行不同的操作
## OC 一门动态的语言，原因 体现
	参考:https://onevcat.com/2012/04/objective-c-runtime/
	1.动态类型:即运行时再决定对象的类型
	2.动态绑定:在实例所属类确定后，将某些属性和相应的方法绑定到实例上
	3.动态加载
	
## 性能检测
https://blog.leancloud.cn/2835/
http://www.jianshu.com/p/cdae09aa4f8d
内存泄漏定位
http://www.jianshu.com/p/c0aa12d91f05
使用的时候要勾选hide system Libiaries， 和 Invert call  tree

 