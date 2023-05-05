import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:uvbs/graphql/GraphQLConfig.dart';

String getAllAudios() {
  return """
    query AllAudios {
      allAudios {
        id
        title
        description
        thumbnail
        audioUrl
        song
        language
        createdAt
        updatedAt
      }
    }
  """;
}

Future<QueryResult> getAllAudiosMutation() async {
  GraphQLClient client = GraphQLConfig.clientToQuery();
  QueryResult result = await client.query(QueryOptions(
    fetchPolicy: FetchPolicy.networkOnly,
    document: gql(getAllAudios()),
  ));

  return result;
}
