import gql from "graphql-tag";

const query = gql`
  {
    users {
      id
      email
    }
  }
`;

export default function users({ apollo, }) {
  return apollo.query({ query });
}
