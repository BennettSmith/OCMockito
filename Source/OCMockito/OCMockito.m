//
//  OCMockito - OCMockito.m
//  Copyright 2013 Jonathan M. Reid. See LICENSE.txt
//
//  Created by: Jon Reid, http://qualitycoding.org/
//  Source: https://github.com/jonreid/OCMockito
//

#import "OCMockito.h"

#import "MKTAtLeastTimes.h"
#import "MKTExactTimes.h"
#import "MKTMockitoCore.h"
#import "MKTMockSettings.h"


static BOOL isValidMockClass(id mock)
{
    NSString *className = NSStringFromClass([mock class]);
    return [className isEqualToString:@"MKTObjectMock"] ||
            [className isEqualToString:@"MKTProtocolMock"] ||
            [className isEqualToString:@"MKTClassObjectMock"] ||
            [className isEqualToString:@"MKTObjectAndProtocolMock"];
}

static NSString *actualTypeName(id mock)
{
    NSString *className = NSStringFromClass([mock class]);
    if (className)
        return [@"type " stringByAppendingString:className];
    else
        return @"nil";
}

static BOOL reportedInvalidMock(id mock, id testCase, const char *fileName, int lineNumber, NSString *functionName)
{
    if (isValidMockClass(mock))
        return NO;
    NSString *description = [NSString stringWithFormat:@"Argument passed to %@ should be a mock but is %@",
                                                       functionName, actualTypeName(mock)];
    MKTFailTest(testCase, fileName, lineNumber, description);
    return YES;
}

MKTOngoingStubbing *MKTGivenWithLocation(id testCase, const char *fileName, int lineNumber, ...)
{
    return [[MKTMockitoCore sharedCore] stubAtLocation:MKTTestLocationMake(testCase, fileName, lineNumber)];
}

id MKTVerifyWithLocation(id mock, id testCase, const char *fileName, int lineNumber)
{
    if (reportedInvalidMock(mock, testCase, fileName, lineNumber, @"verify()"))
        return nil;
    
    return MKTVerifyCountWithLocation(mock, MKTTimes(1), testCase, fileName, lineNumber);
}

id MKTVerifyCountWithLocation(id mock, id mode, id testCase, const char *fileName, int lineNumber)
{
    if (reportedInvalidMock(mock, testCase, fileName, lineNumber, @"verifyCount()"))
        return nil;

    return [[MKTMockitoCore sharedCore] verifyMock:mock
                                          withMode:mode
                                        atLocation:MKTTestLocationMake(testCase, fileName, lineNumber)];
}

id MKTTimes(NSUInteger wantedNumberOfInvocations)
{
    return [MKTExactTimes timesWithCount:wantedNumberOfInvocations];
}

id MKTNever()
{
    return MKTTimes(0);
}

id MKTAtLeast(NSUInteger minimumWantedNumberOfInvocations)
{
    return [MKTAtLeastTimes timesWithMinimumCount:minimumWantedNumberOfInvocations];
}

id MKTAtLeastOnce()
{
    return MKTAtLeast(1);
}

id MKTSpy(id spiedObject)
{
    MKTMockSettings *settings = [[MKTMockSettings alloc] init];
    [settings setSpiedObject:spiedObject];
    return [MKTObjectMock mockForClass:[spiedObject class] withSettings:settings];
}

MKTStubber *MKTWillDoNothingWithLocation(id testCase, const char *fileName, int lineNumber)
{
    return [[MKTMockitoCore sharedCore] stubDoNothingAtLocation:MKTTestLocationMake(testCase, fileName, lineNumber)];
}

OBJC_EXPORT MKTStubber *MKTWillReturnWithLocation(id obj, id testCase, const char *fileName, int lineNumber)
{
    return [[MKTMockitoCore sharedCore] stubDoReturn:obj
                                          atLocation:MKTTestLocationMake(testCase, fileName, lineNumber)];
}
