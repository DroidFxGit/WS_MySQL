//
//  ReportsTableViewController.m
//  WS MySQL
//
//  Created by DroidFx on 4/2/15.
//  Copyright (c) 2015 DroidFx. All rights reserved.
//

#import "ReportsTableViewController.h"
#import "protoCellTableViewCell.h"
#import "ViewController.h"
#import "Location.h"

@interface ReportsTableViewController ()
{
    HomeModel *_homeModel;
    NSArray *_feedItems;
    Location *_selectedLocation;
}
@end

@implementation ReportsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.backgroundColor = [UIColor grayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];

    //self.tableView.delegate = self;
    //self.tableView.dataSource = self;
    
    // Create array object and assign it to _feedItems variable
    _feedItems = [[NSArray alloc] init];
    
    // Create new HomeModel object and assign it to _homeModel variable
    _homeModel = [[HomeModel alloc] init];
    
    // Set this view controller object as the delegate for the home model object
    _homeModel.delegate = self;
    
    // Call the download items method of the home model object
    [self downloadDatafromInterface];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)itemsDownloaded:(NSArray *)items
{
    // This delegate method will get called when the items are finished downloading
    if (_feedItems == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to get Data, please try again or later..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else {
        
        // Set the downloaded items to the array
        _feedItems = items;
        
        // Reload the table view
        [self.tableView reloadData];
        //[self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:0.5];
    }
    
}

- (void)reloadData {
    
    [self downloadDatafromInterface];
    
    // Reload table data
    [self.tableView reloadData];
    
    // End the refreshing
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Ultima actualización: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
    
        [UIView animateWithDuration:2.0 animations:^{
            self.tableView.alpha = 0.85;
        } completion:^(BOOL finished) {
            self.tableView.alpha = 1.0;
            [self.refreshControl endRefreshing];
        }];
        
        
    }

}


- (void)downloadDatafromInterface {
    
    [_homeModel downloadItems];
    
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of feed items (initially 0)
    return _feedItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Retrieve cell
    NSString *cellIdentifier = @"reportCell";
    protoCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                   forIndexPath:indexPath];
    
    // Configure the cell...
    Location *item = _feedItems[indexPath.row];
    
    cell.titleField.text = item.address;
    cell.dateTimeField.text = item.dateTime;
    
    return cell;
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


#pragma mark - Navigation


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set selected location to var
    _selectedLocation = _feedItems[indexPath.row];
    
    // Manually call segue to detail view controller
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        
        // Get reference to the destination view controller
        ViewController *detailViewController = segue.destinationViewController;
        
        // Set the property to the selected location so when the view for
        // detail view controller loads, it can access that property to get the feeditem obj
        detailViewController.selectedLocation = _selectedLocation;
    }
    
    
}


- (IBAction)performAdd:(id)sender {
    
     [self performSegueWithIdentifier:@"performSegueAdd" sender:self];
}
@end
