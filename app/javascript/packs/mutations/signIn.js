import gql from "graphql-tag";

const mutation = gql`
  mutation signIn($email: String!, $password: String!) {
    signIn(email: $email, password: $password) {
      result
      success
      errors
    }
  }
`;

export default function signIn({ apollo, email, password }) {
  return apollo.mutate({
    mutation,
    variables: {
      email,
      password
    }
  });
}
