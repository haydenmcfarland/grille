import gql from "graphql-tag";

const modelQuery = (
  model,
  attributes,
  pageSize,
  pageNumber,
  sortModel,
  filterModel
) => {
  const query = gql`
    {
      ${model}(
        pageSize: ${pageSize},
        pageNumber: ${pageNumber},
        sortModel: ${JSON.stringify(JSON.stringify(sortModel))},
        filterModel: ${JSON.stringify(JSON.stringify(filterModel))}) {
        totalPages,
        rows {
          ${attributes.join("\r\n")}
        }
      }
    }
  `;

  console.log(query);
  return query;
};

export default function modelRecords({
  apollo,
  model,
  attributes,
  pageSize,
  pageNumber,
  sortModel,
  filterModel
}) {
  const modelQueryResult = modelQuery(
    model,
    attributes,
    pageSize,
    pageNumber,
    sortModel,
    filterModel
  );
  return apollo.query({ query: modelQueryResult });
}
