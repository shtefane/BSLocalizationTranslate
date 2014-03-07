//
//  BSSelectViewController.m
//  LocalizationTranslate
//
//  Created by Balica S on 07/03/2014.
//  Copyright (c) 2014 Balica Stefan. All rights reserved.
//

#import "BSSelectViewController.h"

#import "BSTranslateViewController.h"

@interface BSSelectViewController ()
{
    
    NSArray *languages;
}

@end

@implementation BSSelectViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"languages" ofType:@"plist"];
    languages = [NSArray arrayWithContentsOfFile:path];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [languages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellLanguage";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    UILabel *langLbl = (UILabel*)[cell viewWithTag:1];
    NSDictionary *lang = [languages objectAtIndex:indexPath.row];
    
    langLbl.text = [NSString stringWithFormat:@"%@ %@", [lang objectForKey:@"language"],[lang objectForKey:@"code"] ];
    
    return cell;
}



#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"translateSegue"]) {
        
        NSInteger selIndex = [self.tableView indexPathForSelectedRow].row;
        [[segue destinationViewController] setLanguageInfo:[languages objectAtIndex:selIndex]];
    }
}



@end
