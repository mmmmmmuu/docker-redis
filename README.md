采用1主1从3哨兵的模式<br>
 7000 redis主节点<br>
 7001 redis从节点<br>
 8000，8001，8002为3个哨兵节点<br>

 如果需要读取修改数据，可以直接连接reids主节点<br>

1.2  redis和哨兵配置参考浪哥的改造<br>
1.3  修复bug   从节点slave slaveof采用直接ip的方式  原：127.0.0.1<br>
     优化    新增参数 maxmemory=2gb  容许自定义redis最大容量  默认1gb<br>
     