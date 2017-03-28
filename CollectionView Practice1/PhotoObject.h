//
//  PhotoObject.h
//  CollectionView Practice1
//
//  Created by Trevor MacGregor on 2017-03-26.
//  Copyright © 2017 Trevor MacGregor. All rights reserved.
//

@import UIKit;

@interface PhotoObject : NSObject


@property (nonatomic) UIImage *picture;
@property (nonatomic) NSString *title;

@property (nonatomic) NSString *pictureURL;

//-(instancetype)initWithTitle:(NSString *)title picture:(UIImage*)picture;


@end
