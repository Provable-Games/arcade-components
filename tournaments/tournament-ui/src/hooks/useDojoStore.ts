import { createDojoStore } from "@dojoengine/sdk";
import { SchemaType } from "@/generated/models.gen";

export const useDojoStore = createDojoStore<SchemaType>();
