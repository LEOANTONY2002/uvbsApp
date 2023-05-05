import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:uvbs/graphql/GraphQLConfig.dart';

String getAllProducts() {
  return """
    query AllProducts {
      allProducts {
        id
        name
        description
        price
        photo
        stock
        createdAt
        updatedAt
      }
    }
  """;
}

Future<QueryResult> getAllProductsMutation() async {
  GraphQLClient client = GraphQLConfig.clientToQuery();
  QueryResult result = await client.query(QueryOptions(
    fetchPolicy: FetchPolicy.networkOnly,
    document: gql(getAllProducts()),
  ));

  return result;
}
