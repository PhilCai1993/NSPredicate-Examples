//
//  TableViewController.m
//  NSPredicate
//
//  Created by 哲人蔡 on 15/7/12.
//  Copyright (c) 2015年 Phil. All rights reserved.
//

#import "TableViewController.h"

@interface Person : NSObject
@property NSString *firstName;
@property NSString *lastName;
@property NSNumber *age;
@end
@implementation Person
- (NSString *)description {return [NSString stringWithFormat:@"%@ %@ (%@ years old)",self.firstName,self.lastName,self.age];}
@end



@interface TableViewController ()
@property (nonatomic, strong) NSMutableArray *people;
@property (nonatomic, strong) NSMutableArray *exampleList;
@end
static NSString *const cellIdentifier = @"reuse";
@implementation TableViewController
#pragma mark - init
- (NSMutableArray *)people {
    if (!_people) {
        _people = [NSMutableArray array];
        Person *john = [Person new];
        john.firstName = @"John";
        john.lastName = @"Snow";
        john.age = @(20);
        Person *tim = [Person new];
        tim.firstName = @"Tim";
        tim.lastName = @"Cook";
        tim.age = @(55);
        Person *phil = [Person new];
        phil.firstName = @"Phil";
        phil.lastName = @"Cai";
        phil.age = @(20);
        
        NSArray *people = @[john,tim,phil];
        [_people addObjectsFromArray:people];
    }
    return _people;
}
- (NSMutableArray *)exampleList {
    if (!_exampleList) {
        _exampleList = [NSMutableArray array];
        NSArray *elements = @[@"properties1",@"properties2",@"keyPath1"];
        [_exampleList addObjectsFromArray:elements];
    }
    return _exampleList;
}



#pragma mark - ViewLife
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.exampleList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.exampleList[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *selectorName = self.exampleList[indexPath.row];
    SEL selector = NSSelectorFromString(selectorName);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:selector];
#pragma clang diagnostic pop
}
#pragma mark - NSPredicate Examples
- (void)properties1 {
    NSArray *people = self.people;
    NSLog(@"all:%@",people);
    NSPredicate *philPredicate = [NSPredicate predicateWithFormat:@"firstName = 'Phil'"];
    NSPredicate *cookPredicate = [NSPredicate predicateWithFormat:@"lastName = 'Cook'"];
    NSPredicate *age20Predicate = [NSPredicate predicateWithFormat:@"age <= 20"];
    NSLog(@"phil : %@",[people filteredArrayUsingPredicate:philPredicate]);
    NSLog(@"cook : %@",[people filteredArrayUsingPredicate:cookPredicate]);
    NSLog(@"age<=20 : %@",[people filteredArrayUsingPredicate:age20Predicate]);
}

- (void)properties2 {
    NSArray *people = self.people;
    NSLog(@"all:%@",people);
    NSPredicate *philPredicate = [NSPredicate predicateWithFormat:@"%K = %@",@"firstName",@"Phil"];
    NSPredicate *cookPredicate = [NSPredicate predicateWithFormat:@"%K = 'Cook'",@"lastName"];
    NSPredicate *age20Predicate = [NSPredicate predicateWithFormat:@"age <= %d",20];
    NSLog(@"phil : %@",[people filteredArrayUsingPredicate:philPredicate]);
    NSLog(@"cook : %@",[people filteredArrayUsingPredicate:cookPredicate]);
    NSLog(@"age<=20 : %@",[people filteredArrayUsingPredicate:age20Predicate]);
    //    c和d来修改操作符以相应的指定不区分大小写和变音符号
    NSPredicate *namesBeginningWithLetterPredicate = [NSPredicate predicateWithFormat:@"(firstName BEGINSWITH[cd] $letter) OR (lastName BEGINSWITH[cd] $letter)"];
    NSLog(@"'c' Names: %@", [people filteredArrayUsingPredicate:[namesBeginningWithLetterPredicate predicateWithSubstitutionVariables:@{@"letter": @"c"}]]);
    
    NSPredicate *length4Predicate = [NSPredicate predicateWithFormat:@"firstName.%K = 4",@"length"];
    //    euqals to ...
    //    NSPredicate *length4Predicate = [NSPredicate predicateWithFormat:@"%K.%K = 4",@"firstName",@"length"];
    //    and euqals to ...
    //    NSPredicate *length4Predicate = [NSPredicate predicateWithFormat:@"firstName.length = 4"];
    NSLog(@"firstNameLength = 4 : %@",[people filteredArrayUsingPredicate:length4Predicate]);
}

-(void)keyPath1 {
    //    [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
    //
    //    }];
}
@end



