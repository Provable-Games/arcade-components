import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import "./index.css";
import App from "./App.tsx";
import { init } from "@dojoengine/sdk";
import { TournamentSchemaType, schema } from "./generated/models.gen";
import { dojoConfig } from "../dojoConfig.ts";
import { StarknetProvider } from "./context/starknet";
import { DojoContextProvider } from "./DojoContext";
import { SDKProvider } from "./context/sdk";
import { setupBurnerManager } from "@dojoengine/create-burner";
import { BrowserRouter as Router } from "react-router-dom";

async function main() {
  const sdk = await init<TournamentSchemaType>(
    {
      client: {
        rpcUrl: dojoConfig.rpcUrl,
        toriiUrl: dojoConfig.toriiUrl,
        relayUrl: dojoConfig.relayUrl,
        worldAddress: dojoConfig.manifest.world.address,
      },
      domain: {
        name: "WORLD_NAME",
        version: "1.0",
        chainId: "KATANA",
        revision: "1",
      },
    },
    schema
  );

  createRoot(document.getElementById("root")!).render(
    <StrictMode>
      <StarknetProvider>
        <DojoContextProvider
          burnerManager={await setupBurnerManager(dojoConfig)}
        >
          <SDKProvider value={sdk}>
            <Router>
              <App />
            </Router>
          </SDKProvider>
        </DojoContextProvider>
      </StarknetProvider>
    </StrictMode>
  );
}

main().catch((error) => {
  console.error("Failed to initialize the application:", error);
});
