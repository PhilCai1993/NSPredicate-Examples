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

@interface Note : NSObject
+ (instancetype)noteWithExpenses:(NSArray *)expenses noteID:(NSString *)noteID;
@property (nonatomic, readonly) NSArray *expenses;
@property (nonatomic, readonly) NSString *noteID;
@end
@implementation Note
+(instancetype)noteWithExpenses:(NSArray *)expenses noteID:(NSString *)noteID{
    return [[self alloc] initWithExpenses:expenses noteID:noteID];
}
-(instancetype)initWithExpenses:(NSArray *)expenses noteID:(NSString *)noteID{
    self = [super init];
    if (self) {
        _expenses = expenses;
        _noteID = noteID;
    }
    return self;
}
- (NSString *)description {
    NSMutableString *des = [[NSMutableString alloc] init];
    double sum = 0;
    for (NSNumber *expense in self.expenses) {
        [des appendFormat:@"%@,",expense];
        sum += expense.doubleValue;
    }
    NSString *result;
    if ([des hasSuffix:@","]) {
        result = [des substringToIndex:des.length-1];
    }else {
        result = des;
    }
    
    return [NSString stringWithFormat:@"ID:%@  Sum:%f, Average:%f, EXPENSES:[%@]",self.noteID,sum,sum/self.expenses.count,result];
}
@end




@interface TableViewController ()
@property (nonatomic, strong) NSMutableArray *exampleList;
@property (nonatomic, strong) NSMutableArray *people;
@property (nonatomic, strong) NSMutableArray *strings;
@property (nonatomic, strong) NSMutableArray *notes;
@end
static NSString *const cellIdentifier = @"reuse";
@implementation TableViewController
#pragma mark - init
- (NSMutableArray *)exampleList {
    if (!_exampleList) {
        _exampleList = [NSMutableArray array];
        NSArray *elements = @[@"properties1",@"properties2",@"properties3",@"self1",@"compound",@"compoundPredicate",@"block",@"stringComparisonContain",@"stringComparisonBeginAndEnd",@"stringComparisonLike",@"stringComparisonMatch",@"keyPath_avg",@"keyPath_sum",@"keyPath_max_min",@"keyPath_count",@"aggregate"];
        [_exampleList addObjectsFromArray:elements];
    }
    return _exampleList;
}

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
        NSArray *strings = @[@"Tag",@"Code",@"folder",@"cooperation",@"coach",@"Conan",@"folding",@"OS X",@"iOS",@"Name",@"nick",@"Eleme",@"doom",@"MacBook Air",@"MacBook Pro",@"iPhone",@"Cook",@"after",@"Aftermath",@"Cooking",@"coordinate",@"Coordinate",@"cool",@"node",@"Node",@"clutter",@"order",@"matter",@"safe",@"GitHub",@"home",@"GitCafe",@"GitLab",@"Retina MacBook Pro",@"iMac",@"Apple",@"Apple Watch",@"iPod",@"iTunes",@"iPhoto",@"AFNetworking",@"github.com",@"philcai.com",@"10086",@"12306",@"10000",@"10010",@"504277874",@"12306.com",@"yeah.net",@"coding.net",@"objccn.io",@"hexo.io",@"xxx.com.cn",@"xxx.com.jp"];
        [_strings addObjectsFromArray:strings];
    }
    return _strings;
}
-(NSMutableArray *)notes {
    if (!_notes) {
        _notes = [NSMutableArray array];
        NSArray *notes = @[
                           [Note noteWithExpenses:@[@(10),@(3),@(1),@(16),@(3),@(2)] noteID:@"00"],
                           [Note noteWithExpenses:@[@(1),@(3),@(1),@(6),@(3),@(2)] noteID:@"01"],
                           [Note noteWithExpenses:@[@(10),@(2),@(9),@(6),@(3)] noteID:@"02"],
                           [Note noteWithExpenses:@[@(3),@(3),@(3),@(6),@(3),@(2)] noteID:@"03"],
                           [Note noteWithExpenses:@[@(6),@(3),@(2),@(6),@(3),@(2)] noteID:@"04"],
                           [Note noteWithExpenses:@[@(3),@(1),@(6),@(3),@(2)] noteID:@"05"],
                           [Note noteWithExpenses:@[@(24)] noteID:@"06"],
                           [Note noteWithExpenses:@[@(1),@(3),@(5),@(7),@(9),@(11)] noteID:@"07"],
                           [Note noteWithExpenses:@[@(2),@(2),@(4),@(4),@(6),@(6)] noteID:@"08"],
                           [Note noteWithExpenses:@[@(3),@(3),@(3),@(3),@(6),@(5),@(1)] noteID:@"09"],
                           [Note noteWithExpenses:@[@(3),@(3),@(3),@(3),@(5),@(5),@(2)] noteID:@"10"],
                           [Note noteWithExpenses:@[@(21),@(3),@(5),@(7),@(9),@(11)] noteID:@"11"],
                           [Note noteWithExpenses:@[@(2),@(3),@(5),@(7),@(9),@(11)] noteID:@"12"],
                           [Note noteWithExpenses:@[@(2),@(8),@(5),@(7),@(9),@(10)] noteID:@"13"],
                           [Note noteWithExpenses:@[@(2),@(3),@(5),@(7),@(9),@(11)] noteID:@"14"],
                           [Note noteWithExpenses:@[@(2),@(3),@(5),@(7),@(9),@(1)] noteID:@"15"],
                           [Note noteWithExpenses:@[@(2),@(3),@(5),@(9),@(10)] noteID:@"16"],
                           [Note noteWithExpenses:@[@(10),@(14)] noteID:@"17"],
                           [Note noteWithExpenses:@[@(12),@(14)] noteID:@"18"],
                           [Note noteWithExpenses:@[@(11),@(11)] noteID:@"19"],
                           [Note noteWithExpenses:@[@(5),@(1),@(6),@(3)] noteID:@"20"],
                           ];
        [_notes addObjectsFromArray:notes];
    }
    return _notes;
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







#pragma mark - Basic

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

#pragma mark - 组合

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
- (void)compoundPredicate {
    NSArray *strings = self.strings;
    PHLog(@"strings : %@",strings);
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[c] 'c'"];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"length >= 5"];
    NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] 'me'"];
//    AND
    NSCompoundPredicate *compoundAndPredicate = [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType subpredicates:@[predicate1,predicate2]];
    PHLog(@"%@ : %@",compoundAndPredicate.description,[strings filteredArrayUsingPredicate:compoundAndPredicate]);
//    PHLog(@"%@",compoundAndPredicate.subpredicates);
//    OR
    NSCompoundPredicate *compoundOrPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[predicate1,predicate3]];
    PHLog(@"%@ : %@",compoundOrPredicate.description,[strings filteredArrayUsingPredicate:compoundOrPredicate]);
