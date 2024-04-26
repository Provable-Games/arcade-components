// src/components/ClientTable.tsx
import { useState } from "react";
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

const ClientTable: React.FC = () => {
  const [games, setGames] = useState([
    {
      gameId: "1",
      name: "Survivor",
      url: "survivor.com",
    },
  ]);

  return (
    <TableContainer component={Paper}>
      <Table aria-label="simple table">
        <TableHead>
          <TableRow>
            <TableCell>Game ID</TableCell>
            <TableCell>Name</TableCell>
            <TableCell>URL</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {games.map((game, index) => (
            <TableRow key={index}>
              <TableCell>{game.gameId}</TableCell>
              <TableCell>{game.name}</TableCell>
              <TableCell>{game.url}</TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </TableContainer>
  );
};

export default ClientTable;
