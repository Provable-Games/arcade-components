// src/components/GameForm.tsx

import React, { useState } from "react";
import { TextField, Button, Box } from "@mui/material";

interface RegisterFormData {
  gameId: string;
  name: string;
  url: string;
}

const RegisterForm: React.FC = () => {
  const [formData, setFormData] = useState<RegisterFormData>({
    gameId: "",
    name: "",
    url: "",
  });

  const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setFormData({
      ...formData,
      [event.target.name]: event.target.value,
    });
  };

  const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    console.log("Submitted data:", formData);
  };

  return (
    <Box component="form" onSubmit={handleSubmit} noValidate sx={{ mt: 1 }}>
      <TextField
        margin="normal"
        required
        fullWidth
        id="gameId"
        label="Game ID"
        name="gameId"
        autoComplete="game-id"
        autoFocus
        value={formData.gameId}
        onChange={handleChange}
      />
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
      />
      <Button type="submit" fullWidth variant="contained" sx={{ mt: 3, mb: 2 }}>
        Submit
      </Button>
    </Box>
  );
};

export default RegisterForm;
