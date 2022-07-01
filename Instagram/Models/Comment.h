//
//  Comment.h
//  Instagram
//
//  Created by Megan Miller on 6/28/22.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Post.h"

@interface Comment : PFObject<PFSubclassing>

@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *text;

+ (void) postCommentWithText:(NSString * _Nullable)text forPost:(Post * _Nonnull)post
              withCompletion:(PFBooleanResultBlock _Nullable)completion;

@end
