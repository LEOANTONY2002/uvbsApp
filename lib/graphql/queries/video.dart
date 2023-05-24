import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:uvbs/graphql/GraphQLConfig.dart';

String getAllVideos() {
  return """
    query AllVideos {
      allVideos {
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

Future<QueryResult> getAllVideosMutation() async {
  GraphQLClient client = GraphQLConfig.clientToQuery();
  QueryResult result = await client.query(QueryOptions(
    fetchPolicy: FetchPolicy.networkOnly,
    document: gql(getAllVideos()),
  ));

  return result;
}

String getAllPreviousVideos() {
  return """
    query AllPreviousVideos {
      allPreviousVideos {
        id
        title
        year
        thumbnail
        url
        createdAt
        updatedAt
      }
    }
  """;
}

Future<QueryResult> getAllPreviousVideosMutation() async {
  GraphQLClient client = GraphQLConfig.clientToQuery();
  QueryResult result = await client.query(QueryOptions(
    fetchPolicy: FetchPolicy.networkOnly,
    document: gql(getAllPreviousVideos()),
  ));

  return result;
}