//    PHLog(@"%@",compoundOrPredicate.subpredicates);;
//    NOT
    NSCompoundPredicate *compoundNotPredicate = [NSCompoundPredicate notPredicateWithSubpredicate:predicate2];
    PHLog(@"%@ : %@",compoundNotPredicate.description,[strings filteredArrayUsingPredicate:compoundNotPredicate]);
//    PHLog(@"%@",compoundNotPredicate.subpredicates);
//    wrong with follows and have not figured out
//    NSCompoundPredicate *compoundNotPredicate2 = [[NSCompoundPredicate alloc]initWithType:NSNotPredicateType subpredicates:@[predicate1,predicate2]];
//    PHLog(@"%@ : %@",compoundNotPredicate2.description,[strings filteredArrayUsingPredicate:compoundNotPredicate2]);
}

#pragma mark - block

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

#pragma mark - String
- (void)stringComparison {
    NSArray *strings = self.strings;
    PHLog(@"strings : %@",strings);
//    CONTAINS
    NSPredicate *containPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] 'af'"];
    PHLog(@"%@ : %@",containPredicate.description,[strings filteredArrayUsingPredicate:containPredicate]);
//    BEGINSWITH
    NSPredicate *beginwithPredicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH %@",@"Co"];
    PHLog(@"%@ : %@",beginwithPredicate.description,[strings filteredArrayUsingPredicate:beginwithPredicate]);
//    ENDSWITH
    NSPredicate *endwithPredicate = [NSPredicate predicateWithFormat:@"SELF ENDSWITH %@",@"r"];
    PHLog(@"%@ : %@",endwithPredicate.description,[strings filteredArrayUsingPredicate:endwithPredicate]);
//    LIKE
    NSPredicate *likePredicate1 = [NSPredicate predicateWithFormat:@"SELF LIKE %@",@"*o*e"];
    PHLog(@"%@ : %@",likePredicate1.description,[strings filteredArrayUsingPredicate:likePredicate1]);
    NSPredicate *likePredicate2 = [NSPredicate predicateWithFormat:@"SELF LIKE %@",@"*o?e*"];
    PHLog(@"%@ : %@",likePredicate2.description,[strings filteredArrayUsingPredicate:likePredicate2]);
//    MATCHES
    NSPredicate *matchPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[a-z]+$"];
    PHLog(@"%@ : %@",matchPredicate.description,[strings filteredArrayUsingPredicate:matchPredicate]);
}

