import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import "./index.css";
import App from "./App.tsx";
import { StarknetProvider } from "./context/starknet";
import { DojoContextProvider } from "./DojoContext";
import { BrowserRouter as Router } from "react-router-dom";
import { makeDojoAppConfig } from "./config";
import { ApolloProvider } from "@apollo/client";
import { lsClientsConfig } from "@/config";

async function main() {
  const dojoAppConfig = makeDojoAppConfig();
  const client = lsClientsConfig[dojoAppConfig.initialChainId].gameClient;
  createRoot(document.getElementById("root")!).render(
    <StrictMode>
      <ApolloProvider client={client}>
        <StarknetProvider dojoAppConfig={dojoAppConfig}>
          <DojoContextProvider appConfig={dojoAppConfig}>
            <Router>
              <App />
            </Router>
          </DojoContextProvider>
        </StarknetProvider>
      </ApolloProvider>
    </StrictMode>
  );
}

main().catch((error) => {
  console.error("Failed to initialize the application:", error);
});
