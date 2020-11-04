//
//  TupleTest.m
//  JDTuple
//
//  Created by JD_曾智 on 2020/9/30.
//  Copyright (c) 2020 JD.com, Inc. All rights reserved.
//

#import "TupleTest.h"
#import "JDTuple.h"

@implementation TupleTest

- (instancetype)init {
    self = [super init];
    
    NSObject *name = [NSString stringWithFormat:@"jimmy"];
    NSInteger age = 28;
    NSArray *arr = @[@"a", @"b", @"c"];
    CGRect frame = CGRectMake(1, 2, 3, 4);
    CGFloat f = 55.334;
    JDTuple *someTuple = jd_tuple(name, age, arr, frame, f);
    
    [self testUnpack:someTuple];
    [self testUnpackStrict:someTuple];
    [self testUnpackWithkey:someTuple];
    [self testUnpackSingle:someTuple];
    NSLog(@"%@", someTuple);
    return self;
}

- (void)testUnpack:(JDTuple *)tuple {
    jd_unpack(tuple)^(NSString *N, NSInteger A, NSArray *ARR, CGRect FRAME, CGFloat FNUMBER) {
        NSLog(@"name : %@", N);
        NSLog(@"age : %ld", (long)A);
        NSLog(@"arr : %@", ARR);
        NSLog(@"frame.origin.x : %f", FRAME.origin.x);
        NSLog(@"f : %f", FNUMBER);
    };
    
    jd_unpack(tuple)^(NSString *N, NSInteger A) {
        NSLog(@"name : %@", N);
        NSLog(@"age : %ld", (long)A);
    };

    
    jd_unpack(tuple)^(NSString *N, arg_ph ph1, arg_ph ph2, arg_ph ph3, CGFloat FNUMBER) {
        NSLog(@"name : %@", N);
        NSLog(@"f : %f", FNUMBER);
    };
}

- (void)testUnpackStrict:(JD_TUPLE(NSString *, NSInteger, NSArray *, CGRect, CGFloat))tuple {
    jd_unpack_strict(tuple)^(NSString *N, NSInteger A, NSArray *ARR, CGRect FRAME, CGFloat FNUMBER) {
        NSLog(@"name : %@", N);
        NSLog(@"age : %ld", (long)A);
        NSLog(@"arr : %@", ARR);
        NSLog(@"frame.origin.x : %f", FRAME.origin.x);
        NSLog(@"f : %f", FNUMBER);
    };
}

- (void)testUnpackWithkey:(JD_TUPLE(NSString *, NSInteger, NSArray *, CGRect, CGFloat))tuple {
    
    jd_unpackWithkey(NSString *name, CGFloat f) = tuple;
    NSLog(@"name : %@", name);
    NSLog(@"f : %f", f);
    
    jd_unpackWithkeyMore(2, NSInteger age) = tuple;
    NSLog(@"age : %ld", (long)age);
    
    jd_unpackWithkeyMore(3, NSArray *arr, CGRect frame) = tuple;
    NSLog(@"arr : %@", arr);
    NSLog(@"frame.origin.x : %f", frame.origin.x);
}

- (void)testUnpackSingle:(JDTuple *)tuple {
    //unpack with key
    NSLog(@"name : %@", [tuple[@"name"] nonretainedObjectValue]);
    NSLog(@"age : %ld", [tuple[@"age"] integerValue]);
    NSLog(@"arr : %@",  [tuple[@"arr"] nonretainedObjectValue]);
    NSLog(@"frame.origin.x : %f", [tuple[@"frame"] CGRectValue].origin.x);
    NSLog(@"f : %f\n ", [tuple[@"f"] floatValue]);
    
    //unpack with index
    NSLog(@"name : %@", [tuple[0] nonretainedObjectValue]);
    NSLog(@"age : %ld", [tuple[1] integerValue]);
    NSLog(@"arr : %@",  [tuple[2] nonretainedObjectValue]);
    NSLog(@"frame.origin.x : %f", [tuple[3] CGRectValue].origin.x);
    NSLog(@"f : %f", [tuple[4] floatValue]);
}
@end
