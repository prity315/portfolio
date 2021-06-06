import React, { Component } from "react";
import { Card, CardContent, Grid, Typography } from "@material-ui/core";
import Social from "../components/Social";
import "../App.css";

class Education extends Component {
  render() {
    return (
      <>
        <div className="condiv">
          <Typography variant="h5" style={{ marginBottom: "20px" }}>
            My Education
          </Typography>
          <div className="education">
            <Card className="root">
              <CardContent>
                <Grid container>
                  <Grid item>
                    <Typography
                      variant="subtitle1"
                      style={{ fontWeight: "bold", marginBottom: "10px" }}
                    >
                      B.Tech.(CSE)
                    </Typography>
                    <Typography variant="subtitle2">
                      2014 Passout from WBUT
                    </Typography>
                    <Typography variant="subtitle2">DGPA: 8.46</Typography>
                  </Grid>
                </Grid>
              </CardContent>
            </Card>
            <Card className="root">
              <CardContent>
                <Grid container>
                  <Grid item>
                    <Typography
                      variant="subtitle1"
                      style={{ fontWeight: "bold", marginBottom: "10px" }}
                    >
                      Intermediate
                    </Typography>
                    <Typography variant="subtitle2">
                      2010 Passout from BSEB
                    </Typography>
                    <Typography variant="subtitle2">Marks: 78.6%</Typography>
                  </Grid>
                </Grid>
              </CardContent>
            </Card>
            <Card className="root">
              <CardContent>
                <Grid container>
                  <Grid item>
                    <Typography
                      variant="subtitle1"
                      style={{ fontWeight: "bold", marginBottom: "10px" }}
                    >
                      Matriculation
                    </Typography>
                    <Typography variant="subtitle2">
                      2008 Passout from BSEB
                    </Typography>
                    <Typography variant="subtitle2">Marks: 68.6%</Typography>
                  </Grid>
                </Grid>
              </CardContent>
            </Card>
          </div>
        </div>
        <Social />
      </>
    );
  }
}

export default Education;
