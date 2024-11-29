import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import "./index.css";
import App from "./App.tsx";
import { StarknetProvider } from "./context/starknet";
import { DojoContextProvider } from "./DojoContext";
import { setupBurnerManager } from "@dojoengine/create-burner";
import { BrowserRouter as Router } from "react-router-dom";
import { makeDojoAppConfig } from "./config";
import { dojoConfig } from "../dojoConfig.ts";

async function main() {
  // const dojoAppConfig = useMemo(() => makeDojoAppConfig(), []);
  const dojoAppConfig = makeDojoAppConfig();
  createRoot(document.getElementById("root")!).render(
    <StrictMode>
      <StarknetProvider dojoAppConfig={dojoAppConfig}>
        <DojoContextProvider
          burnerManager={await setupBurnerManager(dojoConfig)}
          appConfig={dojoAppConfig}
        >
          <Router>
            <App />
          </Router>
        </DojoContextProvider>
      </StarknetProvider>
    </StrictMode>
  );
}

main().catch((error) => {
  console.error("Failed to initialize the application:", error);
});
