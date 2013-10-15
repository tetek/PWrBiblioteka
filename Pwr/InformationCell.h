//
//  InformationCell.h
//  TemomukoFlow
//
//  Created by Bartosz Hernas on 30.03.2013.
//  Copyright (c) 2013 Bartosz Hernas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *keyLabel;
@property (strong, nonatomic) IBOutlet UIView *separator;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;

@end
