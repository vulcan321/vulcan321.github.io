## OpenGL Sharders（着色器）

### GPU显示数据流程

![image-01](https://raw.githubusercontent.com/mingxingren/Notes/master/resource/photo/image-2021123001.png)

### 顶点着色器的坐标系统

顶点着色器的坐标很有意思,  它使用 -1 和 1表示坐标系轴方向上的负边界和正边界.  仔细想想确实应该如此，假使我们想渲染的一块区域的大小是 10x10大小的矩形，那么边界就是 -5 ~ 5，当区域是20x20时，边界便改为 -10~10. 我猜如果以确定边界绘制左边代码便不具有普适性，这个矩形尺寸调整一下，那个矩形尺寸调整一下. 所以统一用 -1 和 1表示边界值, 中间值乘以系数表示其他坐标点，这样就不用受到渲染矩形区域大小的影响.

![image-01](https://github.com/mingxingren/Notes/raw/master/resource/photo/image-2021120501.png)

着色器（**Shader**）是运行在GPU上的小程序，这些小程序为图形渲染管线的某个特定部分而运行。使用一种叫 **GLSL** 的类C语言写成，一个典型的着色器有下面的结构

```glsl
#version version_number
in type in_variable_name;
in type in_variable_name;

out type out_variable_name;

uniform type uniform_name;

int main()
{
  // 处理输入并进行一些图形操作
  ...
  // 输出处理过的结果到输出变量
  out_variable_name = weird_stuff_we_processed;
}
```

### 着色器数据输入

CPU数据通过OpenGL缓冲区发送到GPU

![image-02](https://github.com/mingxingren/Notes/raw/master/resource/photo/image-2021123002.png)

#### [glsl支持的数据类型](https://github.com/qyvlik/GLSL.qml/blob/master/glsl/GLSL%E5%8F%98%E9%87%8F%E5%92%8C%E6%95%B0%E6%8D%AE%E7%B1%BB%E5%9E%8B.md)

## 双缓冲

应用程序使用单缓冲绘图时可能会存在图像闪烁的问题。 这是因为生成的图像不是一下子被绘制出来的，而是按照从左到右，由上而下逐像素地绘制而成的。最终图像不是在瞬间显示给用户，而是通过一步一步生成的，这会导致渲染的结果很不真实。为了规避这些问题，我们应用双缓冲渲染窗口应用程序。**前**缓冲保存着最终输出的图像，它会在屏幕上显示；而所有的的渲染指令都会在**后**缓冲上绘制。当所有的渲染指令执行完毕后，我们**交换**(Swap)前缓冲和后缓冲，这样图像就立即呈显出来，之前提到的不真实感就消除了。

## OpenGL 调用流程

1. 着色器创建流程

```flow
start=>start: Start
op_1=>operation: glCreateShader 创建着器句柄
op_2=>operation: glShaderSource 加载着色器脚本
op_3=>operation: glCompileShader 编译着色器脚本
op_4=>operation: glGetShaderiv 判断着色器编译结果是否成功
op_5=>operation: glGetShaderInfoLog 获取着色器信息日志
cond=>condition: 是否成功
end=>end
start->op_1->op_2->op_3->op_4->cond
cond(yes)->end
cond(no)->op_5->end
```

2. 创建 OpenGL 工程对象

```flow
st=>start: Start
op_1=>operation: glCreateProgram 创建工程对象
op_2=>operation: glAttachShader 加载顶点着色器,片段着色器
op_3=>operation: glLinkProgram 构建工程
op_4=>operation: glGetProgramiv 获取工程构建状态
op_5=>operation: glDeleteShader 删除着色器
op_6=>operation: glGetProgramInfoLog 获取工程日志
cond=>condition: 是否成功
e=>end
st->op_1->op_2->op_3->op_4->cond
cond(yes)->op_5->e
cond(no)->op_6->e
```

3. 申请顶点队列对象(VAO)、顶点缓冲对象(VBO)、索引缓冲对象(EBO), 细节参考: (https://blog.csdn.net/xiji333/article/details/114934590)
   
   ```flow
   st=>start: Start
   op_1=>operation: glGenVertexArrays 申请顶点队列对象(VAO)
   op_2=>operation: glGetBuffer 创建VBO(顶点缓冲对象) EBO(索引缓冲对象)等缓冲对象
   op_3=>operation: glBindVertexArray 将当前执行对象绑定到VAO
   op_4=>operation: glBindData 将VBO绑定到VAO上,并将当前操作对象指向VBO
   op_5=>operation: glBufferData 对VBO EBO填入数据
   op_6=>operation: glVertexAttribPointer 将location id 绑定到当前的 VBO 缓存
   op_7=>operation: glDrawElements 根据 EBO 画出图形
   e=>end: End
   st->op_1->op_2->op_3->op_4->op_5->op_6->op_7->e
   ```
   
   ​    注：顶点缓冲区使用步骤：
   
   ​    
   
   ```flow
   st=>start: Start
   op_1=>operation: 获取缓冲区标识: glGenBuffers(GLsizei n, GLuint* buffers);
   op_2=>operation: 绑定缓冲区对象: glBindBuffer(GLenum target, GLuint buffer);
   op_3=>operation: 用数据填充缓冲区: glBufferData(GLenum target, GLsizeiptr size, const void* data, GLenum usage)
   op_4=>operation: 更新缓冲数据: glBufferSubData(GLenum target, GLintptr offset, GLsizeiptr size, const void*  data);
   op_5=>operation: 清楚缓冲区对象 glDeleteBuffers(GLsizei n, const GLuint* buffers);
   e=>end: End
   st->op_1->op_2->op_3->op_4->op_5->e
   ```

4. 使用 texture(纹理) 流程
   
   ```flow
   st=>start: Start
   op_1=>operation: glGenTextures 申请 texture 对象
   op_2=>operation: glBindTexture 绑定当前需要操作的 texture
   op_3=>operation: glTexParameteri 设置 texture 属性?
   op_4=>operation: glTexImage2D 对 texture 填入数据
   op_5=>operation: glGenerateMipmap 生成 mipmap https://zh.wikipedia.org/wiki/Mipmap
   op_6=>operation: glUniform1i 特殊用法: 将 片段着色器中 texture变量 指定为对应的纹理单元
   op_7=>operation: glActiveTexture 激活纹理单元例如:GL_TEXTURE0, 并设置成当前操作的纹理单元
   op_8=>operation: glBindTexture 将我们申请的texture对象绑定到当前的纹理单元中
   e=>end: End
   st->op_1->op_2->op_3->op_4->op_5->op_6->op_7->op_8->e
   ```

片段着色器中的变量和我们程序申请的texture资源是通过纹理单元进行传值的. 其关系大致为：

```sequence
fs texture变量->texture unit: 绑定对应的纹理单元
程序 texture对象资源->texture unit: 程序申请的texture资源输入到纹理单元
texture unit->fs texture变量: 映射
```

注: OpenGL CPU像素数据向GPU纹理传输细节 —— [glPixelStorei](https://www.cnblogs.com/dongguolei/p/11982230.html)

注:  glActiveTexture 激活纹理单元后，调用 glBindTexture 会将 纹理绑定到纹理单元，此时如果再调用 glBindTexture 去操作其他纹理，那当前活跃的纹理单元就绑定为其他的纹理。故在要使用纹理的时候，一定要先 glActiveTexture 然后再 glBindTexture 。

## opengl 参考资料

1. https://antongerdelan.net/opengl/index.html#onlinetuts1.
2. GLSL各版本区别：https://blog.51cto.com/u_11207102/3275866

## 片段着色器变量

```中文
gl_FragCoord: 记录顶点在窗体的实际坐标, x和y分量是片段的窗口空间(Window-space)坐标, 原点为窗口左下角

gl_FrontFacing: 当不启用面剔除 (GL_FACE_CULL), gl_FrontFacing 将会告诉我们当前片段是属于正向面的一部分还是背向面的一部分

gl_FragDepth: 可以设置的当前片段的深度值, 如果着色器没有写入值到gl_FragDepth，它会自动取用gl_FragCoord.z的值
```

## 接口块

接口块的声明和 `struct` 的声明有点想象，不同的是，现在 根据它是一个输入还是输出块(Block), 使用 `in` 和 `out` 关键字来定义

```glsl
// vertex shader
#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec2 aTexCoords;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

out VS_OUT
{
    vec2 TexCoords;
} vs_out;

void main()
{
    gl_Position = projection * view * model * vec4(aPos, 1.0);    
    vs_out.TexCoords = aTexCoords;
}  


// Pixel shader
#version 330 core
out vec4 FragColor;

in VS_OUT
{
    vec2 TexCoords;
} fs_in;

uniform sampler2D texture;

void main()
{             
    FragColor = texture(texture, fs_in.TexCoords);   
}
```

## uniform 缓冲对象

```glsl
#version 330 core
layout (location = 0) in vec3 aPos;

layout (std140) uniform Matrices
{
    mat4 projection;
    mat4 view;
};

uniform mat4 model;

void main()
{
    gl_Position = projection * view * model * vec4(aPos, 1.0);
}
```

uniform buffer object 比 独立的uniform的好处:

① 一次设置很多 uniform会比一个一个设置要快很多

② 可以同时修改多个 shader程序中的 uniform 变量

③ 如果使用Uniform缓冲对象的话，你可以在着色器中使用更多的uniform。OpenGL限制了它能够处理的uniform数量，这可以通过GL_MAX_VERTEX_UNIFORM_COMPONENTS来查询

## 几何着色器

几何着色器的输入是一个的图元(如点或者三角形)的一组顶点, 可以在顶点发送到下一个着色器阶段之前对他们随意变换.

## 实例化

在需要渲染大量物体时, 非常消耗性能. 与绘制顶点本身相比，使用 `glDrawArrays`和 `glDrawElements` 函数告诉GPU去绘制你的顶点数据会消耗更多的性能, 因为 OpenGL 绘制顶点数据前需要做很多工作(比如告诉GPU该从哪个缓冲读取数据, 从哪寻找顶点数据属性,  而且这些都是在相对缓慢的CPU到GPU总线上进行的). 

而实例化能够降数据一次性发给GPU, 然后使用一个绘制函数让OpenGL利用这些数据绘制多个物体.

```c
/**
* glDrawArraysInstanced 绘画多个一组顶点的实例
* @param mode 指出要画的基本形状
* @param first 顶点数据起点
* @param count 基本形状需要使用的顶点数据
* @param instancecount 要绘画的实例数量
*/
void glDrawArraysInstanced(GLenum mode, GLint first, GLsizei count, GLsizei instancecount);

/**
* glDrawElementsInstanced 绘画多个元素集合形式的实例
* @param mode 指出要画的基本形状
* @param count 表示一个实例需要的元素数量
* @param type 元素类型
* @param indices 元素起始位置
* @param instancecount 实例数量
*/
void glDrawElementsInstanced(GLenum mode, GLsizei count, GLenum type, const void * indices, GLsizei instancecount);
```

## 实例化数组

定义为一个顶点属性(能够让我们存储更多的数据), 仅在顶点着色器渲染一个新的实例时才会更新

```c
/**
* glVertexAttribDivisor 修改实例化渲染时通用顶点数据更新速度
* @param index 输入顶点的index
* @param divisor 除数, 描述每渲染几个实例顶点数据更新成下一个, 为 0 时表示每一个顶点都会更新数据而不是每个实例
*/
void glVertexAttribDivisor(GLuint index,GLuint divisor);
```

## 抗锯齿

### 多重采样

注: 多重采样在 OpenGL 中默认开启

### 自定义抗锯齿算法

将一个多重采样的纹理图像不进行还原直接传入着色器. `GLSL` 能对纹理图像的每个子样本进行采样 , 所以我们可以创建我们自己的抗锯齿算法. 在大型的图形应用中通常都会这么做.

```glsl
uniform sampler2DMS screenTextureMS;
...
vec4 colorSample = texelFetch(screenTextureMS, TexCoords, 3);  // 第4个子样本
```

## 向量算法

减法： 向量 AB 方向为 A点指向B点，向量 AB = 点A - 点B

## LookAt 矩阵

使用 3 个相互垂直 (或非线性) 的轴定义了一个坐标空间. 你可以用这个三个轴外加一个平移向量来创建一个矩阵, 并且你可以用这个矩阵乘以任何向量来将其变换到那个坐标系.

## 裁剪空间

在一个顶点着色器运行的最后, `OpenGL`期望所有的坐标都能落在一个特定的范围, 且任何在这个范围之外的点都应该被裁剪掉. 被裁剪掉的坐标就会被忽略, 所以剩下的坐标就将变为屏幕上可见的片段. 这也是`裁剪空间` 名字的由来.

因为将所有可见的坐标都指定在 `-1.0` 到 `1.0` 的范围内不是很直观,  所以我们会指定自己的坐标集(Coordinate Set) 并将它变换回标准化设备坐标系, 就像`OpenGL` 期望的那样.

为了将顶点坐标从观察变换到裁剪空间, 我们需要定义一个投影矩阵(Projection Matrix), 它指定了一个范围的坐标, 比如在每个维度上的`-1000`到`1000`. 投影矩阵接着会将在这个指定的范围内的坐标变换为标准化设备坐标系的范围 `(-1.0, 1.0)`. 所有在范围外的坐标不会被映射到`-1.0`到 `1.0`的范围之间, 所以会被裁剪掉. 在上面这个投影矩阵所指定的范围内, 坐标`(1250, 500, 750)`将是不可见的, 这是由于它的`x`坐标超出了范围, 它被转化为一个大于`1.0`的标准化设备坐标, 所以被裁剪掉了.

由投影矩阵创建的`观察箱(Viewing Box)`被称为`平截头体(Frustum)`, 每个出现在平截头体范围内的坐标都会最终出现在用户屏幕上, 将特定范围内的坐标转化到标准化设备坐标系的过程(而且它很容易被映射到2D观察空间坐标) 被称之为投影(Projection), 因此使用投影矩阵能将3D坐标投影(Project)到很容易映射到2D的标准化设备坐标系中.

一旦所有的顶点被变换到裁剪空间, 最终的操作——`透视除法(Perspective Division)`将会执行, 在这个过程中我们将位置向量的下x, y, z分量分别处以向量的齐次w分量; 透视除法是将4D裁剪空间坐标变换为3D标准化设备坐标的过程. 这一步会在每一个顶点着色器运行的最后被自动执行.

在这一阶段之后, 最后的坐标将会被映射到屏幕空间中(使用glViewport中的设定), 并被变换成片段.

将观察坐标变换为裁剪坐标的投影矩阵可以为两种不同的形式, 每种形式都定义了不同的平截头体. 我们可以选择创建一个`正射投影矩阵(Orthographic Projection Matrix)`或一个`透视投影矩阵(Perspective Projection Matrix)`.

## 投影矩阵

## 欧拉角

欧拉角(Euler Angle)是可以表示3D空间中旋转的3个值, 由莱昂哈德·欧拉(Leonhard·Euler)在18世纪提出. 一共有3种欧拉角:` 俯仰角(Pitch)`、`偏航角(Yaw)`和`滚转角(Roll)`.
