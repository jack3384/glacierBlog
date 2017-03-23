<!--
author: 火柴同学
date: 2017-02-17
title: PHP实现dijkstra算法，解决求最短路径问题。
category: 算法
summary: PHP实现dijkstra算法，解决求最短路径问题
-->
# PHP实现dijkstra算法
dijkstra算法广泛用于求无负权边的图中求最短路径(花费)等问题，比如路由中的选择最短路由的协议
```
//因为SPL的优先队列通过最大堆实现故，继承修改下实现最小索引堆功能，本示例代码中暂时未使用到
class IndexMinHeap extends SplPriorityQueue
{
    public function __construct()
    {
        //more返回数据和优先级
        parent::setExtractFlags(3);
    }

    public function setExtractFlags($flag)
    {
        throw new Exception('禁止用户设置这个属性');
        //禁止用户设置这个属性
    }

    public function insert($value, $priority)
    {
        $priority = -$priority;
        parent::insert($value, $priority);
    }

    public function top($flag = 'data')
    {
        $top = parent::top();
        if ($flag === 'data') {
            return $top['data'];
        } elseif ($flag === 'priority') {
            return -$top['priority'];
        } elseif ($flag === 'both') {
            $top['priority'] = -$top['priority'];
            return $top;
        } else {
            throw new Exception('top的flag错误');
        }
    }

    public function extract($flag = 'data')
    {
        $top = parent::extract();
        if ($flag === 'data') {
            return $top['data'];
        } elseif ($flag === 'priority') {
            return -$top['priority'];
        } elseif ($flag === 'both') {
            $top['priority'] = -$top['priority'];
            return $top;
        } else {
            throw new Exception('top的flag错误');
        }
    }
}

//带权边
class Edge
{
    protected $vertex1;
    protected $vertex2;
    public $weight;

    public function __construct($vertex1, $vertex2, $weight)
    {
        $this->vertex1 = $vertex1;
        $this->vertex2 = $vertex2;
        $this->weight = $weight;
    }

    public function getVertex()
    {
        return array($this->vertex1, $this->vertex2);
    }

    public function other($vertex)
    {
        if ($vertex === $this->vertex1) {
            return $this->vertex2;
        } elseif ($vertex === $this->vertex2) {
            return $this->vertex1;
        } else {
            throw new Exception("{$this->vertex1}{$this->vertex2}构成的边不存在该顶点{$vertex}");
        }
    }

}

//带权图，暂不考虑有向图的情况
class WeightGraph
{
    public $arcArr = array();//使用领接表存储边的信息,key为顶点名，值为一个包含邻接边信息的数组
    //格式为 $arcArr['vertex1']=['vertex2'=>[$edgeObj1...],'vertex3'=>[$edgeObj2...]]
    protected $direct = 0; //0无向图，1有向
    protected $isChange = true;//有新的边加入后表示改变
    protected $vertexArr = array(); //储存顶点是否被访问过
    protected $edges;//储存边信息的Map对象。

    public function __construct($vertexArr, $direct = 0)
    {
        $this->direct = $direct;
        foreach ($vertexArr as $vertex) {
            $this->arcArr[$vertex] = array();
            $this->vertexArr[$vertex] = false;
        }
        $this->edges = new SplObjectStorage;//采用标准库的Map类型储存对象被访问的属性
    }

    //$arc格式 ['vertex1__vertex2'=>1,'vertex3__vertex2'=>[1,2,3]]
    public static function make($vertexArr, array $arc)
    {
        $obj = new static($vertexArr);
        foreach ($arc as $path => $weights) {
            $path = explode('__', $path);
            settype($weights, 'array');
            foreach ($weights as $weight) {
                $obj->setEdge($path[0], $path[1], $weight);
            }
        }
        return $obj;
    }

    //验证顶点是否存在，不存在时抛出异常
    protected function isVertex($var)
    {
        $var = (array)$var;
        foreach ($var as $v) {
            if (!isset($this->arcArr[$v])) {
                throw new Exception("顶点:{$v}不存在");
            }
        }
    }

    //设置顶点间的边
    public function setEdge($from, $to, $weight)
    {
        if (isset($this->arcArr[$from]) && isset($this->arcArr[$to])) {
            $this->isChange = true;
            //平行边的情况
            if (!isset($this->arcArr[$from][$to])) {
                $this->arcArr[$from][$to] = array();
            }
            $edge = new Edge($from, $to, $weight);
            $this->edges[$edge] = false;
            array_push($this->arcArr[$from][$to], $edge);
            if (!$this->direct) {
                if (!isset($this->arcArr[$to][$from])) {
                    $this->arcArr[$to][$from] = array();
                }
                array_push($this->arcArr[$to][$from], $edge);
            }
        } else {
            throw new Exception('有顶点不存在');
        }
        return $this;
    }

}

class Dijkstra extends WeightGraph
{
    protected $source;//标记当前的原点
    protected $shortestPaths = array();//标记已经找到最短路径的顶点与其信息
    protected $undefined;//存放待定的顶点与其距离
    protected $from = array();//储存路径

    public function __construct($vertexArr, $direct = 0)
    {
        parent::__construct($vertexArr, $direct);
        foreach ($vertexArr as $vertex) {
            // array与任何其它类型比较，array 总是更大，故这里array()代表无穷大
            $this->undefined[$vertex] = array();
            $this->from[$vertex] = null;
        }
    }


    public function getShortestPath($from, $to)
    {
        $this->isVertex(array($from, $to));
        $this->generateShortestPath($from);
        if(!isset($this->shortestPaths[$to])){
            echo "找不到从从{$from}到{$to}的路径";
            return;
        }
        $stack = array();
        $node = $this->from[$to];
        while (null !== $node) {
            array_unshift($stack, $node);
            $node = $this->from[$node];
        }
        array_push($stack, $to);
        $path = implode('==>', $stack);
        echo $path . PHP_EOL;
        echo 'weight:' . $this->shortestPaths[$to];
    }

    protected function generateShortestPath($vertex)
    {
        $this->source = $vertex;
        unset($this->undefined[$vertex]);
        $this->shortestPaths[$vertex] = 0;
        while (!empty($this->undefined)) {
            $vertex = $this->getPath($vertex);
        }
    }

    protected function getPath($vertex)
    {
        //获得这个节点的邻边做松弛操作
        $edges = $this->getAdjEdges($vertex);
        foreach ($edges as $edge) {
            $other = $edge->other($vertex);
            if (!isset($this->undefined[$other])) {
                continue;
            }
            if ($edge->weight + $this->shortestPaths[$vertex] < $this->undefined[$other]) {
                $this->undefined[$other] = $edge->weight + $this->shortestPaths[$vertex];
                $this->from[$other] = $vertex;
            }
        }
        //计算最小值获得最短路径
        $v = $this->getMin();
        if ($v['vertex'] === null) {//表示已经没有任何可用路径了
            $this->undefined = array();
            return false;
        }
        $this->shortestPaths[$v['vertex']] = $v['weight'];
        unset($this->undefined[$v['vertex']]);
        return $v['vertex'];
    }

    protected function getMin()
    {
        $min = array();//array表示无穷大
        $minVertex = null;
        foreach ($this->undefined as $vertex => $weight) {
            if ($weight < $min) {
                $minVertex = $vertex;
                $min = $weight;
            }
        }
        return array('weight' => $min, 'vertex' => $minVertex);
    }

    protected function getAdjEdges($vertex)
    {
        $edges = array();
        foreach ($this->arcArr[$vertex] as $adjacency) {
            //暂时不考虑平行边
            array_push($edges, $adjacency[0]);
        }
        return $edges;
    }

}

////测试代码
$vertexArr = ['成都', '广州', '西安', '武汉', '北京', '上海'];
//以下为路径和距离，任意添加修改路径会有不同的结果
$arc = [
    '北京__西安' => 800,
     '北京__上海' => 1000,
     '北京__武汉' => 950,
    '成都__西安' => 600,
    '成都__武汉' => 900,
    '成都__广州' => 1200,
    '广州__武汉' => 850,
    '广州__上海' => 1100,
    '武汉__上海' => 1050,
];
$graph = Dijkstra::make($vertexArr, $arc);
$graph->getShortestPath('北京', '广州');
```