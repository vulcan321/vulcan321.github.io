## Dear Imgui Ui部分的API说明

```c++
// 开始新的一帧，可以提交任何指令直到调用 Render()/EndFrame()
IMGUI_API void NewFrame();




// 将 window 入栈并且开始调用命令修饰它，直到调用 End 让 window 出栈
// 当 bool *p_open！= NULL, 窗体右上角会有关闭选项, 点击这个选项会设置p_open为false
// 可以在同一帧调用多次 Begin()/End() 来对同一个窗体进行多次操作，前提是 name 相同
// 像 flags 或者 p_open 只在第一次调用 Begin() 起作用
// Begin() 返回 false 表示窗口已折叠或完全裁剪，因此可以提前退出并省略提交
// [重要提示: 由于遗留问题，这与大多数其他函数如 BeginMenu/EndMenu、BeginPopup/EndPopup 等不一致
// , 只有在相应的 BeginXXX函数返回 true 时才应调用 EndXXX 调用. Begin 和 BeginChild 是唯一奇数. 
// 将在未来的更新中修复]
// 请注意，窗口堆栈的底部始终包含一个名为"调试"的窗口
IMGUI_API bool Begin(const char* name, bool* p_open = NULL, ImGuiWindowFlags flags = 0);




// ImGuiWindowFlags 说明
enum ImGuiWindowFlags_
{
    ImGuiWindowFlags_None                   = 0,
    ImGuiWindowFlags_NoTitleBar             = 1 << 0,   // 禁用标题栏
    ImGuiWindowFlags_NoResize               = 1 << 1,   // 禁止用户调整通过右下角调整大小
    ImGuiWindowFlags_NoMove                 = 1 << 2,   // 禁止用户移动窗体
    ImGuiWindowFlags_NoScrollbar            = 1 << 3,   // 禁止滚动条 (window can still scroll with mouse or programmatically)
    ImGuiWindowFlags_NoScrollWithMouse      = 1 << 4,   // 禁止用户使用鼠标滚轮垂直滚动. On child window, mouse wheel will be forwarded to the parent unless NoScrollbar is also set.
    ImGuiWindowFlags_NoCollapse             = 1 << 5,   // 禁止用户通过双击折叠窗口
    ImGuiWindowFlags_AlwaysAutoResize       = 1 << 6,   // 窗体大小自适应每帧内容
    ImGuiWindowFlags_NoBackground           = 1 << 7,   // 禁止画背景和边框. Similar as using SetNextWindowBgAlpha(0.0f).
    ImGuiWindowFlags_NoSavedSettings        = 1 << 8,   // Never load/save settings in .ini file
    ImGuiWindowFlags_NoMouseInputs          = 1 << 9,   // 禁止捕捉鼠标, hovering test with pass through.
    ImGuiWindowFlags_MenuBar                = 1 << 10,  // 有一个菜单栏
    ImGuiWindowFlags_HorizontalScrollbar    = 1 << 11,  // 允许有一个水平滚动条 (默认关闭). You may use SetNextWindowContentSize(ImVec2(width,0.0f)); prior to calling Begin() to specify width. Read code in imgui_demo in the "Horizontal Scrolling" section.
    ImGuiWindowFlags_NoFocusOnAppearing     = 1 << 12,  // 从隐藏状态转换为可见状态时禁用获取焦点
    ImGuiWindowFlags_NoBringToFrontOnFocus  = 1 << 13,  // Disable bringing window to front when taking focus (e.g. clicking on it or programmatically giving it focus)
    ImGuiWindowFlags_AlwaysVerticalScrollbar= 1 << 14,  // 总是显示垂直滚动条(even if ContentSize.y < Size.y)
    ImGuiWindowFlags_AlwaysHorizontalScrollbar=1<< 15,  // 总是显示水平滚动条 (even if ContentSize.x < Size.x)
    ImGuiWindowFlags_AlwaysUseWindowPadding = 1 << 16,  // 使用style.Window Padding 确保子窗体没有边框 (ignored by default for non-bordered child windows, because more convenient)
    ImGuiWindowFlags_NoNavInputs            = 1 << 18,  // 窗口内没有游戏手柄/键盘导航
    ImGuiWindowFlags_NoNavFocus             = 1 << 19,  // No focusing toward this window with gamepad/keyboard navigation (e.g. skipped by CTRL+TAB)
    ImGuiWindowFlags_UnsavedDocument        = 1 << 20,  // Display a dot next to the title. When used in a tab/docking context, tab is selected when clicking the X + closure is not assumed (will wait for user to stop submitting the tab). Otherwise closure is assumed when pressing the X, so if you keep submitting the tab may reappear at end of tab bar.
    ImGuiWindowFlags_NoNav                  = ImGuiWindowFlags_NoNavInputs | ImGuiWindowFlags_NoNavFocus,
    ImGuiWindowFlags_NoDecoration           = ImGuiWindowFlags_NoTitleBar | ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoScrollbar | ImGuiWindowFlags_NoCollapse,
    ImGuiWindowFlags_NoInputs               = ImGuiWindowFlags_NoMouseInputs | ImGuiWindowFlags_NoNavInputs | ImGuiWindowFlags_NoNavFocus,

    // [Internal]
    ImGuiWindowFlags_NavFlattened           = 1 << 23,  // [BETA] Allow gamepad/keyboard navigation to cross over parent border to this child (only use on child that have no scrolling!)
    ImGuiWindowFlags_ChildWindow            = 1 << 24,  // Don't use! For internal use by BeginChild()
    ImGuiWindowFlags_Tooltip                = 1 << 25,  // Don't use! For internal use by BeginTooltip()
    ImGuiWindowFlags_Popup                  = 1 << 26,  // Don't use! For internal use by BeginPopup()
    ImGuiWindowFlags_Modal                  = 1 << 27,  // Don't use! For internal use by BeginPopupModal()
    ImGuiWindowFlags_ChildMenu              = 1 << 28   // Don't use! For internal use by BeginMenu()

    // [Obsolete]
    //ImGuiWindowFlags_ResizeFromAnySide    = 1 << 17,  // --> Set io.ConfigWindowsResizeFromEdges=true and make sure mouse cursors are supported by backend (io.BackendFlags & ImGuiBackendFlags_HasMouseCursors)
};



// 弹出框: 打开 / 关闭 功能
// - OpenPopup(): 设置弹出框为打开, ImGuiPopupFlags 可用于打开选项
// - If not modal: 通过点击其他地方关闭弹出框 或者 点击 ESCAPE
// - CloseCurrentPopup(): 在 BeginPopup 到 EndPopup 命令执行中，调用 CloseCurrentPopup 可以手动关闭, 当 Selectable()/MenuItem() 激活时, CloseCurrentPopup()默认被调用 
// - Use ImGuiPopupFlags_NoOpenOverExistingPopup to avoid opening a popup if there's already one at the same level. This is equivalent to e.g. testing for !IsAnyPopupOpen() prior to OpenPopup().
// - 在BeginPopup() 之后使用 IsWindowAppearing() 判断窗口是否刚刚打开
IMGUI_API void OpenPopup(const char* str_id, ImGuiPopupFlags popup_flags = 0);	// call to mark popup as open (don't call every frame!).


// 弹出层, 模态
// - 会阻塞 调用 后面的鼠标悬停检测(以及大多数鼠标交互)
// - if not modal: 通过点击其他地方关闭弹出框 或者 点击 ESCAPE
// - 可见性状态 (~bool) 是在内部保存的, 并不是被调用者保存
// - 上面的三个属性是相关的: 我们需要在库中保留弹出窗口可见性状态，因为弹出窗口可能随时关闭
// - 可以调用 IsItemHovered() or IsWindowHovered() 时使用 ImGuiHoveredFlags_AllowWhenBlockedByPopup 来绕过悬停限制
// - 重要提示: Popup 标识符时相对于当前 ID 堆栈的, 因此 OpenPopup 和 BeginPopup 一般需要在堆栈的同一级别

// Popups: begin/end functions
// -BeginPopup(): 查询弹出状态, 如果打开就附加到 window. 之后调用 EndPopup(). ImGuiWindowFlags 被转发到window
// -BeginPopupModal():  block every interactions behind the window, cannot be closed by user, add a dimming background, has a title bar.
IMGUI_API bool BeginPopup(const char* str_id, ImGuiWindowFlags flags = 0);	// return true if the popup is open, and you can start outputting to it.



```

