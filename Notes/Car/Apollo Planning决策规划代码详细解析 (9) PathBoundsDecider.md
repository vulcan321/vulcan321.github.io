**正文如下：**

一、概述

PathBoundsDecider 是lanefollow 场景下，所调用的第 4 个 task，它的作用主要是：

-   根据借道信息、道路宽度生成FallbackPathBound
-   根据借道信息、道路宽度生成、障碍物边界生成PullOverPathBound、LaneChangePathBound、RegularPathBound中的一种

二、PathBoundsDecider的具体逻辑如下：

1、PublicRoadPlanner 的 LaneFollowStage 配置了以下几个task 来实现具体的规划逻辑，PathBoundsDecider 是第四个task，PathBoundsDecider根据lane borrow决策器的输出、本车道以及相邻车道的宽度、障碍物的左右边界，来计算path 的boundary，从而将path 搜索的边界缩小，将复杂问题转化为凸空间的搜索问题，方便后续使用QP算法求解；

PathBoundsDecider生成的每个bound，后续都会生成对应的轨迹

```protobuf
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

PathBoundsDecider被调用流程与其他task类似：

![](..\..\images\e96ee73a-7f00-451a-95df-a442a6689b46.jpg)

![](..\..\images\094d9693-9541-4a14-821f-09a88c3487b9.webp)

2、PathBoundsDecider计算path上可行使区域边界，其输出是对纵向s等间距采样，横向s对应的左右边界，以此来作为下一步路径搜索的边界约束；与其他task一样，PathBoundsDecider的主要逻辑在Process() 方法中。

在Process() 方法中分四种情况对pathBound进行计算，按照处理顺序分别是fallback、pullover、lanechange、regular，不同的boundary对应不同的应用场景，其中fallback对应的path bound一定会生成，其余3个只有一个被激活，即按照顺序一旦有有效的boundary生成，就结束该task。

Process() 方法的代码及详细备注如下，首先看下整体代码，下文会对其中的模块做详细介绍：

```cpp
Status PathBoundsDecider::Process(
    Frame* const frame, ReferenceLineInfo* const reference*line*info) {
  // Sanity checks.
  CHECK_NOTNULL(frame);
  CHECK*NOTNULL(reference*line_info);
 
  // 如果道路重用置位，则跳过PathBoundsDecider
  // Skip the path boundary decision if reusing the path.
  if (FLAGS*enable*skip*path*tasks && reference*line*info->path_reusable()) {
    return Status::OK();
  }
 
  std::vector<PathBoundary> candidate*path*boundaries;
  // const TaskConfig& config = Decider::config_;
 
  // Initialization.
  // 用规划起始点自车道的lane width去初始化 path boundary
  // 如果无法获取规划起始点的道路宽度，则用默认值目前是5m，来初始化
  InitPathBoundsDecider(*frame, *reference*line*info);
 
  // Generate the fallback path boundary.
  // 生成fallback*path*bound，无论何种场景都会生成fallback*path*bound
  // 生成fallback*path*bound时，会考虑借道场景，向哪个方向借道，对应方向的path_bound会叠加这个方向相邻车道宽度
  PathBound fallback*path*bound;
  Status ret =
      // 生成fallback*path*bound，
      // 首先计算当前位置到本车道两侧车道线的距离；
      // 然后判断是否借道，并根据借道方向叠加相邻车道的车道宽度
      // 带有adc的变量表示与自车相关的信息
      GenerateFallbackPathBound(*reference*line*info, &fallback*path*bound);
  if (!ret.ok()) {
    ADEBUG << "Cannot generate a fallback path bound.";
    return Status(ErrorCode::PLANNING*ERROR, ret.error*message());
  }
  if (fallback*path*bound.empty()) {
    const std::string msg = "Failed to get a valid fallback path boundary";
    AERROR << msg;
    return Status(ErrorCode::PLANNING_ERROR, msg);
  }
  if (!fallback*path*bound.empty()) {
    CHECK*LE(adc*frenet*l*, std::get<2>(fallback*path*bound[0]));
    CHECK*GE(adc*frenet*l*, std::get<1>(fallback*path*bound[0]));
  }
  // Update the fallback path boundary into the reference*line*info.
  // 将fallback*path*bound存入到candidate*path*boundaries
  std::vector<std::pair<double, double>> fallback*path*bound_pair;
  for (size*t i = 0; i < fallback*path_bound.size(); ++i) {
    fallback*path*bound*pair.emplace*back(std::get<1>(fallback*path*bound[i]),
                                          std::get<2>(fallback*path*bound[i]));
  }
  candidate*path*boundaries.emplace*back(std::get<0>(fallback*path_bound[0]),
                                         kPathBoundsDeciderResolution,
                                         fallback*path*bound_pair);
  candidate*path*boundaries.back().set_label("fallback");
 
  // 根据场景生成另外一条path_bound
  // 依次判断是否处于pull*over、lane*change、regular；当处于其中一个场景，计算对应的path_bound并返回结果；
  // 即以上3种场景，只会选一种生成对应的根据场景生成另外一条path_bound
 
  // 判断是否为pull*over*status
  // If pull-over is requested, generate pull-over path boundary.
  auto* pull*over*status = injector*->planning*context()
                               ->mutable*planning*status()
                               ->mutable*pull*over();
  const bool plan*pull*over*path = pull*over*status->plan*pull*over*path();
  if (plan*pull*over_path) {
    PathBound pull*over*path_bound;
    Status ret = GeneratePullOverPathBound(*frame, *reference*line*info,
                                           &pull*over*path_bound);
    if (!ret.ok()) {
      AWARN << "Cannot generate a pullover path bound, do regular planning.";
    } else {
      ACHECK(!pull*over*path_bound.empty());
      CHECK*LE(adc*frenet*l*, std::get<2>(pull*over*path_bound[0]));
      CHECK*GE(adc*frenet*l*, std::get<1>(pull*over*path_bound[0]));
 
      // Update the fallback path boundary into the reference*line*info.
      std::vector<std::pair<double, double>> pull*over*path*bound*pair;
      for (size*t i = 0; i < pull*over*path*bound.size(); ++i) {
        pull*over*path*bound*pair.emplace_back(
            std::get<1>(pull*over*path_bound[i]),
            std::get<2>(pull*over*path_bound[i]));
      }
      candidate*path*boundaries.emplace_back(
          std::get<0>(pull*over*path_bound[0]), kPathBoundsDeciderResolution,
          pull*over*path*bound*pair);
      candidate*path*boundaries.back().set_label("regular/pullover");
 
      reference*line*info->SetCandidatePathBoundaries(
          std::move(candidate*path*boundaries));
      ADEBUG << "Completed pullover and fallback path boundaries generation.";
 
      // set debug info in planning_data
      auto* pull*over*debug = reference*line*info->mutable_debug()
                                  ->mutable*planning*data()
                                  ->mutable*pull*over();
      pull*over*debug->mutable_position()->CopyFrom(
          pull*over*status->position());
      pull*over*debug->set*theta(pull*over_status->theta());
      pull*over*debug->set*length*front(pull*over*status->length_front());
      pull*over*debug->set*length*back(pull*over*status->length_back());
      pull*over*debug->set*width*left(pull*over*status->width_left());
      pull*over*debug->set*width*right(pull*over*status->width_right());
 
      return Status::OK();
    }
  }
 
  // 判断是否满足lane_change场景
  // 首先FLAGS*enable*smarter*lane*change 要置位
  // 通过判断当前reference_line 是否为目标车道，来进行判断
  // If it's a lane-change reference-line, generate lane-change path boundary.
  if (FLAGS*enable*smarter*lane*change &&
      reference*line*info->IsChangeLanePath()) {
    PathBound lanechange*path*bound;
    // 当前reference*line 如果是目标path，则计算lanechange*path_bound
    // 首先根据借道与否，用道路宽度来生成基本的path bound
    // 然后遍历path上的每个点，并且判断这个点上的障碍物，利用障碍物的边界来修正path bound
    // 如果目标在左边将left_bound 设置为目标右边界
    // 如果目标在右边，将right_bound设置为目标的左边界
    Status ret = GenerateLaneChangePathBound(*reference*line*info,
                                             &lanechange*path*bound);
    if (!ret.ok()) {
      ADEBUG << "Cannot generate a lane-change path bound.";
      return Status(ErrorCode::PLANNING*ERROR, ret.error*message());
    }
    if (lanechange*path*bound.empty()) {
      const std::string msg = "Failed to get a valid fallback path boundary";
      AERROR << msg;
      return Status(ErrorCode::PLANNING_ERROR, msg);
    }
 
    // disable this change when not extending lane bounds to include adc
    if (config*.path*bounds*decider*config()
            .is*extend*lane*bounds*to*include*adc()) {
      CHECK*LE(adc*frenet*l*, std::get<2>(lanechange*path*bound[0]));
      CHECK*GE(adc*frenet*l*, std::get<1>(lanechange*path*bound[0]));
    }
    // Update the fallback path boundary into the reference*line*info.
    std::vector<std::pair<double, double>> lanechange*path*bound_pair;
    for (size*t i = 0; i < lanechange*path_bound.size(); ++i) {
      lanechange*path*bound*pair.emplace*back(
          std::get<1>(lanechange*path*bound[i]),
          std::get<2>(lanechange*path*bound[i]));
    }
    candidate*path*boundaries.emplace_back(
        std::get<0>(lanechange*path*bound[0]), kPathBoundsDeciderResolution,
        lanechange*path*bound_pair);
    candidate*path*boundaries.back().set_label("regular/lanechange");
    RecordDebugInfo(lanechange*path*bound, "", reference*line*info);
    reference*line*info->SetCandidatePathBoundaries(
        std::move(candidate*path*boundaries));
    ADEBUG << "Completed lanechange and fallback path boundaries generation.";
    return Status::OK();
  }
 
  // Generate regular path boundaries.
  // 生成regular path boundaries
  std::vector<LaneBorrowInfo> lane*borrow*info_list;
  lane*borrow*info*list.push*back(LaneBorrowInfo::NO_BORROW);
 
  // 判断是否进行借道，以及借道的方向
  if (reference*line*info->is*path*lane_borrow()) {
    const auto& path*decider*status =
        injector*->planning*context()->planning*status().path*decider();
    for (const auto& lane*borrow*direction :
         path*decider*status.decided*side*pass_direction()) {
      if (lane*borrow*direction == PathDeciderStatus::LEFT_BORROW) {
        lane*borrow*info*list.push*back(LaneBorrowInfo::LEFT_BORROW);
      } else if (lane*borrow*direction == PathDeciderStatus::RIGHT_BORROW) {
        lane*borrow*info*list.push*back(LaneBorrowInfo::RIGHT_BORROW);
      }
    }
  }
 
  // Try every possible lane-borrow option:
  // PathBound regular*self*path_bound;
  // bool exist*self*path_bound = false;
  for (const auto& lane*borrow*info : lane*borrow*info_list) {
    PathBound regular*path*bound;
    std::string blocking*obstacle*id = "";
    std::string borrow*lane*type = "";
    // 根据借道信息，以及path上障碍物来生成path bound
    // 首先根据借道与否，用道路宽度来生成基本的path bound
    // 然后遍历path上的每个点，并且判断这个点上的障碍物，利用障碍物的边界来修正path bound
    // 如果目标在左边将left_bound 设置为目标右边界
    // 如果目标在右边，将right_bound设置为目标的左边界
    Status ret = GenerateRegularPathBound(
        *reference*line*info, lane*borrow*info, &regular*path*bound,
        &blocking*obstacle*id, &borrow*lane*type);
    if (!ret.ok()) {
      continue;
    }
    if (regular*path*bound.empty()) {
      continue;
    }
    // disable this change when not extending lane bounds to include adc
    if (config*.path*bounds*decider*config()
            .is*extend*lane*bounds*to*include*adc()) {
      CHECK*LE(adc*frenet*l*, std::get<2>(regular*path*bound[0]));
      CHECK*GE(adc*frenet*l*, std::get<1>(regular*path*bound[0]));
    }
 
    // Update the path boundary into the reference*line*info.
    std::vector<std::pair<double, double>> regular*path*bound_pair;
    for (size*t i = 0; i < regular*path_bound.size(); ++i) {
      regular*path*bound*pair.emplace*back(std::get<1>(regular*path*bound[i]),
                                           std::get<2>(regular*path*bound[i]));
    }
    candidate*path*boundaries.emplace*back(std::get<0>(regular*path_bound[0]),
                                           kPathBoundsDeciderResolution,
                                           regular*path*bound_pair);
    std::string path_label = "";
    switch (lane*borrow*info) {
      case LaneBorrowInfo::LEFT_BORROW:
        path_label = "left";
        break;
      case LaneBorrowInfo::RIGHT_BORROW:
        path_label = "right";
        break;
      default:
        path_label = "self";
        // exist*self*path_bound = true;
        // regular*self*path*bound = regular*path_bound;
        break;
    }
    // RecordDebugInfo(regular*path*bound, "", reference*line*info);
    candidate*path*boundaries.back().set_label(
        absl::StrCat("regular/", path*label, "/", borrow*lane_type));
    candidate*path*boundaries.back().set*blocking*obstacle_id(
        blocking*obstacle*id);
  }
 
  // Remove redundant boundaries.
  // RemoveRedundantPathBoundaries(&candidate*path*boundaries);
 
  // Success
  reference*line*info->SetCandidatePathBoundaries(
      std::move(candidate*path*boundaries));
  ADEBUG << "Completed regular and fallback path boundaries generation.";
  return Status::OK();
}
```

3、关于ADC\*bound 与lane\*bound的计算

![](..\..\images\d3721676-f15f-4fba-9ca1-23e0ab14cd4d.jpg)

![](..\..\images\d5fd98bf-5e11-4b82-9eb2-57ee6bbb94c9.webp)

（1）根据车道生成左右的lane\*bound，从地图中获得；根据自车状态生成adc\*bound，

adc\*bound = adc\*l\*to\*lane\*center\* + ADC\*speed\*buffer + adc\*half\*width + ADC\_buffer

上式中的各项：

adc\*l\*to\*lane\*center\_ - 自车

adc\*half\*width - 车宽

adc\_buffer - 0.5

ADCSpeedBuffer表示横向的瞬时位移， 公式如下：

![](..\..\images\49ec8883-bfcf-44b0-b519-cf4ab76f9822.jpg)

![](..\..\images\8e0fc927-ee83-46a9-b338-641456d9389b.webp)

其中kMaxLatAcc = 1.5

（2）根据ADC\*bound 与lane\*bound 生成基本的bound

左侧当前s对应的bound取MAX(left\*lane\*bound,left\*adc\*bound), 即取最左边的

右侧当前s对应的bound取MIN(right\*lane\*bound,right\*adc\*bound)，即取最右边的

4、InitPathBoundsDecider()

在Process()过程中，首先会初始化bounds，用规划起始点自车道的lane width去初始化 path boundary，如果无法获取规划起始点的道路宽度，则用默认值目前是5m，来初始化。

path\_bounds由一系列采样点组成，数据结构如下，这组数据里共有0～199个200个采样点，每两个点的间隔是0.5m；每个点由3个变量组成，分别是根据参考线建立的s-l坐标系的s坐标，右边界的l取值，左边界的s取值：

![](..\..\images\515f5729-6958-4e43-a7e6-5923cfa2d6a8.jpg)

![](..\..\images\210aed2b-4324-4a4c-8521-f7c501625e6e.webp)

  

5、GenerateFallbackPathBound()

无论当前处于何种场景，都会调用GenerateFallbackPathBound() 来生成备用的path bound，在计算FallbackPathBound时不考虑障碍物边界，仅使用道路边界，并考虑借道信息来进行计算。

```cpp
// Generate the fallback path boundary.
  // 生成fallback*path*bound，无论何种场景都会生成fallback*path*bound
  // 生成fallback*path*bound时，会考虑借道场景，向哪个方向借道，对应方向的path_bound会叠加这个方向相邻车道宽度
  PathBound fallback*path*bound;
  Status ret =
      // 生成fallback*path*bound，
      // 首先计算当前位置到本车道两侧车道线的距离；
      // 然后判断是否借道，并根据借道方向叠加相邻车道的车道宽度
      // 带有adc的变量表示与自车相关的信息
      GenerateFallbackPathBound(*reference*line*info, &fallback*path*bound);
  if (!ret.ok()) {
    ADEBUG << "Cannot generate a fallback path bound.";
    return Status(ErrorCode::PLANNING*ERROR, ret.error*message());
  }
  if (fallback*path*bound.empty()) {
    const std::string msg = "Failed to get a valid fallback path boundary";
    AERROR << msg;
    return Status(ErrorCode::PLANNING_ERROR, msg);
  }
  if (!fallback*path*bound.empty()) {
    CHECK*LE(adc*frenet*l*, std::get<2>(fallback*path*bound[0]));
    CHECK*GE(adc*frenet*l*, std::get<1>(fallback*path*bound[0]));
  }
  // Update the fallback path boundary into the reference*line*info.
  // 将fallback*path*bound存入到candidate*path*boundaries
  std::vector<std::pair<double, double>> fallback*path*bound_pair;
  for (size*t i = 0; i < fallback*path_bound.size(); ++i) {
    fallback*path*bound*pair.emplace*back(std::get<1>(fallback*path*bound[i]),
                                          std::get<2>(fallback*path*bound[i]));
  }
  candidate*path*boundaries.emplace*back(std::get<0>(fallback*path_bound[0]),
                                         kPathBoundsDeciderResolution,
                                         fallback*path*bound_pair);
  candidate*path*boundaries.back().set_label("fallback");
