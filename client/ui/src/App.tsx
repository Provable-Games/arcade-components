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

  const [selectedRegisterTab, setSelectedRegisterTab] = useState(0);
  const [selectedTableTab, setSelectedTableTab] = useState(0);

  const handleRegisterTabChange = (
    _event: React.SyntheticEvent,
    newValue: number
  ) => {
    setSelectedRegisterTab(newValue);
  };

  const handleTableTabChange = (
    _event: React.SyntheticEvent,
    newValue: number
  ) => {
    setSelectedTableTab(newValue);
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
          sx={{
            display: "flex",
            flexDirection: "row",
            minHeight: "100vh",
            gap: "24px", // Adjust the gap size as needed }}
          }}
        >
          <Box
            sx={{
              flex: "0 0 300px", // This sets the Box to a fixed width of 300px
              display: "flex",
              flexDirection: "column",
              borderRight: 1, // Optional: adds a border line between the tabs and the table
              borderColor: "divider",
              paddingRight: "24px", // Optional: adds padding inside the Box
              minHeight: "100vh",
            }}
          >
            <Tabs
              value={selectedRegisterTab}
              onChange={handleRegisterTabChange}
              aria-label="simple tabs example"
              variant="fullWidth"
              sx={{ borderBottom: 1, borderColor: "divider" }}
            >
              <Tab label="Creators" />
              <Tab label="Game Clients" disabled={creators.length === 0} />
              <Tab label="Tokens" disabled={creators.length === 0} />
            </Tabs>
            {selectedRegisterTab === 0 && <RegisterCreatorForm />}
            {selectedRegisterTab === 1 && <RegisterClientForm />}
            {selectedRegisterTab === 2 && <CreatorTokens />}
          </Box>
          <Box
            sx={{
              display: "flex",
              flexDirection: "column",
              minHeight: "100vh",
            }}
          >
            <Tabs
              value={selectedTableTab}
              onChange={handleTableTabChange}
              aria-label="simple tabs example"
              variant="fullWidth"
              sx={{ borderBottom: 1, borderColor: "divider" }}
            >
              <Tab label="Clients" />
              <Tab label="Creators" disabled={creators.length === 0} />
            </Tabs>
            {selectedTableTab === 0 && <ClientTable />}
            {selectedTableTab === 1 && <CreatorTable />}
          </Box>
        </Container>
      )}
    </>
  );
}

export default App;
