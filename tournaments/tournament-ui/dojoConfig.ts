import { createDojoConfig } from "@dojoengine/core";

import manifest from "../contracts/manifest_dev.json";

export const dojoConfig = createDojoConfig({
  manifest,
});
