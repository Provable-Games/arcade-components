import React, { useState } from "react";
import {
  Box,
  Button,
  Grid,
  Card,
  CardMedia,
  CardContent,
  Typography,
  TextField,
  CardActions,
} from "@mui/material";
import { useGetCreatorsForOwner } from "../hooks/useGetCreatorsForOwner";
import { useGetOwnersForAddress } from "../hooks/useGetOwnersForAddress";
import { useDojo } from "../dojo/useDojo";

const CreatorTokens: React.FC = () => {
  const [address, setAddress] = useState<string>("");
  const { account } = useDojo();
  const { ownerTokens } = useGetOwnersForAddress(
    BigInt(account?.account.address)
  );
  const { creators } = useGetCreatorsForOwner(ownerTokens);

  console.log(creators);

  const handleTransfer = (nftId: bigint) => {
    console.log(`Transfer NFT with ID ${nftId} to address ${address}`);
    // Implement the transfer logic here
  };

  const handleBurn = (nftId: bigint) => {
    console.log(`Burn NFT with ID ${nftId}`);
    // Implement the burn logic here
  };

  return (
    <Box sx={{ flexGrow: 1, overflow: "hidden", padding: 2 }}>
      <Typography
        variant="h5"
        component="h2"
        sx={{ textAlign: "center", marginBottom: 2 }}
      >
        Owned Tokens
      </Typography>
      {creators.length > 0 ? (
        <Box sx={{ overflowX: "auto" }}>
          <Grid
            container
            spacing={2}
            sx={{ display: "flex", flexDirection: "row" }}
          >
            {creators.map((creator) => (
              <Grid item key={creator.creator_id} sx={{ flex: "none" }}>
                <Card sx={{ maxWidth: 275 }}>
                  <CardMedia
                    component="img"
                    height="140"
                    image={"creator.webp"} // Update this URL based on actual image sources
                    alt={creator.github_username}
                  />
                  <CardContent>
                    <Typography variant="body1" color="text.primary">
                      Creator: {creator.creator_id.toString()}
                    </Typography>
                    <Typography variant="body2" color="text.secondary">
                      Github: {creator.github_username}
                    </Typography>
                    <Typography variant="body2" color="text.secondary">
                      Telegram: {creator.telegram_handle}
                    </Typography>
                    <Typography variant="body2" color="text.secondary">
                      X: {creator.x_handle}
                    </Typography>
                  </CardContent>
                  <CardActions>
                    <TextField
                      label="Address"
                      variant="outlined"
                      size="small"
                      fullWidth
                      value={address}
                      onChange={(e) => setAddress(e.target.value)}
                    />
                    <Button
                      variant="contained"
                      color="primary"
                      onClick={() => handleTransfer(BigInt(creator.creator_id))}
                    >
                      Send
                    </Button>
                    <Button
                      variant="contained"
                      color="secondary"
                      onClick={() => handleBurn(BigInt(creator.creator_id))}
                    >
                      Burn
                    </Button>
                  </CardActions>
                </Card>
              </Grid>
            ))}
          </Grid>
        </Box>
      ) : (
        <Typography variant="h6" color="text.secondary" textAlign="center">
          No tokens yet.
        </Typography>
      )}
    </Box>
  );
};

export default CreatorTokens;
