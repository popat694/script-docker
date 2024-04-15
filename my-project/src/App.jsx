import { useState } from "react";
import "./App.css";
import Layout from "./pages/Layout";
import { BrowserRouter, Routes, useRoutes } from "react-router-dom";
import Home from "./pages/Home";
import Contact from "./pages/Contact";
import NoPage from "./pages/NoPage";
import Project from "./pages/Project";

const ROUTE = [
  {
    path: "/",
    children: [
      { index: true, element: <Home /> },
      { path: "contact", element: <Contact /> },
      { path: "projects", element: <Project /> },
    ],
  },
  {
    path: "*",
    element: <NoPage />,
  },
];
function App() {
  return (
    <>
      <Layout>{useRoutes(ROUTE)}</Layout>
    </>
  );
}

export default App;
