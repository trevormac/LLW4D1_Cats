//
//  CollectionViewController.m
//  CollectionView Practice1
//
//  Created by Trevor MacGregor on 2017-03-26.
//  Copyright © 2017 Trevor MacGregor. All rights reserved.
//



#import "CollectionViewController.h"
#import "CollectionViewCell.h"
#import "PhotoObject.h"
#import "DetailViewController.h"
#import "FlickrAPIKey.h"

@interface CollectionViewController ()

@property (nonatomic) NSMutableArray *photoData;
//@property (nonatomic) NSMutableArray *photoTitles;

@property (strong, nonatomic) NSURLSession *session;
@end

@implementation CollectionViewController




static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    //initialize array
    //self.photoTitles = [[NSMutableArray alloc] init];
    self.photoData = [[NSMutableArray alloc] init];
    
    
    ///fetch our flickr data with our API key
    
    NSString *apiEndPoint = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=%@&tags=cat", FlickrAPIKey];
    
     NSURL *url = [NSURL URLWithString:apiEndPoint];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc]initWithURL:url];
    
    self.session =  [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        if (error) {
            NSLog(@"error: %@", error.localizedDescription);
            return ;
        }
         NSError *jsonError = nil;
        
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError) {
            NSLog(@"error: %@", jsonError.localizedDescription);
            return ;
        }
       
        // Loop through each entry in the dictionary...
        for (NSDictionary *photo in jsonData[@"photos"][@"photo"])
        {
            // Get title of the image
            NSString *title = [photo objectForKey:@"title"];
            
            // Save the title to the photo titles array
//            [self.photoData addObject:(title.length > 0 ? title : @"Untitled")];
            PhotoObject *newPhoto = [[PhotoObject alloc] init];
            newPhoto.title = title;
            
            
            // Build the URL to where the image is stored (see the Flickr API)
            // In the format http://farmX.static.flickr.com/server/id_secret.jpg
            // The "_s" which requests a "small" image 75 x 75 pixels
            NSString *photoURLString =
            [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_s.jpg",
             [photo objectForKey:@"farm"], [photo objectForKey:@"server"],
             [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
            newPhoto.pictureURL = photoURLString;
 
            [self.photoData addObject:newPhoto];
        }

        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.collectionView reloadData];
        }];
        
        
        
    }];
    
    [dataTask resume];
    
    
    //Part 2 Adding the geoloaction data
//    NSURLSessionDataTask *mapDataTask [self.session dataTaskWithRequest:(nonnull NSURLRequest *) completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        
//    }
//        
//    }]





    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//assign photos to Photo Object instance





//- (void)createData {
//    PhotoObject *p1 = [[PhotoObject alloc]initWithTitle:@"Photo1" picture:[UIImage imageNamed:@"Photo1.jpg" ]];
//    PhotoObject *p2 = [[PhotoObject alloc]initWithTitle:@"Photo2" picture:[UIImage imageNamed:@"Photo2.jpg" ]];
//    
//    PhotoObject *p3 = [[PhotoObject alloc]initWithTitle:@"Photo3" picture:[UIImage imageNamed:@"Photo3.jpg" ]];
//    PhotoObject *p4 = [[PhotoObject alloc]initWithTitle:@"Photo4" picture:[UIImage imageNamed:@"Photo4.jpg" ]];
//    
//    PhotoObject *p5 = [[PhotoObject alloc]initWithTitle:@"Photo5" picture:[UIImage imageNamed:@"Photo5.jpg" ]];
//    PhotoObject *p6 = [[PhotoObject alloc]initWithTitle:@"Photo6" picture:[UIImage imageNamed:@"Photo6.jpg" ]];
//    
//    //assign to arrays within array
//    self.data = @[@[p1,p2,],@[p3, p4],@[p5, p6]];
//                  self.titles = @[@"title 1",@"title 2",@"title 3" ];
//}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//    if ([segue.identifier isEqualToString:@"DetailViewController"]) {
//        DetailViewController *dvc = segue.destinationViewController;
//        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
//        PhotoObject *photoObject = self.photoData[indexPath.section][indexPath.row];
//        dvc.photoObject = photoObject;
//    }
//}


#pragma mark <UICollectionViewDataSource>


//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//   return self.photoData.count;
//}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.photoData.count;
}

    - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        
        CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        PhotoObject *photoObject = self.photoData[indexPath.row];
        cell.label.text = photoObject.title;
//        cell.image.image = photoObject.picture;
//        cell.label.text = self.photoData[0];
//        cell.image.image = self.photoData[1];
       
        //task to fetch the image off of the server. Have to go back on main queue to set the image on the cell
        NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString: photoObject.pictureURL] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSData *data = [NSData dataWithContentsOfURL:location];
            UIImage *pictureImage = [UIImage imageWithData:data];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                cell.image.image = pictureImage;
            }];
        }];
        [downloadTask resume];
        return cell;



}
@end
