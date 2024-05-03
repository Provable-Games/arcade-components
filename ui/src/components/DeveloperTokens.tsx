import React from "react";
import {
  Box,
  Grid,
  Card,
  CardMedia,
  CardContent,
  Typography,
} from "@mui/material";
import { useGetDevelopers } from "../hooks/useGetDevelopers";

// Mock data for NFTs, replace with your actual data source
const nfts: any[] = [
  // {
  //   id: 1,
  //   title: "NFT Artwork 1",
  //   imageUrl: "https://via.placeholder.com/150",
  //   description: "This is a description of NFT Artwork 1.",
  // },
  // {
  //   id: 2,
  //   title: "NFT Artwork 2",
  //   imageUrl: "https://via.placeholder.com/150",
  //   description: "This is a description of NFT Artwork 2.",
  // },
  // {
  //   id: 3,
  //   title: "NFT Artwork 3",
  //   imageUrl: "https://via.placeholder.com/150",
  //   description: "This is a description of NFT Artwork 3.",
  // },
];

const DeveloperTokens: React.FC = () => {
  const { developers } = useGetDevelopers();
  console.log(developers);
  return (
    <Box sx={{ flexGrow: 1, padding: 2 }}>
      <Typography
        variant="h4"
        component="h2"
        sx={{ textAlign: "center", marginBottom: 2 }}
      >
        Developer Tokens
      </Typography>
      {nfts.length > 0 ? (
        <Grid container spacing={2}>
          {nfts.map((nft) => (
            <Grid item xs={12} sm={6} md={4} key={nft.id}>
              <Card>
                <CardMedia
                  component="img"
                  height="140"
                  image={nft.imageUrl}
                  alt={nft.title}
                />
                <CardContent>
                  <Typography gutterBottom variant="h5" component="div">
                    {nft.title}
                  </Typography>
                  <Typography variant="body2" color="text.secondary">
                    {nft.description}
                  </Typography>
                </CardContent>
              </Card>
            </Grid>
          ))}
        </Grid>
      ) : (
        <Typography variant="h6" color="text.secondary" textAlign="center">
          No tokens yet.
        </Typography>
      )}
    </Box>
  );
};

export default DeveloperTokens;
