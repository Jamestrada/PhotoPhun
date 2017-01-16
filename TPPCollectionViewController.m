//
//  TPPCollectionViewController.m
//  PhotoPhun
//
//  Created by James Estrada on 15/01/2017.
//  Copyright © 2017 James Estrada. All rights reserved.
//

#import "TPPCollectionViewController.h"
#import "TPPUICollectionViewCell.h"

NSString *const DATA_VERSION_DATE = @"20160627";
NSString *const DATA_FORMAT = @"foursquare";

@implementation TPPCollectionViewController


-(void)viewDidLoad{
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.topItem.title = @"PhotoPhun";
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.accessToken = [defaults stringForKey:@"accessToken"];
    
    if(self.accessToken == nil){
        //get token
        [SimpleAuth authorize:@"foursquare-web" completion:^(id responseObject, NSError *error) {
            NSLog(@"response: %@", responseObject);
            NSString *token = responseObject[@"credentials"][@"token"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:token forKey:@"accessToken"];
            [defaults synchronize];
            
            self.accessToken = token; //set token first before calling refreshFoursquare
            [self refreshFoursquare];
        }];
        
    }else{
        //use token, get venue data
        [self refreshFoursquare];
    }
}

-(void)refreshFoursquare{
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = [[NSString alloc]initWithFormat:@"https://api.foursquare.com/v2/users/self/venuelikes/?oauth_token=%@&v=%@&m=%@", self.accessToken, DATA_VERSION_DATE, DATA_FORMAT];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //            NSLog(@"Response: %@", response);
        //            NSString *text = [[NSString alloc]initWithContentsOfURL:location encoding:NSUTF8StringEncoding error:nil];
        //            NSLog(@"text: %@", text);
        NSData *data = [[NSData alloc]initWithContentsOfURL:location]; //location refers to location on disk. NSData used to hold raw data
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]; //convert raw data into a dictionary
        //NSLog(@"ResponseDict: %@", responseDict);
        self.likedArray = [responseDict valueForKeyPath:@"response.venues.items.id"];
        self.venueArray = [[NSMutableArray alloc]init];
        
        for(NSString *venueID in self.likedArray){
            NSString *urlStringVenue = [[NSString alloc]initWithFormat:@"https://api.foursquare.com/v2/venues/%@?oauth_token=%@&v=%@&m=%@", venueID, self.accessToken, DATA_VERSION_DATE, DATA_FORMAT];
            NSURL *urlVenue = [NSURL URLWithString:urlStringVenue];
            NSURLRequest *requestVenue = [[NSURLRequest alloc]initWithURL:urlVenue];
            NSURLSessionDownloadTask *taskVenue = [session downloadTaskWithRequest:requestVenue completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                NSData *dataVenue = [[NSData alloc]initWithContentsOfURL:location];
                NSDictionary *responseDictVenue = [NSJSONSerialization JSONObjectWithData:dataVenue options:kNilOptions error:nil];
                [self.venueArray addObject:responseDictVenue];
                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.collectionView reloadData];
//                });
                
                if(self.likedArray.count == self.venueArray.count){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.collectionView reloadData];
                    });
                }
            }];
            [taskVenue resume];
        }
        
    }];
    [task resume];
    
    //[self refreshPhotos];
}

-(void)refreshPhotos{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"https://swapi.co/api/people"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *responseText = [[NSString alloc]initWithContentsOfURL:location encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"ResponseText: %@", responseText);
    }];
    
    [task resume];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.venueArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TPPUICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoPhunCell" forIndexPath:indexPath];
    cell.photoData = self.venueArray[indexPath.row];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showDetail"]){
        NSIndexPath *selectedPath = [self.collectionView indexPathsForSelectedItems][0];
        
        NSDictionary *photo = self.venueArray[selectedPath.row];
        TPPDetailViewController *detailView = segue.destinationViewController;
        detailView.photo = photo;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}


@end
