import React, { useState, useEffect } from "react";
import { Box, Tab, Tabs, Container, Grid, CssBaseline } from "@mui/material";
import RegisterCreatorForm from "./components/RegisterCreatorForm";
import RegisterClientForm from "./components/RegisterClientForm";
import CreatorTable from "./components/CreatorTable";
import ClientTable from "./components/ClientTable";
import "./App.css";
import { useDojo } from "./dojo/useDojo";
import CreatorTokens from "./components/CreatorTokens"; // Assuming this is the footer now
import { useGetCreators } from "./hooks/useGetCreators";
import { useGetClients } from "./hooks/useGetClients";
import { useGetOwners } from "./hooks/useGetOwners";

function App() {
  const { account } = useDojo();
  const { creators } = useGetCreators();
  const { clients } = useGetClients();
  const { owners } = useGetOwners();
  console.log(owners);

  const [clipboardStatus, setClipboardStatus] = useState({
    message: "",
    isError: false,
  });

  useEffect(() => {
    if (clipboardStatus.message) {
      const timer = setTimeout(() => {
        setClipboardStatus({ message: "", isError: false });
      }, 3000);
      return () => clearTimeout(timer);
    }
  }, [clipboardStatus.message]);

  const [selectedTab, setSelectedTab] = useState(0);

  const handleTabChange = (_event: React.SyntheticEvent, newValue: number) => {
    setSelectedTab(newValue);
  };

  const accountExists = account && account?.list().length > 0;

  return (
    <>
      <CssBaseline />
      {!accountExists ? (
        <button onClick={() => account?.create()}>
          {account?.isDeploying ? "deploying burner" : "create burner"}
        </button>
      ) : (
        <Container
          component="main"
          maxWidth={false}
          disableGutters
          sx={{ display: "flex", flexDirection: "column", minHeight: "100vh" }}
        >
          <Grid container spacing={2} sx={{ flex: 1, overflow: "auto" }}>
            <Grid item xs={12}>
              <Tabs
                value={selectedTab}
                onChange={handleTabChange}
                aria-label="simple tabs example"
                variant="fullWidth"
                sx={{ borderBottom: 1, borderColor: "divider" }}
              >
                <Tab label="Creators" />
                <Tab label="Clients" disabled={creators.length === 0} />
              </Tabs>
              {selectedTab === 0 && (
                <Grid container spacing={2}>
                  <Grid item xs={12} md={9}>
                    <CreatorTable />
                  </Grid>
                  <Grid item xs={12} md={3}>
                    <RegisterCreatorForm />
                  </Grid>
                </Grid>
              )}
              {selectedTab === 1 && (
                <Grid container spacing={2}>
                  <Grid item xs={12} md={9}>
                    <ClientTable />
                  </Grid>
                  <Grid item xs={12} md={3}>
                    <RegisterClientForm />
                  </Grid>
                </Grid>
              )}
            </Grid>
          </Grid>
          {/* Footer fixed at the bottom */}
          <Box
            component="footer"
            sx={{
              height: "400px",
              width: "100%",
            }}
          >
            <CreatorTokens />
          </Box>
        </Container>
      )}
    </>
  );
}

export default App;
