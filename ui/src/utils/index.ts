import { BigNumberish, shortString } from "starknet";

export type CreatorDetails = {
  githubUsername: BigNumberish;
  telegramHandle: BigNumberish;
  xHandle: BigNumberish;
};

export type ClientDetails = {
  creatorId: BigNumberish;
  gameId: BigNumberish;
  name: BigNumberish;
  url: BigNumberish;
};

export const stringToFelt = (v: string): string =>
  v ? shortString.encodeShortString(v) : "0x0";

export const feltToString = (hex: string): string =>
  BigInt(hex) > 0n ? shortString.decodeShortString(hex) : "";

export const feltToHex = (v: bigint): string =>
  v ? "0x" + v.toString(16) : "0x0";

export function shortenAddress(string: string) {
  if (string === undefined) return "unknown";
  return string.substring(0, 6) + "..." + string.substring(string.length - 4);
}
