import axios from "axios";
import Vue from "vue";

const API_URL = "http://localhost:3000";

const securedAxiosInstance = axios.create({
  baseURL: API_URL,
  withCredentials: true,
  headers: {
    "Content-Type": "application/json"
  }
});

const plainAxiosInstance = axios.create({
  baseURL: API_URL,
  withCredentials: true,
  headers: {
    "Content-Type": "application/json"
  }
});

plainAxiosInstance.interceptors.request.use(config => {
  Vue.prototype.$Progress.start();
  return config;
});

securedAxiosInstance.interceptors.request.use(config => {
  const method = config.method.toUpperCase();
  if (method !== "OPTIONS" && method !== "GET") {
    config.headers = {
      ...config.headers,
      "X-CSRF-TOKEN": localStorage.csrf
    };
  }

  Vue.prototype.$Progress.start();
  return config;
});

let toastErrorHandler = error => {
  if (typeof error.response === "undefined") {
    Vue.prototype.$toast.error("Internal server error");
  }
  if (error.response) {
    Vue.prototype.$toast.error(
      error.response.status + " - " + error.response.statusText
    );
  }
};

plainAxiosInstance.interceptors.response.use(
  response => {
    Vue.prototype.$Progress.finish();
    return response;
  },
  error => {
    Vue.prototype.$Progress.fail();
    toastErrorHandler(error);
    return Promise.reject(error);
  }
);

securedAxiosInstance.interceptors.response.use(
  response => {
    Vue.prototype.$Progress.finish();
    return response;
  },
  error => {
    Vue.prototype.$Progress.fail();
    toastErrorHandler(error);

    if (
      error.response &&
      error.response.config &&
      error.response.status === 401
    ) {
      // If 401 by expired access cookie, we do a refresh request
      return plainAxiosInstance
        .post(
          "/refresh",
          {},
          { headers: { "X-CSRF-TOKEN": localStorage.csrf } }
        )
        .then(response => {
          localStorage.csrf = response.data.csrf;
          localStorage.signedIn = true;
          // After another successfull refresh - repeat original request
          let retryConfig = error.response.config;
          retryConfig.headers["X-CSRF-TOKEN"] = localStorage.csrf;
          return plainAxiosInstance.request(retryConfig);
        })
        .catch(error => {
          delete localStorage.csrf;
          delete localStorage.signedIn;
          // redirect to signin if refresh fails
          location.replace("/");
          return Promise.reject(error);
        });
    } else {
      return Promise.reject(error);
    }
  }
);

export { securedAxiosInstance, plainAxiosInstance };
