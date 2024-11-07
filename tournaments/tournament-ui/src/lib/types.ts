import { ReactElement } from "react";
import { ScreenPage } from "../hooks/useUIStore";
import { GatedType, Premium, TokenDataType } from "@/generated/models.gen";
import { OptionValue } from "@/generated/constants";
import { ByteArray } from "starknet";
import { GatedTypeValue, GatedEntryTypeValue } from "@/generated/models.gen";

export type Menu = {
  id: number;
  label: string | ReactElement;
  screen: ScreenPage;
  path: string;
  disabled?: boolean;
};

export type FormData = {
  tournamentName: string;
  tournamentDescription: string;
  startTime: Date | undefined;
  endTime: Date | undefined;
  submissionPeriod: number;
  scoreboardSize: number;
  gatedType: OptionValue<
    GatedTypeValue<GatedEntryTypeValue<EntryCriteria | number>>
  >;
  entryFree: OptionValue<Premium>;
  prizes: Prize[];
};

export type Tournament = {
  name: number;
  description: ByteArray;
  start_time: number;
  end_time: number;
  submission_period: number;
  winners_count: number;
  gated_type: OptionValue<
    GatedTypeValue<GatedEntryTypeValue<EntryCriteria | number>>
  >;
  entry_premium: OptionValue<Premium>;
};

export type Prize = {
  tournamentId: number;
  token: string;
  tokenDataType: TokenDataType;
  position: number;
};

export interface GatedToken<T> {
  token: string;
  entry_type: T;
}

export interface EntryCriteria {
  token_id: number;
  entry_count: number;
}
