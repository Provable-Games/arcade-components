export type DeveloperDetails = {
  githubUsername: number;
  telegramHandle: number;
  xHandle: number;
};

export type ClientDetails = {
  developerId: number;
  gameId: number;
  name: number;
  url: number;
};

export function stringToFelt(str: string) {
  const encoder = new TextEncoder();
  const encoded = encoder.encode(str);
  const hex = Array.from(encoded)
    .map((byte) => byte.toString(16).padStart(2, "0"))
    .join("");
  return "0x" + hex;
}
