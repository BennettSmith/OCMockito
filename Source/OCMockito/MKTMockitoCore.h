//
//  OCMockito - MKTMockitoCore.h
//  Copyright 2013 Jonathan M. Reid. See LICENSE.txt
//
//  Created by: Jon Reid, http://qualitycoding.org/
//  Source: https://github.com/jonreid/OCMockito
//

#import <Foundation/Foundation.h>

#import "MKTTestLocation.h"

@class MKTObjectMock;
@class MKTOngoingStubbing;
@class MKTStubber;
@protocol MKTVerificationMode;


@interface MKTMockitoCore : NSObject

+ (id)sharedCore;

- (MKTOngoingStubbing *)stubAtLocation:(MKTTestLocation)location;
- (MKTStubber *)stubDoNothingAtLocation:(MKTTestLocation)location;

- (id)verifyMock:(MKTObjectMock *)mock
        withMode:(id <MKTVerificationMode>)mode
      atLocation:(MKTTestLocation)location;

- (MKTStubber *)stubDoReturn:(id)obj atLocation:(MKTTestLocation)location;
@end
