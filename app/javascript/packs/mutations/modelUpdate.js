import gql from "graphql-tag";

const mutation = gql`
  mutation update($model: String!, $jsonArray: [String!]!) {
    update(model: $model, jsonArray: $jsonArray) {
      result
      success
      errors
    }
  }
`;

export default function modelUpdate({ apollo, model, jsonArray }) {
  return apollo.mutate({
    mutation,
    variables: {
      model,
      jsonArray
    }
  });
}
