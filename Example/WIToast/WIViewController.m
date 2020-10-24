//
//  WIViewController.m
//  IToast
//
//  Created by huipengo on 10/24/2020.
//  Copyright (c) 2020 huipengo. All rights reserved.
//

#import "WIViewController.h"
#import "WIToast.h"

@interface WIViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *datas;

@end

@implementation WIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.datas = @[ @"图文 Toast", @"纯文本 Toast，纯文本 Toast，纯文本 Toast，纯文本 Toast，纯文本 Toast，纯文本 Toast", @"纯图 Toast" ];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"wi_cell_identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
    }
    cell.textLabel.text = self.datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *message = self.datas[indexPath.row];
    if (indexPath.row == 0) {
        [WIToast showSuccess:message];
    }
    else if (indexPath.row == 1) {
        [WIToast showInfo:message];
    }
    else if (indexPath.row == 2) {
        [WIToast showImage:[UIImage imageNamed:@"AppStore"]];
    }
}

@end
