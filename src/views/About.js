import React, { Component } from "react";
import { Typography } from "@material-ui/core";
import Social from "../components/Social";
import "../App.css";

class About extends Component {
  render() {
    return (
      <div className="condiv">
        <Typography variant="h5" style={{ marginBottom: "20px" }}>
          About me
        </Typography>
        <Typography variant="subtitle2">Name: Prity Kumari</Typography>
        <Typography variant="subtitle2">Languages Known: Hindi, English, Bengali</Typography>
        <Typography variant="subtitle2">Marital Status: Married</Typography>
        <Typography variant="subtitle2"></Typography>
        <Typography variant="subtitle2"></Typography>
        <Social />
      </div>
    );
  }
}

export default About;
