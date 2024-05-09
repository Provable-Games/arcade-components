import React, { useState } from "react";
import {
  Box,
  Button,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  TextField,
  Paper,
  FormControl,
  InputLabel,
  Select,
  SelectChangeEvent,
  MenuItem,
} from "@mui/material";
import PlayArrowIcon from "@mui/icons-material/PlayArrow";
import { useGetClients } from "../hooks/useGetClients";
import { useGetOwnersForAddress } from "../hooks/useGetOwnersForAddress";
import { useDojo } from "../dojo/useDojo";
import { useGetCreators } from "../hooks/useGetCreators";
import { isValidUrl } from "../utils/validate";

const ClientTable: React.FC = () => {
  const {
    setup: {
      systemCalls: { playClient, rateClient, changeUrl },
    },
    account,
  } = useDojo();
  const { clients } = useGetClients();
  const { creators } = useGetCreators();
  const { ownerTokens } = useGetOwnersForAddress(
    BigInt(account?.account.address)
  );

  const [isEditUrls, setIsEditUrls] = useState<{ [key: string]: string }>({});
  const [editUrls, setEditUrls] = useState<{ [key: string]: string }>({});
  const [ratings, setRatings] = useState<{ [key: string]: string }>({});

  const toggleEdit = (clientId: any) => {
    const isEditing = isEditUrls[clientId];
    setIsEditUrls({ ...isEditUrls, [clientId]: !isEditing });
    if (!isEditing) {
      setEditUrls({
        ...editUrls,
        [clientId]: "",
      });
    }
  };

  const handleUrlChange = (clientId: string, value: string) => {
    setEditUrls((prev) => ({ ...prev, [clientId]: value }));
  };

  const handleRatingChange = (clientId: string, value: string) => {
    const numericValue = parseInt(value, 10); // Convert input to a number
    if (numericValue >= 0 && numericValue <= 100) {
      setRatings((prev) => ({ ...prev, [clientId]: value }));
    }
  };

  const submitUrlChange = (clientId: string) => {
    console.log(
      "Changing url for client:",
      clientId,
      "Url:",
      editUrls[clientId]
    );
    changeUrl(account.account, BigInt(clientId), BigInt(editUrls[clientId]));
    setEditUrls((prev) => ({ ...prev, [clientId]: "" }));
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

  const [filters, setFilters] = useState({
    filterCreatorId: "",
    filterGameId: "",
    filterName: "",
    filterUrl: "",
  });

  // Create a mapping from creatorId to creator's name
  const creatorMap = creators.reduce((acc, creator) => {
    acc[creator.creatorId] = creator.name;
    return acc;
  }, {});

  const filteredClients = clients.filter(
    (client) =>
      client.creatorId.toString().includes(filters.filterCreatorId) &&
      client.gameId.toString().includes(filters.filterGameId) &&
      client.name.toLowerCase().includes(filters.filterName.toLowerCase()) &&
      client.url.includes(filters.filterUrl)
  );

  const games = ["Loot Survivor", "Loot Survivor 2", "Dragon Quest", "Chess"];

  const handleSelectFilter = (event: SelectChangeEvent<string>) => {
    const name = event.target.name;
    const value = event.target.value;

    if (name === "filterGameId") {
      // Find the index of the selected game
      const gameIndex = games.indexOf(value);
      setFilters({
        ...filters,
        [name]: gameIndex.toString(), // Store the index as a string
      });
    } else {
      // Handle other select changes normally
      setFilters({
        ...filters,
        [name]: value,
      });
    }
  };

  return (
    <Box>
      <Box
        sx={{
          display: "flex", // Enables flexbox layout
          marginBottom: 2, // Adds margin below the box for spacing
          gap: 2, // Adds gap between each child component
        }}
      >
        <FormControl fullWidth margin="normal">
          <InputLabel id="filter-creator-label">Creator</InputLabel>
          <Select
            labelId="filter-creator-label"
            id="filterCreatorId"
            name="filterCreatorId"
            value={filters.filterCreatorId}
            label="Creator"
            onChange={handleSelectFilter}
          >
            {creators.map((client) => (
              <MenuItem key={client.creatorId} value={client.creatorId}>
                {client.creatorId.toString()}
              </MenuItem>
            ))}
          </Select>
        </FormControl>
        <FormControl fullWidth margin="normal">
          <InputLabel id="filter-game-label">Game</InputLabel>
          <Select
            labelId="filter-game-label"
            id="filterGameId"
            name="filterGameId"
            value={games[parseInt(filters.filterGameId)]}
            label="Game"
            onChange={handleSelectFilter}
          >
            {games.map((game, index) => (
              <MenuItem key={index} value={game}>
                {game}
              </MenuItem>
            ))}
          </Select>
        </FormControl>
      </Box>
      <TableContainer
        component={Paper}
        style={{ maxHeight: 600, overflow: "auto" }}
      >
        <Table stickyHeader aria-label="simple table">
          <TableHead>
            <TableRow>
              <TableCell>Creator</TableCell>
              <TableCell>Game ID</TableCell>
              <TableCell>Name</TableCell>
              <TableCell>URL</TableCell>
              <TableCell>Played Count</TableCell>
              <TableCell>Rating</TableCell>
              <TableCell>Votes (/ Played)</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {filteredClients.map((client, index) => (
              <TableRow key={index}>
                <TableCell>{creatorMap[client.creatorId]}</TableCell>
                <TableCell>{games[client.gameId]}</TableCell>
                <TableCell>{client.name}</TableCell>
                <TableCell>
                  {isEditUrls[client.clientId.toString()] ? (
                    <>
                      <TextField
                        size="small"
                        value={editUrls[client.clientId.toString()] || ""}
                        onChange={(e) =>
                          handleUrlChange(
                            client.clientId.toString(),
                            e.target.value
                          )
                        }
                        onBlur={() => toggleEdit(client.clientId.toString())}
                      />
                      <Button
                        size="small"
                        variant="outlined"
                        onClick={() => submitUrlChange(client.clientId)}
                      >
                        Save
                      </Button>
                    </>
                  ) : (
                    <>
                      {client.url}
                      {ownerTokens.includes(BigInt(client.creatorId)) && (
                        <Button
                          size="small"
                          variant="outlined"
                          onClick={() => toggleEdit(client.clientId.toString())}
                        >
                          Edit
                        </Button>
                      )}
                    </>
                  )}
                </TableCell>
                <TableCell>
                  <div
                    style={{
                      display: "flex",
                      alignItems: "center",
                      gap: "5px",
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
                  <div
                    style={{
                      display: "flex",
                      alignItems: "center",
                      gap: "2px",
                    }}
                  >
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
                <TableCell>
                  {`${client.voteCount} ( /${client.playTotal})`}
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>
    </Box>
  );
};

export default ClientTable;
