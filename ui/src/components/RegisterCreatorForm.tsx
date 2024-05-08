// src/components/GameForm.tsx

import React, { useState } from "react";
import { TextField, Typography, Button, Box } from "@mui/material";
import { useDojo } from "../dojo/useDojo";
import { stringToFelt } from "../utils";

interface RegisterCreatorData {
  githubUsername: string;
  telegramHandle: string;
  xHandle: string;
}

const RegisterCreatorForm: React.FC = () => {
  const {
    setup: {
      systemCalls: { registerCreator },
    },
    account,
  } = useDojo();

  const [formData, setFormData] = useState<RegisterCreatorData>({
    githubUsername: "",
    telegramHandle: "",
    xHandle: "",
  });

  const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setFormData({
      ...formData,
      [event.target.name]: event.target.value,
    });
  };

  const isFormComplete = (): boolean => {
    return (
      Boolean(formData.githubUsername) &&
      Boolean(formData.telegramHandle) &&
      Boolean(formData.xHandle)
    );
  };

  const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    console.log("Submitted data:", formData);
    registerCreator(account.account, {
      githubUsername: BigInt(stringToFelt(formData.githubUsername)),
      telegramHandle: BigInt(stringToFelt(formData.telegramHandle)),
      xHandle: BigInt(stringToFelt(formData.xHandle)),
    });
  };

  return (
    <Box component="form" onSubmit={handleSubmit} noValidate sx={{ mt: 1 }}>
      <Typography variant="h5" component="h2" sx={{ textAlign: "left" }}>
        Register Creator
      </Typography>
      <TextField
        margin="normal"
        required
        fullWidth
        id="githubUsername"
        label="Github Username"
        name="githubUsername"
        autoComplete="github-username"
        autoFocus
        value={formData.githubUsername}
        onChange={handleChange}
      />
      <TextField
        margin="normal"
        required
        fullWidth
        id="telegramHandle"
        label="Telegram Handle"
        name="telegramHandle"
        autoComplete="telegram-handle"
        value={formData.telegramHandle}
        onChange={handleChange}
      />
      <TextField
        margin="normal"
        required
        fullWidth
        id="xHandle"
        label="X Handle"
        name="xHandle"
        autoComplete="x-handle"
        value={formData.xHandle}
        onChange={handleChange}
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

export default RegisterCreatorForm;
