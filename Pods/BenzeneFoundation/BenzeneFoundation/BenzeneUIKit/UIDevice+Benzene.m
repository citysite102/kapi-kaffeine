//
//  UIDevice+Benzene.m
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

#import "UIDevice+Benzene.h"
#import <objc/runtime.h>
#import <sys/utsname.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <libextobjc/extobjc.h>
#import "BFDefines.h"
#import "BFFunctionUtilities.h"

static char BF_UIDeviceModelIdentitiferAssociationKey;
static char BF_UIDeviceModelGenArrayAssociationKey;
static char BF_UIDeviceIsDeviceAssociationKey;
static char BF_UIDeviceUUIDAssociationKey;

static NSLock *UUIDLock;
NSString *const BF_UUIDFileName = @"device.bf_nsuuid";  // To Keep Compatibility, Do NOT change this.

@implementation UIDevice (Benzene)

- (NSString *)modelIdentifier {
    NSString *result = objc_getAssociatedObject(self, &BF_UIDeviceModelIdentitiferAssociationKey);
    if (!result) {
        struct utsname systemInfo;
        uname(&systemInfo);
        
        result = @(systemInfo.machine);
        objc_setAssociatedObject(self, &BF_UIDeviceModelIdentitiferAssociationKey,
                                 result, OBJC_ASSOCIATION_RETAIN);
    }
    return result;
}

// ?? iPod Touch
- (NSArray *)modelGenerationArray {
    NSArray *result = objc_getAssociatedObject(self, &BF_UIDeviceModelGenArrayAssociationKey);
    if (!result) {
        NSString *model = self.model;
        if ([model.lowercaseString rangeOfString:@"simulator"].location!=NSNotFound) {
            result = @[@(-1), @(-1)];
        } else {
            NSString *modelIdentifier = self.modelIdentifier;
            NSArray *genArray = [[modelIdentifier stringByReplacingOccurrencesOfString:model withString:@""]
                                 componentsSeparatedByString:@","];
            NSInteger majorGen = [genArray.firstObject integerValue];
            NSInteger minorGen = [genArray.lastObject integerValue];
            result = @[@(majorGen), @(minorGen)];
        }
        objc_setAssociatedObject(self, &BF_UIDeviceModelGenArrayAssociationKey, result, OBJC_ASSOCIATION_RETAIN);
    }
    return result;
}

- (NSInteger)majorModelGeneration {
    return [[self modelGenerationArray].firstObject integerValue];
}

- (NSInteger)minorModelGeneration {
    return [[self modelGenerationArray].lastObject integerValue];
}

- (BOOL)isDevice {
    NSNumber *flag = objc_getAssociatedObject(self, &BF_UIDeviceIsDeviceAssociationKey);
    if (!flag) {
        flag = @([self.model.lowercaseString rangeOfString:@"simulator"].location == NSNotFound);
        objc_setAssociatedObject(self, &BF_UIDeviceIsDeviceAssociationKey, flag, OBJC_ASSOCIATION_RETAIN);
    }
    return flag.boolValue;
}

- (NSString *)IPAddress {
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;

    if (getifaddrs(&interfaces) == -1) {
        return nil;
    }

    NSString *address;

    // Loop through linked list of interfaces
    temp_addr = interfaces;
    while (temp_addr != NULL) {
        if (temp_addr->ifa_addr->sa_family == AF_INET) {
            // Check if interface is en0 which is the wifi connection on the iPhone
            if ([@(temp_addr->ifa_name) isEqualToString:@"en0"]) {
                // Get NSString from C String
                address = @(inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr));
            }
        }
        temp_addr = temp_addr->ifa_next;
    }
    freeifaddrs(interfaces);

    return address;
}

#pragma mark - UUID

- (NSUUID *)UUID {
    // Get from associated object
    NSUUID *uuid = objc_getAssociatedObject(self, &BF_UIDeviceUUIDAssociationKey);
    if (!uuid) {
        // Create lock
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            UUIDLock = [[NSLock alloc] init];
        });
        [UUIDLock lock];
        @onExit {
            [UUIDLock unlock];
        };

        // Check from associated object again (maybe it's associated when you are being bloked by lock)
        uuid = objc_getAssociatedObject(self, &BF_UIDeviceUUIDAssociationKey);
        if (!uuid) {
            // Generate path
            NSURL *libraryURL = [[NSFileManager defaultManager] URLForDirectory:NSLibraryDirectory
                                                                       inDomain:NSUserDomainMask
                                                              appropriateForURL:nil
                                                                         create:YES
                                                                          error:nil];
            NSString *path = [libraryURL.path stringByAppendingPathComponent:BF_UUIDFileName];

            // Load UUID from disk
            uuid = BFObjectCasting(NSUUID, [NSKeyedUnarchiver unarchiveObjectWithFile:path]);
            if (!uuid) {
                // Create new UUID and save it
                uuid = [NSUUID UUID];
                if (![NSKeyedArchiver archiveRootObject:uuid toFile:path]) {
                    // Failed to save uuid
                    uuid = nil;
                }
            }
            // Associate UUID
            if (uuid) {
                objc_setAssociatedObject(self, &BF_UIDeviceUUIDAssociationKey, uuid, OBJC_ASSOCIATION_RETAIN);
            }

        }
    }
    return uuid;
}

@end
