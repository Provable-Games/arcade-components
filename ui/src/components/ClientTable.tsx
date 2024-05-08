import React, { useState } from "react";
import {
  Button,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  TextField,
  Paper,
} from "@mui/material";
import PlayArrowIcon from "@mui/icons-material/PlayArrow";
import { useGetClients } from "../hooks/useGetClients";
import { useDojo } from "../dojo/useDojo";

const ClientTable: React.FC = () => {
  const { clients } = useGetClients();
  const {
    setup: {
      systemCalls: { playClient, rateClient },
    },
    account,
  } = useDojo();

  const [ratings, setRatings] = useState<{ [key: string]: string }>({});

  const handleRatingChange = (clientId: string, value: string) => {
    const numericValue = parseInt(value, 10); // Convert input to a number
    if (numericValue >= 0 && numericValue <= 100) {
      setRatings((prev) => ({ ...prev, [clientId]: value }));
    }
  };

  const submitRating = (clientId: string) => {
    console.log(
      "Submitting rating for client:",
      clientId,
      "Rating:",
      ratings[clientId]
    );
    rateClient(account.account, BigInt(clientId), BigInt(ratings[clientId]));
    setRatings((prev) => ({ ...prev, [clientId]: "" }));
  };

  const handlePlay = (clientId: string) => {
    console.log(`Play Client with ID ${clientId}`);
    playClient(account.account, BigInt(clientId));
  };

  return (
    <TableContainer
      component={Paper}
      style={{ maxHeight: 440, overflow: "auto" }}
    >
      <Table stickyHeader aria-label="simple table">
        <TableHead>
          <TableRow>
            <TableCell>Creator ID</TableCell>
            <TableCell>Game ID</TableCell>
            <TableCell>Name</TableCell>
            <TableCell>URL</TableCell>
            <TableCell>Played Count</TableCell>
            <TableCell>Rating</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {clients.map((client, index) => (
            <TableRow key={index}>
              <TableCell>{client.creatorId}</TableCell>
              <TableCell>{client.gameId}</TableCell>
              <TableCell>{client.name}</TableCell>
              <TableCell>{client.url}</TableCell>
              <TableCell>
                <div
                  style={{
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "space-between",
                  }}
                >
                  {client.playTotal}
                  <Button
                    size="small"
                    variant="outlined"
                    startIcon={<PlayArrowIcon />}
                    onClick={() => handlePlay(client.clientId.toString())}
                  >
                    Play
                  </Button>
                </div>
              </TableCell>
              <TableCell>
                <div style={{ display: "flex", alignItems: "center" }}>
                  {client.ratingTotal}
                  <TextField
                    size="small"
                    type="number"
                    value={ratings[client.clientId.toString()] || ""}
                    onChange={(e) =>
                      handleRatingChange(
                        client.clientId.toString(),
                        e.target.value
                      )
                    }
                    style={{ marginLeft: "10px", width: "60px" }}
                    disabled={client.playTotal <= client.voteCount}
                  />
                  <Button
                    size="small"
                    variant="contained"
                    color="primary"
                    onClick={() => submitRating(client.clientId.toString())}
                    style={{ marginLeft: "10px" }}
                    disabled={client.playTotal <= client.voteCount}
                  >
                    Rate
                  </Button>
                </div>
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </TableContainer>
  );
};

export default ClientTable;
