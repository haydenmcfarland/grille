import gql from "graphql-tag";

const mutation = gql`
  mutation signUp(
    $firstName: String!
    $lastName: String!
    $email: String!
    $password: String!
  ) {
    signUp(
        firstName: $firstName
        lastName: $lastName
        email: $email
        password: $password
    ) {
      user {
        id
        email
        token
      }
      success
      errors
    }
  }
`;

export default function signUp({ apollo, firstName, lastName, email, password }) {
  return apollo.mutate({
    mutation,
    variables: {
      firstName,
      lastName,
      email,
      password
    }
  });
}
