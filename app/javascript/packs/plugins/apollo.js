import Vue from "vue";
import VueApollo from "vue-apollo";
import { ApolloClient } from "apollo-client";
import { ApolloLink } from "apollo-link";
import { onError } from "apollo-link-error";
import { createHttpLink } from "apollo-link-http";
import { setContext } from "apollo-link-context";
import { InMemoryCache } from "apollo-cache-inmemory";
import { AUTH_TOKEN_KEY } from "../config/constants";

Vue.use(VueApollo);

const host = window.location.origin;
const httpLink = createHttpLink({ uri: `${host}/graphql` });

const errorLink = onError(({ graphQLErrors, networkError }) => {
  if (graphQLErrors)
    graphQLErrors.map(({ message, locations, path }) =>
      console.log(
        `[GraphQL error]: Message: ${message}, Location: ${locations}, Path: ${path}`,
      ),
    );

  if (networkError) console.log(`[Network error]: ${networkError}`);

  Vue.prototype.$toast.error(graphQLErrors || networkError)
});

const authLink = setContext((_, { headers }) => {
  // get the csrfToken from the element in appilcation.html layout
  const csrfToken = document.querySelector('meta[name="csrf-token"]').attributes
    .content.value;

  // get the authentication token from local storage if it exists
  const authToken = localStorage.getItem(AUTH_TOKEN_KEY);

  return {
    headers: {
      ...headers,
      "X-CSRF-Token": csrfToken,
      authorization: authToken ? `Bearer ${authToken}` : ""
    }
  };
});

const link = ApolloLink.from([
  authLink,
  errorLink,
  httpLink
])

const client = new ApolloClient({
  link: link,
  cache: new InMemoryCache()
});

const apolloProvider = new VueApollo({
  defaultClient: client,
});

export default apolloProvider;
