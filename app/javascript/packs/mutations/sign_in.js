import gql from "graphql-tag";

const mutation = gql`
  mutation signIn($email: String!, $password: String!) {
    login(email: $email, password: $password) {
      id
      firstName
      lastName
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
