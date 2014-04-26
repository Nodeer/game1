//
//  AGQuestionTableCell.m
//  spritybird
//
//  Created by Tai Truong on 3/22/14.
//  Copyright (c) 2014 Alexis Creuzot. All rights reserved.
//

#import "AGQuestionTableCell.h"

@implementation AGQuestionTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        // Initialization code
        self.textLabel.font = [UIFont fontWithName:APP_FONT size:17.0f];
        self.textLabel.shadowOffset = CGSizeMake(1.0, 1.0);
        self.textLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    AGQuestionTableItem *item = self.object;
    item.selected = selected;
    [self updateSelect];
}


-(void)setObject:(id)object
{
    _object = object;
    AGQuestionTableItem *item = object;
    self.textLabel.text = item.title;
    [self updateSelect];
}

-(void)updateSelect
{
    AGQuestionTableItem *item = self.object;
    if (item.selected) {
        self.textLabel.textColor = [UIColor orangeColor];
    }
    else {
        self.textLabel.textColor = [UIColor colorWithRed:252.0f/255.0f green:184.0f/255.0f blue:0.0f alpha:1.0f];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect r = self.textLabel.frame;
    r.origin.x = 50;
    r.size.width = 250;
    self.textLabel.frame = r;
}
@end
