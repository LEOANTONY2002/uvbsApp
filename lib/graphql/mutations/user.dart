import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:uvbs/graphql/GraphQLConfig.dart';

String login(String email, String password) {
  return """
    mutation Login(\$email: String!, \$password: String!) {
      login(email: \$email, password: \$password) {
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

Future<QueryResult> loginMutation(String email, String password) async {
  GraphQLClient client = GraphQLConfig.clientToQuery();
  QueryResult result = await client.mutate(
    MutationOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(login(email, password)),
        variables: {'email': email, 'password': password}),
  );

  return result;
}

String signup() {
  return """
    mutation Signup(\$name: String!, \$email: String!, \$phone: String!, \$password: String!) {
      signup(name: \$name, email: \$email, phone: \$phone, password: \$password) {
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
          createdAt
          updatedAt
        }
      }
    }
  """;
}

Future<QueryResult> signupMutation(
    String name, String email, String phone, String password) async {
  GraphQLClient client = GraphQLConfig.clientToQuery();
  QueryResult result = await client.mutate(
    MutationOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(signup()),
        variables: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password
        }),
  );

  return result;
}

String updateUser() {
  return """
    mutation UpdateUser(\$id: String!, \$name: String!, \$email: String!, \$phone: String!, \$password: String!) {
      updateUser(id: \$id, name: \$name, email: \$email, phone: \$phone, password: \$password) {
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

Future<QueryResult> updateUserMutation(
    String id, String name, String email, String phone, String password) async {
  GraphQLClient client = GraphQLConfig.clientToQuery();
  QueryResult result = await client.mutate(
    MutationOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(updateUser()),
        variables: {
          'id': id,
          'name': name,
          'email': email,
          'phone': phone,
          'password': password
        }),
  );

  return result;
}
