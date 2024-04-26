import React, { useState } from "react";
import { Box, Tab, Tabs } from "@mui/material";
import RegisterForm from "./components/RegisterForm";
import ClientTable from "./components/ClientTable";
import "./App.css";

function App() {
  const [selectedTab, setSelectedTab] = useState(0);

  const handleTabChange = (event: React.SyntheticEvent, newValue: number) => {
    setSelectedTab(newValue);
  };
  return (
    <>
      <h1>Register Client</h1>
      <Box sx={{ borderBottom: 1, borderColor: "divider" }}>
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
    </>
  );
}

export default App;
