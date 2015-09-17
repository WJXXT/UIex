//
//  RootCell.m
//  UIex
//
//  Created by XXT on 15/9/17.
//  Copyright (c) 2015年 XXT. All rights reserved.
//

#import "RootCell.h"

@implementation RootCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {

    [_nameLab release];
    [_detalLab release];
    [_imgv release];
    [super dealloc];
}
@end
