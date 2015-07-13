//
//  TableViewController.m
//  NSPredicate
//
//  Created by 哲人蔡 on 15/7/12.
//  Copyright (c) 2015年 Phil. All rights reserved.
//
#define PHLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#import "TableViewController.h"
@interface Person : NSObject
@property NSString *firstName;
@property NSString *lastName;
@property NSNumber *age;
+ (instancetype)personWithFirstName:(NSString *)first lastName:(NSString *)last age:(NSNumber *)age;
@end
@implementation Person
+ (instancetype)personWithFirstName:(NSString *)first lastName:(NSString *)last age:(NSNumber *)age{
    return [[self alloc] initWithFirstName:first lastName:last age:age];
}
-(instancetype)initWithFirstName:(NSString *)first lastName:(NSString *)last age:(NSNumber *)age{
    self = [super init];
    if (self) {
        _firstName = first;
        _lastName = last;
        _age = age;
    }
    return self;
}
- (NSString *)description {return [NSString stringWithFormat:@"%@ %@ (%@ years old)",self.firstName,self.lastName,self.age];}
@end

@interface TableViewController ()
@property (nonatomic, strong) NSMutableArray *people;
@property (nonatomic, strong) NSMutableArray *strings;
@property (nonatomic, strong) NSMutableArray *exampleList;
@end
static NSString *const cellIdentifier = @"reuse";
@implementation TableViewController
#pragma mark - init
- (NSMutableArray *)people {
    if (!_people) {
        _people = [NSMutableArray array];
        Person *john = [Person personWithFirstName:@"John" lastName:@"Snow" age:@(20)];
        Person *tim = [Person personWithFirstName:@"Tim" lastName:@"Cook" age:@(55)];
        Person *phil = [Person personWithFirstName:@"Phil" lastName:@"Cai" age:@(20)];
        Person *tom = [Person personWithFirstName:@"Tom" lastName:@"Tsui" age:@(19)];
        Person *jim = [Person personWithFirstName:@"Jim" lastName:@"Swift" age:@(12)];
        Person *lim = [Person personWithFirstName:@"Lim" lastName:@"Nicole" age:@(19)];
        Person *jonny = [Person personWithFirstName:@"Jonny" lastName:@"Pereira" age:@(32)];
        Person *andy = [Person personWithFirstName:@"Andy" lastName:@"Pereira" age:@(33)];
        NSArray *people = @[john,tim,phil,tom,jim,lim,jonny,andy];
        [_people addObjectsFromArray:people];
    }
    return _people;
}
-(NSMutableArray *)strings {
    if (!_strings) {
        _strings = [NSMutableArray array];
        NSArray *strings = @[@"Tag",@"Code",@"iOS",@"Name",@"nick",@"Eleme",@"MacBook Air",@"MacBook Pro",@"iPhone",@"Cook",@"Cooking",@"coordinate",@"Coordinate",@"cool"];
        [_strings addObjectsFromArray:strings];
    }
    return _strings;
}
- (NSMutableArray *)exampleList {
    if (!_exampleList) {
        _exampleList = [NSMutableArray array];
        NSArray *elements = @[@"properties1",@"properties2",@"properties3",@"self1",@"compound",@"block",@"keyPath1"];
        [_exampleList addObjectsFromArray:elements];
    }
    return _exampleList;
}

#pragma mark - ViewLife
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    PHLog(@"all:%@",people);
    NSPredicate *philPredicate = [NSPredicate predicateWithFormat:@"firstName = 'Phil'"];
    NSPredicate *cookPredicate = [NSPredicate predicateWithFormat:@"lastName = 'Cook'"];
    NSPredicate *age20Predicate = [NSPredicate predicateWithFormat:@"age <= 20"];
    PHLog(@"%@ : %@",philPredicate.description,[people filteredArrayUsingPredicate:philPredicate]);
    PHLog(@"%@ : %@",cookPredicate.description,[people filteredArrayUsingPredicate:cookPredicate]);
    PHLog(@"%@ : %@",age20Predicate.description,[people filteredArrayUsingPredicate:age20Predicate]);
}

