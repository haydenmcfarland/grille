import gql from "graphql-tag";

const mutation = gql`
  mutation delete($model: String!, $ids: [ID!]!) {
    delete(model: $model, ids: $ids) {
      result
      success
      errors
    }
  }
`;

export default function modelDelete({ apollo, model, ids }) {
  return apollo.mutate({
    mutation,
    variables: {
      model,
      ids
    }
  });
}
