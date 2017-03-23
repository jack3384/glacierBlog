<!--
author:火柴同学
date: 2017-01-10
title:Laravel组件之Collection类
category:PHP
summary:从源码解读对Laravel之eloqunt返回的Collection实例介绍
-->
# Collection简介
Laravel`Eloeuqnt`返回的所有的包含多条记录的结果集都是都是一个继承于`Illuminate\Support\Collection`类的实例对象，该对象提供了很多有用的方法和函数，方便我们对数据库查询返回的结果做2次处理，现在看看他的源码:

#### 实现的接口
```
class Collection implements ArrayAccess, Arrayable, Countable, IteratorAggregate, Jsonable, JsonSerializable
{
//....省略
}
```
先来看看`implements`实现的接口有什么用？
- ArrayAccess: PHP内置标准接口，实现后可以像访问数组一样访问这个对象
- Countable PHP内置标准接口，实现后可被用于 `count()` 函数.
- IteratorAggregate PHP内置标准接口，实现后可被用于`foreach()`进行迭代
- JsonSerializable HP内置标准接口 实现后可被 `json_encode()`函数使用。
- Arrayable 自动义的：实现 `toArray()`函数
- Jsonable 自动义的：实现`toJson()`函数

**可以看出这个Collection对象是可以被`foreach()`函数,`$array['key']`这样数组形式访问和`json_encode()`以及`count()`的**

#### 构造函数
```
    public function __construct($items = [])
    {
        $this->items = is_array($items) ? $items : $this->getArrayableItems($items);
    }

        protected function getArrayableItems($items)
    {
        if ($items instanceof self) {
            return $items->all();
        } elseif ($items instanceof Arrayable) {
            return $items->toArray();
        } elseif ($items instanceof Jsonable) {
            return json_decode($items->toJson(), true);
        }

        return (array) $items;
    }
```
**可以看出`Collection`实例实际上对数组的一个封装（或者是另一个可以转换成数组的实例，转化成数组后再进行封装），也就是说`Eloquent`把`PDO`返回的对象(底层通过PDO来实现数据库操作的)提取出数组后用`Collection`类进行了封装（把数组保存在`$this->items`中）**

#### 其他函数
```
    public function __toString()
    {
        return $this->toJson();
    }
    public function all()
    {
        return $this->items;
    }
    public function chunk($size, $preserveKeys = false)
    {
        $chunks = [];

        foreach (array_chunk($this->items, $size, $preserveKeys) as $chunk) {
            $chunks[] = new static($chunk);
        }
        //这里用new static而不是new self 区别在于:
        //Eloquent返回的是Illuminate\Database\Eloquent\Collection实例
        //它继承于Illuminate\Support\Collection
        //通过static返回的实例就是调用对象本身的实例而不是其父类的实例
        return new static($chunks);
    }
```
**这里只简单列举了几个method,只是想说明，Collection的很多方法的本质都是返回之前被封装的数组，或者通过`array_xxx()`函数处理后的新数组重写封装的`Collection`类。**

#### 建议
请自己查看其源代码，代码比较简洁易懂，同时也可以学习很多数组相关的函数用法。