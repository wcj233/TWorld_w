//
//  SearchLocationViewController.m
//  PhoneWorld
//
//  Created by sheshe on 2021/1/11.
//  Copyright © 2021 xiyoukeji. All rights reserved.
//

#import "SearchLocationViewController.h"

@interface SearchLocationViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,BMKSuggestionSearchDelegate,BMKPoiSearchDelegate>

@property (nonatomic) UISearchBar *searchBar;
@property (nonatomic) BMKPOICitySearchOption *cityOption;
@property (nonatomic) BMKPoiSearch *POISearch;
@property (nonatomic) UITableView *resultTableView;
@property (nonatomic) NSArray *dataArray;
@property (nonatomic) NSMutableArray *searchResultArray;


@end

@implementation SearchLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchResultArray = [NSMutableArray array];
    self.dataArray = [NSArray array];
    
    [self setupSearcher];
}

-(void)setCity:(NSString *)city{
    _city = city;
    [self setUpView];
    [self resultTableView];
}

//初始化搜索
- (void)setupSearcher
{
    self.POISearch = [[BMKPoiSearch alloc] init];
        //设置POI检索的代理
    self.POISearch.delegate = self;
        //初始化请求参数类BMKCitySearchOption的实例
    self.cityOption = [[BMKPOICitySearchOption alloc]init];
        //检索关键字，必选。举例：天安门
    self.cityOption.keyword = @"";
        //区域名称(市或区的名字，如北京市，海淀区)，最长不超过25个字符，必选
    self.cityOption.city = self.city;
    self.cityOption.pageIndex = 0;
    //单次召回POI数量，默认为10条记录，最大返回20条
    self.cityOption.pageSize = 20;
        /**
         城市POI检索：异步方法，返回结果在BMKPoiSearchDelegate的onGetPoiResult里
         cityOption 城市内搜索的搜索参数类（BMKCitySearchOption）
         成功返回YES，否则返回NO
         */
        BOOL flag = [self.POISearch poiSearchInCity:self.cityOption];
        if(flag) {
            NSLog(@"POI城市内检索成功");
        } else {
            NSLog(@"POI城市内检索失败");
        }
}

- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPOISearchResult *)poiResult errorCode:(BMKSearchErrorCode)error {
    if (self.searchResultArray.count > 0) {
        [self.searchResultArray removeAllObjects];
    }
    //------------------------------------------周边搜索
    NSArray *arr = poiResult.poiInfoList;
    for (BMKPoiInfo *info in arr) {
        [self.searchResultArray addObject:info];
    }

    self.dataArray = self.searchResultArray;
    if (self.resultTableView) {
        [self.resultTableView reloadData];
    }
    
    
}

#pragma mark - Lazy


- (UITableView *)resultTableView
{
    if (!_resultTableView) {
        _resultTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _resultTableView.delegate = self;
        _resultTableView.dataSource = self;
        [self.view addSubview:_resultTableView];
        
        [_resultTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.view);
            make.top.mas_equalTo(self.searchBar.mas_bottom);
        }];
        _resultTableView.tableFooterView = [[UIView alloc]init];
    }
    return _resultTableView;
}

-(void)setUpView{
    self.title = @"地址选择";
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"定位"]];
    [self.view addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(20);
        make.width.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    UILabel *cityLabel = [UILabel labelWithTitle:self.city color:kSetColor(@"333333") font:font16 alignment:0];
    [self.view addSubview:cityLabel];
    [cityLabel sizeToFit];
    [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconImageView.mas_right).mas_equalTo(5);
        make.centerY.mas_equalTo(iconImageView);
        make.height.mas_equalTo(22);
//        make.width.mas_equalTo();
    }];
    
    self.searchBar = [[UISearchBar alloc]init];
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"小区/街道/大厦/学校名称";
    self.searchBar.showsCancelButton = NO;
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cityLabel.mas_right).mas_equalTo(10);
        make.centerY.mas_equalTo(iconImageView);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(-10);
    }];
    
    self.searchBar.layer.borderWidth=1;
    if (@available(iOS 13.0, *)) {
        self.searchBar.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    } else {
        // Fallback on earlier versions
        [self getSearchField:self.searchBar];
    }
    self.searchBar.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)getSearchField:(UIView *)view {
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            UITextField *searchTextField = (UITextField *)subView;
            searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            break;;
        }
    }
}

#pragma mark - searchBar代理
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
//    searchBar.showsCancelButton = YES;
    
    return YES;
}
 
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}
 
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar __TVOS_PROHIBITED
{
//    searchBar.showsCancelButton = NO;
//    if (!searchView.isHidden) {
////        [searchView removeFromSuperview];
//        searchView.hidden = YES;
//    }
    [searchBar resignFirstResponder];
//
    [self.searchResultArray removeAllObjects];
    [self.resultTableView reloadData];
}
 
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //option是百度搜索类的BMKSuggestionSearchOption，searcher是BMKSuggestionSearch
    
    if ([searchText isEqualToString:@""]) {
        self.searchResultArray = [NSMutableArray array];
        [self.resultTableView reloadData];
    }else{
        self.cityOption = [[BMKPOICitySearchOption alloc] init];
        self.cityOption.city = self.city;
        self.cityOption.keyword = searchText;
        self.cityOption.pageIndex = 0;
        //单次召回POI数量，默认为10条记录，最大返回20条
        self.cityOption.pageSize = 20;
        [self.POISearch poiSearchInCity:self.cityOption];
    }
}
 
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.cityOption = [[BMKPOICitySearchOption alloc] init];
    self.cityOption.city = self.city;
    self.cityOption.keyword = searchBar.text;
    self.cityOption.pageIndex = 0;
    //单次召回POI数量，默认为10条记录，最大返回20条
    self.cityOption.pageSize = 20;
    [self.POISearch poiSearchInCity:self.cityOption];
 
    [searchBar resignFirstResponder];
}



#pragma mark - tableView代理
 
#pragma mark - tableView datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResultArray.count;
}
 
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"resultCell"];
    //自定义的model存储搜索结果的地址名和坐标字段
    BMKPoiInfo *info = self.searchResultArray[indexPath.row];
    cell.textLabel.text = info.name;
    cell.detailTextLabel.text = info.address;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BMKPoiInfo *info = self.searchResultArray[indexPath.row];
//    self.mycallBack([NSString stringWithFormat:@"%@%@",info.address,info.name]);
    self.mycallBack(info);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.searchBar resignFirstResponder];
}

@end