```

6、障碍物边界生成

考虑如下场景：

![](..\..\images\750dab78-4904-4d05-a6fa-c482a3eb25af.jpg)

![](..\..\images\4bd1e63c-e067-4c11-898e-4b7512bda64d.webp)

（1）首先筛选障碍物，障碍物筛选规则如下，需要符合以下所有的条件，才加到obs\_list中：

-   不是虚拟障碍物
-   不是可忽略的障碍物（其他decider中添加的ignore decision）
-   静态障碍物或速度小于FLAGS\*static\*obstacle\*speed\*threshold（0.5m/s）
-   在自车的前方

（2）将每个障碍物分解成两个ObstacleEdge，起点一个终点一个，记录下s，start\*l,end\*l,最后按s排序

![](..\..\images\011e6092-7c4b-46c0-b9b2-7c3528bef5f4.jpg)

![](..\..\images\00cbe63b-0750-493d-a2c2-96c357bd7600.webp)

对于上图场景中id为2的obstacle，sort后得到的内部数据结构为：

![](..\..\images\aecc7f6a-01ba-4cb7-b91a-02330c3aaf8c.jpg)

![](..\..\images\c66c0617-9daa-45d6-8dfc-7b6b8e281b43.webp)

7、根据场景生成另外一条path\_bound

依次判断是否处于pull\*over、lane\*change、regular；当处于其中一个场景，计算对应的path\*bound并返回结果；即以上3种场景，只会选一种生成对应的根据场景生成另外一条path\*bound。

这3种path bound均考虑了障碍物的边界，用障碍物的边界来修正path bound：

-   首先根据借道与否，用道路宽度来生成基本的path bound
-   然后遍历path上的每个点，并且判断这个点上的障碍物，利用障碍物的边界来修正path bound
-   如果目标在左边将left\_bound 设置为目标右边界
-   如果目标在右边，将right\_bound设置为目标的左边界

下面以GenerateLaneChangePathBound 进行说明：

```cpp
Status PathBoundsDecider::GenerateLaneChangePathBound(
    const ReferenceLineInfo& reference*line*info,
    std::vector<std::tuple<double, double, double>>* const path_bound) {
  // 1. Initialize the path boundaries to be an indefinitely large area.
  // 1、用numeric 的最大最小值初始化path bound
  if (!InitPathBoundary(reference*line*info, path_bound)) {
    const std::string msg = "Failed to initialize path boundaries.";
    AERROR << msg;
    return Status(ErrorCode::PLANNING_ERROR, msg);
  }
  // PathBoundsDebugString(*path_bound);
 
  // 2、用当前车道宽度计算path bound，同时考虑lane borrow，如果借道将目标车道的宽度叠加
  // 2. Decide a rough boundary based on lane info and ADC's position
  std::string dummy*borrow*lane_type;
  if (!GetBoundaryFromLanesAndADC(reference*line*info,
                                  LaneBorrowInfo::NO*BORROW, 0.1, path*bound,
                                  &dummy*borrow*lane_type, true)) {
    const std::string msg =
        "Failed to decide a rough boundary based on "
        "road information.";
    AERROR << msg;
    return Status(ErrorCode::PLANNING_ERROR, msg);
  }
  // PathBoundsDebugString(*path_bound);
 
  // 3、在换道结束前，用ADC坐标到目标道路边界的距离，修正path bound
  // 3. Remove the S-length of target lane out of the path-bound.
  GetBoundaryFromLaneChangeForbiddenZone(reference*line*info, path_bound);
 
  PathBound temp*path*bound = *path_bound;
  std::string blocking*obstacle*id;
  // 根据path上的障碍物修正path_bound，遍历path上每个点，并在每个点上遍历障碍物；
  // 如果目标在左边将left_bound 设置为目标右边界
  // 如果目标在右边，将right_bound设置为目标的左边界
  if (!GetBoundaryFromStaticObstacles(reference*line*info.path_decision(),
                                      path*bound, &blocking*obstacle_id)) {
    const std::string msg =
        "Failed to decide fine tune the boundaries after "
        "taking into consideration all static obstacles.";
    AERROR << msg;
    return Status(ErrorCode::PLANNING_ERROR, msg);
  }
  // Append some extra path bound points to avoid zero-length path data.
  int counter = 0;
  while (!blocking*obstacle*id.empty() &&
         path*bound->size() < temp*path_bound.size() &&
         counter < kNumExtraTailBoundPoint) {
    path*bound->push*back(temp*path*bound[path_bound->size()]);
    counter++;
  }
 
  ADEBUG << "Completed generating path boundaries.";
  return Status::OK();
}
```

————————————————