//
//  CartorgViewController.m
//  UIex
//
//  Created by XXT on 15/9/17.
//  Copyright (c) 2015年 XXT. All rights reserved.
//

#import "CartorgViewController.h"

@interface CartorgViewController ()<NSXMLParserDelegate>
@property (nonatomic ,copy)NSString *contentStr;//记录读取内容
@property (nonatomic ,copy)NSString *fromName;//发信人
@property (nonatomic ,copy)NSString *messageContent;//信息
@property (nonatomic ,copy)NSString *toName;
@property (nonatomic ,copy)NSString *time;//时间

@property (nonatomic,retain)NSMutableDictionary *categoryDic;
@property (nonatomic,retain)NSMutableArray *categoryArr;
@end

@implementation CartorgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"name" object:nil userInfo:@{@"color":self.view.backgroundColor}];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title =@"所有分类";
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    [self xmlData];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}
-(void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)xmlData{
    self.categoryDic =[NSMutableDictionary dictionary];
    //获取文件路径
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"Categories" ofType:@"xml"];
    //读取文件内容
    NSData *parseData = [NSData dataWithContentsOfFile:filePath];
    //创建解析对象
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:parseData];
    //设置代理
    parser.delegate = self;
    //解析
    [parser parse];
    
    
}
#pragma mark - SAX解析
//读取到开始标签
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if ([elementName isEqualToString:@"category_name"]) {
        self.categoryArr =[NSMutableArray array];
    }
}
//获取内容
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    self.contentStr =string;
}
//读取到结束标签
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if([elementName isEqualToString:@"category_name"]){
        //将对应分组放入字典
        [_categoryDic setValue:_categoryArr forKey:_contentStr];
    }else if ([elementName isEqualToString:@"subcategories"]){
        [_categoryArr addObject:_contentStr];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

//    NSLog(@"%ld",_categoryDic.allKeys.count);
    return _categoryDic.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key =_categoryDic.allKeys[section];
    NSMutableArray *group = [_categoryDic valueForKey:key];
    return group.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    NSString *key =_categoryDic.allKeys[indexPath.section];
    NSMutableArray *group = [_categoryDic valueForKey:key];
    cell.textLabel.text =[group objectAtIndex:indexPath.row];
    
    
    return cell;
}
//设置分区 title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _categoryDic.allKeys[section];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key =_categoryDic.allKeys[indexPath.section];
    NSMutableArray *group = [_categoryDic valueForKey:key];
     [[NSNotificationCenter defaultCenter]postNotificationName:@"name" object:nil userInfo:@{@"name":[group objectAtIndex:indexPath.row]}];
    [self.navigationController popViewControllerAnimated:YES];
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
