//
//  AGQuestionTableItem.h
//  spritybird
//
//  Created by Tai Truong on 3/22/14.
//  Copyright (c) 2014 Alexis Creuzot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGQuestionTableItem : NSObject
@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) BOOL selected;

-(id)initWithTitle:(NSString*)title;
@end
