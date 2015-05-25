//
//  ViewController.m
//  SocketDemo
//
//  Created by wayne on 15/1/9.
//  Copyright (c) 2015年 zh.wayne. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#include <netdb.h> 


@interface ViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>
{
    CGSize _scrennSize;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _scrennSize = [UIScreen mainScreen].bounds.size;
    _dataSource = [NSMutableArray new];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, _scrennSize.width, _scrennSize.height - 200) style:UITableViewStylePlain];
    _tableView.layer.borderWidth = .5f;
    _tableView.layer.borderColor = [UIColor grayColor].CGColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleReceivedData:) name:@"TCUdpSocketReveivedData" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_dataSource removeAllObjects];
    [_tableView reloadData];
    
    
    NSData *data = [@"online:?" dataUsingEncoding:NSUTF8StringEncoding];
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate.udpSocket sendMulticastData:data];
}


#pragma mark -
- (void)handleReceivedData:(NSNotification *)notification
{
    NSData *data = [notification.userInfo objectForKey:@"data"];
    NSData *address = [notification.userInfo objectForKey:@"address"];
    NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *host = nil;
    uint16_t port = 0;
    [TCUdpSocket getHost:&host port:&port fromAddress:address];
    
    
    NSMutableDictionary *info = [NSMutableDictionary new];
    [info setValue:host forKey:@"host"];
    [info setValue:@(port) forKey:@"port"];
    
    
    if([dataStr isEqualToString:@"online:!"]){
        NSLog(@"收到成员%@回复.", host);
    }
    else if([dataStr isEqualToString:@"online:?"]){
        NSLog(@"回复我在线.");
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        [delegate.udpSocket sendData:[@"online:!" dataUsingEncoding:NSUTF8StringEncoding] serviveHost:host servicePort:port];
    }
    
    __block BOOL shouldAdd = YES;
    [_dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([[obj objectForKey:@"host"] isEqualToString:host]){
            shouldAdd = NO;
            return;
        }
    }];
    
    if(shouldAdd == YES){
        [_dataSource addObject:info];
    }
    
    [_tableView reloadData];
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    NSDictionary *info = [_dataSource objectAtIndex:indexPath.row];
    NSString *host = [info objectForKey:@"host"];
    NSString *port = [[info objectForKey:@"port"] stringValue];
    
    [cell.textLabel setText:host];
    [cell.detailTextLabel setText:port];
    
    return cell;
}

@end
