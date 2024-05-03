// src/components/GameForm.tsx

import React, { useState } from "react";
import { TextField, Button, Box } from "@mui/material";
import { useDojo } from "../dojo/useDojo";
import { Entity } from "@dojoengine/recs";
// import { Direction } from "./utils";
import { useComponentValue } from "@dojoengine/react";
import { getEntityIdFromKeys } from "@dojoengine/utils";
import { stringToFelt } from "../utils";

interface RegisterDeveloperData {
  githubUsername: string;
  telegramHandle: string;
  xHandle: string;
}

const RegisterDeveloperForm: React.FC = () => {
  const {
    setup: {
      systemCalls: { registerDeveloper },
      clientComponents: { ClientDeveloper },
    },
    account,
  } = useDojo();

  // entity id we are syncing
  const entityId = getEntityIdFromKeys([
    BigInt(account?.account.address),
  ]) as Entity;

  // get current component values
  const clientDeveloper = useComponentValue(ClientDeveloper, entityId);

  console.log(clientDeveloper);

  const [formData, setFormData] = useState<RegisterDeveloperData>({
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

  const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    console.log("Submitted data:", formData);
    registerDeveloper(account.account, {
      githubUsername: parseInt(stringToFelt(formData.githubUsername)),
      telegramHandle: parseInt(stringToFelt(formData.telegramHandle)),
      xHandle: parseInt(stringToFelt(formData.xHandle)),
    });
  };

  return (
    <Box component="form" onSubmit={handleSubmit} noValidate sx={{ mt: 1 }}>
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
      <Button type="submit" fullWidth variant="contained" sx={{ mt: 3, mb: 2 }}>
        Submit
      </Button>
    </Box>
  );
};

export default RegisterDeveloperForm;
