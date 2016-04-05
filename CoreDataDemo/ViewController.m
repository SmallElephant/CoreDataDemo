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
//
//@property (strong,nonatomic) AppDelegate *appDelegate;

@property (strong,nonatomic) Book *book;

@property (strong,nonatomic) NSMutableArray *dataSource;

@property (strong,nonatomic) FEDataManger *dataManger;


@property (weak, nonatomic) IBOutlet UITextField *textField;

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
    self.dataManger=[[FEDataManger alloc]init];
    self.context=self.dataManger.managedObjectContext;
    NSArray *arr=@[@"FlyElephant",@"keso",@"Small",@"SQL",@"iOS",@"Objective-C",@"Swift"];
    self.dataSource=[NSMutableArray arrayWithArray:arr];
    NSLog(@"%@",NSHomeDirectory());
}

- (IBAction)insertData:(UIButton *)sender {
    Book *insertBook=[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Book class]) inManagedObjectContext:self.context];
    if (self.textField.text.length) {
        insertBook.author=self.textField.text;
        [self.dataManger saveContext];
        NSLog(@"数据插入成功--%@--",self.textField.text);
    }
}

- (IBAction)updateData:(UIButton *)sender {
    if (self.textField.text.length) {
        NSFetchRequest *request =[[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription entityForName:NSStringFromClass([Book class]) inManagedObjectContext:self.context];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"author like %@", self.textField.text];
        request.predicate = predicate;
        NSError *error = nil;
        NSArray *objs = [self.context executeFetchRequest:request error:&error];
        if (error) {
            [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
        }
        for (NSManagedObject *obj in objs) {
            
            NSLog(@"作者=%@", [obj valueForKey:@"author"]);
            NSString *updateValue=[NSString stringWithFormat:@"%@修改",[obj valueForKey:@"author"]];
            [obj  setValue:updateValue forKey:@"author"];
        }
        [self.dataManger saveContext];
        NSLog(@"更新成功");
    }
}

- (IBAction)searchData:(UIButton *)sender {
    if (self.textField.text.length) {
        NSFetchRequest *request =[[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription entityForName:NSStringFromClass([Book class]) inManagedObjectContext:self.context];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"author contains %@", self.textField.text];
        request.predicate = predicate;
        NSError *error = nil;
        NSArray *objs = [self.context executeFetchRequest:request error:&error];
        if (error) {
            [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
        }
        for (NSManagedObject *obj in objs) {
            NSLog(@"作者=%@", [obj valueForKey:@"author"]);
        }
        NSLog(@"查询成功");
    }else{
        NSFetchRequest *request =[[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription entityForName:NSStringFromClass([Book class]) inManagedObjectContext:self.context];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"author != ''"];
        request.predicate = predicate;
        NSError *error = nil;
        NSArray *objs = [self.context executeFetchRequest:request error:&error];
        if (error) {
            [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
        }
        for (NSManagedObject *obj in objs) {
            NSLog(@"作者=%@", [obj valueForKey:@"author"]);
        }
        NSLog(@"查询成功");
    }
}

- (IBAction)deleteData:(UIButton *)sender {
    if (self.textField.text.length) {
        NSFetchRequest *request =[[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription entityForName:NSStringFromClass([Book class]) inManagedObjectContext:self.context];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"author contains %@", self.textField.text];
        request.predicate = predicate;
        NSError *error = nil;
        NSArray *objs = [self.context executeFetchRequest:request error:&error];
        if (error) {
            [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
        }
        for (NSManagedObject *obj in objs) {
            NSLog(@"作者=%@", [obj valueForKey:@"author"]);
            [self.context deleteObject:obj];
        }
        [self.dataManger saveContext];
        NSLog(@"删除成功");
    }else{
        NSFetchRequest *request =[[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription entityForName:NSStringFromClass([Book class]) inManagedObjectContext:self.context];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"author != ''"];
        request.predicate = predicate;
        NSError *error = nil;
        NSArray *objs = [self.context executeFetchRequest:request error:&error];
        if (error) {
            [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
        }
        for (NSManagedObject *obj in objs) {
            NSLog(@"作者=%@", [obj valueForKey:@"author"]);
            [self.context deleteObject:obj];
        }
        [self.dataManger saveContext];
        NSLog(@"删除成功");
    }
}

@end
