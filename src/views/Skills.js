import React, { Component } from "react";
import { Button, Typography } from "@material-ui/core";
import Social from "../components/Social";
import "../App.css";

class Skills extends Component {
  render() {
    return (
      <>
        <div className="condiv">
          <h1 className="subtopic">Skills</h1>
          <ul>
            <li>
              {" "}
              <Button variant="outlined" className="button">
                <Typography>Java</Typography>{" "}
              </Button>
            </li>
            <li>
              {" "}
              <Button variant="outlined" className="button">
                <Typography>AWS Services</Typography>{" "}
              </Button>
            </li>
            <li>
              <Button variant="outlined" className="button">
                <Typography>Terraform</Typography>{" "}
              </Button>
            </li>
          </ul>
        </div>
        <Social />
      </>
    );
  }
}

export default Skills;
