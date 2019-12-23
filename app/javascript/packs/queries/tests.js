import gql from "graphql-tag";

const query = gql`
  {
    tests {
      id
      name
      age
      details
    }
  }
`;

export default function test({ apollo, }) {
  return apollo.query({ query });
}
