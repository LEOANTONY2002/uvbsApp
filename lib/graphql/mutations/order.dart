import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:uvbs/graphql/GraphQLConfig.dart';

String upsertShipping() {
  return """
    mutation upsertShipping(\$userId: String!, \$line1: String!, \$line2: String!, \$city: String!, \$state: String!, \$country: String!, \$zip: Int!) {
      upsertShipping(userId: \$userId, line1: \$line1, line2: \$line2, city: \$city, state: \$state, country: \$country, zip: \$zip) {
        id
        name
        email
        phone
        password
        createdAt
        updatedAt
        cart {
          id
          price
          products {
            id
            quantity
            product {
              id
              name
              description
              price
              photo
            }
          }
        }
        orders {
          id
          line1
          line2
          city
          state
          country
          zip
          status
          products
          price
          payment_mode
          payment_status
          razorpay_temp_order_id
          razorpay_payment_id
          razorpay_order_id
          razorpay_signature
          createdAt
          updatedAt
        }
        shipping {
          id
          line1
          line2
          city
          state
          country
          zip
        }
      }
    }
  """;
}

Future<QueryResult> upsertShippingMutation(String userId, String line1,
    String line2, String city, String state, String country, int zip) async {
  GraphQLClient client = GraphQLConfig.clientToQuery();
  QueryResult result = await client.mutate(
    MutationOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(upsertShipping()),
        variables: {
          'userId': userId,
          'line1': line1,
          'line2': line2,
          'city': city,
          'state': state,
          'country': country,
          'zip': zip
        }),
  );

  return result;
}

String createCODOrder() {
  return """
    mutation CreateCODOrder(\$userId: String!, \$line1: String!, \$line2: String!, \$city: String!, \$state: String!, \$country: String!, \$zip: Int!, \$products: String!, \$price: Int!) {
      createCODOrder(userId: \$userId, line1: \$line1, line2: \$line2, city: \$city, state: \$state, country: \$country, zip: \$zip, products: \$products, price: \$price) {
        id
        name
        email
        phone
        password
        createdAt
        updatedAt
        cart {
          id
          price
          products {
            id
            quantity
            product {
              id
              name
              description
              price
              photo
            }
          }
        }
        orders {
          id
          line1
          line2
          city
          state
          country
          zip
          status
          products
          price
          payment_mode
          payment_status
          razorpay_temp_order_id
          razorpay_payment_id
          razorpay_order_id
          razorpay_signature
          createdAt
          updatedAt
        }
        shipping {
          id
          line1
          line2
          city
          state
          country
          zip
        }
      }
    }
  """;
}

Future<QueryResult> createCODOrderMutation(
    String userId,
    String line1,
    String line2,
    String city,
    String state,
    String country,
    int zip,
    String products,
    int price) async {
  GraphQLClient client = GraphQLConfig.clientToQuery();
  QueryResult result = await client.mutate(
    MutationOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(createCODOrder()),
        variables: {
          'userId': userId,
          'line1': line1,
          'line2': line2,
          'city': city,
          'state': state,
          'country': country,
          'zip': zip,
          'products': products,
          'price': price,
        }),
  );

  return result;
}
