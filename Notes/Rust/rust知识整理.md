1. Rust 的克隆与复制

https://zhuanlan.zhihu.com/p/21730929



2. Rust 提供了分层式处理错误方案：

   ```rust
   Option<T>: 用于处理有值和无值的情况
   Result<T, E>: 用于处理可恢复错误的情况
   Panic: 用于处理不可恢复错误的情况
   Abort: 用于处理会发生灾难性后果的情况
   ```

   

3. 生命周期注解位于引用的 **&** 操作符之后，并用一个空格将生命周期注解与引用类型分隔开，比如 **& 'a i32**  、 **&'a mut i32**、**&'a str** 。生周期注解并不改变任何引用的生命周期的大小，只用于描述多个生命周期间的关系。



4. **async** 关键字作用:

   ```cn
   // 1. 允许函数体内使用 .await 语法
   // 2. 修改函数的返回类型。 async fn foo() -> Bar 实际上返回的是 impl std::future::Future<Output=Bar>
   // 3. 自动将返回值封装进一个新的 future 对象
   ```

   **.await** 语法的作用

   ```
   
   ```




5.  **C/CPP Type to Rust**

   参考：https://locka99.gitbooks.io/a-guide-to-porting-c-to-rust/content/features_of_rust/types.html

   |         C/C++          |                   Rust                    |
   | :--------------------: | :---------------------------------------: |
   |          char          |                 i8(or u8)                 |
   |     unsigned char      |                    u8                     |
   |      signed char       |                    i8                     |
   |       short int        |                    i16                    |
   |   unsigned short int   |                    u16                    |
   |     (signed)  int      |                i32 or i16                 |
   |      unsigned int      |                u32 or u16                 |
   |   (signed) long int    |               i32` or `i64                |
   |   unsigned long int    |               u32` or `u64                |
   | (signed) long long int |                    i64                    |
   |         size_t         |                   usize                   |
   |         float          |                    f32                    |
   |         double         |                    f64                    |
   |      long double       | f128<br />(Rust 在有些平台上不支持该类型) |
   |          bool          |                   bool                    |
   |          void          |                    ()                     |

   C 的 `<stdin.h>`  头文件提供具有长度签名的类型别名（推荐使用）

   |  C/CPP   | Rust |
   | :------: | :--: |
   |  int8_t  |  i8  |
   | uint8_t  |  u8  |
   | int16_t  | i16  |
   | uint16_t | u16  |
   | int32_t  | i32  |
   | uint32_t | u32  |
   | int64_t  | i64  |
   | uint64_t | u64  |

   Rust FFI编程——手动绑定C库
   
   https://rustcc.cn/article?id=f70a81d1-cb79-4429-985c-d3d53247f5c0



6. **rust 指针转换**

```rust
// Rust *mut u8 转换成 &[u8]
unsafe {
    // data_ptr为 *mut u8, data为 &[u8]
    // 使用 slice::from_raw_parts 不会发生拷贝，作用给这块内存创建一个切片
    let data = slice::from_raw_parts(data_ptr, size);
}

// Rust *mut u8 转换成 &mut [u8]
unsafe {
    // data_ptr为 *mut u8, data为 Vec[u8]
    // 使用 Vec::from_raw_parts 不会发生拷贝，该块内存的所有权会被 data 接管
    let data = Vec::from_raw_parts(data_ptr, size, size);
}

// &[u8] 转换成 * const u8
let ptr = data.as_ptr()
```



7.原始指针

```Rust
let a = &56;
let a_raw_ptr = a as *const u32;
// or
let b = &mut 5634.3;
let b_mut_ptr = b as *mut T;
```



8.rust 智能指针

> - 独占式智能指针 `Box<T>`
> - 非线程安全的引用计数智能指针 `Rc<T>`
> - 线程安全的引用计数智能指针 `Arc<T>`
> - 弱指针 `Weak<T>`



9. rust **async/await**作用理解： **async** 关键字将一个代码块转为为实现了**future**特征的状态机，使得在同步方法中调用阻塞函数（**async**转化的函数会阻塞整个线程），但是阻塞的**future**会让出线程控制权，允许其他**future**运行；而**await**关键字可以使**async**代码块中的其他**async**函数按顺序执行，当**await**发生阻塞时，不会阻塞当前线程，可以让其他任务执行。

参考：https://zhuanlan.zhihu.com/p/144325440

异步测试代码：

