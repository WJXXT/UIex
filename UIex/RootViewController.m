//
//  RootViewController.m
//  UIex
//
//  Created by XXT on 15/9/17.
//  Copyright (c) 2015年 XXT. All rights reserved.
//

#import "RootViewController.h"
#import "RootCell.h"
#import "CartorgViewController.h"
#import "RequestHandle.h"
#import "CommonDefine.h"
#import "SignatrueEncryption.h"
#import "rootData.h"
#import "QXBModelTool.h"
#import "UIImageView+WebCache.h"
@interface RootViewController ()<RequestHandleDelegate>
@property (nonatomic,retain)RequestHandle *requestHandle;//记录网络请求
@property (nonatomic,retain)NSMutableArray *rootArr;
@property (nonatomic,copy)NSString *titles;
@property (nonatomic,retain)rootData *data;
@end

@implementation RootViewController
- (IBAction)leftBarAction:(id)sender {
    CartorgViewController *cartorg =[[CartorgViewController alloc]init];
    [self.navigationController pushViewController:cartorg animated:YES];

}
- (IBAction)rigthBarAction:(id)sender {
    [self.tableView reloadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeColor:) name:@"name" object:nil];
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _titles =@"生活家居";
    [self.tableView registerNib:[UINib nibWithNibName:@"RootCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"pepe"];
}

-(void)requestData{
//http://api.dianping.com/v1/deal/find_deals?appkey=42960815&sign=34691B2D691C0C23FA8AE643DF3178E508250585&city=%E4%B8%8A%E6%B5%B7&category=%E7%BE%8E%E9%A3%9F&limit=30&page=1
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"上海",@"city",@"生活家居",@"category",@"30",@"limit",@"1",@"page",nil];
    [dic setValue:_titles forKey:@"category"];
    NSMutableDictionary *request =[SignatrueEncryption encryptedParamsWithBaseParams:dic];
    NSLog(@"%@",request);
    NSString *category= [request valueForKey:@"category"];
    NSString *city= [request valueForKey:@"city"];
    NSString *limit= [request valueForKey:@"limit"];
    NSString *page= [request valueForKey:@"page"];
    NSString *sign= [request valueForKey:@"sign"];
    NSString *str =[NSString stringWithFormat:@"http://api.dianping.com/v1/deal/find_deals?appkey=42960815&sign=%@&city=%@&category=%@&limit=%@&page=%@",sign,city,category,limit,page];

    self.requestHandle =[[RequestHandle alloc]initWithURLString:str parameter:nil requestMethod:@"GET" delegate:self];
}

-(void)changeColor:(NSNotification *)notification{
    NSDictionary *dic =[notification valueForKey:@"userInfo"];
    NSString *title =[dic valueForKey:@"name"];
    if(title !=nil){
    _titles=title;
    self.navigationItem.title =_titles;
    }
}

#pragma mark -RequestHandleDelegate
//加载成功
-(void)requestHandle:(RequestHandle *)requestHandle didSucceedWithData:(NSData *)data{
    NSDictionary *dataDic =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSMutableArray *datast =[dataDic valueForKey:@"deals"];
        self.rootArr =[NSMutableArray array];
    for (NSDictionary *dic in datast) {
        rootData *data =[[rootData alloc]init];
        data.title= [dic valueForKey:@"title"];

        data.descirptions =[dic valueForKey:@"description"];
//        NSLog(@"%@",[dic valueForKey:@"description"]);
        data.image_url =[dic valueForKey:@"image_url"];
        data.categories =[dic valueForKey:@"categories"];
                    NSLog(@"%@",_titles);
        for (NSString *categories in data.categories) {
            if ([categories isEqualToString:_titles]) {

                [_rootArr addObject:data];
//                NSLog(@"%@",data);
            }
        }

    }
    [self.tableView reloadData];
}
//加载失败
-(void)requestHandle:(RequestHandle *)requestHandle didFailWithError:(NSError *)error{
    NSLog(@"请求失败!%@",error);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    return _rootArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RootCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pepe" forIndexPath:indexPath];
//    NSLog(@"%@",_rootArr[indexPath.row]);
    rootData *data = _rootArr[indexPath.row];
    cell.nameLab.text =data.title;
    cell.detalLab.text =data.descirptions;
    [cell.imgv sd_setImageWithURL:[NSURL URLWithString:data.image_url] placeholderImage:[UIImage imageNamed:@"picholder.png"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 134;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
