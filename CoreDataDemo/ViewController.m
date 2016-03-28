//
//  ViewController.m
//  CoreDataDemo
//
//  Created by keso on 16/3/20.
//  Copyright © 2016年 FlyElephant. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Book.h"
#import "FEDataManger.h"
@interface ViewController ()

@property (strong,nonatomic) NSManagedObjectContext *context;

@property (strong,nonatomic) AppDelegate *appDelegate;

@property (strong,nonatomic) Book *book;

@property (copy,nonatomic) NSMutableArray *dataSource;

@property (strong,nonatomic) FEDataManger *dataManger;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setup

-(void)setup{
//    self.appDelegate=[UIApplication sharedApplication].delegate;
//    self.context=self.appDelegate.managedObjectContext;
   
    
    self.dataManger=[[FEDataManger alloc]init];
    self.context=self.dataManger.managedObjectContext;
     NSLog(@"%@",NSHomeDirectory());
}

-(void)searchData{
    
}

- (IBAction)insertData:(UIButton *)sender {
    self.book=[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Book class]) inManagedObjectContext:self.context];
    self.book.author=@"FlyElephant";
//    [self.appDelegate saveContext];
    
    [self.dataManger saveContext];
    NSLog(@"数据插入成功");
}

- (IBAction)updateData:(UIButton *)sender {
    self.book.author=@"Book更新";
    [self.appDelegate saveContext];
    NSLog(@"修改成功");
}

- (IBAction)searchData:(UIButton *)sender {
    // 初始化一个查询请求
    NSFetchRequest *request =[[NSFetchRequest alloc] init];
    // 设置要查询的实体
    request.entity = [NSEntityDescription entityForName:NSStringFromClass([Book class]) inManagedObjectContext:self.context];

//    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO];
//    request.sortDescriptors = [NSArray arrayWithObject:sort];
    // 设置条件过滤(搜索name中包含字符串"Itcast-1"的记录，注意：设置条件过滤时，数据库SQL语句中的%要用*来代替，所以%Itcast-1%应该写成*Itcast-1*)
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"author like %@", @"*Itcast-1*"];
//    request.predicate = predicate;
    // 执行请求
    NSError *error = nil;
    NSArray *objs = [self.context executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    // 遍历数据
    for (NSManagedObject *obj in objs) {
    
        NSLog(@"作者=%@", [obj valueForKey:@"author"]);
    }
    NSLog(@"查询成功");
}

- (IBAction)deleteData:(UIButton *)sender {
    [self.context deleteObject:self.book];
    NSLog(@"删除成功");
}

@end