```Rust
// 此代码可以使task1 和 task2并发执行，根据 rust tokio调度器进行调度

#[tokio::main]		// basic_scheduler threaded_scheduler 
async fn main() -> Result<(), Box<dyn Error>> {
    // task1
    tokio::spawn(async move {
        println!("########## {} current thread: {:?}", 1, std::thread::current().id());
        tokio::time::sleep(Duration::from_millis(3000)).await;
        println!("########## {} currnet end", 1);
    });

    // 此处休眠给 task1 进入 await状态时间, 交出它所在线程的执行权, 
    // 使得task1和task2在同一个线程并发执行. 若不加，可能两个任务会
    // 分别在不同的线程中执行
    tokio::time::sleep(Duration::from_millis(200)).await;

    // task2
    tokio::spawn(async move {
        println!("########## {} current thread: {:?}", 2, std::thread::current().id());
        tokio::time::sleep(Duration::from_millis(1000)).await;
        println!("########## {} current end", 2);
    });

    tokio::time::sleep(Duration::from_millis(10000)).await;
    Ok(())
}
```

```Rust
// 单线程异步代码块
async fn do_stuff_async() -> Result<(), &'static str> {
    println!("########## {} current thread: {:?}", 1, std::thread::current().id());
    tokio::time::sleep(Duration::from_millis(3000)).await;
    println!("########## {} currnet end", 1);
    Ok(())
}

async fn more_async_work() -> Result<(), &'static str> {
    println!("########## {} current thread: {:?}", 2, std::thread::current().id());
    tokio::time::sleep(Duration::from_millis(1000)).await;
    println!("########## {} current end", 2);
    Ok(())
}

#[tokio::main]
async fn main(){
    // let a = do_stuff_async();
    // let b = more_async_work();
    tokio::try_join!(do_stuff_async(), more_async_work());
}
```





10. Box 可以在堆上申请内存，当我们想解除 Box 获取内存时代码如下：

    ```rust
    let box_data_raw_ptr = Box::into_raw(box_data);
    ```

    使用此方法后，Box 变量变回失效，不能再使用。

    如果想把一块无人管理的内存转给 Box 管理，代码如下：

    ```rust
    let box_data_raw_ptr = Box::into_raw(box_data);
    let box_data_ptr = unsafe { Box::from_raw(box_data_raw_ptr) };
    ```

    

11. Rust **mod关键字**作用：

    ① 在当前目录下寻找 **xxx.rs** 文件。因为一个 rust 文件可以看成一个 module.

    ② 在当前目录下寻找 **xxx/mod.rs** 文件。此时 services 可以看做是一个命名空间.



12.  Rust **Cell** 和 **RefCell** 的作用就是在提供结构体在不可变的时候，可以修改其中的某个成员.



13. 整形转成枚举类型方法：https://enodev.fr/posts/rusticity-convert-an-integer-to-an-enum.html



14.  将一块内存映射成对应的结构，使用 **std::mem::transmute_copy** , 代码如下：

    ```Rust
    use std::mem;
    
    #[repr(packed)]
    struct Foo {
        bar: u8,
    }
    
    let foo_array = [10u8];
    
    unsafe {
        let mut foo_struct: Foo = mem::transmute_copy(&foo_array);
        assert_eq!(foo_struct.bar, 10);
        
        foo_struct.bar = 20;
        assert_eq!(foo_struct.bar, 20);
    }
    assert_eq!(foo_array, [10]);
    
    ```

    

15. Rustup - Rust工具链安装器，参考: [Rust工具链安装器](https://zhuanlan.zhihu.com/p/382810160)



16.  Rust 编写样例代码，参考: http://xion.io/post/code/rust-examples.html



17.  Rust Cargo 命令行，参考: https://doc.rust-lang.org/cargo/commands/cargo-new.html



18.  Rust 打印 [u8] 以16进制显示:

    ```rust
    println!("{:X?}", data);
    ```

    

19. Rust cargo run 编译时，附加 **features** 参数

    ```rust
    run --features "sdl_window  DX11"
    ```

    

20. Rust消除警告

    ```Rust
    #![allow(dead_code)]
    #![allow(unused_variables)]
    #![allow(overflowing_literals)]
    #![allow(non_snake_case)]
    #![allow(non_camel_case_types)]
    #![allow(unused_imports)]
    ```

    

21. Cargo 链接 dll 库

    ```rust
    // 指定库寻找目录
    println!("cargo:rustc-link-search={}", Path::new(&dir).join("src/render/lib").display());
    // 链接库
    println!("cargo:rustc-link-lib={}={}", mode, lib);
    ```




22. rust 导出 C 标准函数

```toml
# Cargo.toml
[lib]
crate-type = ["cdylib"]
```

```rust
// 带有 #[no_mangle]属性的函数, rust编译器不会为它进行函数名混淆
#[no_mangle]
pub extern "C" fn test_func(a: u32, b: u32) {
    let c = a + b;
    println!("print in rust, sum is: {}", c);
}
```

