# Apollo Planning决策规划算法代码详解 (22):决策规划算法最完整介绍


前言：

后台已经写完了Apollo Planning决策规划算法的完整解析，一路从规划模块的入口OnLanePlanning，介绍到常见的规划器PublicRoadPlanner；接着介绍了在PublicRoadPlanner中如何通过类似有限状态机的ScenarioDispatch进行场景决策。之后又介绍了在每个场景Scenario中如何配置以及判断当前所处的stage，以及对于每个stage又是如何注册tasks来执行具体的规划任务。

现在回头来看，这个系列应该是目前全网最完整的apollo规划算法planning模块的解析教程了，所以现在阶段性的，想再对apollo整个规划算法的流程做一个总结，也可以当做是整个系列的文章的概述。

如果对apollo规划算法感兴趣，想学习完整的系列文章，可以订阅下面专栏：

[Apollo决策规划模块代码详解\*自动驾驶 Player的博客-CSDN博客blog.csdn.net/nn243823163/category\*11685852.html?spm=1001.2014.3001.5482![](..\..\images\9f18e633-56c1-4ffb-a743-d633cbc9ddf3.jpg)](https://link.zhihu.com/?target=https%3A//blog.csdn.net/nn243823163/category_11685852.html%3Fspm%3D1001.2014.3001.5482)

**也可以加我vx公众号（L5Player）进一步交流学习：**

在本文将会讲解下面这些内容：

1、apollo规划算法整体运行框架pipline

2、常用的LANE\_FOLLOW场景如何执行具体的规划任务；

3、LANE\*FOLLOW\*DEFAULT\_STAGE有哪些tasks，这些task分别执行什么任务；

4、完整的决策规划流程

正文如下：

一、apollo规划算法整体运行框架

在每个运行周期内，可以理解为task是最小的执行单位；按照配置不同的task构成了stage；当确定所处stage后，会执行stage下注册的所有task。

apollo规划算法中，task的执行流程如下，下图便是apollo规划算法的完整运行流程：

  

![](..\..\images\dc8d0bcc-74b7-418e-9a9c-71405366e2a6.jpg)

![](..\..\images\44f9b722-7c0d-4ff9-bb08-42ff5feb11d5.webp)

二、apollo规划算法具体执行的task

上文讲到PublicRoadPlanner 的 LaneFollowStage 是在自动驾驶过程中使用频率最高的场景与stage，LaneFollowStage的配置如下，正是下面这些task组成了在LaneFollowStage状态下完整的决策规划算法。

```text
scenario*type: LANE*FOLLOW
stage*type: LANE*FOLLOW*DEFAULT*STAGE
stage_config: {
  stage*type: LANE*FOLLOW*DEFAULT*STAGE
  enabled: true
  task*type: LANE*CHANGE_DECIDER
  task*type: PATH*REUSE_DECIDER
  task*type: PATH*LANE*BORROW*DECIDER
  task*type: PATH*BOUNDS_DECIDER
  task*type: PIECEWISE*JERK*PATH*OPTIMIZER
  task*type: PATH*ASSESSMENT_DECIDER
  task*type: PATH*DECIDER
  task*type: RULE*BASED*STOP*DECIDER
  task*type: ST*BOUNDS_DECIDER
  task*type: SPEED*BOUNDS*PRIORI*DECIDER
  task*type: SPEED*HEURISTIC_OPTIMIZER
  task*type: SPEED*DECIDER
  task*type: SPEED*BOUNDS*FINAL*DECIDER
  # task*type: PIECEWISE*JERK*SPEED*OPTIMIZER
  task*type: PIECEWISE*JERK*NONLINEAR*SPEED_OPTIMIZER
  task*type: RSS*DECIDER
}
```

三、apollo规划算法tasks最完整解析

上文提到task组成了在LaneFollowStage状态下完整的决策规划算法，本节将会完整介绍这些task设置的目的，具体执行什么样的任务：

1、LaneChangeDecider

LaneChangeDecider 是lanefollow 场景下，所调用的第一个task，它的作用主要有两点：

-   判断当前是否进行变道，以及变道的状态，并将结果存在变量lane\*change\*status中；
-   变道过程中将目标车道的reference line放置到首位，变道结束后将当前新车道的reference line放置到首位

流程图如下：

  

![](..\..\images\6d335618-f9cd-4273-ac1d-f8e86794d4fd.jpg)

![](..\..\images\a9658fd2-c8c9-44e0-9108-c86b98975a9f.webp)

2、PathReuseDecider

PathReuseDecider 是lanefollow 场景下，所调用的第 2 个 task，它的作用主要是换道时：

-   根据横纵向跟踪偏差，来决策是否需要重新规划轨迹；
-   如果横纵向跟踪偏差，则根据上一时刻的轨迹生成当前周期的轨迹，以尽量保持轨迹的一致性

流程如下：

  

![](..\..\images\6bae07df-e45c-4a55-ab7e-10776e3f021f.jpg)

![](..\..\images\909dc953-22e3-46d9-94c5-463f4bc9e52a.webp)

3、PathLaneBorrowDecider

PathLaneBorrowDecider 是第3个task，PathLaneBorrowDecider会判断已处于借道场景下判断是否退出避让；判断未处于借道场景下判断是否具备借道能力。

需要满足下面条件才能判断是否可以借道：

-   只有一条参考线，才能借道
-   起点速度小于最大借道允许速度
-   阻塞障碍物必须远离路口
-   阻塞障碍物会一直存在
-   阻塞障碍物与终点位置满足要求
-   为可侧面通过的障碍物

![](..\..\images\0d5d5d74-0597-4f49-bcfb-108cfba97aa4.jpg)

![](..\..\images\47e0442d-1885-4187-aa8c-807543d2df61.webp)

4、PathBoundsDecider

PathBoundsDecider 是第四个task，PathBoundsDecider根据lane borrow决策器的输出、本车道以及相邻车道的宽度、障碍物的左右边界，来计算path 的boundary，从而将path 搜索的边界缩小，将复杂问题转化为凸空间的搜索问题，方便后续使用QP算法求解。

  

![](..\..\images\c41e5f98-a272-4732-bd22-ecb03d71a421.jpg)

![](..\..\images\48a9f71e-8291-4e41-a393-97ebc71ec58e.webp)

5、**PiecewiseJerkPathOptimizer**

PiecewiseJerkPathOptimizer 是lanefollow 场景下，所调用的第 5 个 task，属于task中的optimizer类别它的作用主要是：

-   1、根据之前decider决策的reference line和 path bound，以及横向约束，将最优路径求解问题转化为二次型规划问题；
-   2、调用osqp库求解最优路径；

![](..\..\images\a2c90a84-fedc-4e24-aa10-966e54b63e6e.jpg)

![](..\..\images\4bbb7b67-f20f-4b32-86d3-3dece338eb86.webp)

6、PathAssessmentDecider

PathAssessmentDecider 是lanefollow 场景下，所调用的第 6 个 task，属于task中的decider 类别它的作用主要是：

-   选出之前规划的备选路径中排序最靠前的路径；
-   添加一些必要信息到路径中

![](..\..\images\2719f62e-fa01-4d59-93e3-9acf36ea0d3b.jpg)

![](..\..\images\c1dc19db-6f48-4253-b8b0-f813c97a5910.webp)

7、PathDecider

PathDecider 是lanefollow 场景下，所调用的第 7 个 task，属于task中的decider 类别它的作用主要是：

在上一个任务中获得了最优的路径，PathDecider的功能是根据静态障碍物做出自车的决策，对于前方的静态障碍物是忽略、stop还是nudge

![](..\..\images\3dce0050-85d2-43a7-985f-f0dfbbdcd4a8.jpg)

![](..\..\images\71b48644-b8fe-48bb-b9bd-548648cbaa00.webp)

8、RuleBasedStopDecider

RuleBasedStopDecider 是lanefollow 场景下，所调用的第 8 个 task，属于task中的decider 类别它的作用主要是：

-   根据一些规则来设置停止标志。

  

![](..\..\images\68657a1a-57e6-4f42-8368-1d99fdd13094.jpg)

![](..\..\images\fd346892-27d8-4690-856c-ec3e6616cea3.webp)

9、SPEED\*BOUNDS\*PRIORI\_DECIDER

SPEED\*BOUNDS\*PRIORI\_DECIDER 是lanefollow 场景下，所调用的第 10 个 task，属于task中的decider 类别它的作用主要是：

（1）将规划路径上障碍物的st bounds 加载到路径对应的st 图上

（2）计算并生成路径上的限速信息

![](..\..\images\27169440-569a-4d7d-aa63-864d27e437f4.jpg)

![](..\..\images\d7291f01-fd00-458e-8f36-3bfa149f142b.webp)

SPEED\*BOUNDS\*PRIORI\*DECIDER 这个task 是 SpeedBoundsDecider 这个类的对象，使用SPEED\*BOUNDS\*PRIORI\*DECIDER 的config进行初始化，相关代码在 [http://task\*factory.cc](http://task*factory.cc) 中定义。

![](..\..\images\7c7b8a76-03af-453f-b6d8-d09c6421473f.jpg)

![](..\..\images\953f0b7f-0e37-46a4-b7cc-fa88dc328abd.webp)

10、PathTimeHeuristicOptimizer

SPEED\*HEURISTIC\*OPTIMIZER 是lanefollow 场景下，所调用的第 11个 task，属于task中的optimizer 类别，它的作用主要是：

-   apollo中使用动态规划的思路来进行速度规划，其实更类似于使用动态规划的思路进行速度决策；
-   首先将st图进行网格化，然后使用动态规划求解一条最优路径，作为后续进一步速度规划的输入，将问题的求解空间转化为凸空间

代码总流程如下：

-   1、遍历每个障碍物的boundry，判度是否有碰撞风险，如果有碰撞风险使用fallback速度规划；
-   2、初始化cost table
-   3、按照纵向采样点的s，查询各个位置处的限速
-   4、搜索可到达位置
-   5、计算可到达位置的cost
-   6、搜索最优路径

![](..\..\images\9455c1c3-4d6a-4127-90ee-a07189a6baba.jpg)

![](..\..\images\3de84a38-b979-46da-8950-18dfa6d6a07c.webp)

11、SpeedDecider

SpeedDecider 是lanefollow 场景下，Apollo Planning算法所调用的第12个 task，属于task中的decider 类别它的作用主要是：

-   1、对每个目标进行遍历，分别对每个目标进行决策
-   2、或得mutable\*obstacle->path\*st\_boundary()
-   3、根据障碍物st\_boundary的时间与位置的分布，判断是否要忽略
-   4、对于虚拟目标 Virtual obstacle，如果不在referenceline的车道上，则跳过
-   5、如果是行人则决策结果置为stop
-   6、SpeedDecider::GetSTLocation() 获取障碍物在st图上与自车路径的位置关系
-   7、根据不同的STLocation，来对障碍物进行决策
-   8、如果没有纵向决策结果，则置位ignore\_decision；

![](..\..\images\d8a8161d-8ec5-45ff-9bd1-4823f27a6a5c.jpg)

![](..\..\images\38e004c4-7d27-4781-a0bf-38a8532d3ec1.webp)

12、SPEED\*BOUNDS\*FINAL\_DECIDER

SPEED\*BOUNDS\*FINAL\_DECIDER 是lanefollow 场景下，所调用的第 13 个 task，属于task中的decider 类别它的作用主要是：

-   （1）将规划路径上障碍物的st bounds 加载到路径对应的st 图上
-   （2）计算并生成路径上的限速信息

![](..\..\images\c5bded78-23f5-4d97-8955-8aff9b56badc.jpg)

![](..\..\images\86b7a48d-9509-4a08-bd00-e5fd78307a8b.webp)

13、PiecewiseJerkSpeedOptimizer

PiecewiseJerkSpeedOptimizer 是lanefollow 场景下，所调用的第 14个 task，属于task中的decider 类别它的作用主要是：

-   1、根据之前decider决策的speed decider和 speed bound，以及纵向约束，将最优速度求解问题转化为二次型规划问题；
-   2、调用osqp库求解最优路径；