const express = require("express");
const httpProxy = require("http-proxy");

const app = express();
const PORT = 9090;

const BASE_PATH = "http://localhost";

const proxy = httpProxy.createProxy();

app.use((req, res) => {
  let hostname = req.hostname;
  console.log("hostname", hostname);

  if (!hostname) {
    // Handle case where hostname is not provided in the request
    return res.status(400).send("Hostname is missing in the request");
  }

  const subdomain = hostname.split(".")[0];
  console.log("subdomain", subdomain);
  // Custom Domain - DB Query

  const resolvesTo = `${BASE_PATH}/${subdomain}`;
  console.log("resolvesTo", resolvesTo);
  try {
    // proxy.web(req, res, { target: resolvesTo, changeOrigin: true });
    proxy.web(req, res, { target: resolvesTo });
  } catch (error) {
    console.error("Error during proxy request:", error);
    res.status(500).send("Internal Server Error");
  }
});

// proxy.on("proxyReq", (proxyReq, req, res) => {
//   const url = req.url;
//   if (url === "/") proxyReq.path += "index.html";
// });

app.listen(PORT, () => console.log(`Reverse Proxy Running..${PORT}`));
