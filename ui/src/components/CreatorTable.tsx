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
  // const [games, _setGames] = useState([
  //   {
  //     gameId: "1",
  //     name: "Survivor",
  //     url: "survivor.com",
  //   },
  // ]);

  return (
    <TableContainer component={Paper}>
      <Table aria-label="simple table">
        <TableHead>
          <TableRow>
            <TableCell>Game ID</TableCell>
            <TableCell>Name</TableCell>
            <TableCell>URL</TableCell>
            <TableCell>Owner</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {creators.map((creator, index) => (
            <TableRow key={index}>
              <TableCell>{creator.github_username}</TableCell>
              <TableCell>{creator.telegram_handle}</TableCell>
              <TableCell>{creator.x_handle}</TableCell>
              <TableCell>{shortenAddress(creator.ownerAddress)}</TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </TableContainer>
  );
};

export default ClientTable;
