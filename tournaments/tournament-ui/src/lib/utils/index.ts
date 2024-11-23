import { ClassValue, clsx } from "clsx";
import { twMerge } from "tailwind-merge";
import { BigNumberish, shortString, ByteArray } from "starknet";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export function formatNumber(num: number): string {
  if (Math.abs(num) >= 1000000) {
    return parseFloat((num / 1000000).toFixed(2)) + "m";
  } else if (Math.abs(num) >= 1000) {
    return parseFloat((num / 1000).toFixed(2)) + "k";
  } else {
    return num.toFixed(2);
  }
}

export function indexAddress(address: string) {
  return address.replace(/^0x0+/, "0x");
}

export function displayAddress(string: string) {
  if (string === undefined) return "unknown";
  return string.substring(0, 6) + "..." + string.substring(string.length - 4);
}

export const stringToFelt = (v: string): BigNumberish =>
  v ? shortString.encodeShortString(v) : "0x0";

export const bigintToHex = (v: BigNumberish): `0x${string}` =>
  !v ? "0x0" : `0x${BigInt(v).toString(16)}`;

export const feltToString = (v: BigNumberish): string =>
  BigInt(v) > 0n ? shortString.decodeShortString(bigintToHex(v)) : "";

export function byteArrayFromString(targetString: string): ByteArray {
  const shortStrings: string[] = shortString.splitLongString(targetString);
  const remainder: string = shortStrings[shortStrings.length - 1];
  const shortStringsEncoded: BigNumberish[] = shortStrings.map(
    shortString.encodeShortString
  );

  const [pendingWord, pendingWordLength] =
    remainder === undefined || remainder.length === 31
      ? ["0x00", 0]
      : [shortStringsEncoded.pop()!, remainder.length];

  return {
    data: shortStringsEncoded.length === 0 ? [] : shortStringsEncoded,
    pending_word: pendingWord,
    pending_word_len: pendingWordLength,
  };
}

export const formatTime = (seconds: number): string => {
  const minutes = Math.floor(seconds / 60);
  const hours = Math.floor(minutes / 60);
  const days = Math.floor(hours / 24);

  if (days > 0) {
    return `${days} day${days > 1 ? "s" : ""}`;
  } else if (hours > 0) {
    return `${hours} hour${hours > 1 ? "s" : ""}`;
  } else if (minutes > 0) {
    return `${minutes} minute${minutes > 1 ? "s" : ""}`;
  } else {
    return `${seconds} second${seconds > 1 ? "s" : ""}`;
  }
};

// Add a utility function to check if a date is before another date
export function isBefore(date1: Date, date2: Date) {
  return date1.getTime() < date2.getTime();
}
