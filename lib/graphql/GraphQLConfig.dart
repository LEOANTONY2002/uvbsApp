import "package:graphql_flutter/graphql_flutter.dart";

class GraphQLConfig {
  static HttpLink link = HttpLink(
    'http://10.0.2.2:4001/graphql',
  );

  static GraphQLClient clientToQuery() {
    return GraphQLClient(
        link: link, cache: GraphQLCache(store: InMemoryStore()));
  }
}

//  https://uvbs.onrender.com/graphql/
//  http://10.0.2.2:4001/graphql