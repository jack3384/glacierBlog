<!--
author: 火柴同学
date: 2016-11-30
title: PHP实现二分搜索树
category:算法
summary: PHP实现二分搜索树
-->
## PHP实现二分搜索树
二分搜索树是一种二叉树（不同于堆并不是完全二叉）
**特性：左子节点值 < 当前节点的值 < 右子节点值 **
直接看代码，原理有时间再讲
```
//二分搜索树
class BST
{
    public $root = null;

    //将数组转换成BTS对象
    public static function make(array $array)
    {
        $res = new static;
        foreach ($array as $value) {
            $res->insert($value);
        }
        return $res;
    }

    //插入元素，如已经存在count属性+1
    public function insert($value)
    {
        if (!$this->root) {
            $this->root = new node($value);
        } else {
            $this->shiftDown($this->root, $value);
        }
        return $this;
    }

    //查询是否包含该值
    public function has($value)
    {
        if ($this->root === null) {
            return false;
        }
        $res = $this->extract($this->root, $value);
        if ($res) {
            return true;
        } else {
            return false;
        }
    }

    //查找该值并返回对应的node对象
    public function search($value)
    {
        if ($this->root === null) {
            return false;
        }
        return $this->extract($this->root, $value);
    }


    public function min()
    {
        if (!$this->root) {
            return false;
        }
        return $this->getMinNode($this->root)->value;
    }

    public function max()
    {
        if (!$this->root) {
            return false;
        }
        return $this->getMaxNode($this->root)->value;
    }

    protected function &getMinNode(node &$node)
    {
        if ($node->leftChild === null) {
            return $node;
        }else{
            return $this->getMinNode($node->leftChild);
        }

    }

    protected function &getMaxNode(node &$node)
    {
        if ($node->rightChild === null) {
            return $node;
        }else{
            return $this->getMaxNode($node->rightChild);
        }

    }

    //中序遍历返回数组。
    public function midIterate()
    {
        if (!$this->root) {
            return [];
        }
        $res = [];
        $this->midIterator($this->root, $res);
        return $res;
    }

    protected function midIterator($node, &$res)
    {
        if ($node === null) {
            return;
        }
        $this->midIterator($node->leftChild, $res);
        $res[] = $node->value;
        $this->midIterator($node->rightChild, $res);
    }

    public function delete($value)
    {
        if(!$this->root){return false;}
        if($delete_node=&$this->extract($this->root,$value)){
            $this->deleteNode($delete_node);
            return true;
        }else{
            return false;
        }
    }

    protected function deleteNode(node &$delete_node)
    {
        //$delete_node使用返回对象的引用，这样将其设置为null后，关联的都为null
           if($delete_node->leftChild!==null){
               $replaceNode=&$this->getMaxNode($delete_node->leftChild);
               $delete_node->value=$replaceNode->value;
               $delete_node->count=$replaceNode->count;
               $this->deleteNode($replaceNode);
           }elseif ($delete_node->rightChild!==null){
               $replaceNode=&$this->getMinNode($delete_node->rightChild);
               $delete_node->value=$replaceNode->value;
               $delete_node->count=$replaceNode->count;
               $this->deleteNode($replaceNode);
           }else{
               $delete_node=null;
           }
    }

    public function rank($value)
    {

    }

    public function select($rank)
    {

    }


    //找到要查询的值返回node对象
    protected function &extract(node &$node, $value)
    {
        $notFound=false;
        if ($node->value > $value) {
            if ($node->leftChild === null) {
                return $notFound;
            } else {
                return $this->extract($node->leftChild, $value);
            }
        } elseif ($node->value < $value) {
            if ($node->rightChild === null) {
                return $notFound;
            } else {
                return $this->extract($node->rightChild, $value);
            }
        } else {
            return $node;
        }
    }

    protected function shiftDown(node $node, $value)
    {
        if ($node->value > $value) {
            //左
            if ($node->leftChild === null) {
                $node->leftChild = new node($value);
            } else {
                $this->shiftDown($node->leftChild, $value);
            }
        } elseif ($node->value < $value) {
            //右
            if ($node->rightChild === null) {
                $node->rightChild = new node($value);
            } else {
                $this->shiftDown($node->rightChild, $value);
            }
        } else {
            //等于
            $node->count++;
        }
    }

}

//存储节点信息
class  node
{
    public $leftChild = null;
    public $rightChild = null;
    public $value;
    public $count = 1;

    public function __construct($value)
    {
        $this->value = $value;
    }
}

//测试代码
$a=BST::make([30,15,12,13,14,18,17,50]);
var_dump($a->delete(50));
var_dump($a->delete(12));
print_r($a->midIterate());
```