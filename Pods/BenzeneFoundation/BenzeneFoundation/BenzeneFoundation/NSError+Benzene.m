//
//  NSError+Benzene.m
//  BenzeneFoundation
//
//  BSD License
//
//  Copyright (c) 2012-2015, Wantoto Inc.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
//  * Neither the name of the Wantoto Inc. nor the
//    names of its contributors may be used to endorse or promote products
//    derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL Wantoto Inc. BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "NSError+Benzene.h"
#import <libextobjc/extobjc.h>
#import <objc/runtime.h>

static char NSErrorBenzeneDebugMessageAssociationKey;
static char NSErrorBenzeneDebugInfoAssociationKey;

@implementation NSError (Benzene)

- (NSString *)debugMessage {
    return objc_getAssociatedObject(self, &NSErrorBenzeneDebugMessageAssociationKey);
}

- (void)setDebugMessage:(NSString *)debugMessage {
    objc_setAssociatedObject(self,
                             &NSErrorBenzeneDebugMessageAssociationKey,
                             debugMessage,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)debugInfo {
    return objc_getAssociatedObject(self, &NSErrorBenzeneDebugInfoAssociationKey);
}

- (void)setDebugInfo:(NSDictionary *)debugInfo {
    objc_setAssociatedObject(self,
                             &NSErrorBenzeneDebugInfoAssociationKey,
                             debugInfo,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    if (self.localizedDescription) {
        result[@keypath(self.localizedDescription)] = self.localizedDescription;
    }
    if (self.localizedFailureReason) {
        result[@keypath(self.localizedFailureReason)] = self.localizedFailureReason;
    }
    if (self.debugMessage) {
        result[@keypath(self.debugMessage)] = self.debugMessage;
    }
    if (self.debugInfo) {
        result[@keypath(self.debugInfo)] = self.debugInfo;
    }
    return [NSDictionary dictionaryWithDictionary:result];
}

@end
