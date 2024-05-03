import React, { useState, useEffect } from "react";
import { Box, Tab, Tabs, Container } from "@mui/material";
import RegisterDeveloperForm from "./components/RegisterDeveloperForm";
import RegisterClientForm from "./components/RegisterClientForm";
import ClientTable from "./components/ClientTable";
import "./App.css";
// import { Direction } from "./utils";
import { useDojo } from "./dojo/useDojo";
import DeveloperTokens from "./components/DeveloperTokens";

function App() {
  // DOJO stuff
  const { account } = useDojo();

  const [clipboardStatus, setClipboardStatus] = useState({
    message: "",
    isError: false,
  });

  // const handleRestoreBurners = async () => {
  //   try {
  //     await account?.applyFromClipboard();
  //     setClipboardStatus({
  //       message: "Burners restored successfully!",
  //       isError: false,
  //     });
  //   } catch (error) {
  //     setClipboardStatus({
  //       message: `Failed to restore burners from clipboard`,
  //       isError: true,
  //     });
  //   }
  // };

  useEffect(() => {
    if (clipboardStatus.message) {
      const timer = setTimeout(() => {
        setClipboardStatus({ message: "", isError: false });
      }, 3000);

      return () => clearTimeout(timer);
    }
  }, [clipboardStatus.message]);

  // App stuff

  const [selectedTab, setSelectedTab] = useState(0);

  const handleTabChange = (_event: React.SyntheticEvent, newValue: number) => {
    setSelectedTab(newValue);
  };

  const componentStyle = {
    width: "100%", // or a fixed width like 500px
    maxWidth: "800px", // Ensures that width does not exceed 800px
    margin: "auto", // This centers the component in the available space
  };

  const accountExists = account && account?.list().length > 0;

  return (
    <>
      {!accountExists ? (
        <button onClick={() => account?.create()}>
          {account?.isDeploying ? "deploying burner" : "create burner"}
        </button>
      ) : (
        <Container component="main" maxWidth="lg">
          <Box sx={componentStyle}>
            <Tabs
              value={selectedTab}
              onChange={handleTabChange}
              aria-label="simple tabs example"
            >
              <Tab label="Register Developer" />
              <Tab label="Register Client" disabled />
              <Tab label="View Clients" disabled />
            </Tabs>
          </Box>
          {selectedTab === 0 && <RegisterDeveloperForm />}
          {selectedTab === 1 && <RegisterClientForm />}
          {selectedTab === 2 && <ClientTable />}
          <DeveloperTokens />
        </Container>
      )}
    </>
  );
}

export default App;
