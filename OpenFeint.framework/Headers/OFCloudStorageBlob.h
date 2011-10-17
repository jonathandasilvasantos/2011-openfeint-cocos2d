//  Copyright 2009-2010 Aurora Feint, Inc.
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

#import "OFResource.h"
#import "math.h"

@class OFService;

@interface OFCloudStorageBlob : OFResource
{
@package
	NSString* userId;
	NSString*	keyStr;
}

@property (nonatomic, readonly, retain)	NSString* userId;
@property (nonatomic, readonly, retain)	NSString* keyStr;

@end