- (void)stringComparisonContain {
    NSArray *strings = self.strings;
    PHLog(@"strings : %@",strings);
    NSPredicate *containPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] 'af'"];
    PHLog(@"%@ : %@",containPredicate.description,[strings filteredArrayUsingPredicate:containPredicate]);
}
- (void)stringComparisonBeginAndEnd {
    NSArray *strings = self.strings;
    PHLog(@"strings : %@",strings);
    //    BEGINSWITH
    NSPredicate *beginwithPredicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH %@",@"Co"];
    PHLog(@"%@ : %@",beginwithPredicate.description,[strings filteredArrayUsingPredicate:beginwithPredicate]);
    //    ENDSWITH
    NSPredicate *endwithPredicate = [NSPredicate predicateWithFormat:@"SELF ENDSWITH %@",@"r"];
    PHLog(@"%@ : %@",endwithPredicate.description,[strings filteredArrayUsingPredicate:endwithPredicate]);
}
- (void)stringComparisonLike {
    NSArray *strings = self.strings;
    PHLog(@"strings : %@",strings);
    //    LIKE
    NSPredicate *likePredicate1 = [NSPredicate predicateWithFormat:@"SELF LIKE %@",@"*o*e"];
    PHLog(@"%@ : %@",likePredicate1.description,[strings filteredArrayUsingPredicate:likePredicate1]);
    NSPredicate *likePredicate2 = [NSPredicate predicateWithFormat:@"SELF LIKE %@",@"*o?e*"];
    PHLog(@"%@ : %@",likePredicate2.description,[strings filteredArrayUsingPredicate:likePredicate2]);
}

- (void)stringComparisonMatch {
    NSArray *strings = self.strings;
    PHLog(@"strings : %@",strings);
    //    MATCHES
    NSPredicate *matchPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[a-z]+$"];
    PHLog(@"%@ : %@",matchPredicate.description,[strings filteredArrayUsingPredicate:matchPredicate]);
}
#pragma mark - keyPath

-(void)keyPath_avg {
//    avg
    NSArray *notes = self.notes;
    PHLog(@"notes : %@", notes);
    NSPredicate *avg5Predicate = [NSPredicate predicateWithFormat:@"expenses.@avg.doubleValue >= 5.0"];
    PHLog(@"%@ : %@",avg5Predicate.description, [notes filteredArrayUsingPredicate:avg5Predicate]);
}
- (void)keyPath_sum {
    NSArray *notes = self.notes;
    PHLog(@"notes : %@", notes);
    NSPredicate *sumPredicate = [NSPredicate predicateWithFormat:@"expenses.@sum.doubleValue == 24.0"];
    PHLog(@"%@ : %@",sumPredicate.description, [notes filteredArrayUsingPredicate:sumPredicate]);
}
- (void)keyPath_max_min {
    NSArray *notes = self.notes;
    PHLog(@"notes : %@", notes);
    NSPredicate *maxPredicate = [NSPredicate predicateWithFormat:@"expenses.@max.doubleValue <= 11.0"];
    PHLog(@"%@ : %@",maxPredicate.description, [notes filteredArrayUsingPredicate:maxPredicate]);
}
- (void)keyPath_count {
    NSArray *notes = self.notes;
    PHLog(@"notes : %@", notes);
    NSPredicate *countPredicate = [NSPredicate predicateWithFormat:@"expenses.@count.integerValue == 5"];
    PHLog(@"%@ : %@",countPredicate.description, [notes filteredArrayUsingPredicate:countPredicate]);
}
#pragma mark - 存在
- (void)aggregate {
    NSArray *notes = self.notes;
    PHLog(@"notes : %@", notes);
    NSPredicate *anyPredicate = [NSPredicate predicateWithFormat:@"ANY expenses == 11"];
    PHLog(@"%@ : %@",anyPredicate.description, [notes filteredArrayUsingPredicate:anyPredicate]);
    NSPredicate *allPredicate = [NSPredicate predicateWithFormat:@"ALL expenses == 11"];
    PHLog(@"%@ : %@",allPredicate.description, [notes filteredArrayUsingPredicate:allPredicate]);
    NSPredicate *somePredicate = [NSPredicate predicateWithFormat:@"SOME expenses == 11"];
    PHLog(@"%@ : %@",somePredicate.description, [notes filteredArrayUsingPredicate:somePredicate]);
    NSPredicate *nonePredicate = [NSPredicate predicateWithFormat:@"NONE expenses == 11"];
    PHLog(@"%@ : %@",nonePredicate.description, [notes filteredArrayUsingPredicate:nonePredicate]);
}
@end



