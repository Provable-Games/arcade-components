/* Autogenerated file. Do not edit manually. */
import { BigNumberish } from "starknet";

//
// enums
//

// Define the enum for Option
export enum Option {
  Some,
  None,
}

// Define an interface to hold the data
export interface OptionValue<T> {
  kind: Option;
  value?: T; // value is optional and only present when kind is Some
}

// Example usage
const someOption: OptionValue<number> = { kind: Option.Some, value: 42 };
const noneOption: OptionValue<null> = { kind: Option.None };

// export enum Option {
//   Some,
//   None,
// }

// from: ../contracts/src/ls15_components/interfaces.cairo
export enum DataType {
  SpotEntry = "SpotEntry",
  FutureEntry = "FutureEntry",
  GenericEntry = "GenericEntry",
}
export const DataTypeNameToValue: Record<DataType, number> = {
  [DataType.SpotEntry]: 0,
  [DataType.FutureEntry]: 1,
  [DataType.GenericEntry]: 2,
};
export const getDataTypeValue = (name: DataType): number =>
  DataTypeNameToValue[name];
export const getDataTypeFromValue = (value: number): DataType =>
  Object.keys(DataTypeNameToValue).find(
    (key) =>
      DataTypeNameToValue[key as keyof typeof DataTypeNameToValue] === value
  ) as DataType;

// from: ../contracts/src/ls15_components/interfaces.cairo
export enum AggregationMode {
  Median = "Median",
  Mean = "Mean",
  Error = "Error",
}
export const AggregationModeNameToValue: Record<AggregationMode, number> = {
  [AggregationMode.Median]: 0,
  [AggregationMode.Mean]: 1,
  [AggregationMode.Error]: 2,
};
export const getAggregationModeValue = (name: AggregationMode): number =>
  AggregationModeNameToValue[name];
export const getAggregationModeFromValue = (value: number): AggregationMode =>
  Object.keys(AggregationModeNameToValue).find(
    (key) =>
      AggregationModeNameToValue[
        key as keyof typeof AggregationModeNameToValue
      ] === value
  ) as AggregationMode;

// from: ../contracts/src/ls15_components/models/tournament.cairo
export enum GatedEntryType {
  criteria = "criteria",
  uniform = "uniform",
}
export const GatedEntryTypeNameToValue: Record<GatedEntryType, number> = {
  [GatedEntryType.criteria]: 0,
  [GatedEntryType.uniform]: 1,
};
export const getGatedEntryTypeValue = (name: GatedEntryType): number =>
  GatedEntryTypeNameToValue[name];
export const getGatedEntryTypeFromValue = (value: number): GatedEntryType =>
  Object.keys(GatedEntryTypeNameToValue).find(
    (key) =>
      GatedEntryTypeNameToValue[
        key as keyof typeof GatedEntryTypeNameToValue
      ] === value
  ) as GatedEntryType;

// from: ../contracts/src/ls15_components/models/tournament.cairo
export enum GatedType {
  token = "token",
  tournament = "tournament",
  address = "address",
}
export const GatedTypeNameToValue: Record<GatedType, number> = {
  [GatedType.token]: 0,
  [GatedType.tournament]: 1,
  [GatedType.address]: 2,
};
export const getGatedTypeValue = (name: GatedType): number =>
  GatedTypeNameToValue[name];
export const getGatedTypeFromValue = (value: number): GatedType =>
  Object.keys(GatedTypeNameToValue).find(
    (key) =>
      GatedTypeNameToValue[key as keyof typeof GatedTypeNameToValue] === value
  ) as GatedType;

// from: ../contracts/src/ls15_components/models/tournament.cairo
export enum GatedSubmissionType {
  token_id = "token_id",
  game_id = "game_id",
}
export const GatedSubmissionTypeNameToValue: Record<
  GatedSubmissionType,
  number
> = {
  [GatedSubmissionType.token_id]: 0,
  [GatedSubmissionType.game_id]: 1,
};
export const getGatedSubmissionTypeValue = (
  name: GatedSubmissionType
): number => GatedSubmissionTypeNameToValue[name];
export const getGatedSubmissionTypeFromValue = (
  value: number
): GatedSubmissionType =>
  Object.keys(GatedSubmissionTypeNameToValue).find(
    (key) =>
      GatedSubmissionTypeNameToValue[
        key as keyof typeof GatedSubmissionTypeNameToValue
      ] === value
  ) as GatedSubmissionType;

// from: ../contracts/src/ls15_components/models/tournament.cairo
export enum TokenDataType {
  erc20 = "erc20",
  erc721 = "erc721",
}
export const TokenDataTypeNameToValue: Record<TokenDataType, number> = {
  [TokenDataType.erc20]: 0,
  [TokenDataType.erc721]: 1,
};
export const getTokenDataTypeValue = (name: TokenDataType): number =>
  TokenDataTypeNameToValue[name];
export const getTokenDataTypeFromValue = (value: number): TokenDataType =>
  Object.keys(TokenDataTypeNameToValue).find(
    (key) =>
      TokenDataTypeNameToValue[key as keyof typeof TokenDataTypeNameToValue] ===
      value
  ) as TokenDataType;
// from: ../contracts/src/ls15_components/models/tournament.cairo
export enum EntryStatus {
  Started = "Started",
  Submitted = "Submitted",
}
export const EntryStatusNameToValue: Record<EntryStatus, number> = {
  [EntryStatus.Started]: 0,
  [EntryStatus.Submitted]: 1,
};
export const getEntryStatusValue = (name: EntryStatus): number =>
  EntryStatusNameToValue[name];
export const getEntryStatusFromValue = (value: number): EntryStatus =>
  Object.keys(EntryStatusNameToValue).find(
    (key) =>
      EntryStatusNameToValue[key as keyof typeof EntryStatusNameToValue] ===
      value
  ) as EntryStatus;

//
// constants
//
