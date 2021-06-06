import React, { Component } from "react";
import Social from "../components/Social";
import "../App.css";

class Contact extends Component {
  render() {
    return (
      <div className="condiv">
        <h1 className="subtopic"> Contact me</h1>
        <h3>Email: prity315@gmail.com</h3>
        <Social />
      </div>
    );
  }
}

export default Contact;
