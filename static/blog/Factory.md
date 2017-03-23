<!--
author: 火柴同学
date: 2017-01-13
title: 设计模式之工厂模式
category: 设计模式
summary: 工厂模式的简单介绍
-->
# 工厂模式

举个例子，传统方式下我们需要一个对象会自己去`new`一个然后再调用其方法，这样耦合性就比较高。当你需要的对象改变时就需要修改所有的代码。
比如以下代码：后来你发现，需要不是再拍照的男人时而是提包的男人这时就需要修改所有代码
```
class malePhoto{
    public function holiday(){
        echo "我负责拍照".PHP_EOL;
    }
}
class maleLift{
    public function holiday(){
        echo "我来提包".PHP_EOL;
    }
}

/* 大海边 */
$person=new malePhoto();
$person->holiday();//我负责拍照
/* 雪山下 */
$person=new malePhoto();
$person->holiday();//我负责拍照
/* 草原上 */
$person=new malePhoto();
$person->holiday();//我负责拍照
```
但是通过工厂模式来生成对象，这样就不需要修改代码，修改工厂即可。
同时有时候这世界上需要的不止是男人还有女人，工厂模式可以做的更多。
```
<?php
class Factory{
    public static function create($human){
        switch ($human){
            case 'male':
                //return new malePhoto();
                return new maleLift();
                break;
            case 'female':
                return new femaleSmile();
                //return new femaleWarm();
                break;
            default:
                throw new Exception("不支持其他性别");
        }
    }
}
interface normalPeople{
    public function holiday();
}

class malePhoto{
    public function holiday(){
        echo "我负责拍照".PHP_EOL;
    }
}
class maleLift{
    public function holiday(){
        echo "我来提包".PHP_EOL;
    }
}

class femaleSmile{
    public function holiday(){
        echo "人家负责微笑".PHP_EOL;
    }
}
class femaleWarm{
    public function holiday(){
        echo "人家负责暖床".PHP_EOL;
    }
}

/* 大海边 */
$person=Factory::create('male');
$person->holiday();//我来提包
/* 雪山下 */
$person=Factory::create('male');
$person->holiday();//我来提包
/* 草原上 */
$person=Factory::create('female');
$person->holiday();//人家负责微笑
```
现在看到耦合度已经没那么高了，对象的改变只需要修改工厂方法即可。
但是这时候还有个问题，有些人只工作不度假(没有`holiday()`方法)，那么你这辈都不会遇见。所以我们还要对工厂生产的对象做限制，通过`interface`接口来实现，强制正常人`normalpeople`必须实现`holiday()`方法
```
<?php
class Factory{
    public static function create($human){
        switch ($human){
            case 'male':
                return new malePhoto();
                //return new maleLift();
                break;
            case 'female':
                //return new femaleSmile();
                return new femaleWarm();
                break;
            default:
                throw new Exception("不支持其他性别");
        }
    }
}
interface normalPeople{
    public function holiday();
}

class malePhoto implements normalPeople{
    public function holiday(){
        echo "我负责拍照".PHP_EOL;
    }
}
class maleLift implements normalPeople{
    public function holiday(){
        echo "我来提包".PHP_EOL;
    }
}

class femaleSmile implements normalPeople{
    public function holiday(){
        echo "人家负责微笑".PHP_EOL;
    }
}
class femaleWarm implements normalPeople{
    public function holiday(){
        echo "人家负责暖床".PHP_EOL;
    }
}

/* 大海边 */
$person=Factory::create('male');
$person->holiday();//我负责拍照
/* 雪山下 */
$person=Factory::create('male');
$person->holiday();//我负责拍照
/* 草原上 */
$person=Factory::create('female');
$person->holiday();//人家负责暖床
```
**这样就排除了不合格的对象。以上就是最简单的静态工厂方法模式。**

### 更多的工厂
当然了，可能我们会不满足现状，不仅要度假的时候遇见小伙伴
还想去吃大餐，这时候可以通过一个吃饭工厂`class EatFactory{}`实现`create($food)`来获取想要的对象。
这样一来工厂多了难免有些假冒的工厂出现，这时就需要对工厂限制，**让他们实现同一个接口实现`create()`方法才行。**
这样在以后需要对象的时候仅通过`工厂名::create($产品名)`即可获得想要的对象。