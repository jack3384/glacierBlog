<!--
author: 火柴同学
date: 2016-12-23
title: 反转控制与依赖注入--IOC容器的实现
category: 设计模式
summary: IOC容器的实现，相关技术反射、匿名函数，实现依赖类的自动加载与松耦合
-->

## IOC（控制反转）与DI（依赖注入）
**DI依赖注入**：最原始的是依赖的对象通过参数形式动态的传入，现在的方式就是由IOC容器在运行期间，动态地将某种依赖关系注入到对象之中
**IOC控制反转：**，又叫容器（这个容器实现了控制反转），其观点大体是这样的：
- **借助于“第三方(IOC容器）”实现具有依赖关系的对象之间的解耦。**
- **反转的是什么：**获得依赖对象的过程被反转了。控制被反转之后，获得依赖对象的过程由自身管理（比如自己new）变为了由IOC容器主动注入。所以IOC又叫做“依赖注入（Dependency Injection）

### IOC概念
- 软件系统在没有引入IOC容器之前，对象A依赖于对象B，那么对象A在初始化或者运行到某一点的时候，自己必须主动去创建对象B或者使用已经创建的对象B。无论是创建还是使用对象B，控制权都在自己手上。
- 软件系统在引入IOC容器之后，这种情形就完全改变了，由于IOC容器的加入，对象A与对象B之间失去了直接联系，所以，当对象A运行到需要对象B的时候，IOC容器会主动创建一个对象B注入到对象A需要的地方。
- 通过前后的对比，我们不难看出来：**对象A获得依赖对象B的过程,由主动行为变为了被动行为，控制权颠倒过来了，这就是“控制反转”这个名称的由来**。

### IOC的优缺点
**优点**
- 解耦
- 需求变更时代码维护方便

**缺点：**
- 软件系统中由于引入了第三方IOC容器，**生成对象的步骤变得有些复杂**，本来是两者之间的事情，又凭空多出一道手续，所以，我们在刚开始使用IOC框架的时候，**会感觉系统变得不太直观**
- 由于IOC容器**生成对象是通过反射方式，在运行效率上有一定的损耗**。如果你要追求运行效率的话，就必须对此进行权衡。

### 关键技术
IOC中最基本的技术就**匿名函数与反射(Reflection)**

## IOC容器的实现
分几个步骤逐步优化：
- 最简单版本：本质是**匿名函数（用作回调）**的使用
- 绑定的时候可以通过类名自动生成匿名函数，但是Dating类由于有依赖还是必须通过匿名函数方式绑定。
- 解决Dating类的实例化问题，这里用到了反射
- laravel中通过容器类的`make()`为注册的类产生实例化所需的匿名函数，需要调用时通过`build()`实例化类

## 现在开始实现最简单版本
这个最简单的版本，虽然目前看起还用处不大，因为要自己写匿名函数、要自己通过new实例化对象。不过没关系，后面慢慢优化后可以不用自己写回调（IOC->bind自动把类名转成回调函数），然后通过反射实现实例化对象。
- **这个例子反映了IOC-bind()的实质,匿名函数**
- **当A依赖的对象B变化时，只需要更改B的bind()，不需要动A**

```
<?php

//定义IOC容器类
class IOC
{
    protected $objs = [];

    //绑定类
    public function bind($name, Closure $definition)
    {
        $this->objs[$name] = $definition;
    }

//获得实例
    public function get($name)
    {
        if (isset($this->objs[$name])) {
            return $this->objs[$name]();
        } else {
            echo "有异常发生，所以这里要做异常处理";
        }
    }
}

//Dating 依赖实现Eat接口的实例比如Dinner
class Dating
{
    protected $objectEat;
    //实例化Dating的时候，需要传入关于吃的主题
    public function __construct($objectEat)
    {
        $this->objectEat = $objectEat;
    }

    public function eat()
    {
        $this->objectEat->eat();
    }
}

//定义Eat接口所有有吃饭有关的都要实现该接口
Interface Eat
{
    public function eat();
}

//定类DInner
class Dinner implements Eat
{
    public function eat()
    {
        echo "Start Dinner" . PHP_EOL;
    }
}

//Lunch
class Lunch implements Eat
{
    public function eat()
    {
        echo "!!!Start Lunch!!!" . PHP_EOL;

    }
}

//实例化IOC容器
$obj = new Ioc();

//绑定eating为Dinner类
$obj->bind('eating', function () {
    return new Dinner;
});

$obj->bind('Dating', function () use ($obj) {
    return new Dating($obj->get('eating'));
});

$objDating = $obj->get('Dating'); //获得Dating实例
$objDating->eat(); //Start Dinner

//替换绑定eating为Lunch类
$obj->bind('eating', function () {
    return new Lunch;
});

//重新获得对象Dating
$objDating = $obj->get('Dating');

$objDating->eat();//输出 "!!!Start Lunch!!!"
```
#### 自动生成匿名函数
上面的例子每次生成匿名函数写的太多，所以要有这样的功能**传入类名自动生成匿名函数**
```
<?php

//定义IOC容器类
class IOC
{
    protected $objs = [];

//这个函数改进下 如果传的不是匿名函数而是类名自动生成一个默认的匿名函数
    public function bind($name, $definition){
        if(!$definition instanceof Closure){
            $definition=$this->getClosure($definition);
        }
        $this->objs[$name]=$definition;
    }

//获得实例
    public function get($name)
    {
        if (isset($this->objs[$name])) {
            return $this->objs[$name]();
        } else {
            echo "有异常发生，所以这里要做异常处理";
        }
    }
    protected function getClosure($definition)
    {
        return function()use($definition)
        {
            return new $definition;
        };
    }
}

//Dating 依赖Dinner
class Dating
{
    protected $objectEat;
    //实例化Dating的时候，需要传入关于吃的主题
    public function __construct($objectEat)
    {
        $this->objectEat = $objectEat;
    }

    public function eat()
    {
        $this->objectEat->eat();
    }
}

//定义Eat接口所有有吃饭有关的都要实现该接口
Interface Eat
{
    public function eat();
}

//定类DInner
class Dinner implements Eat
{
    public function eat()
    {
        echo "Start Dinner" . PHP_EOL;
    }
}

//Lunch
class Lunch implements Eat
{
    public function eat()
    {
        echo "!!!Start Lunch!!!" . PHP_EOL;

    }
}

//实例化IOC容器
$obj = new Ioc();

//绑定的方法从匿名函数替换成类名了
$obj->bind('eating','Dinner');

$obj->bind('Dating', function () use ($obj) {
    return new Dating($obj->get('eating'));
});

$objDating = $obj->get('Dating'); //获得Dating实例
$objDating->eat(); //Start Dinner

//绑定的方法从匿名函数替换成类名了
$obj->bind('eating', 'Lunch');

//重新获得对象Dating
$objDating = $obj->get('Dating');

$objDating->eat();//输出 "!!!Start Lunch!!!"
```

### 自动注册（绑定依赖的类）
上面的代码中Dating类不能直接通过传类名的方式实例化，因为要传递依赖的实例进去
改造下，所有类的实例化通过`build`函数获得，需要依赖的时候自动获得实例。
```
<?php
//定义IOC容器类
class IOC
{
    protected $objs = [];
    //这个函数改进下 如果传的不是匿名函数而是类名自动生成一个默认的匿名函数
    public function bind($name, $definition){
        if(!$definition instanceof Closure){
            $definition=$this->getClosure($definition);
        }
        $this->objs[$name]=$definition;
    }
    //获得实例，这里传入了自己作为参数
    public function get($name)
    {
        if (isset($this->objs[$name])) {
            return $this->objs[$name]($this);
        } else {
            echo "有异常发生，所以这里要做异常处理";
        }
    }
    protected function getClosure($definition)
    {
        //此函数更新，实例化类通过容器的build方法
        return function($ioc)use($definition)
        {
            return $ioc->build($definition);
        };
    }

    protected function getParameters($parameters)
    {
        $arguments=[];
        foreach($parameters as $parameter) {
            //如果该参数是个类的实例自动实例化
            $class=$parameter->getClass();
            if($class){
                array_push($arguments,$this->build($class->name));
            }else{
                array_push($arguments,$parameter->getDefaultValue());
            }
        }
        return $arguments;
    }

    //大概意思就是实例化类返回
    protected function build($definition)
    {
        $reflection=new ReflectionClass($definition);
        $constructor=$reflection->getConstructor();
        //没有构造函数或者没有参数直接返回
        if(is_null($constructor)||empty($parameters=$constructor->getParameters())){
            return $reflection->newInstance();
        }
        //有参数就用此函数获得参数所需的类或者默认参数
        $paras=$this->getParameters($parameters);
        return $reflection->newInstanceArgs($paras);

    }
}
//Dating 依赖Dinner
class Dating
{
    protected $objectEat;
    //定义该类依赖的其他类，会自动绑定和实例化
    public function __construct(Dinner $objectEat)
    {
        $this->objectEat = $objectEat;
    }
    public function eat()
    {
        $this->objectEat->eat();
    }
}
//定义Eat接口所有有吃饭有关的都要实现该接口
Interface Eat
{
    public function eat();
}
//定类DInner
class Dinner implements Eat
{
    public function eat()
    {
        echo "Start Dinner" . PHP_EOL;
    }
}
//Lunch
class Lunch implements Eat
{
    public function eat()
    {
        echo "!!!Start Lunch!!!" . PHP_EOL;
    }
}
//实例化IOC容器
$obj = new Ioc();
//只绑定dating了，中间吃的类根据Dating类的构造函数定义自动实例化
$obj->bind('dating','Dating');
$objDating = $obj->get('dating');
$objDating->eat();//输出 "!!!Start Lunch!!!"
```
## 自动注册绑定接口Interface
如果Dating类不固定某个实例化的类，只需要实现Eat接口就行了，该怎么办？修改下代码
```
//绑定到接口
public function __construct(Eat $objectEat)
{.....}

//优化下build类
protected function build($definition)
{
//如果接口已经绑定了具体的类就返回
  if (isset($this->objs[$definition])) {
  return $this->objs[$definition]($this);
 }  $reflection=new ReflectionClass($definition);
  $constructor=$reflection->getConstructor();
  //没有构造函数或者没有参数直接返回
  if(is_null($constructor)||empty($parameters=$constructor->getParameters())){
  return $reflection->newInstance();
 }  //有参数就用此函数获得参数所需的类或者默认参数
  $paras=$this->getParameters($parameters);
  return $reflection->newInstanceArgs($paras);
}


//调用
//实例化IOC容器
$obj = new Ioc();
//只绑定dating了，中间吃的类根据Dating类的构造函数定义自动实例化
$obj->bind('dating','Dating');
//这里把Eat接口绑定到Diner类
$obj->bind('Eat','Dinner');
$objDating = $obj->get('dating');
$objDating->eat();//输出 "Start Dinner"
```