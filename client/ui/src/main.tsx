import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App.tsx";
import { setup } from "./dojo/generated/setup.ts";
import { DojoProvider } from "./dojo/DojoContext.tsx";
import { dojoConfig } from "../dojoConfig.ts";
import "./index.css";

const setupResult = await setup(dojoConfig);

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <DojoProvider value={setupResult}>
      <App />
    </DojoProvider>
  </React.StrictMode>
);
