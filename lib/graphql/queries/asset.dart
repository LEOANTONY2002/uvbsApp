import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:uvbs/graphql/GraphQLConfig.dart';

String getAllAssets() {
  return """
    query AllAssets {
      allAssets {
        id
        themeTitle
        themeDescription
        themePhoto
        isPaymentOnline
        upi
        termsAndConditions
        privacyPolicy
        createdAt
        updatedAt
      }
    }
  """;
}

Future<QueryResult> getAllAssetsMutation() async {
  GraphQLClient client = GraphQLConfig.clientToQuery();
  QueryResult result = await client.query(QueryOptions(
    fetchPolicy: FetchPolicy.networkOnly,
    document: gql(getAllAssets()),
  ));

  return result;
}
