import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:uvbs/graphql/GraphQLConfig.dart';

String addToCart() {
  return """
    mutation addToCartProduct(\$userId: String!, \$cartId: String!, \$productId: String!, \$quantity: Int!) {
      addToCartProduct(userId: \$userId, cartId: \$cartId, productId: \$productId, quantity: \$quantity) {
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

Future<QueryResult> addToCartMutation(
    String userId, String cartId, String productId, int quantity) async {
  GraphQLClient client = GraphQLConfig.clientToQuery();
  QueryResult result = await client.mutate(
    MutationOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(addToCart()),
        variables: {
          'userId': userId,
          'cartId': cartId,
          'productId': productId,
          'quantity': quantity
        }),
  );

  return result;
}

String removeFromCart() {
  return """
    mutation removeFromCartProduct(\$userId: String!, \$cartProductId: String!) {
      removeFromCartProduct(userId: \$userId, cartProductId: \$cartProductId) {
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

Future<QueryResult> removeFromCartMutation(
    String userId, String cartProductId) async {
  GraphQLClient client = GraphQLConfig.clientToQuery();
  QueryResult result = await client.mutate(
    MutationOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(removeFromCart()),
        variables: {
          'userId': userId,
          'cartProductId': cartProductId,
        }),
  );

  return result;
}
