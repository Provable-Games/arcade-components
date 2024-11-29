import { createDojoStore } from "@dojoengine/sdk";
import { TournamentSchemaType } from "@/generated/models.gen";

export const useDojoStore = createDojoStore<TournamentSchemaType>();
