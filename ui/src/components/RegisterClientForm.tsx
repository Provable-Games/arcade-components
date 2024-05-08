// src/components/GameForm.tsx

import React, { useState } from "react";
import {
  TextField,
  Typography,
  Button,
  Box,
  Select,
  MenuItem,
  InputLabel,
  FormControl,
  SelectChangeEvent,
  Grid,
} from "@mui/material";
import { useGetOwnersForAddress } from "../hooks/useGetOwnersForAddress";
import { useGetCreatorsForOwner } from "../hooks/useGetCreatorsForOwner";
import { useDojo } from "../dojo/useDojo";
import { stringToFelt } from "../utils";
import { isValidUrl } from "../utils/validate";

interface RegisterFormData {
  creatorId: string;
  gameId: string;
  name: string;
  url: string;
}

const RegisterClientForm: React.FC = () => {
  const {
    setup: {
      systemCalls: { registerClient },
    },
    account,
  } = useDojo();
  const { ownerTokens } = useGetOwnersForAddress(
    BigInt(account?.account.address)
  );
  const { creators } = useGetCreatorsForOwner(ownerTokens);

  const games = ["Loot Survivor", "Loot Survivor 2", "Dragon Quest", "Chess"];

  const [formData, setFormData] = useState<RegisterFormData>({
    creatorId: "",
    gameId: "",
    name: "",
    url: "",
  });

  const [urlError, setUrlError] = useState<string>("");

  const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = event.target;
    if (name === "url") {
      if (!isValidUrl(value)) {
        setUrlError("Invalid URL");
      } else {
        setUrlError("");
      }
    }
    setFormData({
      ...formData,
      [event.target.name]: event.target.value,
    });
  };

  const handleSelectChange = (event: SelectChangeEvent<string>) => {
    const name = event.target.name as keyof typeof formData;
    const value = event.target.value;

    if (name === "gameId") {
      // Find the index of the selected game
      const gameIndex = games.indexOf(value);
      setFormData({
        ...formData,
        [name]: gameIndex.toString(), // Store the index as a string
      });
    } else {
      // Handle other select changes normally
      setFormData({
        ...formData,
        [name]: value,
      });
    }
  };

  console.log(formData);

  const isFormComplete = (): boolean => {
    return (
      Boolean(formData.creatorId) &&
      Boolean(formData.gameId) &&
      Boolean(formData.name) &&
      Boolean(formData.url) &&
      !urlError
    );
  };

  const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    if (!isFormComplete()) {
      alert("Please fill all the fields correctly before submitting.");
      return;
    }
    console.log("Submitted data:", formData);
    registerClient(account.account, {
      creatorId: BigInt(formData.creatorId),
      gameId: BigInt(formData.gameId),
      name: BigInt(stringToFelt(formData.name)),
      url: BigInt(stringToFelt(formData.url)),
    });
  };

  return (
    <Box component="form" onSubmit={handleSubmit} noValidate sx={{ mt: 1 }}>
      <Typography variant="h5" component="h2" sx={{ textAlign: "center" }}>
        Register Client
      </Typography>
      <FormControl fullWidth margin="normal">
        <InputLabel id="creator-label">Creator</InputLabel>
        <Select
          labelId="creator-label"
          id="creatorId"
          name="creatorId"
          value={formData.creatorId}
          label="Creator"
          onChange={handleSelectChange}
        >
          {creators.map((creator) => (
            <MenuItem key={creator.creatorId} value={creator.creatorId}>
              {creator.creatorId.toString()}
            </MenuItem>
          ))}
        </Select>
      </FormControl>
      <FormControl fullWidth margin="normal">
        <InputLabel id="game-label">Game</InputLabel>
        <Select
          labelId="game-label"
          id="gameId"
          name="gameId"
          value={games[parseInt(formData.gameId)]}
          label="Game"
          onChange={handleSelectChange}
        >
          {games.map((game, index) => (
            <MenuItem key={index} value={game}>
              {game}
            </MenuItem>
          ))}
        </Select>
      </FormControl>
      <TextField
        margin="normal"
        required
        fullWidth
        id="name"
        label="Name"
        name="name"
        autoComplete="name"
        value={formData.name}
        onChange={handleChange}
      />
      <TextField
        margin="normal"
        required
        fullWidth
        id="url"
        label="URL"
        name="url"
        autoComplete="url"
        value={formData.url}
        onChange={handleChange}
        error={!!urlError}
        helperText={urlError}
      />
      <Button
        type="submit"
        fullWidth
        variant="contained"
        sx={{ mt: 3, mb: 2 }}
        disabled={!isFormComplete()}
      >
        Submit
      </Button>
    </Box>
  );
};

export default RegisterClientForm;
