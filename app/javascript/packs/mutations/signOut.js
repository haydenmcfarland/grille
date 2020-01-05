import gql from "graphql-tag";

const mutation = gql`
  mutation signOut {
    signOut {
      success
      errors
    }
  }
`;

export default function signOut({ apollo }) {
  return apollo.mutate({ mutation });
}
