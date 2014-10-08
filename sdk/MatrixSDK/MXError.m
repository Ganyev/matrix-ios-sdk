/*
 Copyright 2014 OpenMarket Ltd
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "MXError.h"

NSString *const kMatrixNSErrorDomain = @"org.matrix.sdk";

// Random NSError code
// Matrix does not use integer but string for error code
NSInteger const kMatrixNSErrorCode = 6;

@implementation MXError

-(id)initWithErrorCode:(NSString*)errcode error:(NSString*)error
{
    self = [super init];
    if (self)
    {
        _errcode = errcode;
        _error = error;
    }
    return self;
}

-(id)initWithNSError:(NSError*)nsError
{
    if ([MXError isMXError:nsError])
    {
        self = [self initWithErrorCode:nsError.userInfo[@"errcode"]
                                 error:nsError.userInfo[@"error"]];
    }
    else
    {
        self = nil;
    }

    return self;
}

- (NSError *)createNSError
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    if (self.errcode)
    {
        userInfo[@"errcode"] = self.errcode;
    }

    if (self.error)
    {
        userInfo[@"error"] = self.error;
        userInfo[NSLocalizedDescriptionKey] = self.error;
    }
    
    if ((nil == self.error || 0 == self.error.length) && self.errcode)
    {
        // Fallback: use errcode as description
        userInfo[NSLocalizedDescriptionKey] = self.errcode;
    }
    
    return [NSError errorWithDomain:kMatrixNSErrorDomain
                               code:kMatrixNSErrorCode
                           userInfo:userInfo];
}

+ (BOOL)isMXError:(NSError *)nsError
{
    if (nsError && [nsError.domain isEqualToString:kMatrixNSErrorDomain])
    {
        return YES;
    }
    return NO;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@", self.errcode, self.error];
}

@end
