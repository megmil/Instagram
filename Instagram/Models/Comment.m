//
//  Comment.m
//  Instagram
//
//  Created by Megan Miller on 6/28/22.
//

#import "Comment.h"

@implementation Comment

@dynamic author;
@dynamic text;
    
+ (nonnull NSString *)parseClassName {
    return @"Comment";
}

+ (void)postCommentWithText:(NSString * _Nullable)text forPost:(Post *)post
             withCompletion:(PFBooleanResultBlock _Nullable)completion {
    
    Comment *newComment = [Comment new];
    newComment.author = [PFUser currentUser];
    newComment.text = text;
    
    [newComment saveInBackgroundWithBlock:completion]; // TODO: addCommentToPost
    
    [post incrementKey:@"commentCount"];
    [post addObject:newComment forKey:@"comments"];
    [post saveInBackgroundWithBlock:completion];
}

@end
