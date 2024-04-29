import React, { useState } from "react";
import { Box, Tab, Tabs, Container } from "@mui/material";
import RegisterForm from "./components/RegisterForm";
import ClientTable from "./components/ClientTable";
import "./App.css";

function App() {
  const [selectedTab, setSelectedTab] = useState(0);

  const handleTabChange = (event: React.SyntheticEvent, newValue: number) => {
    setSelectedTab(newValue);
  };

  const componentStyle = {
    width: "100%", // or a fixed width like 500px
    maxWidth: "800px", // Ensures that width does not exceed 800px
    margin: "auto", // This centers the component in the available space
  };

  return (
    <Container component="main" maxWidth="lg">
      <h1>Register Client</h1>
      <Box sx={componentStyle}>
        <Tabs
          value={selectedTab}
          onChange={handleTabChange}
          aria-label="simple tabs example"
        >
          <Tab label="Enter Data" />
          <Tab label="View Data" />
        </Tabs>
      </Box>
      {selectedTab === 0 && <RegisterForm />}
      {selectedTab === 1 && <ClientTable />}
    </Container>
  );
}

export default App;
