import 'package:graphql_flutter/graphql_flutter.dart';
import '../GraphQLConfig.dart';

String addComment() {
  return """
    mutation AddComment(\$userId: String!, \$videoId: String!, \$msg: String!) {
      addComment(userId: \$userId, videoId: \$videoId, msg: \$msg) {
        id
        title
        description
        thumbnail
        videoUrl
        likes {
          id
          user {
            id
            name
            email
          }
        }
        comments {
          id
          user {
            id
            name
            email
          }
          msg
        }
        createdAt
        updatedAt
      }
    }
  """;
}

Future<QueryResult> addCommentMutation(
    String userId, String videoId, String msg) async {
  GraphQLClient client = GraphQLConfig.clientToQuery();
  QueryResult result = await client.mutate(
    MutationOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(addComment()),
        variables: {'userId': userId, 'videoId': videoId, 'msg': msg}),
  );

  return result;
}

String addLike() {
  return """
    mutation AddLike(\$userId: String!, \$videoId: String!) {
      addLike(userId: \$userId, videoId: \$videoId) {
        id
        title
        description
        thumbnail
        videoUrl
        likes {
          id
          user {
            id
            name
            email
          }
        }
        comments {
          id
          user {
            id
            name
            email
          }
          msg
        }
        createdAt
        updatedAt
      }
    }
  """;
}

Future<QueryResult> addLikeMutation(String userId, String videoId) async {
  GraphQLClient client = GraphQLConfig.clientToQuery();
  QueryResult result = await client.mutate(
    MutationOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(addLike()),
        variables: {'userId': userId, 'videoId': videoId}),
  );

  return result;
}
