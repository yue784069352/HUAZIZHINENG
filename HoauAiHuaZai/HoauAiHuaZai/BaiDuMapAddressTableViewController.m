//
//  BaiDuMapAddressTableViewController.m
//  HoauAiHuaZai
//
//  Created by 岳俊杰 on 2017/9/18.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "BaiDuMapAddressTableViewController.h"

@interface BaiDuMapAddressTableViewController ()
@property(nonatomic,strong)NSMutableArray * poiNameArray,*poiAddressArray;


@end

@implementation BaiDuMapAddressTableViewController
-(NSMutableArray *)poiNameArray
{
    if (!_poiNameArray)
    {
        _poiNameArray = [[NSMutableArray alloc]init];
        
    }
    return _poiNameArray;
    
}
-(NSMutableArray *)poiAddressArray
{
    if (!_poiAddressArray)
    {
        _poiAddressArray = [[NSMutableArray alloc]init];
        
    }
    return _poiAddressArray;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"当前位置周边";
    for (BMKPoiInfo *poiInfo in self.reslutsPoiInfoList)
    {
        [self.poiNameArray addObject:poiInfo.name];
        [self.poiAddressArray addObject:poiInfo.address];
    }
    self.tableView.tableFooterView = [UIView new];
    [self.tableView reloadData];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.reslutsPoiInfoList.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"addressCell"];
        
    }
   
        cell.textLabel.text = self.poiNameArray[indexPath.row];
        cell.detailTextLabel.text = self.poiAddressArray[indexPath.row];
   
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.addressMapName(self.poiAddressArray[indexPath.row]);
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



@end
