//
//  GoogleSearchView.m
//  CLOrder
//
//  Created by Naveen Thukkani on 21/06/18.
//  Copyright © 2018 Vegunta's. All rights reserved.
//

#import "GoogleSearchView.h"
#import "AppHeader.h"
#import "APIRequester.h"
#import "APIRequest.h"

@interface GoogleSearchView ()

@end

@implementation GoogleSearchView
@synthesize object,locationsObjects,objects;
- (void)viewDidLoad {
    [super viewDidLoad];
    searchBars= [[UISearchBar alloc] init];
    [searchBars sizeToFit];
    searchBars.delegate=self;
    searchBars.placeholder=@"Search";
    searchBars.backgroundColor=[UIColor clearColor];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 10, 20, 20);
    [backButton setImage:[UIImage imageNamed:@"left-arrow"] forState:UIControlStateNormal];
    UIBarButtonItem * menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = searchBars;
    self.navigationItem.leftBarButtonItems=[[NSArray alloc] initWithObjects: menuBarButton, nil];
    
    autoCompleteData=[[NSMutableArray alloc] initWithCapacity:0];
    self.tableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
}
-(void)backButtonAction{
    [searchBars resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    //NSLog(@"searchBarTextDidEndEditing");
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if([searchText length] > 2)
    {
        [self autoCompleteApi:searchText];
    }
    
}
-(void)autoCompleteApi:(NSString *)string
{
    NSString *encode = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
    NSString *url=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?key=%@&input=%@&components=country:us",GOOGLE_API_KEY,encode];
    [APIRequest googleAutoComplteApi:nil url:url completion:^(NSMutableData *buffer) {
        if(!buffer){
        }else{
            [autoCompleteData removeAllObjects];
            NSError *error = nil;
            NSDictionary *resObj = [NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"Response :\n %@",resObj);
            [autoCompleteData addObject:resObj];
            [self.tableView reloadData];
        }
    }];
            

}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if([searchBar.text length] > 2)
    {
        [self autoCompleteApi:searchBar.text];
    }
    [searchBar resignFirstResponder];}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(autoCompleteData.count > 0){
        return  [[[autoCompleteData objectAtIndex:0] objectForKey:@"predictions"] count];
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 55;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@""];
    cell.textLabel.font = APP_FONT_BOLD_18;
    [cell.textLabel setTextColor:DARK_GRAY];
    cell.detailTextLabel.font = APP_FONT_REGULAR_16;
    [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
    NSMutableArray *collections;
        if(autoCompleteData.count  > 0)
        {
            collections=[[NSMutableArray alloc]initWithArray:[self splitingTheData:indexPath.row section:indexPath.section]];
        }
        cell.textLabel.text=[self splitigValues:indexPath.row label:@"textLabel" arry:collections];
        cell.detailTextLabel.text=[self splitigValues:indexPath.row label:@"detailTextLabel" arry:collections];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [searchBars resignFirstResponder];
    NSString *string=[self splitigValues:indexPath.row label:@"textLabel" arry:[[NSMutableArray alloc]initWithArray:[self splitingTheData:indexPath.row section:indexPath.section]]];
    if(_fromOrderOnline){
        NSString *encode = [[[[[autoCompleteData objectAtIndex:0]objectForKey:@"predictions"] objectAtIndex:indexPath.row] objectForKey:@"description"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
        [self gettingLatLong:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&key=%@",encode,GOOGLE_API_KEY]];
    }else{
        [object addressSelection:string locationDetails:locationsObjects];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)gettingLatLong:(NSString *)string{
    [APIRequest gettingLatLong:nil url:string completion:^(NSMutableData *buffer) {
        if(!buffer){
            
        }else{
            NSError *error = nil;
            NSDictionary *resObj = [NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"Response :\n %@",resObj);
            if(![[resObj objectForKey:@"status"]  isEqualToString:@"ZERO_RESULTS"])
            {
                locationsObjects.latitude=[[[[[[resObj objectForKey:@"results"] objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"] doubleValue];
                locationsObjects.longitude=[[[[[[resObj objectForKey:@"results"] objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"] doubleValue];
                [objects addressSelection:[NSString stringWithFormat:@"%@", [[[resObj objectForKey:@"results"] objectAtIndex:0] objectForKey:@"formatted_address"]] locationDetails:locationsObjects];
                [self.navigationController popViewControllerAnimated:YES];

            }
        }
    }];
}
-(NSArray *)splitingTheData:(NSInteger)row section:(NSInteger)section
{
    if(section==0){
        NSArray *parameters = [[[[[autoCompleteData objectAtIndex:0] objectForKey:@"predictions"] objectAtIndex:row] objectForKey:@"description"] componentsSeparatedByString:@","];
        return parameters;
    }
    return nil;
}
-(NSString *)splitigValues:(NSInteger)row label:(NSString *)labelName arry:(NSMutableArray *)collections
{
    if([labelName isEqualToString:@"textLabel"])
    {
        if(collections.count > 2)
            return [NSString stringWithFormat:@"%@,%@",[collections objectAtIndex:0],[collections objectAtIndex:1]];
        else if(collections.count > 1)
        {
            return [NSString stringWithFormat:@"%@",[collections objectAtIndex:0]];
        }else if(collections.count==0){
            return @"";
        }
    }else{
        if (collections.count > 2)
        {
            NSString *string=@"";
            for(int i=2; i< collections.count; i++)
            {
                if(!((collections.count-1)==i))
                    string=[string stringByAppendingString:[NSString stringWithFormat:@"%@,",[collections objectAtIndex:i]]];
                else{
                    string=[string stringByAppendingString:[NSString stringWithFormat:@"%@",[collections objectAtIndex:i]]];
                }
            }
            return  string;
        }
    }
    return @"";
}

@end
