//
//  PFDSList.m
//  PurelyFunctionDS
//
//  Created by Curt Clifton on 3/16/14.
//  Copyright (c) 2014 curtclifton.net. All rights reserved.
//

#import "PFDSList.h"

#import "PFDSExceptions.h"

static PFDSList *empty;

@interface ConsCell : NSObject
@property (nonatomic, strong) id element;
@property (nonatomic, strong) ConsCell *nextCell;
@end

@interface PFDSList ()
@property (nonatomic, strong) ConsCell *firstCell;
@end

@interface _PFDSEmptyList : PFDSList
@end

@implementation PFDSList
+ (void)initialize;
{
    if (self != [PFDSList class]) {
        return;
    }
    
    empty = [_PFDSEmptyList new];
}

+ (instancetype)listFromArray:(NSArray *)array;
{
    __block PFDSList *result = [PFDSList empty];
    [array enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        result = [result cons:obj];
    }];
    return result;
}

#pragma mark - NSObject subclass

- (BOOL)isEqual:(id)object;
{
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[PFDSList class]]) {
        return NO;
    }

    PFDSList *otherObject = object;
    if ([otherObject isEmpty]) {
        // We're not empty
        return NO;
    }
    
    if ([self.head isEqual:otherObject.head]) {
        return [self.tail isEqual:otherObject.tail];
    }
        
    return NO;
}

- (NSUInteger)hash;
{
    return [self.head hash] * 31 + [self.tail hash];
}

- (NSString *)description;
{
    NSString *result = @"[";
    PFDSList *list = self;
    while (![list isEmpty]) {
        result = [result stringByAppendingString:[list.head description]];
        list = list.tail;
        if (![list isEmpty]) {
            result = [result stringByAppendingString:@","];
        }
    }
    result = [result stringByAppendingString:@"]"];
    return result;
}

#pragma mark - PFDSStack protocol

+ (instancetype)empty;
{
    return empty;
}

- (BOOL)isEmpty;
{
    return NO;
}

- (id <PFDSStack>)cons:(id)element;
{
    ConsCell *newCell = [ConsCell new];
    newCell.element = element;
    PFDSList *result = [PFDSList new];
    result.firstCell = newCell;
    
    // Need to chain to our linked list of cells, but since our list in immutable, we don't need to copy anything here.
    newCell.nextCell = self.firstCell;
    
    return result;
}

- (id)head;
{
    return self.firstCell.element;
}

- (id <PFDSStack>)tail;
{
    ConsCell *nextCell = self.firstCell.nextCell;
    if (nextCell == nil) {
        return empty;
    }
    
    PFDSList *result = [PFDSList new];
    result.firstCell = nextCell;
    return result;
}

// CCC, 5/25/2014. Jonathon Mah @dev_etc, Adventures with tail recursion and ARC: http://devetc.org/code/2014/05/24/tail-recursion-objc-and-arc.html
// CCC, 5/25/2014. This isn't even tail recursive, so will blow out the stack.
- (id <PFDSStack>)append:(id <PFDSStack>)otherStack;
{
    if (otherStack == nil) {
        [NSException raise:PFDSIllegalArgumentException format:@"otherStack must be non-nil"];
    }
    
    return [[self.tail append:otherStack] cons:self.head];
}

// CCC, 5/25/2014. This isn't even tail recursive, so will blow out the stack.
- (id <PFDSStack>)updateIndex:(NSUInteger)index withElement:(id)element;
{
    if (index == 0) {
        return [self.tail cons:element];
    }
    
    return  [[self.tail updateIndex:index - 1 withElement:element] cons:self.head];
}

// CCC, 5/25/2014. This isn't even tail recursive, so will blow out the stack.
- (id <PFDSStack>)suffixes;
{
    return [self.tail.suffixes cons:self];
}

@end

@implementation _PFDSEmptyList
#pragma mark - NSObject subclass

// CCC, 4/22/2014. It might be nice to allow two different implementations of PFDSStack to compare isEqual: if their contents were the same. However, isEqual: is part of the NSObject contract where [a isEqual:b] ==> [a hash] == [b hash]. We can't guarantee that unless the hash function is specified by the protocol.
- (BOOL)isEqual:(id)object;
{
    // Since the empty list is a singleton, identity comparison is all we need.
    if (self == object) {
        return YES;
    }
    
    return NO;
}

- (NSUInteger)hash;
{
    return (NSUInteger)self;
}

- (NSString *)description;
{
    return @"[]";
}

#pragma mark - PFDSStack protocol

- (BOOL)isEmpty;
{
    return YES;
}

- (id <PFDSStack>)cons:(id)element;
{
    ConsCell *newCell = [ConsCell new];
    newCell.element = element;
    PFDSList *result = [PFDSList new];
    result.firstCell = newCell;
    
    return result;
}

- (id)head;
{
    [NSException raise:PFDSEmptyStackException format:@"can't take the head of an empty list"];
    return nil;
}

- (id <PFDSStack>)tail;
{
    [NSException raise:PFDSEmptyStackException format:@"can't take the head of an empty list"];
    return nil;
}

- (id <PFDSStack>)append:(id <PFDSStack>)otherStack;
{
    if (otherStack == nil) {
        [NSException raise:PFDSIllegalArgumentException format:@"otherStack must be non-nil"];
    }
    
    return otherStack;
}

- (id <PFDSStack>)updateIndex:(NSUInteger)index withElement:(id)element;
{
    [NSException raise:PFDSEmptyStackException format:@"can't update an empty list"];
    return nil;
}

- (id <PFDSStack>)suffixes;
{
    return [[PFDSList empty] cons:[PFDSList empty]];
}

@end

@implementation ConsCell
// nothing to do here but autosynthesize the properties
@end
