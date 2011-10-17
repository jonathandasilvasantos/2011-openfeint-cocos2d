//  Copyright 2011 Aurora Feint, Inc.
// 
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//  	http://www.apache.org/licenses/LICENSE-2.0
//  	
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#pragma once

#import <UIKit/UIKit.h>

@interface OFXmlElement : NSObject {
    NSString* mValue;
    NSString* mName;
    NSMutableArray* mChildren;
    NSDictionary* mAttributes;
    NSMutableArray* mLoadingElements;
}

//xml conversion
+(id)elementWithString:(NSString*)str;
+(id)elementWithData:(NSData*)data;

+(id)elementWithName:(NSString*)name;
-(id)initWithName:(NSString*)name;

-(OFXmlElement*)getChildWithName:(NSString*)name;


-(void)addChild:(OFXmlElement*)childNode;
-(BOOL)hasChildren;

@property (nonatomic, retain) NSString* value;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSDictionary* attributes;
@property (nonatomic, readonly, retain) NSMutableArray* children;

@end
