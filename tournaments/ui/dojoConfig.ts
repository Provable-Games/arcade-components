import { createDojoConfig } from "@dojoengine/core";

import manifest from "../dojo-starter/manifests/dev/deployment/manifest.json";

export const dojoConfig = createDojoConfig({
  manifest,
});