- (void)properties2 {
    NSArray *people = self.people;
    PHLog(@"all:%@",people);
    NSPredicate *philPredicate = [NSPredicate predicateWithFormat:@"%K = %@",@"firstName",@"Phil"];
    NSPredicate *cookPredicate = [NSPredicate predicateWithFormat:@"%K = 'Cook'",@"lastName"];
    NSPredicate *age20Predicate = [NSPredicate predicateWithFormat:@"age <= %d",20];
    PHLog(@"%@ : %@",philPredicate.description,[people filteredArrayUsingPredicate:philPredicate]);
    PHLog(@"%@ : %@",cookPredicate.description,[people filteredArrayUsingPredicate:cookPredicate]);
    PHLog(@"%@ : %@",age20Predicate.description,[people filteredArrayUsingPredicate:age20Predicate]);
    //    c和d来修改操作符以相应的指定不区分大小写和变音符号
    NSPredicate *namesBeginningWithLetterPredicate = [NSPredicate predicateWithFormat:@"(firstName BEGINSWITH[cd] $letter) OR (lastName BEGINSWITH[cd] $letter)"];
    PHLog(@"%@ : %@", namesBeginningWithLetterPredicate,[people filteredArrayUsingPredicate:[namesBeginningWithLetterPredicate predicateWithSubstitutionVariables:@{@"letter": @"c"}]]);
    
    NSPredicate *length4Predicate = [NSPredicate predicateWithFormat:@"firstName.%K = 4",@"length"];
    //    euqals to ...
    //    NSPredicate *length4Predicate = [NSPredicate predicateWithFormat:@"%K.%K = 4",@"firstName",@"length"];
    //    and euqals to ...
    //    NSPredicate *length4Predicate = [NSPredicate predicateWithFormat:@"firstName.length = 4"];
    PHLog(@"%@ : %@",length4Predicate.description,[people filteredArrayUsingPredicate:length4Predicate]);
}
- (void)properties3 {
    NSArray *strings = self.strings;
    PHLog(@"all : %@",strings);
    NSPredicate *length5Predicate = [NSPredicate predicateWithFormat:@"length >= 5"];
    PHLog(@"%@ : %@",length5Predicate.description,[strings filteredArrayUsingPredicate:length5Predicate]);
}
- (void)self1 {
    NSArray *strings = self.strings;
    PHLog(@"all : %@",strings);
    //    NSPredicate *selfPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] 'c'"];
    //    equals to ...
    //    NSPredicate *selfPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS 'c' || SELF CONTAINS 'C'"];
    //    and euqals to ...
    NSPredicate *selfPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS 'c' OR SELF CONTAINS 'C'"];
    PHLog(@"%@ : %@",selfPredicate.description,[strings filteredArrayUsingPredicate:selfPredicate]);
}

- (void)compound {
    NSArray *people = self.people;
    NSArray *strings = self.strings;
    PHLog(@"allStrings : %@",strings);
    //    OR (||)
    NSPredicate *cCPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS 'c' OR SELF CONTAINS 'C'"];
    PHLog(@"%@ : %@",cCPredicate.description,[strings filteredArrayUsingPredicate:cCPredicate]);
    //    AND (&&)
    NSPredicate *andPredicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[c] 'c' AND length >= 5"];
    PHLog(@"%@ : %@",andPredicate.description,[strings filteredArrayUsingPredicate:andPredicate]);
    
    PHLog(@"people : %@",people);
    //    NOT (!)
    NSPredicate *notPredicate = [NSPredicate predicateWithFormat:@"firstName CONTAINS 'm' && NOT(lastName CONTAINS 'o')"];
    PHLog(@"%@ : %@",notPredicate.description,[people filteredArrayUsingPredicate:notPredicate]);
    
}
- (void)block {
    NSArray *people = self.people;
    PHLog(@"people : %@",people);
    //    In OS X v10.6, Core Data supports this method in the in-memory and atomic stores, but not in the SQLite-based store.
    NSPredicate *firstName4Predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        Person *person = evaluatedObject;
        return person.firstName.length>=4;
    }];
    PHLog(@"%@ : %@",firstName4Predicate.description,[people filteredArrayUsingPredicate:firstName4Predicate]);
}
-(void)keyPath1 {
}

@end



