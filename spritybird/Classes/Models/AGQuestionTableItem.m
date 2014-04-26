//
//  AGQuestionTableItem.m
//  spritybird
//
//  Created by Tai Truong on 3/22/14.
//  Copyright (c) 2014 Alexis Creuzot. All rights reserved.
//

#import "AGQuestionTableItem.h"

@implementation AGQuestionTableItem

-(id)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        _title = title;
        _selected = NO;
    }
    return self;
}
@end
