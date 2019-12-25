import gql from "graphql-tag";

const modelQuery = (model, attributes, pageSize, pageNumber) => {
  const query = gql`
    {
      ${model}(pageSize: ${pageSize}, pageNumber: ${pageNumber}) {
        ${attributes.join("\r\n")}
      }
    }
  `;

  return query;
};

export default function modelRecords({
  apollo,
  model,
  attributes,
  pageSize,
  pageNumber
}) {
  const modelQueryResult = modelQuery(model, attributes, pageSize, pageNumber);
  return apollo.query({ query: modelQueryResult });
}
