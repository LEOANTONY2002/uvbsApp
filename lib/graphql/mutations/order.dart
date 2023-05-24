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
        isSubscribed
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
          deliveryDate
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
        isSubscribed
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
          deliveryDate
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

String generateRPOrderId() {
  return """
    mutation generateRPOrderId(\$price: Int!) {
      generateRPOrderId(price: \$price) {
        id
        entity
        amount
        amount_paid
        amount_due
        currency
        receipt
        offer_id
        status
        attempts
      }
    }
  """;
}

Future<QueryResult> generateRPOrderIdMutation(int price) async {
  GraphQLClient client = GraphQLConfig.clientToQuery();
  QueryResult result = await client.mutate(
    MutationOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(generateRPOrderId()),
        variables: {
          'price': price,
        }),
  );

  return result;
}

String generateStripePaymentIndent() {
  return """
    mutation generateStripePaymentIndent(\$price: Int!) {
      generateStripePaymentIndent(price: \$price) {
        id
        client_secret
      }
    }
  """;
}

Future<QueryResult> generateStripePaymentIndentMutation(int price) async {
  GraphQLClient client = GraphQLConfig.clientToQuery();
  QueryResult result = await client.mutate(
    MutationOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(generateStripePaymentIndent()),
        variables: {
          'price': price,
        }),
  );

  return result;
}

String createRPOrder() {
  return """
    mutation CreateRPOrder(\$userId: String!, \$line1: String!, \$line2: String!, \$city: String!, \$state: String!, \$country: String!, \$zip: Int!, \$products: String!, \$price: Int!, \$razorpay_temp_order_id: String!,  \$razorpay_payment_id: String!,  \$razorpay_order_id: String!,  \$razorpay_signature: String!) {
      createRPOrder(userId: \$userId, line1: \$line1, line2: \$line2, city: \$city, state: \$state, country: \$country, zip: \$zip, products: \$products, price: \$price, razorpay_temp_order_id: \$razorpay_temp_order_id, razorpay_payment_id: \$razorpay_payment_id, razorpay_order_id: \$razorpay_order_id, razorpay_signature: \$razorpay_signature) {
        id
        name
        email
        phone
        password
        isSubscribed
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
          deliveryDate
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

Future<QueryResult> createRPOrderMutation(
  String userId,
  String line1,
  String line2,
  String city,
  String state,
  String country,
  int zip,
  String products,
  int price,
  String razorpayTempOrderId,
  String razorpayPaymentId,
  String razorpayOrderId,
  String razorpaySignature,
) async {
  GraphQLClient client = GraphQLConfig.clientToQuery();
  QueryResult result = await client.mutate(
    MutationOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(createRPOrder()),
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
          'razorpay_temp_order_id': razorpayTempOrderId,
          'razorpay_payment_id': razorpayPaymentId,
          'razorpay_order_id': razorpayOrderId,
          'razorpay_signature': razorpaySignature,
        }),
  );

  return result;
}
