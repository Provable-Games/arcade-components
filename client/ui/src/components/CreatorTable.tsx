// src/components/ClientTable.tsx
import React from "react";
import {
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
} from "@mui/material";
import { useGetCreators } from "../hooks/useGetCreators";
import { shortenAddress } from "../utils";

const ClientTable: React.FC = () => {
  const { creators } = useGetCreators();

  return (
    <TableContainer component={Paper}>
      <Table aria-label="simple table">
        <TableHead>
          <TableRow>
            <TableCell>Name</TableCell>
            <TableCell>Github Username</TableCell>
            <TableCell>Telegram Handle</TableCell>
            <TableCell>X Handle</TableCell>
            <TableCell>Owner</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {creators.map((creator, index) => (
            <TableRow key={index}>
              <TableCell>{creator.name}</TableCell>
              <TableCell>{creator.githubUsername}</TableCell>
              <TableCell>{creator.telegramHandle}</TableCell>
              <TableCell>{creator.xHandle}</TableCell>
              <TableCell>{shortenAddress(creator.ownerAddress)}</TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </TableContainer>
  );
};

export default ClientTable;
