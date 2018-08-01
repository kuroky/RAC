//
//  ViewController.m
//  RACMacro
//
//  Created by kuroky on 2018/8/1.
//  Copyright © 2018年 Kuroky. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) RACSignal *signal;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self test];
    //[self test2];
    //[self test3];
    //[self test4];
    [self test5];
}

// RAC:把一个对象的某个属性绑定一个信号，只要发出信号，就会把信号的内容给对象的属性赋值
// 给label的text属性绑定了文本框改变的信号
- (void)test {
    RAC(self.label, text) = self.textField.rac_textSignal;
    [self.textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        self.label.text = x;
    }];
}

/**
 KVO
 RACObserce:快速的监听某个对象某个属性改变
 返回的是一个信号，对象的某个属性改变的信号
 */
- (void)test2 {
    [RACObserve(self.view, center) subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
}

- (void)test3 {
    RAC(self.label, text) = self.textField.rac_textSignal;
    [RACObserve(self.label, text) subscribeNext:^(id  _Nullable x) {
        NSLog(@"====label的文字变了: %@", x);
    }];
    
    self.label.text = @"12345";
}

/**
 循环引用
 */
- (void)test4 {
    @weakify(self)
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        NSLog(@"%@", self.view);
        return nil;
    }];
    _signal = signal;
}

/**
 元祖
 快速包装一个元祖
 把包装的类型放在宏的参数里面，就会自动包装
 */
- (void)test5 {
    // 宏的参数类型和元祖元素类型一致， 右边为要解析的元祖
    RACTuple *tuple = RACTuplePack(@1, @2, @3);
    
    // 快速包装一个元祖 把包装的类型放在宏的参数里，就会自动包装
    RACTupleUnpack(NSNumber *num1, NSNumber *num2, NSNumber *num3) = tuple;
    
    NSLog(@"%@  %@  %@", num1.stringValue, num2.stringValue, num3.stringValue);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
