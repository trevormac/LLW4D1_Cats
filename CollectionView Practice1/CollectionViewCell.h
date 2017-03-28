//
//  CollectionViewCell.h
//  CollectionView Practice1
//
//  Created by Trevor MacGregor on 2017-03-26.
//  Copyright © 2017 Trevor MacGregor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoObject.h"

@interface CollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *label;
//@property (nonatomic) PhotoObject *photo;


@end
