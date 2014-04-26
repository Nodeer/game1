//
//  AGCustomFontLabel.m
//  spritybird
//
//  Created by Tai Truong on 3/22/14.
//  Copyright (c) 2014 Alexis Creuzot. All rights reserved.
//

#import "AGCustomFontLabel.h"

@implementation AGCustomFontLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    self.font = [UIFont fontWithName:@"04b_19" size:self.font.pointSize];
}

@end
