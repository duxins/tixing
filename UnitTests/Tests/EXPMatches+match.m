//
//  EXPMatches+match.m
//  Created by Jonathan Crooke on 25/03/2014.
//

#import "EXPMatches+match.h"

EXPMatcherImplementationBegin(match, (NSString *pattern)) {
  BOOL actualIsNil = (actual == nil);
  BOOL actualIsCompatible = (!actualIsNil && [actual isKindOfClass:[NSString class]]);
  NSError *error = nil;
  NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                    options:0
                                                                      error:&error];
  BOOL patternIsCompatible = ([pattern isKindOfClass:[NSString class]]);
  
  prerequisite(^BOOL{
    return actualIsCompatible && patternIsCompatible && !error;
  });
  
  match(^BOOL{
    return ([regex numberOfMatchesInString:actual options:0 range:NSMakeRange(0, [(NSString *)actual length])]);
  });
  
  NSString*(^incompatibilityMessage)(void) = ^NSString* (void) {
    if(!actualIsCompatible)
      return [NSString stringWithFormat:
              @"%@ is not an instance of NSString",
              EXPDescribeObject(actual)];
    if(actualIsNil)
      return @"the actual value is nil/null";
    if(!patternIsCompatible)
      return [NSString stringWithFormat:
              @"%@ is not an instance of NSString",
              EXPDescribeObject(pattern)];
    if (error) {
      return [NSString stringWithFormat:
              @"%@ is not a valid regular expression, %@",
              EXPDescribeObject(pattern),
              EXPDescribeObject(error)];
    }
    return nil;
  };
  
  failureMessageForTo(^NSString *{
    return incompatibilityMessage() ?:
    [NSString stringWithFormat:
     @"expected: string %@ matches regular expression %@, ",
     actual, pattern];
  });
  
  failureMessageForNotTo(^NSString *{
    return incompatibilityMessage() ?:
    [NSString stringWithFormat:
     @"expected: string %@ not to match regular expression %@, ",
     actual, pattern];
  });
}
EXPMatcherImplementationEnd
