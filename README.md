# JDTuple

Objective-C Tuple

## 1、元组构造
JDTuple通过jd_tuple(...)方法来构造一个元组，如下代码所示我们构造了一个包含三个元素的元组：
```Objective-C
    NSString *name = @"阿珍";
    NSInteger age = 28;
    NSArray *arr = @[@"a", @"b", @"c"];
    JDTuple *someTuple = jd_tuple(name, age, arr);
```
这一个方法其实包含了三个步骤：
* 给元素定义键值：name、age、arr。
* 给元素定义下标：0，1，2。
* 给元素赋值：阿珍，28，["a", "b", "c"]。

当然也可以定义匿名元素的元组，直接将值传给构造方法，将默认为匿名的元素。如：

```Objective-C
    JDTuple *someTuple = jd_tuple(@"阿强", 18, (CGRectMake(100, 200, 50.5, 7)), [NSObject new]);
```
## 2、元组解构
#### 1.顺序解构
JDTuple通过jd_tuple(tuple)^(...){...}方法来进行顺序元素解构，顺序解构是根据构造元组时的元素顺序来取值，根据构造时元素的顺序和类型，定义相应的变量就能获取到元素的值，如：
```Objective-C
    JDTuple *someTuple = jd_tuple(@"阿强", 18, (CGSizeMake(5, 18)), [NSObject new]);
    
    jd_unpack(someTuple)^(NSString *name, int age, CGSize size, NSObject *objc) {
        NSLog(@"name: %@", name);
        NSLog(@"age: %d", age);
        NSLog(@"width:%f, height:%f", size.width, size.height);
        NSLog(@"objc: %@", objc);

        //NSLog output
        //name: 阿强
        //age: 18
        //width:5.000000, height:18.000000
        //objc: <NSObject: 0x6000014279d0>
    };
```

上述代码解构了someTuple元组，将元素在一个作用域内赋值给了name、age、size、objc变量。

当我们只需要部分元素时，我们只需要在相应的位置上定义变量就可以了，需要忽略的元素可以用arg_ph类型来占位，如：
```Objective-C
    JDTuple *someTuple = jd_tuple(@"阿强", 18, (CGSizeMake(5, 18)), [NSObject new]);
    
    jd_unpack(someTuple)^(NSString *name, int age) {
        NSLog(@"name: %@", name);
        NSLog(@"age: %d", age);

        //NSLog output
        //name: 阿强
        //age: 18
    };

    jd_unpack(someTuple)^(NSString *name, arg_ph one, arg_ph two, NSObject *objc) {
        NSLog(@"name: %@", name);
        NSLog(@"objc: %@", objc);

        //NSLog output
        //name: 阿强
        //objc: <NSObject: 0x6000014279d0>
    };
```
当相应位置的元素类型不匹配时，元素将不会被赋值，并在控制台输出提示， 如：
```Objective-C
    JDTuple *someTuple = jd_tuple(@"阿强", 18, (CGSizeMake(5, 18)), [NSObject new]);
    
    jd_unpack(someTuple)^(NSInteger name, id age, CGSize size, NSObject *objc) {
        NSLog(@"name: %ld", name);
        NSLog(@"age: %@", age);
        NSLog(@"width:%f, height:%f", size.size.width, size.size.height);
        NSLog(@"objc: %@", objc);

        //NSLog output
        //JDTuple unpack params _ 0 _ type is not match. @ != q
        //JDTuple unpack params _ 1 _ type is not match. i != @
        //name: 0
        //age: (null)
        //width:5.000000, height:18.000000
        //objc: <NSObject: 0x6000002439e0>
    };
```
#### 2.键值解构
如果元组在构造时包含键值，则可以使用jd_unpackWithkey(...)方法，通过对应的键值解构元组，而无需关心元素顺序或个数，如：
```Objective-C
- (void)testFunctionOne {

    NSString *name = @"阿珍";
    NSInteger age = 28;
    NSArray *arr = @[@"a", @"b", @"c"];
    JDTuple *someTuple = jd_tuple(name, age, arr);
    
    [self testFunctionTwo:someTuple];
}

- (void)testFunctionTwo:(JDTuple *)tuple {
    jd_unpackWithkey(NSInteger age, NSArray *arr, NSString *name) = tuple;

    NSLog(@"name: %@", name);
    NSLog(@"age: %ld", age);
    NSLog(@"array: %@", arr);

    //NSLog output
    //name: 阿珍
    //age: 28
    //array: (a,b,c)
}
```

上述代码在testFunctionTwo方法中解构了入参tuple, 在函数作用域内将元素直接赋值给了同名的参数name、age、arr。

如果尝试解构元组中不存在的键值，或者键值类型不匹配，则不会给予赋值，并在控制台输出提示，如：
```Objective-C
- (void)testFunctionOne {

    NSString *name = @"阿珍";
    NSInteger age = 28;
    NSArray *arr = @[@"a", @"b", @"c"];
    JDTuple *someTuple = jd_tuple(name, age, arr);
    
    [self testFunctionTwo:someTuple];
}

- (void)testFunctionTwo:(JDTuple *)tuple {
    jd_unpackWithkey(NSString *name, id test1, CGFloat age) = tuple;
    NSLog(@"name: %@", name);
    NSLog(@"age: %f", age);
    NSLog(@"test1: %@", test1);

    //NSLog output
    //JDTuple unpack params _ ” id test1 ” _ non-existent
    //JDTuple unpack params _ “ CGFloat age ” _ type is not match. q != d
    //name: 阿珍
    //age: 0.000000
    //test1: (null)
}
```
#### 3.单个元素获取
可以从元组中根据下标或者键值来获取单个元素，类似数组或者字典的操作，得到的元素是被NSValue封装起来的，使用时要根据实际的类型进行值的获取， 如果下标或键值不正确，则会返回nil，如：
```Objective-C
    NSString *name = @"阿珍";
    NSInteger age = 28;
    NSArray *arr = @[@"a", @"b", @"c"];
    JDTuple *someTuple = jd_tuple(name, age, arr);
    
    NSString *nameWithIndex = [someTuple[0] nonretainedObjectValue]; //阿珍
    NSInteger ageWithKey = [someTuple[@"age"] integerValue];  //28
    
    NSValue *nonexistentWithIndex = someTuple[99999]; //(null)
    NSValue *nonexistentWithKey = someTuple[@"existent"]; //(null)
```
#### 4.元组定义
为了让开发者清楚的知道元组中有什么元素，我们可以使用JD_TUPLE(...)来定义一个元组，避免遇到一个元组时不清楚里面会包含什么元素的窘境，在使用顺序解构时，我们可以使用严格模式 jd_unpack_strict(...)来完全匹配元组的定义。
```Objective-C
//定义元组内包含：NSString *name, NSInteger age
JD_TUPLE(NSString *name, NSInteger age) tuple = jd_tuple(@"阿强", 18); 
```
```Objective-C
- (void)testFunction:( JD_TUPLE(NSString *name, NSInteger age) )tuple {    

    jd_unpack_strict(tuple)^(NSString *name, NSUInteger age) {  ⭕️ //解构正确可以通过编译
        ...
    };

    jd_unpack_strict(tuple)^(UIView *name) {  ❌ //解构错误编译不通过
        ...
    };
    
    jd_unpack(tuple)^(CGFloat f) { ⭕️ //解构正确可以通过编译，非严格模式
        ...
    };
}

```  
