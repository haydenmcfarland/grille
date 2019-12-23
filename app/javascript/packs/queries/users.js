import gql from "graphql-tag";

const query = gql`
  {
    users {
      id
      email
      firstName
      lastName
    }
  }
`;

export default function users({ apollo, }) {
  return apollo.query({ query });
}
