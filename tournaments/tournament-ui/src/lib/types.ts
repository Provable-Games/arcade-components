import { ReactElement } from "react";
import { ScreenPage } from "../hooks/useUIStore";
import { Premium } from "@/generated/models.gen";
import {
  ByteArray,
  CairoOption,
  CairoCustomEnum,
  BigNumberish,
} from "starknet";

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
  gatedType: CairoOption<GatedTypeEnum>;
  entryFee: CairoOption<Premium>;
  prizes: Prize[];
};

export type Tournament = {
  name: number;
  description: ByteArray;
  start_time: number;
  end_time: number;
  submission_period: number;
  winners_count: number;
  gated_type: CairoOption<CairoCustomEnum>;
  entry_premium: CairoOption<Premium>;
};

export type Prize = {
  tournamentId: number;
  token: string;
  tokenDataType: TokenDataTypeEnum;
  position: number;
};

// export interface GatedToken<T> {
//   token: string;
//   entry_type: T;
// }

export interface EntryCriteria {
  token_id: number;
  entry_count: number;
}

export interface Distribution {
  position: number;
  percentage: number;
}

export interface Token {
  token: string;
  tokenDataType: TokenDataTypeEnum;
}

export type GatedType = {
  token?: GatedToken;
  tournament?: number[];
  address?: string[];
};

export type GatedToken = {
  token: string;
  entry_type: EntryTypeEnum;
};

export type EntryType = {
  criteria?: EntryCriteria[];
  uniform?: number;
};

export type TokenDataType = {
  erc20?: ERC20Data;
  erc721?: ERC721Data;
};

export type GatedSubmissionType = {
  token_id: BigNumberish;
  game_id: BigNumberish[];
};

// Create a typed wrapper for CairoCustomEnum
export type TypedCairoEnum<T> = CairoCustomEnum & {
  variant: { [K in keyof T]: T[K] | undefined };
  unwrap(): T[keyof T];
};

export type GatedTypeEnum = TypedCairoEnum<GatedType>;
export type EntryTypeEnum = TypedCairoEnum<EntryType>;
export type TokenDataTypeEnum = TypedCairoEnum<TokenDataType>;
export type GatedSubmissionTypeEnum = TypedCairoEnum<GatedSubmissionType>;

// export type Premium = {
//   token: string;
//   token_amount: number;
//   token_distribution: Array<number>;
//   creator_fee: number;
// };

export type ERC20Data = {
  token_amount: number;
};

export type ERC721Data = {
  token_id: number;
};

export const DataType = {
  SpotEntry: (pairId: string) => ({
    variant: "SpotEntry",
    activeVariant: () => "SpotEntry",
    unwrap: () => pairId,
  }),
  FutureEntry: (pairId: string, expirationTimestamp: string) => ({
    variant: "FutureEntry",
    activeVariant: () => "FutureEntry",
    unwrap: () => [pairId, expirationTimestamp],
  }),
  GenericEntry: (key: string) => ({
    variant: "GenericEntry",
    activeVariant: () => "GenericEntry",
    unwrap: () => key,
  }),
};
