import { ReactElement } from "react";
import { ScreenPage } from "../hooks/useUIStore";

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
  gatedToken: string;
  entryFree: string;
  prizes: string[];
};

export type Token = {
  token: string;
  amount: number;
};
