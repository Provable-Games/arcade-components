import { ReactElement } from "react";
import { ScreenPage } from "../hooks/useUIStore";
import {
  InputPremium,
  InputGatedTypeEnum,
  InputTokenDataTypeEnum,
  Premium,
  GatedTypeEnum,
  TokenDataTypeEnum,
} from "@/generated/models.gen";
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
  gated_type: CairoOption<GatedTypeEnum>;
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

export type EntryType = {
  criteria?: EntryCriteria[];
  uniform?: number;
};

export type GatedSubmissionType = {
  token_id: BigNumberish;
  game_id: BigNumberish[];
};

export type DataType = {
  SpotEntry: BigNumberish;
  FutureEntry: FutureEntry;
  GenericEntry: BigNumberish;
};

export type FutureEntry = {
  pair_id: BigNumberish;
  expiration_timestamp: BigNumberish;
};

export enum TokenDataEnum {
  erc20,
  erc721,
}

export type TokenDataType = {
  erc20: ERC20Data;
  erc721: ERC721Data;
};

// Create a typed wrapper for CairoCustomEnum
export type TypedCairoEnum<T> = CairoCustomEnum & {
  variant: { [K in keyof T]: T[K] | undefined };
  unwrap(): T[keyof T];
};

export type DataTypeEnum = TypedCairoEnum<DataType>;

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
